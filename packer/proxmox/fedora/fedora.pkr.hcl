packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.3"
      source  = "github.com/hashicorp/proxmox"
    }
    ssh-key = {
      version = ">= 1.2.1"
      source  = "github.com/ivoronin/sshkey"
    }
  }
}

data "sshkey" "install" {
  type = "ed25519"
  name = "packer_key"
}

locals {
  build_date           = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_tool           = "Hashicorp Packer ${packer.version}"
  iso_checksum         = "${var.iso_checksum_type}:${var.iso_checksum_value}"
  ssh_private_key_file = data.sshkey.install.private_key_path
  ssh_public_key       = data.sshkey.install.public_key

  // Boot command for Fedora GRUB2: edit first entry and append HTTP kickstart URL
  bootcmd_grub = [
    "<up>e",
    "<down><down><end>",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg",
    "<leftCtrlOn>x<leftCtrlOff>",
  ]

  data_source_content = {
    "/ks.cfg" = templatefile("${abspath(path.root)}/http/ks.cfg.pkrtpl.hcl", {
      // FIX: was local.build_password_hash / local.build_username (undefined locals)
      build_password_hash = var.build_password_hash
      build_username      = var.build_username
      rpm_packages        = var.kickstart_rpm_packages
      // FIX: was local.build_public_key (undefined local); now uses var with fallback
      ssh_keys             = var.build_public_key != "" ? concat([local.ssh_public_key], [var.build_public_key]) : [local.ssh_public_key]
      vm_guest_os_hostname = var.vm_name
      vm_guest_os_keyboard = var.vm_guest_os_keyboard
      vm_guest_os_language = var.vm_guest_os_language
      vm_guest_os_timezone = var.vm_guest_os_timezone
      vm_guest_part_audit  = var.vm_guest_part_audit
      vm_guest_part_boot   = var.vm_guest_part_boot
      vm_guest_part_efi    = var.vm_guest_part_efi
      vm_guest_part_home   = var.vm_guest_part_home
      vm_guest_part_log    = var.vm_guest_part_log
      vm_guest_part_root   = var.vm_guest_part_root
      vm_guest_part_swap   = var.vm_guest_part_swap
      vm_guest_part_tmp    = var.vm_guest_part_tmp
      vm_guest_part_var    = var.vm_guest_part_var
      vm_guest_part_vartmp = var.vm_guest_part_vartmp
    })
  }
}

// FIX: was source "proxmox" — correct builder for ISO-based builds is "proxmox-iso"
source "proxmox-iso" "fedora" {
  // proxmox connection
  node                     = var.proxmox_node
  proxmox_url              = "https://${var.proxmox_host}:8006/api2/json"
  username                 = var.proxmox_user
  token                    = var.proxmox_token
  insecure_skip_tls_verify = true
  task_timeout             = "10m"

  // virtual machine
  vm_id                = var.vm_id
  vm_name              = "base-${var.fedora_version}"
  template_name        = var.vm_template_name
  template_description = "Base image for Fedora ${var.fedora_version} created on ${local.build_date} with ${local.build_tool}"
  os                   = var.vm_guest_os_type
  qemu_agent           = var.vm_qemu_agent
  scsi_controller      = var.vm_scsi_controller

  // bios
  bios = var.vm_bios_type

  // cpu and memory
  // FIX: cpu_cores → cores, cpu_count → sockets; removed cpu_sockets (undefined var)
  cpu_type = var.vm_cpu_type
  cores    = var.vm_cpu_cores
  sockets  = var.vm_cpu_count
  memory   = var.vm_memory

  // disk
  // FIX: vm_disk_storage_pool → proxmox_vm_storage_pool; vm_disk_format → disk_format
  disks {
    type         = var.vm_disk_type
    disk_size    = var.vm_disk_size
    storage_pool = var.proxmox_vm_storage_pool
    format       = var.disk_format
    io_thread    = true
  }

  // efi — FIX: block name was efi {}, correct name is efi_config {}
  efi_config {
    efi_storage_pool  = var.proxmox_vm_storage_pool
    efi_type          = var.vm_efi_type
    pre_enrolled_keys = false
  }

  // tpm — FIX: was empty tpm {}; correct block name is tpm_config and version is required
  tpm_config {
    tpm_storage_pool = var.proxmox_vm_storage_pool
    tpm_version      = "v2.0"
  }

  // iso — download from iso_url if not already on Proxmox, verify with checksum
  boot_iso {
    type             = "ide"
    iso_url          = var.iso_url
    iso_checksum     = local.iso_checksum
    iso_storage_pool = var.proxmox_iso_storage_pool
    unmount          = true
  }

  // network
  network_adapters {
    bridge = var.vm_network_bridge
    model  = var.vm_network_model
  }

  // boot — FIX: was var.vm_boot_command (vars file pointed to cdrom; HCL serves via HTTP)
  boot_command = local.bootcmd_grub
  boot_wait    = var.vm_boot_wait

  // kickstart served via Packer's built-in HTTP server
  http_content = local.data_source_content

  // communicator — FIX: was missing entirely (Packer had no way to SSH into the VM)
  communicator         = "ssh"
  ssh_username         = var.build_username
  ssh_private_key_file = local.ssh_private_key_file
  ssh_port             = var.communicator_port
  ssh_timeout          = var.communicator_timeout
}

build {
  // FIX: was source.proxmox.fedora (must match renamed builder type)
  sources = ["source.proxmox-iso.fedora"]
  // FIX: removed broken file provisioners (wrong paths; kickstart is served via HTTP)
}
