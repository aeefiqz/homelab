locals {
    lightsail_name = "wireguard-vpn"
    availability_zone = "ap-southeast-1a"
    enviroment = "prd"
    instance_count = 1
    blueprint_id = "ubuntu_22_04"
    bundle_id = "micro_2_0"
}


module "lightsail" {
    source  = "clouddrove/lightsail/aws"
    version = "1.3.2"
    name = local.lightsail_name
    environment = local.enviroment
    instance_count = local.instance_count
    availability_zone = local.availability_zone
    blueprint_id = local.blueprint_id
    bundle_id = local.bundle_id
    use_default_key_pair =  false
    create_static_ip = true
    public_key  = file("${path.module}/wireguard_lightsail.pub")
    domain_name = ""

    port_info = [
        {
            port = 53880
            cidrs = ["0.0.0.0/0"] // allow all incoming traffic
            protocol  = "udp"
        },
        {
            port = 22
            cidrs = ["0.0.0.0/0"]
            protocol  = "tcp"
        }
    ]
    
}