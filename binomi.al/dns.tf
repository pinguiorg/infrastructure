locals {
  domain = "binomi.al"
  zone_id = "6351769cb776c364d2b267fd9a662208"

  github_ips = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ]
}

// Create A records for the website hosted on GitHub.
resource "cloudflare_record" "github" {
  count  = length(local.github_ips)
  name   = "@"
  value  = element(local.github_ips, count.index)
  ttl    = 300
  type   = "A"
  zone_id = local.zone_id
}
