////resource "cloudstack_network" "private_gateway_network01" {
////  count = "1"
////  name = "private_gateway_network01"
////  cidr = "172.16.101.0/24"
////  network_offering = "${var.network_offerings["privatenetworks"]}"
////  zone = "${var.zone}"
////}
//
//resource "cloudstack_private_gateway" "vpc01" {
//  ip_address = "172.16.101.1"
//  netmask = "255.255.255.0"
//  vpc_id = "${cloudstack_vpc.vpc01}"
//  acl_id = "${var.default_allow_acl_id}"
//  gateway = "172.16.101.3"
//  vlan = "lswitch:{UUID}"
//  network_offering = "${var.network_offerings["privatenetworks"]}"
////  physical_network_id = "STT?"
//}
//
//resource "cloudstack_private_gateway" "vpc03" {
//  ip_address = "172.16.101.3"
//  netmask = "255.255.255.0"
//  vpc_id = "${cloudstack_vpc.vpc02}"
//  acl_id = "${var.default_allow_acl_id}"
//  gateway = "172.16.101.1"
//  vlan = "lswitch:{UUID}"
//  network_offering = "${var.network_offerings["privatenetworks"]}"
////  physical_network_id = "STT?"
//}
