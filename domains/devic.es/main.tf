locals {
  devices_domain = "devic.es"
}

resource "cloudflare_zone" "devices" {
  zone = local.devices_domain
}

resource "cloudflare_ruleset" "github" {
  zone_id = cloudflare_zone.devices.id
  name    = "GitHub"
  kind    = "zone"
  phase   = "http_request_dynamic_redirect"

  rules {
    action = "redirect"
    action_parameters {
      from_value {
        status_code = 301
        target_url {
          value = "https://github.com/squat/generic-device-plugin"
        }
      }
    }
    expression = "true"
    enabled    = true
  }
}
