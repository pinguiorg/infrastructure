terraform {
  backend "remote" {
    organization = "pinguiorg"

    workspaces {
      name = "pingui-org"
    }
  }
}
