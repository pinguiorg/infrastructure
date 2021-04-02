resource "digitalocean_project" "binomial" {
  name = "binomial"
}

resource "digitalocean_spaces_bucket" "food" {
  name   = "food"
  region = "fra1"
  acl    = "private"
}
