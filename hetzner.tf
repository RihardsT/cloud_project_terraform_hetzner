# Configure the Hetzner Cloud Provider
terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.32"
    }
  }
}
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
  server_type = "cpx11"
  image       = "ubuntu-18.04"
  location    = "hel1"
  ssh_keys    = ["hetzner_key"]
  lifecycle {
    prevent_destroy = true
  }
  firewall_ids = [hcloud_firewall.firewall.id]
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


# New node
resource "hcloud_server" "htz2" {
  name        = "htz2"
  server_type = "cpx21"
  image       = "ubuntu-20.04"
  location    = "hel1"
  ssh_keys    = ["hetzner_key"]
  firewall_ids = [hcloud_firewall.firewall.id]

  provisioner "local-exec" {
    command = <<EOT
      export ANSIBLE_HOST_KEY_CHECKING=False && export ANSIBLE_SSH_RETRIES=5 && \
      ansible-playbook -i ${hcloud_server.htz2.ipv4_address}, \
      -e node_ip_address=${hcloud_server.htz2.ipv4_address} \
      -u root --diff -e ansible_python_interpreter=/usr/bin/python3 -e ansible_port=22 \
      /home/rihards/Code/cloud_project/cloud_project_ansible/Kubes_worker_htz.yml && \
      kubectl apply -f /media/data/Code/cloud_project/cloud_project_kubernetes/Gitlab/gitlab.yml
EOT
  }
  provisioner "local-exec" {
    when    = destroy
    # ssh -o "StrictHostKeyChecking=no" $(terraform output -state=/home/rihards/Code/cloud_project/cloud_project_terraform_gcp/terraform.tfstate | grep -oP '"\K[^"]+') 'sudo s3cmd put /data/gitlab/data/backups/$(sudo ls /data/gitlab/data/backups/) /data/gitlab/config/gitlab-secrets.json s3://rudenspavasaris'; \
    # kubectl exec $(kubectl get pods --no-headers -o custom-columns=":metadata.name" | grep gitlab) -- bash -c 'gitlab-backup create' && \
    command = <<EOT
      kubectl delete -f /media/data/Code/cloud_project/cloud_project_kubernetes/Gitlab/gitlab.yml; \
      kubectl delete node htz2;
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
