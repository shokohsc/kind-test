resource "kubernetes_config_map" "config" {
  metadata {
    name = "config"
  }

  data = {
    api_host             = "myhost:443"
    db_host              = "dbhost:5432"
    "my_config_file.yml" = "${file("${path.module}/my_config_file.yml")}"
  }

  binary_data = {
    "my_payload.bin" = "${filebase64("${path.module}/my_payload.bin")}"
  }

  data {
    config {
      address-pools {
        name = "default"
        protocol = "layer2"
        addresses = [ "172.19.0.64/27" ]
      }
    }
  }
}
