variable "cloudflare_email" {
  type = string
}

variable "cloudflare_api_key" {
  type = string
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}
