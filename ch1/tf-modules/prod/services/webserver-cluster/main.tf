provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  # module variables
  cluster_name           = "webservers-prod"
  #db_remote_state_bucket = "seansbucket"
  #db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  # instance vars
  instance_type = "t2.micro"
  min_size      = "${var.min_size}"
  max_size      = "${var.max_size}"
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = "${var.min_business_hours}"
  max_size              = "${var.max_business_hours}"
  desired_capacity      = "${var.buniness_hours_capacity}"
  recurrence            = "0 9 * * *"

  autoscaling_group_name = "${module.webserver_cluster.asg_name}"
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  recurrence            = "0 17 * * *"

  autoscaling_group_name = "${module.webserver_cluster.asg_name}"
}
