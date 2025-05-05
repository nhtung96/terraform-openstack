variable "ext_network_id" {
    description = "The external network ID to be used."
    default  = ""
}

variable "instance_name" {
    description = ""
    default  = "vm-test"
}

variable "image_id" {
    description = "The image ID to be used."
    default  = ""
}

variable "flavor_id" {
    description = "The flavor id to be used."
    default  = ""
}

variable "floating_ip_pool" {
    description = "The external network to be used to get floating ip"
    default = ""
}

variable "default_security_group_id" {
    description = "The default security group ID to be used"
    default = ""
}
