locals {
  domain = "pingui.org"
}

resource "cloudflare_zone" "pingui" {
  zone = local.domain
}

resource "aws_route53_zone" "pingui" {
  name = "aws.${local.domain}."
}

resource "cloudflare_record" "delegate_aws" {
  count   = "4"
  zone_id = cloudflare_zone.pingui.id
  name    = "aws"
  type    = "NS"
  value   = element(aws_route53_zone.pingui.name_servers, count.index)
}
