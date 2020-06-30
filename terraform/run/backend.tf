terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "shokohsc"
    workspaces {
      name = "kind"
    }
  }
}
