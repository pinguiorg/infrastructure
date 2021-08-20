module "controllers" {
  source               = "git::https://github.com/squat/hetzner-cloud-kubeadm.git?ref=9d4928792e92309768417ec1461332fabe790a8e"
  host_cidr            = var.host_cidr
  cluster_name         = var.cluster_name
  network_zone         = "eu-central"
  datacenter           = var.datacenter
  ssh_keys             = var.ssh_keys
  controller_type      = var.controller_type
  controller_count     = var.controller_count
  worker_type          = var.worker_type
  worker_count         = var.worker_count
  kubernetes_version   = var.kubernetes_version
  apiserver_extra_args = var.apiserver_extra_args
}

module "worker-pool" {
  source = "git::https://github.com/squat/hetzner-cloud-kubeadm-workers.git?ref=7f55a562014f7f1060a75e90be9a7df96857b376"
  count  = var.worker_pool ? 1 : 0

  api                = module.controllers.api
  token              = module.controllers.token
  ca_cert_hash       = module.controllers.ca_cert_hash
  node_count         = var.worker_pool_count
  os_image           = var.os_image
  cluster_name       = "${var.cluster_name}-worker-pool"
  ssh_keys           = var.ssh_keys
  server_type        = var.worker_type
  datacenter         = var.datacenter
  subnet_id          = hcloud_network_subnet.worker-pool[0].id
  kubernetes_version = var.kubernetes_version
  release_version    = var.release_version
}

resource "hcloud_network" "worker-pool" {
  count    = var.worker_pool ? 1 : 0
  name     = "${var.cluster_name}-worker-pool"
  ip_range = var.worker_pool_cidr
}

resource "hcloud_network_subnet" "worker-pool" {
  count        = var.worker_pool ? 1 : 0
  network_id   = hcloud_network.worker-pool[0].id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = var.worker_pool_cidr
}
