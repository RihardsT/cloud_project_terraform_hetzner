# Remember to add the nameservers to registrar - i.e. nic.lv
resource "hcloud_zone" "rudenspavasaris" {
  name              = "rudenspavasaris.id.lv"
  mode              = "primary"
  ttl               = 3600
  delete_protection = false
}

resource "hcloud_zone_rrset" "rudenspavasaris" {
  for_each = length(hcloud_server.htz1[*]) > 0 ? toset(["@", "*"]) : []
  zone     = hcloud_zone.rudenspavasaris.name
  name     = each.value
  type     = "A"
  records = [
    { value = hcloud_server.htz1[0].ipv4_address },
  ]
}

### Didn't get this to give output, as it wants.
# data "external" "oracle_ips" {
#   # program = [ "bash", "-c", "tfer --dir=/home/rihards/Code/cloud_project/cloud_project_terraform_oracle/ output -json oc0_pub_ip" ]
#   program = [ "echo",  "{\"this\":[0]}" ]
# }

data "terraform_remote_state" "oracle_state" {
  backend = "http"
  config = {
    ### See if these necessary variable can be loaded from file
  }
}

# tfer output oc0_pub_ip
resource "hcloud_zone_rrset" "oc_servers" {
  for_each = toset(data.terraform_remote_state.oracle_state.outputs.oc0_pub_ip)
  zone     = hcloud_zone.rudenspavasaris.name
  name     = "oc${index(data.terraform_remote_state.oracle_state.outputs.oc0_pub_ip, each.value)}"
  type     = "A"
  records = [
    { value = each.value },
  ]
}

resource "hcloud_zone_rrset" "oc_servers_wildcard" {
  for_each = toset(data.terraform_remote_state.oracle_state.outputs.oc0_pub_ip)
  zone     = hcloud_zone.rudenspavasaris.name
  name     = "*.oc${index(data.terraform_remote_state.oracle_state.outputs.oc0_pub_ip, each.value)}"
  type     = "A"
  records = [
    { value = each.value },
  ]
}
