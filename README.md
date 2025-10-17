# TO DO
- [ ] Save state in Gitlab?

# Quick
Set up silly alias, to this really quickly and easy
```
tee -a ~/.bash_aliases <<EOF
alias htz_up="tofu -chdir=/home/rihards/Code/cloud_project/cloud_project_terraform_hetzner/ apply -auto-approve -var='htz1=true'"
alias htz_down="tofu -chdir=/home/rihards/Code/cloud_project/cloud_project_terraform_hetzner/ apply -auto-approve -var='htz1=false'"
alias rpssh="ssh rudenspavasaris.id.lv -o StrictHostKeyChecking=no -o 'UserKnownHostsFile=/dev/null'"
alias htz_ansible="ansible-playbook -i $(tofu -chdir=/home/rihards/Code/cloud_project/cloud_project_terraform_hetzner/ output -json ip | jq -r '.[]'), \
    -e node_ip_address=$(tofu -chdir=/home/rihards/Code/cloud_project/cloud_project_terraform_hetzner/ output -json ip | jq -r '.[]') \
    -u rihards --diff -e ansible_python_interpreter=/usr/bin/python3 -e ansible_port=22 \
    /home/rihards/Code/cloud_project/cloud_project_ansible/htz1.yml"
EOF
```

## Start
Create token in Hetzner Cloud -> Security -> Tokens
Create `terraform.tfvars` file with the Hetzner token. Like this:
```
hcloud_token = "TOKEN_GOES_HERE"
```

Run `terraform init -upgrade` to get latest provider version that takes the correct server sizes

Create dependencies - firewall and ssh key, as I'm going to do as one shouldn't:
using targets. Eh
```
terraform -chdir=/home/rihards/Code/cloud_project/cloud_project_terraform_hetzner/ apply -target=hcloud_ssh_key.hetzner_key -target=hcloud_firewall.firewall -auto-approve
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

### Import resources
First get IDs via API. Reference:  
https://docs.hetzner.cloud/
```
curl -H "Authorization: Bearer $(cat terraform.tfvars | grep -oP '"\K[^"]+')" \
	"https://api.hetzner.cloud/v1/firewalls"
curl -H "Authorization: Bearer $(cat terraform.tfvars | grep -oP '"\K[^"]+')" \
	"https://api.hetzner.cloud/v1/ssh_keys"

terraform import hcloud_firewall.firewall 1238619
terraform import hcloud_ssh_key.hetzner_key 19311507
```


### hcloud cli
https://github.com/hetznercloud/cli/blob/main/docs/tutorials/setup-hcloud-cli.md
```shell
curl -sSLO https://github.com/hetznercloud/cli/releases/latest/download/hcloud-linux-amd64.tar.gz
sudo tar -C /usr/local/bin --no-same-owner -xzf hcloud-linux-amd64.tar.gz hcloud
rm hcloud-linux-amd64.tar.gz

# source <(hcloud completion bash)
hcloud completion fish > ~/.config/fish/completions/hcloud.fish

hcloud context create default
```
