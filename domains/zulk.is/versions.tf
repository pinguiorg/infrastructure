terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "3.30.0"
    }
  }
  required_version = ">= 0.13.0"
}
