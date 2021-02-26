locals {
  domain  = "holamyfrend.com"

  improvemx_records = [
    {
      value    = "mx1.improvmx.com"
      priority = 10
      type     = "MX"
    },
    {
      value    = "mx2.improvmx.com"
      priority = 20
      type     = "MX"
    },
    {
      value    = "v=spf1 include:spf.improvmx.com ~all"
      priority = 0
      type     = "TXT"
    },
  ]
}

resource "cloudflare_zone" "holamyfriend" {
  zone = local.domain
}

// Create the email forwarding records.
resource "cloudflare_record" "email_forwarding" {
  count    = length(local.improvemx_records)
  name     = "@"
  value    = element(local.improvemx_records, count.index).value
  ttl      = 3600
  type     = element(local.improvemx_records, count.index).type
  priority = element(local.improvemx_records, count.index).priority
  zone_id  = cloudflare_zone.holamyfriend.id
}
