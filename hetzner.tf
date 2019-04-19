# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = "${var.hcloud_token}"
}

resource "hcloud_ssh_key" "hetzner_key" {
  name       = "hetzner_key"
  public_key = "${file("~/.ssh/hetzner.pub")}"
}

resource "hcloud_server" "node1" {
  name        = "htz1"
  server_type = "cx21"
  image       = "ubuntu-18.04"
  location    = "hel1"
  ssh_keys    = ["hetzner_key"]
}

output "ip" {
  value = "${hcloud_server.node1.ipv4_address}"
}
