// To create/load variables below, run: source <(/data/shared/helper_scripts/cosmic/get_terraform_vars.py)
variable "CLOUDSTACK_API_URL" {}
variable "CLOUDSTACK_API_KEY" {}
variable "CLOUDSTACK_SECRET_KEY" {}

variable "default_allow_acl_id" {}
variable "default_deny_acl_id" {}

variable "zone" {
  default = "MCCT-SHARED-1"
}

provider "cloudstack" {
    api_url    = "${var.CLOUDSTACK_API_URL}"
    api_key    = "${var.CLOUDSTACK_API_KEY}"
    secret_key = "${var.CLOUDSTACK_SECRET_KEY}"
}

variable "vpcofferings" {
  type = "map"
  default = {
    "non_redundant" = "Default VPC offering"
    "redundant" = "Redundant VPC offering"
  }
}

variable "network_offerings" {
  type = "map"
  default {
    "vpc_isolatednetworks" = "DefaultIsolatedNetworkOfferingForVpcNetworks"
    "isolatednetworks" = "DefaultIsolatedNetworkOffering"
    "isolatednetworks_egress" = "DefaultIsolatedNetworkOfferingWithEgress"
    "isolatednetworks_redundant" = "DefaultRedundantIsolatedNetworkOffering"
    "isolatednetworks_redundant_egress" = "DefaultRedundantIsolatedNetworkOfferingWithEgress"
    "privatenetworks" = "DefaultPrivateGatewayNetworkOffering"
  }
}

variable "instance_offering" {
  default = "Small Instance"
}
variable "instance_template" {
  default = "tiny linux kvm"
}

variable "vpn_config" {
  type = "map"
  default = {
    esp_policy = "aes128-sha256;modp2048"
    ike_policy = "aes128-sha256;modp2048"
// CS 4.4.4 Compatible:
//    esp_policy = "aes128-sha1;modp1536"
//    ike_policy = "aes128-sha1;modp1536"
    ipsec_psk = "notasecret"
  }
}