// Proxmox settings
proxmox_host             = "192.168.68.72"
proxmox_node             = "pve-02"
proxmox_user             = "root@pam!packer" //"packer@pam!packer" #token id
proxmox_apikey           = "d7bece4c-dba3-475a-a4be-73a148de5dbb" //"47327599-ec98-49ce-95fc-93728ca53428" // TODO: fill in your Proxmox API token secret
proxmox_vm_storage_pool  = "local-lvm"
proxmox_iso_storage_pool = "local"
proxmox_iso_path         = "local:iso"

// Guest operating system metadata
vm_guest_os_language = "en_US"
vm_guest_os_keyboard = "us"
vm_guest_os_timezone = "Asia/Singapore"

// Virtual machine partition settings (MB)
vm_guest_part_audit  = 4096
vm_guest_part_boot   = 1024
vm_guest_part_efi    = 512
vm_guest_part_home   = 8192
vm_guest_part_log    = 4096
vm_guest_part_root   = 0
vm_guest_part_swap   = 1024
vm_guest_part_tmp    = 4096
vm_guest_part_var    = 2096
vm_guest_part_vartmp = 1024

// Virtual machine hardware settings
vm_id                   = 400
vm_qemu_agent           = true
vm_name                 = "ubuntu2404"
vm_template_name        = "ubuntu-24.04-template"
vm_template_description = "Ubuntu Server 24.04 LTS template"
vm_guest_os_type        = "l26"
vm_bios_type            = "ovmf"
vm_cpu_cores            = 1
vm_cpu_count            = 2
vm_cpu_type             = "host"
vm_mem_size             = 2048
vm_scsi_controller      = "virtio-scsi-single"
vm_network_model        = "virtio"

// Disk configuration
vm_disk_size = "60G"
disk_format  = "raw"

// Removable media settings
cd_label           = "cidata"
iso_checksum_type  = "sha256"
iso_checksum_value = "c3514bf0056180d09376462a7a1b4f213c1d6e8ea67fae5c25099c6fd3d8274b"
iso_file           = "ubuntu-24.04.3-live-server-amd64.iso"
iso_url            = "https://releases.ubuntu.com/noble/ubuntu-24.04.3-live-server-amd64.iso"
unmount_iso        = true

// Boot settings
vm_boot_command = [
    "<esc><wait>c",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/\"",
    "<enter><wait5s>",
    "initrd /casper/initrd",
    "<enter><wait5s>",
    "boot",
    "<enter>"
]
vm_boot_wait = "15s"

// Communicator / build user settings
build_username      = "vmuser"
build_password_hash = "$6$jFtkglE18nEu8XkB$NE.Pt55CSqRjFZ9mRdTSXOrAdf13tRd/EHZJEH1qN3IMm5RAbF8NUkS2Wrt1g.SFiGiF1NY80spb7w6B1tw480"
build_remove_keys   = true
communicator_port   = 22
communicator_timeout = "30m"

// Provisioner settings
cloud_init_apt_packages = [
    "curl",
    "git",
    "wget",
    "net-tools",
    "vim",
    "build-essential",
    "openssh-server",
    "qemu-guest-agent",
    "jq",
    "perl"
]
cloud_init_apt_mirror = ""

post_install_scripts = [
    "../../../scripts/linux/wait-for-cloud-init.sh",
    "../../../scripts/linux/cleanup-subiquity.sh",
    "../../../scripts/linux/configure-sshd.sh"
]

pre_final_scripts = [
    "../../../scripts/linux/cleanup-cloud-init.sh",
    "../../../scripts/linux/cleanup-packages.sh",
    "../../../scripts/linux/generalize.sh"
]
