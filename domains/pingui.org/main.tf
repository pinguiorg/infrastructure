locals {
  domain                     = "pingui.org"
  github_verification        = "db3585dca6"
  github_verification_domain = "_github-challenge-pinguiorg"
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

resource "cloudflare_record" "github_verification" {
  zone_id = cloudflare_zone.pingui.id
  name    = local.github_verification_domain
  type    = "TXT"
  value   = local.github_verification
}
