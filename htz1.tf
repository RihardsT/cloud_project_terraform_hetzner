resource "hcloud_server" "htz1" {
  name        = "htz1"
  server_type = "cpx31"
  image       = "ubuntu-22.04"
  location    = "hel1"
  ssh_keys    = ["hetzner_key"]
  # lifecycle {
  #   prevent_destroy = true
  # }
  firewall_ids = [hcloud_firewall.firewall.id]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  provisioner "local-exec" {
    command = <<EOT
    export ANSIBLE_HOST_KEY_CHECKING=False && export ANSIBLE_SSH_RETRIES=5 && \
    ansible-playbook -i ${self.ipv4_address}, \
    -e node_ip_address=${self.ipv4_address} \
    -u root --diff -e ansible_python_interpreter=/usr/bin/python3 -e ansible_port=22 \
    /home/rihards/Code/cloud_project/cloud_project_ansible/htz1.yml
    EOT
  }
}

output "ip" {
  value = hcloud_server.htz1.ipv4_address
}
output "ipv6" {
  value = hcloud_server.htz1.ipv6_address
}
