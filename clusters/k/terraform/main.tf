module "workers" {
  source = "git::https://github.com/pinguiorg/hetzner-cloud-kubeadm-workers.git?ref=54110e2f3fc6de62062e88f454d814e7b52d8200"

  api                = var.api
  token              = var.token
  ca_cert_hash       = var.ca_cert_hash
  node_count         = var.node_count
  os_image           = var.os_image
  cluster_name       = var.cluster_name
  ssh_keys           = var.ssh_keys
  server_type        = var.server_type
  datacenter         = var.datacenter
  subnet_id          = hcloud_network_subnet.subnet.id
  kubernetes_version = var.kubernetes_version
  release_version    = var.release_version
}

resource "hcloud_network" "network" {
  name     = "cluster_name"
  ip_range = var.host_cidr
}

resource "hcloud_network_subnet" "subnet" {
  network_id   = hcloud_network.network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = var.host_cidr
}
