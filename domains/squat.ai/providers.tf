provider "aws" {
  region = "us-east-1"
}

provider "google" {
  credentials = "/home/squat/.config/gcloud/credentials.json"
  project     = "squat-240910"
  region      = "us-central1"
}

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

variable "digitalocean_token" {
  type = string
}

provider "digitalocean" {
  token = var.digitalocean_token
}
