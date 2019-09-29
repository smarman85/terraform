variable "cluster_name" {
  default = "sample-app"
}

variable "image_id" {
  default = "ami-40d28157"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "server_port" {
  default = "8080"
}

variable "incoming_port" {
  default = "80"
}

variable "min_size" {
  default = "2"
}

variable "max_size" {
  default = "3"
}
