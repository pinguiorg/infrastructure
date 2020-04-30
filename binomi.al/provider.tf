variable "mailgun_api_key" {
  type = string
}

variable "cloudflare_email" {
  type = string
}

variable "cloudflare_api_key" {
  type = string
}

provider "mailgun" {
  api_key = var.mailgun_api_key
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}
