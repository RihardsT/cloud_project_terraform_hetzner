# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = "${var.hcloud_token}"
}

resource "hcloud_ssh_key" "hetzner_key" {
  name       = "hetzner_key"
  public_key = "${file("~/.ssh/hetzner.pub")}"
  lifecycle {
    prevent_destroy = true
  }
}

resource "hcloud_server" "node1" {
  name        = "htz1"
  server_type = "cx21"
  image       = "ubuntu-18.04"
  location    = "hel1"
  ssh_keys    = ["hetzner_key"]
  lifecycle {
    prevent_destroy = true
  }
}

resource "hcloud_network" "htz_network" {
  name = "htz_network"
  ip_range = "10.0.0.0/16"
}
resource "hcloud_network_subnet" "htz_network_subnet_kube" {
  network_id = "${hcloud_network.htz_network.id}"
  type = "server"
  network_zone = "eu-central"
  ip_range   = "10.0.1.0/24"
}
resource "hcloud_server_network" "htz1_srv_net" {
  server_id = "${hcloud_server.node1.id}"
  network_id = "${hcloud_network.htz_network.id}"
  ip = "10.0.1.4"
}

output "ip" {
  value = "${hcloud_server.node1.ipv4_address}"
}


# Temporary worker node
resource "hcloud_server" "htz2" {
  name        = "htz2"
  server_type = "cx11"
  image       = "ubuntu-18.04"
  location    = "hel1"
  ssh_keys    = ["hetzner_key"]

  provisioner "local-exec" {
    command = <<EOT
      docker run -i --rm -v ~/Code/CloudProject/cloud_project_ansible:/d \
      -v ~/Code/CloudProject/Secrets/:/Secrets/ -v ~/.ssh/:/root/.ssh \
      -w /d williamyeh/ansible:alpine3-onbuild \
      sh -c 'apk add --no-cache openssh-client && \
      eval "$(ssh-agent -s)"; ssh-add /root/.ssh/hetzner && \
      export ANSIBLE_HOST_KEY_CHECKING=False && \
      sleep 90 && \
      ansible-playbook -i ${hcloud_server.htz2.ipv4_address}, -u root --diff -e ansible_python_interpreter=/usr/bin/python3 -e ansible_port=22 Kubes_worker.yml'
EOT
  }
}

resource "hcloud_server_network" "htz2_srv_net" {
  server_id = "${hcloud_server.htz2.id}"
  network_id = "${hcloud_network.htz_network.id}"
  ip = "10.0.1.5"
}

output "ip_htz2" {
  value = "${hcloud_server.htz2.ipv4_address}"
}
