resource "cloudstack_vpn_gateway" "vpc02" {
  vpc_id = "${cloudstack_vpc.vpc02.id}"
}
resource "cloudstack_vpn_gateway" "vpc04" {
  vpc_id = "${cloudstack_vpc.vpc04.id}"
}

resource "cloudstack_vpn_customer_gateway" "vpc02" {
  cidr = "${cloudstack_vpc.vpc02.cidr}"
  esp_policy = "${var.vpn_config["esp_policy"]}"
  gateway = "${cloudstack_vpn_gateway.vpc02.public_ip}"
  ike_policy = "${var.vpn_config["ike_policy"]}"
  ipsec_psk = "${var.vpn_config["ipsec_psk"]}"
  name = "Remote gateway to ${cloudstack_vpc.vpc02.name}"
}
resource "cloudstack_vpn_customer_gateway" "vpc04" {
  name = "Remote gateway to ${cloudstack_vpc.vpc04.name}"
  cidr = "${cloudstack_vpc.vpc04.cidr}"
  gateway = "${cloudstack_vpn_gateway.vpc04.public_ip}"
  esp_policy = "${var.vpn_config["esp_policy"]}"
  ike_policy = "${var.vpn_config["ike_policy"]}"
  ipsec_psk = "${var.vpn_config["ipsec_psk"]}"
}

resource "cloudstack_vpn_connection" "vpc02_to_vpc04" {
  customer_gateway_id = "${cloudstack_vpn_customer_gateway.vpc04.id}"
  vpn_gateway_id = "${cloudstack_vpn_gateway.vpc02.id}"
}
resource "cloudstack_vpn_connection" "vpc04_to_vpc02" {
  customer_gateway_id = "${cloudstack_vpn_customer_gateway.vpc02.id}"
  vpn_gateway_id = "${cloudstack_vpn_gateway.vpc04.id}"
}

//resource "null_resource" "ping" {
//  depends_on = ["cloudstack_vpn_connection.vpc04_to_vpc02","cloudstack_vpn_connection.vpc02_to_vpc04"]
//
//  provisioner "remote-exec" {
//    inline = [
//      "(/bin/ping -c 2 ${cloudstack_instance.vpc04-tier01-vm01.ip_address}); exit"
//    ]
//    connection {
//      type = "ssh"
//      user = "root"
//      password = "password"
//      host = "${cloudstack_ipaddress.vpc02-tier01.ip_address}"
//      port = "2201"
//    }
//  }
//}


