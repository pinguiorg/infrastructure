resource "digitalocean_project" "binomial" {
  name = "binomial"
}

resource "digitalocean_spaces_bucket" "food" {
  name   = "food"
  region = "fra1"
  acl    = "private"
}

resource "scaleway_account_ssh_key" "squat" {
  name       = "squat"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/0p08FIZlRLYm3lJOGx/THvIPc4Vwwr5ef4uKkIIOuULV4fzNGOgWoM/yxvoVbP54p//1LpBqtKaxZSQ6hgp8hA2PlAEuCNKYN1LMEE4sHuA9BkZ7S12L0KwfdZK/AHbHh5YGwvLQJLIsV4iRuKABhQJbmDSAcmobu/EjXcQknDtWQFlA6CFwMz+hwt0IoeWp1XfSo6YoOfbik3zXZUt2KhDnngJXCEeoFLg+fIjBo/wWuTV864TMYntLVGFusoRtuTqHjBbIfXxmpHGVjrlA20lytlx6CgdiWQEpoxVyR7yKo4efe40PldmrJLw5AOQa9f000HuJtcXXF4wykUTezMJZ8a8yXLYy4BfDU7wddiYyYO29RLXfsn6CbxCPiuunxvJ6rhVxk/hRM1r5ENXPQqQcPrvfp+/SlL50SnFa94dCpYHEmx7ecDhG7Pbm9nEoFNLMi+vG9s8Px7vWe4CdnORuZ1ubZlCaSgKfDawq8hvm26by/Qi1rvv/hGOTshLpxXBy02ILH9hPQ4176jBIEpZujsbmsJIz9gOvX2gBeRkqIyeyucVFJQlFPoOKneXLe1MEubf9JfXBYa8tZae1nChd/unVwUppy+ywISyX/zlJBbKDZuJGyVilAvjnhtlI6UJB0TmiZqFYzvJRsNPiY9OUfxaUozkmuZVDLNoGNQ== openpgp:0x45372E31"
}

resource "scaleway_object_bucket" "food" {
  name = "food"
  acl  = "private"
}
