provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  
  # module variables
  cluster_name = "webservers-stage"
  #db_remote_state_bucket = "sean-tf-bucket"
  #db_remote_state_key = "stage/data-stores/mysql/terraform.tfstate"

  # instance vars
  instance_type = "t2.micro"
  min_size = "${var.min_size}"
  max_size = "${var.max_size}"
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type = "ingress"
  security_group_id = "${module.webserver_cluster.elb_security_group_id}"

  from_port = 12345
  to_port = 12345
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
