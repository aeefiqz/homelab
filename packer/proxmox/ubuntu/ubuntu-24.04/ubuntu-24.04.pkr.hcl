// BLOCK: packer 
// The packer configuration 
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
// BLOCK: data
// Define variables for data
data "sshkey" "install" {
    type        = "ed25519"
    name        = "packer_key"
}


// BLOCK: local
// Define the local variables
locals {
    build_date              = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
    build_tool              = "Hashicorp Packer ${packer.version}"
    build_description       = "Ubuntu Server 24.04 LTS template\nBuild Date ${local.build_date}\nBuild tool: ${local.build_tool}"
    iso_checksum            = "${var.iso_checksum_type}:${var.iso_checksum_value}"
    iso_path                = "${var.proxmox_iso_path}/${var.iso_file}"
    ssh_private_key_file    = data.sshkey.install.private_key_path
    ssh_public_key          = data.sshkey.install.public_key
    // efi

    //network adapters
    proxmox_network_bridge  = "vmbr0"
    proxmox_network_model   = "virtio"


    data_source_content {
    }
}


source "proxmox-iso" "ubuntu-24.04" {
    // proxmox connection and endpoint settings
    proxmox_url              = "https://${var.proxmox_host}:8006/api2/json"
    username                 = var.proxmox_user
    token                    = var.proxmox_apikey
    insecure_skip_tls_verify = true
    // node settings
    node                     = var.proxmox_node
    
    // virtual machine settings 
    qemu_agent                 = var.vm_qemu_agent
    bios                       = var.vm_bios_type
    cores                      = var.vm_cpu_cores
    sockets                    = var.vm_cpu_count 
    cpu_type                   = var.vm_cpu_type 
    memory                     = var.vm_mem_size 
    os                         = var.vm_guest_os_type 
    scsi_controller            = var.vm_scsi_controller 
    // template meta data
    template_name              = var.vm_template_name 
    template_description       = var.vm_template_description 
    vm_name                    = var.vm_name 

    // disk configurations
    disk {
        type                   = "scsi"
        disk_size              = var.vm_disk_size 
        format                 = var.disk_format
        storage_pool           = var.proxmox_vm_storage_pool
    }

    // efi configurations
    efi_config {
        efi_storage_pool       = local.proxmox_vm_storage_pool
        efi_type               = "4m"
        pre_enrolled_keys      = true 
    }
    // network adapters
    network_adapters {
        bridge                 = local.proxmox_network_bridge
        model                  = local.vm_network_model
    }

    // Removable Media settings 
    additional_iso_files {
        cd_content              = local.data_source_content
        cd_label                = var.cd_label
        iso_storage_pool        = local.proxmox_iso_storage_pool
        unmount_iso             = var.remove_cdrom
    }
    
    boot_iso {
        //iso_file               = local.iso_path
        iso_url                = var.iso_url
        iso_checksum           = var.iso_checksum
        iso_download_pve       = true
        iso_storage_pool       = var.proxmox_iso_storage_pool
        unmount                = var.unmount_iso
    }

    // deprecated iso settings
    // iso_checksum               = local.iso_checksum 
    // iso_url                    = var.iso_url
    // iso_download_pve           = true // download the iso image from iso_url and store in iso path
    //iso_storage_pool           = local.proxmox_iso_storage_pool
    // unmount_iso                = var.remove_cdrom


    // Boot and Provisioning settings 
    boot_command               = var.vm_boot_command 
    boot_wait                  = var.vm_boot_wait

    // Communicator Settings and Credentials 
    communicator               = "ssh"
    ssh_clear_authorized_keys  = var.build_remove_keys
    ssh_port                   = var.communicator_port 
    ssh_private_key_file       = local.ssh_private_key_file 
    ssh_timeout                = var.communicator_timeout
    ssh_username               = local.communicator_username
    
}

// BLOCK: Build 
// Define the builders to run, provisioners, and post-processors
build {
    sources = [
        "source.proxmox-iso.ubuntu-24.04"
    ]

    provisioner "file" {
        source          = "sssss"
        destination     = "sssss"
    }

    provisioner "file" {
        source          = "ssss"
        destination     = "ssss"
    }
}