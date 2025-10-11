# Remember to add the nameservers to registrar - i.e. nic.lv
resource "hcloud_zone" "rudenspavasaris" {
  name = "rudenspavasaris.id.lv"
  mode = "primary"
  ttl = 3600
  delete_protection = false
}

resource "hcloud_zone_rrset" "rudenspavasaris" {
  for_each = length(hcloud_server.htz1[*]) > 0 ? toset(["@", "*"]) : []
  zone = hcloud_zone.rudenspavasaris.name
  name = each.value
  type = "A"
  records = [
    { value = hcloud_server.htz1[0].ipv4_address },
  ]
}
