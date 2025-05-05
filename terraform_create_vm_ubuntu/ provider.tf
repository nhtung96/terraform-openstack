terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "1.53.0"
    }
  }
}
# Configure the OpenStack Provider credensial
provider "openstack" {
  user_name   = "admin"
  tenant_name = "admin"
  password    = ""
  auth_url    = "http://A.B.C.D:5000"
  region      = ""
}
