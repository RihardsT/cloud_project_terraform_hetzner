# Configure the Hetzner Cloud Provider
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.36"
    }
  }
}
provider "hcloud" {
  token = var.hcloud_token
}
resource "hcloud_ssh_key" "hetzner_key" {
  name       = "hetzner_key"
  public_key = file("~/.ssh/id_ed25519.pub")
  # lifecycle {
  #   prevent_destroy = true
  # }
}
resource "hcloud_ssh_key" "hetzner_key_alt" {
  name       = "hetzner_key_alt"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII+6+zyGdusVLIsx+nnqo4/3qeylb8aFBmCS2wolK3kB"
}

# resource "hcloud_network" "htz_network" {
#   name = "htz_network"
#   ip_range = "10.0.0.0/16"
# }
# resource "hcloud_network_subnet" "htz_network_subnet_kube" {
#   network_id = "${hcloud_network.htz_network.id}"
#   type = "server"
#   network_zone = "eu-central"
#   ip_range   = "10.0.1.0/24"
# }
# resource "hcloud_server_network" "htz1_srv_net" {
#   server_id = "${hcloud_server.htz1.id}"
#   network_id = "${hcloud_network.htz_network.id}"
#   ip = "10.0.1.4"
# }
