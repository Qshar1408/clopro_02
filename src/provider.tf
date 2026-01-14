terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=1.8.4"
}

provider "yandex" {
  #  token     = var.token
  service_account_key_file = file(".authorized_key.json")
  cloud_id                 = "${var.yandex_cloud_id}"
  folder_id                = "${var.yandex_folder_id}"
  zone                     = var.a-zone
}
