// Proxmox connection — set these via PKR_VAR_* environment variables (see .example.env)
// FIX: "${env.PROXMOX_*}" is not valid HCL in pkrvars files; values must be literals.
//      These are intentionally omitted here; supply them via the .env file:
//        PKR_VAR_proxmox_host, PKR_VAR_proxmox_node, PKR_VAR_proxmox_user, PKR_VAR_proxmox_token

// Storage — FIX: vm_storage_pool → proxmox_vm_storage_pool; vm_iso_path → proxmox_iso_path
proxmox_vm_storage_pool = "local-lvm"
proxmox_iso_path        = "local:iso"

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
vm_guest_part_var    = 2048
vm_guest_part_vartmp = 1024

// Virtual machine hardware settings
fedora_version          = "43" // FIX: was missing; used in vm_name and template_description
vm_id                   = 300
vm_qemu_agent           = true
vm_name                 = "fedora-43"
vm_template_name        = "fedora-43-template"
vm_template_description = "Fedora 43 Community server template"
vm_guest_os_type        = "l26"
vm_bios_type            = "ovmf"
vm_cpu_cores            = 1
vm_cpu_count            = 1 // number of sockets
vm_cpu_type             = "host"
vm_memory               = 2048 // FIX: was vm_mem_size (undefined var)
vm_scsi_controller      = "virtio-scsi-single"
vm_network_model        = "virtio"
vm_network_bridge       = "vmbr0"

// Disk configuration
vm_disk_type = "scsi" // FIX: was missing; required by disk block
vm_disk_size = "60G"
disk_format  = "raw"

// EFI configuration
vm_efi_type = "4m" // FIX: was missing; required by efi_config block

// ISO settings — FIX: iso_checksum_type/value kept; removed iso_checksum_type (was duplicate)
iso_checksum_type  = "sha256"
iso_checksum_value = "16fd70ddae2c7de13e485637c3da1fb385dd8220389f988279ea3b3d561243cc"
iso_file           = "Fedora-Server-netinst-x86_64-43-1.6.iso"
iso_url            = "https://download.fedoraproject.org/pub/fedora/linux/releases/43/Server/x86_64/iso/Fedora-Server-netinst-x86_64-43-1.6.iso"

// Boot settings — FIX: removed vm_boot_command (now uses local.bootcmd_grub in fedora.pkr.hcl)
vm_boot_wait = "15s"

// Communicator / build user settings
build_username       = "prdadmin"
build_password_hash  = "$6$jFtkglE18nEu8XkB$NE.Pt55CSqRjFZ9mRdTSXOrAdf13tRd/EHZJEH1qN3IMm5RAbF8NUkS2Wrt1g.SFiGiF1NY80spb7w6B1tw480"
build_public_key     = "" // optional: set to your admin SSH public key string
build_remove_keys    = true
communicator_port    = 22
communicator_timeout = "30m"

kickstart_rpm_packages = [
  "cloud-utils-growpart",
  "dbus-tools",
  "dnf-utils",
  "net-tools",
  "perl",
  "qemu-guest-agent",
  "vim",
  "wget",
]

post_install_scripts = [
  "../../../scripts/linux/wait-for-cloud-init.sh",
  "../../../scripts/linux/cleanup-subiquity.sh",
  "../../../scripts/linux/configure-sshd.sh",
]

pre_final_scripts = [
  "../../../scripts/linux/cleanup-cloud-init.sh",
  "../../../scripts/linux/cleanup-packages.sh",
  "../../../scripts/linux/generalize.sh",
]
