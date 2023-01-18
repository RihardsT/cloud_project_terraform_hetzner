## Start
Create `terraform.tfvars` file with the Hetzner token. Like this:
```
hcloud_token = "TOKEN_GOES_HERE"
```

Run `terraform init` to get latest provider version that takes the correct server sizes

```
terraform plan
terraform apply
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


Without upgrade packages, Kubectl apply at end:
hcloud_server.minecraft: Creation complete after 7m52s [id=19851477]

With upgrade packages:
hcloud_server.minecraft: Creation complete after 4m5s
