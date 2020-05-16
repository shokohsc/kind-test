provider "kubernetes" {}

terraform {
  backend "http" {
    address = "https://tf-state-server.herokuapp.com/"
    lock_address = "https://tf-state-server.herokuapp.com/"
    unlock_address = "https://tf-state-server.herokuapp.com/"
    username = "see-eye"
    password = ""
  }
}
