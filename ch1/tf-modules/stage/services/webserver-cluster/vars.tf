variable "min_size" {
  default = 1
}

variable "max_size" {
  default = 1
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket used for the database's remote state storage"
  default = "sean-tf-bucket"
}

variable "db_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the database's remote state storage"
  default = "../state/terraform.tfstate"
}
