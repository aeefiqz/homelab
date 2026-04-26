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
    type = "ed25519"
    name = "packer_key"
}


// BLOCK: local
// Define the local variables
locals {
    build_date           = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
    build_tool           = "Hashicorp Packer ${packer.version}"
    build_description    = "Ubuntu Server 24.04 LTS template\nBuild Date ${local.build_date}\nBuild tool: ${local.build_tool}"
    iso_checksum         = "${var.iso_checksum_type}:${var.iso_checksum_value}"
    ssh_private_key_file = data.sshkey.install.private_key_path
    ssh_public_key       = data.sshkey.install.public_key
    // efi
    efi_storage_pool  = var.proxmox_vm_storage_pool
    efi_type          = "4m"
    pre_enrolled_keys = true
    // network
    proxmox_network_bridge = "vmbr0"
    // communicator
    communicator_username = var.build_username

    data_source_content = {
        "/meta-data" = file("${abspath(path.root)}/http/meta-data.yaml")
        "/user-data"  = templatefile("${path.root}/http/user-data.pkrtpl.hcl", {
            apt_mirror           = var.cloud_init_apt_mirror
            apt_packages         = var.cloud_init_apt_packages
            build_password_hash  = var.build_password_hash
            build_username       = var.build_username
            ssh_keys             = [local.ssh_public_key]
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


source "proxmox-iso" "ubuntu2404" {
    // proxmox connection and endpoint settings
    proxmox_url              = "https://${var.proxmox_host}:8006/api2/json"
    username                 = var.proxmox_user
    token                    = var.proxmox_apikey
    insecure_skip_tls_verify = true
    // node settings
    node  = var.proxmox_node
    vm_id = var.vm_id

    // tpm config
    tpm_config {
        tpm_version      = "v2.0"
        tpm_storage_pool = var.proxmox_vm_storage_pool
    }

    // virtual machine settings
    qemu_agent      = var.vm_qemu_agent
    bios            = var.vm_bios_type
    cores           = var.vm_cpu_cores
    sockets         = var.vm_cpu_count
    cpu_type        = var.vm_cpu_type
    memory          = var.vm_mem_size
    os              = var.vm_guest_os_type
    scsi_controller = var.vm_scsi_controller
    // template meta data
    template_name        = var.vm_template_name
    template_description = var.vm_template_description
    vm_name              = var.vm_name

    // disk configurations
    disks {
        type         = "scsi"
        disk_size    = var.vm_disk_size
        format       = var.disk_format
        storage_pool = var.proxmox_vm_storage_pool
    }

    // efi configurations
    efi_config {
        efi_storage_pool  = local.efi_storage_pool
        efi_type          = local.efi_type
        pre_enrolled_keys = local.pre_enrolled_keys
    }

    // network adapters
    network_adapters {
        bridge = local.proxmox_network_bridge
        model  = var.vm_network_model
    }

    // serve user-data and meta-data via Packer's built-in HTTP server
    http_content = local.data_source_content

    task_timeout = "10m" //https://github.com/hashicorp/packer-plugin-proxmox/issues/313
    // boot ISO - Proxmox downloads it from iso_url if not already present
    boot_iso {
        iso_url          = var.iso_url
        iso_checksum     = local.iso_checksum
        iso_storage_pool = var.proxmox_iso_storage_pool
        iso_download_pve = true
        unmount          = var.unmount_iso
    }

    // Boot and Provisioning settings
    boot_command = var.vm_boot_command
    boot_wait    = var.vm_boot_wait

    // Communicator Settings and Credentials
    communicator              = "ssh"
    ssh_clear_authorized_keys = var.build_remove_keys
    ssh_port                  = var.communicator_port
    ssh_private_key_file      = local.ssh_private_key_file
    ssh_timeout               = var.communicator_timeout
    ssh_username              = local.communicator_username
    ssh_handshake_attempts    = "100"
}

// BLOCK: Build
// Define the builders to run, provisioners, and post-processors
build {
    sources = [
        "source.proxmox-iso.ubuntu2404"
    ]

    provisioner "shell" {
        execute_command   = "bash {{ .Path }}"
        expect_disconnect = true
        scripts           = formatlist("${path.cwd}/%s", var.post_install_scripts)
    }

    provisioner "shell" {
        execute_command   = "bash {{ .Path }}"
        expect_disconnect = true
        pause_before      = "30s"
        scripts           = formatlist("${path.cwd}/%s", var.pre_final_scripts)
    }
}
