provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "../../modules/webserver-cluster"

  # vars to send to the module
  cluster_name  = "${var.cluster_name}"
  image_id      = "${var.image_id}"
  instance_type = "${var.instance_type}"
  server_port   = "${var.server_port}"
  incoming_port = "${var.incoming_port}"
  min_size      = "${var.min_size}"
  max_size      = "${var.max_size}"
}
