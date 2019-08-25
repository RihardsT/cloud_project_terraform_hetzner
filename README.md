## Start
Run `terraform init` to get latest provider version that takes the correct server sizes

```
terraform plan
terraform apply
```

cd ~/Code/CloudProject/cloud_project_terraform_hetzner
terraform destroy -target hcloud_server_network.htz2_srv_net -target hcloud_server.htz2
