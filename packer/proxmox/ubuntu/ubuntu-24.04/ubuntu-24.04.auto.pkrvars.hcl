// Proxmox_settings
proxmox_host            =  "192.168.68.72"
proxmox_node            =  "pve-02"
proxmox_user            =  "packer"
proxmox_apikey          = 

// Guest operating system meta data
vm_guest_os_language    = "us"
vm_guest_os_keyboard    = "us"
vm_guest_os_timezone    = "SGT"


// Virtual machine partition settings
vm_guest_part_audit     = 4096
vm_guest_part_boot      = 1024
vm_guest_part_efi       = 512
vm_guest_part_home      = 8192
vm_guest_part_log       = 4096
vm_guest_part_root      = 0
vm_guest_part_swap      = 1024
vm_guest_part_tmp       = 4096
vm_guest_part_var       = 2096
vm_guest_part_vartmp    = 1024

// Virtual machine hardware settings
vm_id                   = 400
vm_qemu_agent           = true
vm_name                 = "ubuntu2404"
vm_template_description = "VM template for Ubuntu"
vm_guest_os_type        = "126"
vm_bios_type            = "ovmf"
vm_cpu_cores            = 1
vm_cpu_count            = 2
vm_cpu_type             = "host"
vm_mem_size             = "2048"
vm_scsi_controller      = "virtio-scsi-single"
//disk configuration
vm_disk_size            = "60G"
vm_disk_format          = "raw"
storage_pool            = ""
// network adapters
vm_network_model        = "virtio"



// Cloud init settings
cloud_init_enable       = true
cloud_init_storage_pool = "local-lvm"

// Virtual machine removable media settings
cd_label                    =
iso_checksum_type           = "sha256"
iso_checksum_value          = "e240e4b801f7bb68c20d1356b60968ad0c33a41d00d828e74ceb3364a0317be9"
iso_file                    = "ubuntu-24.04.1-live-server-amd64.iso"
iso_url                     = "https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-live-server-amd64.iso"
proxmox_iso_storage_pool    = "local"
proxmox_iso_path            = "local:iso"
unmount_iso                 = true 


// Virtual machine boot settings
boot_key_interval       = "250ms"
vm_boot_command = [
    "<esc><wait>c",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud\"",
    "<enter><wait5s>",
    "initrd /casper/initrd",
    "<enter><wait5s>",
    "boot",
    "<enter>"
  ]
vm_boot_wait            = "5s"

// communicator settings 
build_remove_keys       = true
communicator_port       = "22"
communicator_timeout    = "10m"

// provisioner settings
cloud_init_apt_packages = [

]
cloud_init_apt_mirror = 

post_install_scripts = [

]

pre_final_scripts = [

]