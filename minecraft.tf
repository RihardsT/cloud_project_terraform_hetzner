resource "hcloud_server" "minecraft" {
  name         = "minecraft"
  server_type  = "cpx21"
  image        = "ubuntu-22.04"
  location     = "hel1"
  ssh_keys     = ["hetzner_key"]
  firewall_ids = [hcloud_firewall.firewall.id]

  provisioner "local-exec" {
    command = <<EOT
      kubectl apply -f /home/rihards/Code/cloud_project/cloud_project_kubernetes/Minecraft/minecraft.yml; \
      export ANSIBLE_HOST_KEY_CHECKING=False && export ANSIBLE_SSH_RETRIES=5 && \
      ansible-playbook -i ${self.ipv4_address}, \
      -e node_ip_address=${self.ipv4_address} \
      -u root --diff -e ansible_python_interpreter=/usr/bin/python3 -e ansible_port=22 \
      /home/rihards/Code/cloud_project/cloud_project_ansible/Minecraft.yml
EOT
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
    kubectl delete -f /home/rihards/Code/cloud_project/cloud_project_kubernetes/Minecraft/minecraft.yml; \
    kubectl delete node minecraft; \
    ssh -o "StrictHostKeyChecking=no" $(terraform output -state=/home/rihards/Code/cloud_project/cloud_project_terraform_hetzner/terraform.tfstate minecraft | grep -oP '"\K[^"]+') sh -c '/data/minecraft_backup.sh'
EOT
  }
}
# resource "hcloud_server_network" "minecraft_srv_net" {
#   server_id = "${hcloud_server.minecraft.id}"
#   network_id = "${hcloud_network.htz_network.id}"
#   ip = "10.0.1.6"
# }

output "minecraft" {
  value = hcloud_server.minecraft.ipv4_address
}
