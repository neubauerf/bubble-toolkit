resource "cloudstack_network" "isonet01" {
  count = "1"
  name = "isonet01"
  cidr = "172.16.1.0/24"
  gateway = "172.16.1.1"
  network_offering = "${var.network_offerings["isolatednetworks_redundant"]}"
  zone = "${var.zone}"
}

resource "cloudstack_ipaddress" "isonet01" {
  network_id = "${cloudstack_network.isonet01.id}"
}

resource "cloudstack_firewall" "isonet01" {
  ip_address_id = "${cloudstack_ipaddress.isonet01.id}"
  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol = "tcp"
    ports = ["2201", "2202"]
  }
}


resource "cloudstack_instance" "isonet01-vm01" {
  count = "1"
  name = "isonet01-vm01"
  display_name = "isonet01-vm01"
  ip_address = "172.16.1.11"
  network_id = "${cloudstack_network.isonet01.id}"
  expunge = true
  service_offering = "${var.instance_offering}"
  template = "${var.instance_template}"
  zone = "${var.zone}"
}
resource "cloudstack_port_forward" "isonet01-vm01" {
    count                  = "1"
    ip_address_id          = "${cloudstack_ipaddress.isonet01.id}"
    forward {
        protocol           = "tcp"
        private_port       = 22
        public_port        = 2201
        virtual_machine_id = "${cloudstack_instance.isonet01-vm01.id}"
        vm_guest_ip        = "${cloudstack_instance.isonet01-vm01.ip_address}"
    }
}

resource "cloudstack_instance" "isonet01-vm02" {
  count = "1"
  name = "isonet01-vm02"
  display_name = "isonet01-vm02"
  ip_address = "172.16.1.12"
  network_id = "${cloudstack_network.isonet01.id}"
  expunge = true
  service_offering = "${var.instance_offering}"
  template = "${var.instance_template}"
  zone = "${var.zone}"
}
resource "cloudstack_port_forward" "isonet01-vm02" {
    count                  = "1"
    ip_address_id          = "${cloudstack_ipaddress.isonet01.id}"
    forward {
        protocol           = "tcp"
        private_port       = 22
        public_port        = 2202
        virtual_machine_id = "${cloudstack_instance.isonet01-vm02.id}"
        vm_guest_ip        = "${cloudstack_instance.isonet01-vm02.ip_address}"
    }
}
