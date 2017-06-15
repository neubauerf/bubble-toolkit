
resource "cloudstack_vpc" "vpc02" {
    count           = "1"
    name            = "vpc02"
    cidr            = "10.2.0.0/16"
    vpc_offering    = "${var.vpcofferings["non_redundant"]}"
    zone            = "${var.zone}"
}

// Tier 01
//
resource "cloudstack_network" "vpc02-tier01" {
  count = "1"
  name = "vpc02-tier01"
  cidr = "10.2.1.0/24"
  gateway = "10.2.1.1"
  network_offering = "${var.network_offerings["vpc_isolatednetworks"]}"
  zone = "${var.zone}"
  vpc_id = "${cloudstack_vpc.vpc02.id}"
  acl_id = "${var.default_allow_acl_id}"
}
resource "cloudstack_ipaddress" "vpc02-tier01" {
  count = "1"
  vpc_id = "${cloudstack_vpc.vpc02.id}"
}

resource "cloudstack_instance" "vpc02-tier01-vm01" {
  count = "1"
  name = "vpc02-tier01-vm01"
  display_name = "vpc02-tier01-vm01"
  ip_address = "10.2.1.11"
  network_id = "${cloudstack_network.vpc02-tier01.id}"
  expunge = true
  service_offering = "${var.instance_offering}"
  template = "${var.instance_template}"
  zone = "${var.zone}"
}
resource "cloudstack_port_forward" "vpc02-tier01-vm01" {
    count                  = "1"
    ip_address_id          = "${cloudstack_ipaddress.vpc02-tier01.id}"
    forward {
        protocol           = "tcp"
        private_port       = 22
        public_port        = 2201
        virtual_machine_id = "${cloudstack_instance.vpc02-tier01-vm01.id}"
        vm_guest_ip        = "${cloudstack_instance.vpc02-tier01-vm01.ip_address}"
    }
}


