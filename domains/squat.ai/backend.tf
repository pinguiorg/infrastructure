terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "pinguiorg"
    workspaces {
      name = "squat-ai"
    }
  }
}
