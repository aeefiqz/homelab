variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "proxmox_api_url" {
    type = string
}

variable "proxmox_node" {
    type = string
}

variable  "proxmox_storage" {
    type = string
}

variable "cpu_type" {
  type    = string
}

variable "cpu_cores" {
    type = number 
    default = 2
}

variable "cpu_sockets" {
    type = string 
    default = "1"
}

variable "cloud_init_storage_pool" {
    type = string
    default = "local-lvm"
}

variable "vm_id" {
    type = string
    default = "8000"
}

variable "base_iso_file" {
  type    = string
}

variable "talos_version" {
    type = string
    default = "v1.12.4"
}

locals {
    image = "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/${var.talos_version}/nocloud-amd64.raw.xz"
}