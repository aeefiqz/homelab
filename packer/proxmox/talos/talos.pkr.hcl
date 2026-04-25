packer {
    required_plugins {
        proxmox = {
            version = ">= 1.2.3"
            source  = "github.com/hashicorp/proxmox"
        }
    }
}

## variables




## local variables
locals {
    timestamp = timestamp()
}


### source

source "proxmox-iso" "talos" {

    # proxmox connection settings
    proxmox_url              = "${var.proxmox_api_url}"
    username                 = "${var.proxmox_api_token_id}"
    token                    = "${var.proxmox_api_token_secret}"
    node                     = "${var.proxmox_node}"
    insecure_skip_tls_verify = true


    boot_iso {
        type     = "scsi"
        iso_file = "${var.base_iso_file}"
        unmount  = true
    }

    scsi_controller = "virtio-scsi-pci"

    network_adapters {
        bridge = "vmbr0"
        model  = "virtio"
    }

    disks {
        type         = "scsi"
        disk_size    = "40G"
        format       = "raw"
        cache_mode   = "writethrough"
        storage_pool = var.proxmox_storage
    }

    memory = 4096
    vm_id = "${var.vm_id}" 
    cores = var.cpu_cores
    cpu_type = "${var.cpu_type}"
    sockets = var.cpu_sockets
    ssh_username = "root"
    ssh_password = "packer"
    ssh_timeout  = "15m"

    cloud_init = true
    cloud_init_storage_pool = var.cloud_init_storage_pool
    

    template_name = "talos-template-${var.talos_version}-cloud-init-template"
    template_description = "Talos ${var.talos_version} cloud-init template created by Packer on ${local.timestamp}"
    
    boot_wait = "25s"
    boot_command = [
        "<enter><wait1m>",
        "passwd<enter><wait>packer<enter><wait>packer<enter>",
    ]

}

build {
    sources = ["source.proxmox-iso.talos"]
    provisioner "shell" {
        inline = [
            "echo 'Provisioning Talos ISO...'",
            "curl -s -L ${local.image} -o /tmp/talos.raw.xz",
            "xz -d -c /tmp/talos.raw.xz | dd of=/dev/sda && sync",
        ]
    }
}

