variable "controller_count" {
  type        = number
  description = "Number of controllers (i.e. masters)"
  default     = 1
}

variable "worker_count" {
  type        = number
  description = "Number of workers"
  default     = 0
}

variable "worker_pool" {
  type        = bool
  description = "Whether or not a worker pool should be created"
  default     = false
}

variable "worker_pool_count" {
  type        = number
  description = "Number of workers in the additional worker pool"
  default     = 1
}

variable "os_image" {
  type        = string
  description = "Channel for a Container Linux derivative (stable, beta, alpha)"
  default     = "stable"

  validation {
    condition     = contains(["stable", "beta", "alpha"], var.os_image)
    error_message = "The os_image must be stable, beta, or alpha."
  }
}

variable "cluster_name" {
  type        = string
  description = "Cluster name used as prefix for the nodes names"
}

variable "ssh_keys" {
  type        = list(string)
  description = "SSH public keys for user 'core' and to register on Hetzner Cloud"
}

variable "controller_type" {
  type        = string
  default     = "cx11"
  description = "The server type to rent for controllers"
}

variable "worker_type" {
  type        = string
  default     = "cx11"
  description = "The server type to rent for workers"
}

variable "datacenter" {
  type        = string
  description = "The region to deploy in"
}

variable "kubernetes_version" {
  type        = string
  description = "The Kubernetes version to install"
}

variable "release_version" {
  type        = string
  default     = "v0.4.0"
  description = "The version of the Kubernetes release package"
}

variable "host_cidr" {
  type        = string
  description = "CIDR IPv4 range to assign to the nodes"
  default     = "10.0.0.0/16"
}

variable "worker_pool_cidr" {
  type        = string
  description = "CIDR IPv4 range to assign to the nodes in the worker pool"
  default     = "10.10.0.0/16"
}

variable "apiserver_extra_args" {
  type        = string
  description = "Extra arguments to pass to the API server as a JSON object, e.g. {\"oidc-username-claim\": \"email\", \"oidc-groups-claim\": \"groups\"}"
  default     = ""
}
