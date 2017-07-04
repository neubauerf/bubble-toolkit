resource "cloudstack_egress_firewall" "isonet01" {
  network_id = "${cloudstack_network.isonet01.id}"

  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol = "tcp"
    ports = [8080]
  }
  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol = "icmp"
  }
}

resource "cloudstack_egress_firewall" "isonet02" {
  network_id = "${cloudstack_network.isonet02.id}"

  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol = "tcp"
    ports = [8080]
  }
  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol = "icmp"
  }
}

resource "cloudstack_egress_firewall" "isonet03" {
  network_id = "${cloudstack_network.isonet03.id}"

  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol = "tcp"
    ports = [8080]
  }
  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol = "icmp"
  }
}

resource "cloudstack_egress_firewall" "isonet04" {
  network_id = "${cloudstack_network.isonet04.id}"

  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol = "tcp"
    ports = [8080]
  }
  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol = "icmp"
  }
}

resource "null_resource" "wget_to_outside_from_isonet01-vm01" {
  depends_on = ["cloudstack_egress_firewall.isonet01"]

  provisioner "remote-exec" {
    inline = [
      "echo testing",
      "cat /etc/services",
//      "/sbin/route",
//      "ping -c 1 localhost",
//      "echo using 1 ping works!!!",
//      "/sbin/route",
//      "gw=$(/sbin/route | grep default | /usr/bin/awk '{print $2}'); echo $gw",
//      "gw=$(/sbin/route | grep default | /usr/bin/awk '{print $2}'); ping -c 1 $gw",
//      "ping -c 2 localhost",
//      "echo using 2 pings doesnt work",
//      "wget -t 1 -T 5 192.168.23.1:8080",
//      "echo also doesnt work",
//      "echo done"
    ]
    connection {
      type = "ssh"
      user = "root"
      password = "password"
      host = "${cloudstack_ipaddress.isonet01.ip_address}"
      port = "2201"
      timeout = "30s"
    }
  }
}