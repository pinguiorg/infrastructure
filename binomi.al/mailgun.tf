# Create a new Mailgun domain
resource "mailgun_domain" "binomial" {
  name          = local.domain
  spam_action   = "disabled"
}

// Create DNS records for receiving.
resource "cloudflare_record" "receiving_0" {
  name     = "@"
  value    = mailgun_domain.binomial.receiving_records.0.value
  priority = mailgun_domain.binomial.receiving_records.0.priority
  ttl      = 300
  type     = mailgun_domain.binomial.receiving_records.0.record_type
  zone_id = local.zone_id
}

resource "cloudflare_record" "receiving_1" {
  name     = "@"
  value    = mailgun_domain.binomial.receiving_records.1.value
  priority = mailgun_domain.binomial.receiving_records.1.priority
  ttl      = 300
  type     = mailgun_domain.binomial.receiving_records.1.record_type
  zone_id = local.zone_id
}

// Create DNS records for sending.
resource "cloudflare_record" "sending_0" {
  name   = replace(replace(mailgun_domain.binomial.sending_records.0.name, "/[.]?${local.domain}/", ""), "/^$/", "@")
  value  = "\"${mailgun_domain.binomial.sending_records.0.value}\""
  ttl    = 300
  type   = mailgun_domain.binomial.sending_records.0.record_type
  zone_id = local.zone_id
}

resource "cloudflare_record" "sending_1" {
  name   = replace(replace(mailgun_domain.binomial.sending_records.1.name, "/[.]?${local.domain}/", ""), "/^$/", "@")
  value  = "\"${mailgun_domain.binomial.sending_records.1.value}\""
  ttl    = 300
  type   = mailgun_domain.binomial.sending_records.1.record_type
  zone_id = local.zone_id
}

resource "cloudflare_record" "sending_2" {
  name   = replace(replace(mailgun_domain.binomial.sending_records.2.name, "/[.]?${local.domain}/", ""), "/^$/", "@")
  value  = mailgun_domain.binomial.sending_records.2.value
  ttl    = 300
  type   = mailgun_domain.binomial.sending_records.2.record_type
  zone_id = local.zone_id
}

// Routes.
resource "mailgun_route" "daniel" {
  priority = 0
  description = "daniel"
  expression = "match_recipient(\"daniel@${local.domain}\")"
  actions = [
    "forward(\"dserven+binomial@gmail.com\")"
  ]
}

resource "mailgun_route" "lucas" {
  priority = 0
  description = "lucas"
  expression = "match_recipient(\"lucas@${local.domain}\")"
  actions = [
    "forward(\"lserven+binomial@gmail.com\")"
  ]
}

resource "mailgun_route" "hello" {
  priority = 0
  description = "hello"
  expression = "match_recipient(\"hello@${local.domain}\")"
  actions = [
    "forward(\"lserven+binomial@gmail.com,dserven+binomial@gmail.com\")"
  ]
}
