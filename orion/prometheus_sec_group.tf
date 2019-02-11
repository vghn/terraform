# Prometheus Security Group
module "prometheus_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "2.1.0"

  name        = "Prometheus"
  description = "Security group for the Prometheus"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "ssh-tcp",
    "https-443-tcp",
    "http-80-tcp",
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 8
      to_port     = 0
      protocol    = "icmp"
      description = "Ping"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 10514
      to_port     = 10514
      protocol    = "tcp"
      description = "Log server ports"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  ingress_with_self = [{
    rule = "all-all"
  }]

  egress_rules = ["all-all"]

  tags = "${var.common_tags}"
}
