resource "hcloud_firewall" "firewall" {
  name = "firewall"
  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule { # SSH for temporary worker node
    direction  = "in"
    protocol   = "tcp"
    port       = "22"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule { # ACME
    direction  = "in"
    protocol   = "tcp"
    port       = "81"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule { # ACME
    direction  = "in"
    protocol   = "udp"
    port       = "81"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "3013"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule { # Kubernetes API
    direction  = "in"
    protocol   = "tcp"
    port       = "6443"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule { # Minecraft
    direction  = "in"
    protocol   = "tcp"
    port       = "25565"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule { # Minecraft
    direction  = "in"
    protocol   = "udp"
    port       = "25565"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule { # Kubelet API, required to see logs
    direction  = "in"
    protocol   = "tcp"
    port       = "10250"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule { # Flannel, required for container to container networking
    direction  = "in"
    protocol   = "udp"
    port       = "8472"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  # rule { # Flask test
  #   direction = "in"
  #   protocol  = "tcp"
  #   port      = "5000"
  #   source_ips = ["0.0.0.0/0", "::/0"]
  # }
  # rule { # OpenVPN
  #   direction = "in"
  #   protocol  = "udp"
  #   port      = "1194"
  #   source_ips = ["0.0.0.0/0", "::/0"]
  # }
  # rule { # OpenVPN
  #   direction = "in"
  #   protocol  = "tcp"
  #   port      = "8088"
  #   source_ips = ["0.0.0.0/0", "::/0"]
  # }
  rule { # Local Fleet server for testing only
    direction  = "in"
    protocol   = "tcp"
    port       = "8220"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}
