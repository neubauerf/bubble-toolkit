resource "cloudstack_network" "isonet02" {
  count = "1"
  name = "isonet02"
  cidr = "172.16.2.0/24"
  gateway = "172.16.2.1"
  network_offering = "${var.network_offerings["isolatednetworks"]}"
  zone = "${var.zone}"
}

resource "cloudstack_ipaddress" "isonet02" {
  network_id = "${cloudstack_network.isonet02.id}"
}

resource "cloudstack_firewall" "isonet02" {
  ip_address_id = "${cloudstack_ipaddress.isonet02.id}"
  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol = "tcp"
    ports = ["2201"]
  }
}

resource "cloudstack_instance" "isonet02-vm01" {
  count = "1"
  name = "isonet02-vm01"
  display_name = "isonet02-vm01"
  ip_address = "172.16.2.11"
  network_id = "${cloudstack_network.isonet02.id}"
  expunge = true
  service_offering = "${var.instance_offering}"
  template = "${var.instance_template}"
  zone = "${var.zone}"
}
resource "cloudstack_port_forward" "isonet02-vm01" {
    count                  = "1"
    ip_address_id          = "${cloudstack_ipaddress.isonet02.id}"
    forward {
        protocol           = "tcp"
        private_port       = 22
        public_port        = 2201
        virtual_machine_id = "${cloudstack_instance.isonet02-vm01.id}"
        vm_guest_ip        = "${cloudstack_instance.isonet02-vm01.ip_address}"
    }
}
