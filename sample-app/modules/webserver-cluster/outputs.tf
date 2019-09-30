output "alb_dns_name" {
  value = "${aws_lb.sample_alb.dns_name}"

  #value = "${module.webserver_cluster.alb_dns_name}"
}

output "aws_autoscaling_group" {
  value = "${aws_autoscaling_group.sample_app_asg.name}"
}
