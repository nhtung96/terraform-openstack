resource "openstack_networking_network_v2" "internal_networks" {
  count = 6

  name = "internal_network_${count.index + 1}"
}

resource "openstack_networking_subnet_v2" "internal_subnets" {
  count = 6

  name            = "internal_subnet_${count.index + 1}"
  network_id      = openstack_networking_network_v2.internal_networks[count.index].id
  cidr            = "10.0.${count.index + 1}.0/24"
  gateway_ip      = "10.0.${count.index + 1}.1"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_router_v2" "router" {
  count = 6

  name = "router_${count.index + 1}"
  external_network_id = var.ext_network_id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  count = 6

  router_id      = openstack_networking_router_v2.router[count.index].id
  subnet_id      = openstack_networking_subnet_v2.internal_subnets[count.index].id
}

resource "openstack_compute_keypair_v2" "admin" {
  name       = "admin"
  public_key = ""
}


resource "openstack_compute_instance_v2" "vm" {
  count = 6

  name = format("%s-%02d", var.instance_name, count.index+1)
  image_id = var.image_id
  key_pair = openstack_compute_keypair_v2.admin.name
  flavor_id = var.flavor_id
  network {
    uuid = openstack_networking_network_v2.internal_networks[count.index].id
  }
  user_data = file("/root/terraform_create_vm_ubuntu/cloud_config.yml")
}

resource "openstack_networking_floatingip_v2" "fip" {
  count = 6
  pool = var.floating_ip_pool
}

resource "openstack_compute_floatingip_associate_v2" "fip" {
  count = 6
  floating_ip = openstack_networking_floatingip_v2.fip[count.index].address
  instance_id = openstack_compute_instance_v2.vm[count.index].id
}

resource "openstack_networking_secgroup_rule_v2" "allow-ssh" {
  description       = "allow-ssh"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = var.default_security_group_id
}
