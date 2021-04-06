locals {
  domain = "holamyfrend.com"

  shopify_ip     = "23.227.38.65"
  shopify_domain = "shops.myshopify.com"

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

// Create A record for the website hosted on Shopify.
resource "cloudflare_record" "shopify" {
  name    = "@"
  value   = local.shopify_ip
  ttl     = 300
  type    = "A"
  zone_id = cloudflare_zone.holamyfriend.id
}

// Create CNAME record for the website hosted on Shopify.
resource "cloudflare_record" "shopify_cname" {
  name    = "www"
  value   = local.shopify_domain
  ttl     = 300
  type    = "CNAME"
  zone_id = cloudflare_zone.holamyfriend.id
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
