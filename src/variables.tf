variable "yandex_cloud_id" {
  default = "b1g1ap2fp1jt638alsl9"
}

variable "yandex_folder_id" {
  default = "b1g3sfourkjnlhsdmlut"
}

variable "a-zone" {
  default = "ru-central1-a"
}

variable "lamp-instance-image-id" {
  default = "fd827b91d99psvq5fjit"
}

variable "ssh_username" {
  description = "Username for SSH access to the VM"
  type        = string
  default     = "qshar"  
}

 variable "vms_ssh_root_key" {
  type        = string
  default     = "********************"
  description = "ssh-keygen -t ed25519"
 }

  variable "yandex_storage_access_key" {
  default = "*************************"
}

  variable "yandex_storage_secret_key" {
  type        = string
  default     = "***********************"
  sensitive   = true
}
