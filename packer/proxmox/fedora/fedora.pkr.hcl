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
}


source "proxmox" "fedora" {
    // proxmox configuration
    node             = var.proxmox_node
    proxmox_url      = var.proxmox_url
    username         = var.proxmox_user
    //password         = var.proxmox_password // password authentication is not recommended, use token authentication instead
    token            = var.proxmox_token
    insecure_skip_tls_verify = true // ssl certicate not configured for proxmox server, so skip tls verify
    task_timeout       = "10m" // increase task timeout to 10 minutes to avoid timeout issues during provisioning, especially for larger images or slower hardware
    
    // virtual machine configuration
    vm_id            = var.vm_id
    vm_name          = "base-${var.fedora_version}"

    // bios configuration
    bios            = var.vm_bios_type

    // cpu and memory configuration
    cpu_type        = var.vm_cpu_type
    cpu_cores       = var.vm_cpu_cores
    cpu_sockets     = var.vm_cpu_sockets
    memory          = var.vm_memory
    // disk configuration 
    disk {
        type         = var.vm_disk_type
        disk_size    = var.vm_disk_size
        storage_pool = var.vm_disk_storage_pool
    }

    // efi configuration
    efi {
        efi_storage_pool  = var.vm_efi_storage_pool
        efi_type          = var.vm_efi_type
        efi_format        = var.vm_efi_format
        pre_enrolled_keys = false
    }
    // tpm configuration
    tpm {

    }

    // removable media configuration
    boot_iso {
        type             = var.vm_iso_type
        iso_file         = var.vm_iso_file
        iso_checksum     = var.vm_iso_checksum
        unmount          = true
    }
    // network configuration
    network_adapters {
        bridge = var.vm_network_bridge
        model  = var.vm_network_model
    }
    // boot configuration
    boot_command = var.boot_command
    boot_wait    = "10s"
    
    // kickstart configuration

    // communicatior configuration

}
    
build {
    sources = [
        "source.proxmox.fedora"
    ]
}