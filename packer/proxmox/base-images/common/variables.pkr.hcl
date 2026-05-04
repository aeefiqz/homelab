// Proxmox settings
variable "proxmox_host" {
  type        = string
  description = "The proxmox host"
}

variable "proxmox_user" {
  type        = string
  description = "The username of the proxmox user"
}

variable "proxmox_token" {
  type        = string
  description = "Proxmox API token"
  sensitive   = true
}

variable "proxmox_node" {
  type        = string
  description = "The proxmox node on which the packer template will be created on"
}

variable "proxmox_vm_storage_pool" {
  type        = string
  description = "The storage pool on Proxmox for VM disks and EFI (e.g. 'local-lvm')"
}

variable "proxmox_iso_storage_pool" {
  type        = string
  description = "The storage pool on Proxmox for ISO images (e.g. 'local')"
  default     = "local"
}


// Virtual machine settings
variable "vm_id" {
  type        = number
  description = "The Proxmox VM ID for the template"
}

variable "vm_qemu_agent" {
  type        = bool
  description = "Enables qemu agent option for virtual machine."
  default     = true
}

variable "vm_name" {
  type        = string
  description = "Name of the new template to create"
}

variable "vm_template_name" {
  type        = string
  description = "Name of the resulting Proxmox template"
}

variable "vm_template_description" {
  type        = string
  description = "Description of the resulting Proxmox template"
  default     = ""
}

variable "vm_bios_type" {
  type        = string
  description = "The virtual machine BIOS type (e.g. 'ovmf' or 'seabios')"
  default     = "ovmf"
}

variable "vm_guest_os_type" {
  type        = string
  description = "The guest operating system type (e.g. 'l26' for Linux 2.6+)"
}


// CPU and memory settings 
variable "vm_cpu_cores" {
  type        = number
  description = "Number of CPU cores for the virtual machine"
}

variable "vm_cpu_count" {
  type        = number
  description = "The number of virtual CPU sockets"
}

variable "vm_cpu_type" {
  type        = string
  description = "The CPU type for the virtual machine"
}

variable "vm_memory" {
  type        = number
  description = "The size of virtual memory in MB (e.g. 2048)"
}


// Disk settings
variable "vm_disk_size" {
  type        = string
  description = "The size of the virtual disk (e.g. 60G)"
  default     = "60G"
}

variable "disk_format" {
  type        = string
  description = "The disk image format (e.g. 'raw', 'qcow2')"
  default     = "raw"
}

variable "vm_disk_type" {
  type        = string
  description = "The virtual disk controller type (e.g. 'scsi', 'virtio', 'sata', 'ide')"
  default     = "scsi"
}


// EFI settings
variable "vm_efi_type" {
  type        = string
  description = "The EFI disk size type ('4m' for 4MB or '2m' for 2MB)"
  default     = "4m"
}

variable "vm_guest_os_keyboard" {
  type        = string
  description = "The guest operating system keyboard input."
  default     = "us"
}

variable "vm_guest_os_language" {
  type        = string
  description = "The guest operating system language"
  default     = "en_US"
}

variable "vm_guest_os_timezone" {
  type        = string
  description = "The guest operating system timezone"
  default     = "UTC"
}


// Network adapter settings
variable "vm_network_model" {
  type        = string
  description = "The virtual network adapter type (e.g. 'virtio')"
  default     = "virtio"
}

variable "vm_network_bridge" {
  type        = string
  description = "The Proxmox network bridge to attach the virtual machine to (e.g. 'vmbr0')"
  default     = "vmbr0"
}

variable "vm_scsi_controller" {
  type        = string
  description = "The virtual SCSI controller type (e.g. 'virtio-scsi-single')"
  default     = "virtio-scsi-single"
}


// VM guest partition sizes (MB)
variable "vm_guest_part_audit" {
  type        = number
  description = "Size of the /var/log/audit partition in MB."
}

variable "vm_guest_part_boot" {
  type        = number
  description = "Size of the /boot partition in MB."
}

variable "vm_guest_part_efi" {
  type        = number
  description = "Size of the /boot/efi partition in MB."
}

variable "vm_guest_part_home" {
  type        = number
  description = "Size of the /home partition in MB."
}

variable "vm_guest_part_log" {
  type        = number
  description = "Size of the /var/log partition in MB."
}

variable "vm_guest_part_root" {
  type        = number
  description = "Size of the / partition in MB. Use 0 to fill remaining space."
}

variable "vm_guest_part_swap" {
  type        = number
  description = "Size of the swap partition in MB."
}

variable "vm_guest_part_tmp" {
  type        = number
  description = "Size of the /tmp partition in MB."
}

variable "vm_guest_part_var" {
  type        = number
  description = "Size of the /var partition in MB."
}

variable "vm_guest_part_vartmp" {
  type        = number
  description = "Size of the /var/tmp partition in MB."
}


// Removable media settings
variable "cd_label" {
  type        = string
  description = "CD label for the cloud-init ISO"
  default     = "cidata"
}

variable "iso_checksum_type" {
  type        = string
  description = "The ISO checksum algorithm (e.g. 'sha256')"
}

variable "iso_checksum_value" {
  type        = string
  description = "The checksum value provided by the vendor."
}

variable "proxmox_iso_path" {
  type        = string
  description = "The storage path for ISO images on Proxmox (e.g. 'local:iso')"
  default     = "local:iso"
}

variable "iso_file" {
  type        = string
  description = "The ISO filename (e.g. 'ubuntu-24.04.1-live-server-amd64.iso')"
}

variable "iso_url" {
  type        = string
  description = "The download URL for the ISO image"
}

variable "unmount_iso" {
  type        = bool
  description = "If true, unmount the ISO after installation."
  default     = true
}


// Boot settings
variable "vm_boot_command" {
  type        = list(string)
  description = "The virtual machine boot command sequence"
  default     = []
}

variable "vm_boot_wait" {
  type        = string
  description = "The time to wait before sending the boot command."
}


// Communicator settings
variable "communicator_port" {
  type        = number
  description = "The SSH port."
  default     = 22
}

variable "build_public_key" {
  type        = string
  description = "Optional additional SSH public key string to inject alongside the ephemeral Packer key."
  default     = ""
  sensitive   = false
}

variable "build_username" {
  type        = string
  description = "The username of the build user created during installation."
  default     = "ubuntu"
}

variable "build_password_hash" {
  type        = string
  description = "The SHA-512 hashed password for the build user. Generate with: mkpasswd -m sha-512"
  sensitive   = true
}

variable "build_remove_keys" {
  type        = bool
  description = "If true, remove the temporary SSH key after build."
  default     = true
}

variable "communicator_timeout" {
  type        = string
  description = "The SSH connection timeout."
  default     = "30m"
}


// distro specific settings
variable "cloud_init_apt_packages" {
  type        = list(string)
  description = "A list of apt packages to install during cloud-init"
  default     = []
}

variable "cloud_init_apt_mirror" {
  type        = string
  description = "Optional apt mirror URL. Leave empty to use the Ubuntu default."
  default     = ""
}

variable "kickstart_rpm_packages" {
  type        = list(string)
  description = "Additional RPM packages to install via kickstart %packages section."
  default     = []
}

variable "post_install_scripts" {
  type        = list(string)
  description = "Scripts to run after OS installation, relative to the build directory."
  default     = []
}

variable "pre_final_scripts" {
  type        = list(string)
  description = "Scripts to run before template finalization, relative to the build directory."
  default     = []
}
