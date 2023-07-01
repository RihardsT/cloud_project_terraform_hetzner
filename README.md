# Quick
Set up alias, to this really quickly and easy
```
tee -a .bashrc <<EOF
alias htz_up="terraform -chdir=/media/data/Code/cloud_project/cloud_project_terraform_hetzner/ apply -target=hcloud_server.htz1 -auto-approve"
alias htz_down="terraform -chdir=/media/data/Code/cloud_project/cloud_project_terraform_hetzner/ destroy -target=hcloud_server.htz1 -auto-approve"
EOF
```

## Start
Create `terraform.tfvars` file with the Hetzner token. Like this:
```
hcloud_token = "TOKEN_GOES_HERE"
```

Run `terraform init -upgrade` to get latest provider version that takes the correct server sizes

```
terraform plan
terraform apply
```
Provision with ansible manually, when something fails
```
SERVER_IP=rudenspavasaris.id.lv
export ANSIBLE_HOST_KEY_CHECKING=False && export ANSIBLE_SSH_RETRIES=5 && \
ansible-playbook -i ${SERVER_IP}, \
-e node_ip_address=${SERVER_IP} \
--diff -e ansible_python_interpreter=/usr/bin/python3 -e ansible_port=22 \
/home/rihards/Code/cloud_project/cloud_project_ansible/htz1.yml
```

### Firewall rollout
Needed to update the provider, as I hadn't ran this is in a long time.
`terraform state replace-provider registry.terraform.io/-/hcloud hetznercloud/hcloud`
Needed to also add the `terraform` `required_providers` block.
```
cd ~/Code/cloud_project/cloud_project_terraform_hetzner
terraform apply -target=hcloud_firewall.firewall
terraform apply -target=hcloud_server.node1
```

### Temporary worker node
```
cd ~/Code/cloud_project/cloud_project_terraform_hetzner
terraform apply -target=hcloud_server_network.htz2_srv_net -target=hcloud_server.htz2

terraform destroy -target=hcloud_server.htz2 -target=hcloud_server_network.htz2_srv_net
```

### Temporary Minecraft node
cd ~/Code/cloud_project/cloud_project_terraform_hetzner
terraform apply -auto-approve -target=hcloud_server.minecraft

cd ~/Code/cloud_project/cloud_project_terraform_hetzner
terraform destroy -auto-approve -target=hcloud_server.minecraft

### Images
curl \
	-H "Authorization: Bearer $API_TOKEN" \
	'https://api.hetzner.cloud/v1/images'
