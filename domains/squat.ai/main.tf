locals {
  squat_domain = "squat.ai"
  keybase      = "keybase-site-verification=bhjI3ppUvtPNQmhDX4F-jo0VfgavCb2s42K7S7zEY8o"

  do_ns = [
    "ns1.digitalocean.com.",
    "ns2.digitalocean.com.",
    "ns3.digitalocean.com.",
  ]

  github_ips = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
    "2606:50c0:8000::153",
    "2606:50c0:8001::153",
    "2606:50c0:8002::153",
    "2606:50c0:8003::153",
  ]

}

resource "cloudflare_zone" "squat" {
  zone = local.squat_domain
}

resource "aws_route53_zone" "squat" {
  name = "aws.${local.squat_domain}."
}

resource "digitalocean_domain" "squat" {
  name       = "do.${local.squat_domain}"
  ip_address = "8.8.8.8"
}

resource "google_dns_managed_zone" "squat" {
  dns_name    = "gcp.${local.squat_domain}."
  name        = "squat"
  description = "Production DNS zone"
}

resource "cloudflare_record" "kilo" {
  zone_id = cloudflare_zone.squat.id
  name    = "kilo"
  type    = "CNAME"
  value   = "squat-kilo.netlify.com"
}

resource "cloudflare_record" "keybase" {
  zone_id = cloudflare_zone.squat.id
  name    = "@"
  type    = "TXT"
  value   = local.keybase
}

resource "cloudflare_record" "delegate_aws" {
  count   = "4"
  zone_id = cloudflare_zone.squat.id
  name    = "aws"
  type    = "NS"
  value   = element(aws_route53_zone.squat.name_servers, count.index)
}

resource "cloudflare_record" "delegate_gcp" {
  count   = "4"
  zone_id = cloudflare_zone.squat.id
  name    = "gcp"
  type    = "NS"
  value   = trimsuffix(element(google_dns_managed_zone.squat.name_servers, count.index), ".")
}

resource "cloudflare_record" "delegate_do" {
  count   = length(local.do_ns)
  zone_id = cloudflare_zone.squat.id
  name    = "do"
  type    = "NS"
  value   = trimsuffix(element(local.do_ns, count.index), ".")
}

resource "cloudflare_record" "github_pages" {
  count   = length(local.github_ips)
  zone_id = cloudflare_zone.squat.id
  name    = "@"
  type    = can(cidrnetmask(format("%s/0", element(local.github_ips, count.index)))) ? "A" : "AAAA"
  value   = element(local.github_ips, count.index)
}
