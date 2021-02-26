locals {
  domain = "binomi.al"

  github_ips = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ]

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

resource "cloudflare_zone" "binomial" {
  zone = local.domain
}

// Create A records for the website hosted on GitHub.
resource "cloudflare_record" "github" {
  count   = length(local.github_ips)
  name    = "@"
  value   = element(local.github_ips, count.index)
  ttl     = 300
  type    = "A"
  zone_id = cloudflare_zone.binomial.id
}

// Create the email forwarding records.
resource "cloudflare_record" "email_forwarding" {
  count    = length(local.improvemx_records)
  name     = "@"
  value    = element(local.improvemx_records, count.index).value
  ttl      = 3600
  type     = element(local.improvemx_records, count.index).type
  priority = element(local.improvemx_records, count.index).priority
  zone_id  = cloudflare_zone.binomial.id
}
