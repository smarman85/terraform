output "alb_dns_name" {
  value = "${aws_lb.sample_alb.dns_name}"
}

output "aws_autoscaling_group" "sample_app_asg" {
  value = "${aws_autoscaling_group.sample_alb}"
}

output "aws_security_group" "alb" {
  value = "${aws_security_group.alb}"
}
