# Assets S3 Bucket
resource "aws_s3_bucket" "prometheus" {
  bucket = "prometheus-vghn"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "Remove old versions"
    prefix  = ""
    enabled = true

    noncurrent_version_expiration {
      days = 7
    }
  }

  tags = "${var.common_tags}"
}

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

resource "aws_iam_instance_profile" "prometheus" {
  name = "prometheus"
  role = "${aws_iam_role.prometheus.name}"
}

data "aws_ami" "prometheus" {
  most_recent = true
  owners      = ["self"]
  name_regex  = "^Prometheus_.*"

  filter {
    name   = "tag:Group"
    values = ["vgh"]
  }

  filter {
    name   = "tag:Project"
    values = ["vgh"]
  }
}

resource "aws_eip" "prometheus" {
  vpc        = true
  instance   = "${aws_instance.prometheus.id}"
  depends_on = ["module.vpc"]

  tags = "${merge(
    var.common_tags,
    map(
      "Name", "Prometheus"
    )
  )}"
}

data "null_data_source" "prometheus" {
  inputs = {
    public_dns = "ec2-${replace(join("", aws_eip.prometheus.*.public_ip), ".", "-")}.${data.aws_region.default.name == "us-east-1" ? "compute-1" : "${data.aws_region.default.name}.compute"}.amazonaws.com"
  }
}

resource "cloudflare_record" "prometheus" {
  domain = "ghn.me"
  name   = "prometheus"
  value  = "${data.null_data_source.prometheus.outputs["public_dns"]}"
  type   = "CNAME"
}

resource "aws_instance" "prometheus" {
  instance_type               = "t2.micro"
  ami                         = "${data.aws_ami.prometheus.id}"
  subnet_id                   = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids      = ["${module.prometheus_sg.this_security_group_id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.prometheus.name}"
  key_name                    = "vgh"
  associate_public_ip_address = true

  user_data = <<DATA
#!/usr/bin/env bash
set -euo pipefail
IFS=$$'\n\t'

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo 'Update APT'
export DEBIAN_FRONTEND=noninteractive
while ! apt-get -y update; do sleep 1; done
sudo apt-get -q -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' --allow-remove-essential upgrade

echo 'Mount EBS'
sudo mkdir -p /data
echo '/dev/xvdg  /data  ext4  defaults,nofail  0  2' | sudo tee -a /etc/fstab
sudo mount -a

echo 'Mount EFS'
sudo mkdir -p /mnt/efs
echo '${aws_efs_file_system.prometheus.dns_name}:/  /mnt/efs  nfs  nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport  0  2' | sudo tee -a /etc/fstab
sudo mount -a

echo 'Restore Swarm'
sudo service docker stop
sudo mkdir -p /var/lib/docker/swarm
echo '/data/swarm  /var/lib/docker/swarm  none  defaults,bind  0  2' | sudo tee -a /etc/fstab
sudo mount -a
sudo service docker start

echo 'Reinitialize cluster'
sudo docker swarm init --force-new-cluster --advertise-addr $$(curl -s  http://169.254.169.254/latest/meta-data/local-ipv4)

echo 'Restart services'
sudo service docker restart

echo "FINISHED @ $(date "+%m-%d-%Y %T")" | sudo tee /var/lib/cloud/instance/deployed
DATA

  tags = "${merge(
    var.common_tags,
    map(
      "Name", "Prometheus"
    )
  )}"
}

resource "aws_ebs_volume" "prometheus_data" {
  availability_zone = "us-east-1a"
  type              = "gp2"
  size              = 10

  tags = "${merge(
    var.common_tags,
    map(
      "Name", "Prometheus Data"
    )
  )}"
}

resource "aws_volume_attachment" "prometheus_data_attachment" {
  device_name  = "/dev/sdg"
  instance_id  = "${aws_instance.prometheus.id}"
  volume_id    = "${aws_ebs_volume.prometheus_data.id}"
  skip_destroy = true
}
