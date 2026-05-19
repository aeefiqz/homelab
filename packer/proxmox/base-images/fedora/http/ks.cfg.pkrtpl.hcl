### Kickstart configuration for automated Fedora installation on Proxmox VE ###

### Installs from the first attached CD-ROM/DVD on the system.
#cdrom # using netinst ISO cdrom not required

### Use text install
text 

### Setup Agent is not started the first time the system boots.
firstboot --disabled

### Accepts the End User License Agreement.
eula --agreed

# Keyboard layout
keyboard --vckeymap=${vm_guest_os_keyboard} --xlayouts='${vm_guest_os_keyboard}'

## System language
lang ${vm_guest_os_language}

## System timezone
timezone ${vm_guest_os_timezone} --utc

# Lock root account — access via build user + sudo only
rootpw --lock

## Network information
network --bootproto=dhcp --activate --hostname=${vm_guest_os_hostname}


# Create build user with hashed password and wheel group membership
user --name=${build_username} --password=${build_password_hash} --iscrypted --groups=wheel

## Do not configure the X Window System
skipx

### Insert SSH public keys for the build user.
%{ for ssh_key in ssh_keys ~}
sshkey --username=${ build_username } '${ ssh_key }'
%{ endfor }

# why authselect select sssd?
authselect select minimal

## Firewall
firewall --enabled --ssh

## SELinux
selinux --enforcing

## Disk partitioning (UEFI/GPT with LVM)
ignoredisk --only-use=sda
zerombr
clearpart --all --initlabel --drives=sda
bootloader --location=mbr --boot-drive=sda

# EFI System Partition
part /boot/efi --fstype="efi" --ondisk=sda --size=${vm_guest_part_efi} --fsoptions="umask=0077,shortname=winnt"
# /boot partition
part /boot --fstype="xfs" --ondisk=sda --size=${vm_guest_part_boot}
# LVM physical volume — takes remaining disk space
part pv.01 --fstype="lvmpv" --ondisk=sda --grow

# Volume group on physical volume
volgroup vg_system pv.01

# Logical volumes
logvol swap --fstype="swap" --name=lv_swap --vgname=vg_system --size=${ vm_guest_part_swap } --label=SWAPFS
logvol /tmp           --fstype="xfs"  --size=${vm_guest_part_tmp}    --name=lv_tmp     --vgname=vg_system
logvol /var           --fstype="xfs"  --size=${vm_guest_part_var}    --name=lv_var     --vgname=vg_system
logvol /var/tmp       --fstype="xfs"  --size=${vm_guest_part_vartmp} --name=lv_vartmp  --vgname=vg_system
logvol /var/log       --fstype="xfs"  --size=${vm_guest_part_log}    --name=lv_log     --vgname=vg_system
logvol /var/log/audit --fstype="xfs"  --size=${vm_guest_part_audit}  --name=lv_audit   --vgname=vg_system
logvol /home          --fstype="xfs"  --size=${vm_guest_part_home}   --name=lv_home    --vgname=vg_system
# root: use --grow when size is 0 (fill remaining space)
logvol / --fstype="xfs" --size=${vm_guest_part_root == 0 ? 1 : vm_guest_part_root} --name=lv_root --vgname=vg_system%{ if vm_guest_part_root == 0 } --grow%{ endif }



## System services
services --enabled="NetworkManager,sshd,qemu-guest-agent"

#reboot
%packages --ignoremissing --excludedocs
@core

%{ for pkg in packages ~}
${pkg}
%{ endfor ~}

# Remove unnecessary firmware and packages
# -aic94xx-firmware
# -alsa-*
# -atmel-firmware
# -b43-openfwwf
# -bfa-firmware
# -fprintd-pam
# -ipw*-firmware
# -ivtv-firmware
# -iwl*-firmware
# -libertas-usb8388-firmware
# -microcode_ctl
# -ql*-firmware
# -rt61pci-firmware
# -rt73usb-firmware
# -xorg-x11-drv-ati-firmware
# -zd1211-firmware
# -cockpit
# -intltool
# -quota
%end

%addon com_redhat_kdump --disable
%end

### Post-install configuration
%post
# Grant passwordless sudo to build user so Packer provisioners can run as root
echo "${build_username} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${build_username}
chmod 0440 /etc/sudoers.d/${build_username}
# Inject SSH authorized keys for the build user
mkdir -p /home/${build_username}/.ssh
chmod 700 /home/${build_username}/.ssh
cat > /home/${build_username}/.ssh/authorized_keys << 'SSHEOF'
%{ for key in ssh_keys ~}
${key}
%{ endfor ~}
SSHEOF
chmod 600 /home/${build_username}/.ssh/authorized_keys
chown -R ${build_username}:${build_username} /home/${build_username}/.ssh

// handled by post-install scripts
# Harden SSH: disable root login, ensure pubkey auth is on
#sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
#sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
%end
reboot --eject
