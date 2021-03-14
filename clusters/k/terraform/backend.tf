terraform {
  backend "remote" {
    organization = "pinguiorg"

    workspaces {
      name = "hetzner"
    }
  }
}
