# module for ASG
terraform {
  required_version = ">=0.11"
}

resource "aws_launch_configuration" "asg_conf" {
  name_prefix     = "terraform-lc-sample-app-"
  image_id        = "${var.image_id}"                          #ami-40d28157
  instance_type   = "${var.instance_type}"
  user_data       = "${data.template_file.user_data.rendered}"
  security_groups = ["${aws_security_group.instance.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"

  vars {
    server_port = "${var.server_port}"
  }
}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "sample_app_asg" {
  launch_configuration = "${aws_launch_configuration.asg_conf.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]
  target_group_arns    = ["${aws_lb_target_group.alb.arn}"]
  health_check_type    = "ELB"

  min_size = "${var.min_size}"
  max_size = "${var.max_size}"

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }
}

resource "aws_lb_target_group" "alb" {
  port        = "8080"
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "vpc-b4d093ce"
}

# security groups (instance)
resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_server_http_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.instance.id}"

  from_port   = "${var.server_port}"
  to_port     = "${var.server_port}"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# security groups (alb)
resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.instance.id}"

  from_port   = "${var.incoming_port}"
  to_port     = "${var.incoming_port}"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http_outbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.instance.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# ALB SECTION
resource "aws_lb" "sample_alb" {
  #name               = "sample-alb"
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb.id}"]
  subnets            = ["subnet-83271aad", "subnet-10ac9b77"]

  tags {
    "Created By" = "terraform"
    "Name"       = "${var.cluster_name}_alb"
  }
}

resource "aws_lb_listener" "frontend_alb" {
  load_balancer_arn = "${aws_lb.sample_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "8080"
      protocol    = "HTTP"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "health_check" {
  listener_arn = "${aws_lb_listener.frontend_alb.arn}"

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "HEALTHY"
      status_code  = "200"
    }
  }

  condition {
    field  = "path-pattern"
    values = ["/health"]
  }
}
