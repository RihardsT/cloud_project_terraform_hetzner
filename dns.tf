# Remember to add the nameservers to registrar - i.e. nic.lv
resource "hcloud_zone" "rudenspavasaris" {
  name = "rudenspavasaris.id.lv"
  mode = "primary"
  ttl = 3600
  delete_protection = false
}
