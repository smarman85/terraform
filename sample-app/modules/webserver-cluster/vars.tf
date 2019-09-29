variable "image_id" {
  description = "AMI to build the asg off of"

  #default = "ami-40d28157"
}

variable "instance_type" {
  description = "size of the final image"

  #default = "t2.micro"
}

variable "server_port" {
  description = "Port the application is listening on"

  #default = "8080"
}

variable "incoming_port" {
  description = "Port traffic will come into the ALB"

  #default = "80"
}

variable "min_size" {
  description = "Minimum number of instances to have active in the asg"

  #default = "2"
}

variable "max_size" {
  description = "Maximum number of instances to have active in the asg"

  #default = "3"
}

variable "cluster_name" {
  description = "Name of the cluster"

  #default = "sample_app"
}
