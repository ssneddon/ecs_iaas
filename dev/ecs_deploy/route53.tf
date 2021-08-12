resource "aws_route53_record" "ssl" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name = "${data.aws_vpc.vpc.tags.Project}.${data.local_file.domain_name.content}"
  type = "A"

  alias {
    name = data.aws_lb.lb.dns_name
    zone_id = data.aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}