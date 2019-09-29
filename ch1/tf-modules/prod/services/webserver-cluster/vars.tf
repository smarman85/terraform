#variable "db_remote_state_bucket" {
#  description = "The name of the S3 bucket used for the database's remote state storage"
#}

#variable "db_remote_state_key" {
#  description = "The name of the key in the S3 bucket used for the database's remote state storage"
#}

variable "min_size" {
  default = 1
}

variable "max_size" {
  default = 2
}

variable "min_off_hours" {
  default = 1
}

variable "max_off_hours" {
  default = 2
}

variable "off_hours_capacity" {
  default = 1
}

variable "min_business_hours" {
  default = 2
}

variable "max_business_hours" {
  default = 2
}

variable "buniness_hours_capacity" {
  default = 2
}
