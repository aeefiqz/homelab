// Proxmox settings 
variable "proxmox_host" {
    type = string 
    description = "The proxmox host"
}

variable "proxmox_user" {
    type = string 
    description = "The username of the proxmox user"
}

variable "proxmox_apikey" {
    type = string
    description = "Proxmox API secret key"
    sensitive = true
}

variable "proxmox_node" {
    type = string 
    description = "The proxmox node on which the packer template will be created on"
}


// Virtual machine settings 
variable "vm_qemu_agent" {
    type = bool
    description = "Enables qemu agent option for virtual machine."
    default = true
}

variable "vm_name" {
    type = string
    description = "Name of the new template to create"
}

variable "vm_bios_type" {
    type = string
    description =  "The virtual machine BIOS type (e.g. 'ovmf' or 'seabios')"
    default = "ovmf"
}

variable "vm_cpu_cores" {
    type = number
    description = "Number of CPU cores to for virtual machine (e.g. 1 core)"
}

variable "vm_cpu_count" {
    type = number
    description = "The number of virtual CPU per socket (e.g. 1)"
}

variable "vm_cpu_type" {
    type = string
    description = "The CPU type for the virtual machine"
}


variable "vm_mem_size" {
    type = number
    description = "The size for the virtual memory in MB. (e.g. '2048')"
}

variable  "vm_guest_os_type" {
    type = string
    description = "The guest operating system type. (e.g. 'l26' for Linux 2.6+)"
}

variable "vm_disk_size" {
    type = string 
    description = "The size of the virtual disk (e.g. 60G)"
    default = "60G"
}

variable "vm_guest_os_keyboard" {
    type = string
    description = "The guest operating system keyboard input."
    default = "us"
}

variable "vm_guest_os_language" {
    type = string
    description = "The guest operating system language"
    default = "en_US"
}

variable "vm_guest_os_timezone" {
    type = string 
    description = "The guest operating system timezone"
    default = "SGT"
}

variable "vm_network_model" {
    type = string
    description = "The virtual network adapter type. (e.g. 'vmxnet3' or 'virtio')"
    default = "virtio"
}

variable "vm_scsi_controller" {
    type = string
    description = "The virtual SCSI controller type. (e.g. 'virtio-scsi-single')"
    default = "virtio-scsi-single"
}

// VM guest partition size 
variable "vm_guest_part_audit" {
    type = number
    description = "Size of the /var/log/audit/ partition in MB."
}

variable "vm_guest_part_boot" {
    type = number
    description = "Size of the /boot partition in MB."
}

variable "vm_guest_part_efi" {
    type = number
    description = "Size of the /boot/efi partition in MB."
}

variable "vm_guest_part_home" {
    type = number
    description = "Size of the /home/ partition in MB."
}

variable "vm_guest_part_log" {
    type = number 
    description = "Size of the /var/log/ partition in MB."
}

variable "vm_guest_part_root" {
    type = number 
    description = "Size of the /root/ partition in MB."
}

variable "vm_guest_part_swap" {
    type = number 
    description = "Size of the swap partition in MB."
}

variable "vm_guest_part_tmp" {
    type = number
    description = "Size of the /tmp/ partition in MB."
}

variable "vm_guest_part_var" {
    type = number 
    description = "Size of the /var/ partition in MB."
}

variable "vm_guest_part_vartmp" {
    type = number
    description = "Size of the /var/tmp/ partition in MB"
}

// Removable Media settings 
variable "cd_label" {
    type = string
    description = "CD label"
    default = "cidata"
}

variable "iso_checksum_type" {
    type = string
    description = "The ISO checksum algorithm used by the vendor. (e.g. 'sha256')"
}

variable "iso_checksum_value" {
    type = string
    description = "The checksum value provided by the vendor."
}

variable "proxmox_iso_path" {
    type = string
    description = "The path on the proxmox server where the ISO image is stored (e.g. '/var/lib/vz/template/iso')"
    default = "local"
}

variable "iso_file" {
    type = string
    description = "The file name of the ISO image used by the vendor. (e.g. 'ubuntu-<version>-live-server-amd65.iso' )"
}

variable "iso_url" {
    type = string 
    description = "The URL source of where the ISO image is stored (e.g. https://mirror.example.com/.../os.iso)"
}

variable "unmount_iso" {
    type = bool
    description = "If true, unmount the ISO image after installation."
    default = true
}

// BOOT settings
variable "vm_boot_command" {
    type = list(string)
    description = "The virtual machine boot command"
    default = []
}

variable "vm_boot_wait" {
    type = string
    description = "The time to wait before boot."
}

// Communicator settings
variable "build_remove_keys" {
    type = bool
    description = "If true, packer will remove its temporary key from ~/.ssh/authorized_keys and /root/.ssh/authorized_keys"
    default = true
}

variable "communicator_insecure" {
    type = bool
    description = "If true, do not check the client certificate chain and hostname"
    default = true
}

variable "communicator_port" {
    type = number
    description = "The port of the communicator protocol."
}

variable "communicator_ssl" {
    type = bool 
    description = "If true, use SSL protocol"
    default = true
}

variable "communicator_timeout" {
    type = string
    description = "The timeout of the communicator procotol."
}

// Provisioner settings 
variable "cloud_init_apt_packages" {
    type = list(string)
    description = "A list of apt packages to install during the subquity cloud-init installer"
    default = []
}

variable "cloud_init_apt_mirror" {
    type = string
    description = "Sets the default apt mirror during the subquity cloud-init installer"
    default = ""
}

variable "post_install_scripts" {
    type = list(string)
    description = "A list of scripts and their relative paths to transfer and run after OS install."
    default = []
}

variable "pre_final_scripts" {
    type = list(string)
    description = "A list of scripts and their relative paths to transfer and run before finalization."
    default = []
}