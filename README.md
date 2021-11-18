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

cd ~/Code/CloudProject/cloud_project_terraform_hetzner
terraform destroy -target hcloud_server_network.htz2_srv_net -target hcloud_server.htz2



### Firewall rollout
Needed to update the provider, as I hadn't ran this is in a long time.
`terraform state replace-provider registry.terraform.io/-/hcloud hetznercloud/hcloud`
Needed to also add the `terraform` `required_providers` block.

terraform apply -target=hcloud_firewall.firewall
terraform apply -target=hcloud_server.node1
