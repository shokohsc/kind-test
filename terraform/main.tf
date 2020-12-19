terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "shokohsc"
    workspaces {
      name = "kind"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  config_path = "~/.kube/config"
}

module "apps" {
    source = "./modules"
}
