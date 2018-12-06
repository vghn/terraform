# Assets S3 Bucket
resource "aws_s3_bucket" "unifi" {
  bucket = "unifi-mec7"
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
module "unifi_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "2.1.0"

  name        = "Unifi"
  description = "Security group for the Unifi"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_rules = [
    "ssh-tcp",
    "http-80-tcp",
    "https-443-tcp",
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
      from_port   = 9100
      to_port     = 9100
      protocol    = "tcp"
      description = "Prometheus"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9101
      to_port     = 9101
      protocol    = "tcp"
      description = "Prometheus Cadvisor"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 10514
      to_port     = 10514
      protocol    = "tcp"
      description = "Logs"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Unifi"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8443
      to_port     = 8443
      protocol    = "tcp"
      description = "Unifi"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8880
      to_port     = 8880
      protocol    = "tcp"
      description = "Unifi"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8843
      to_port     = 8843
      protocol    = "tcp"
      description = "Unifi"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 6789
      to_port     = 6789
      protocol    = "tcp"
      description = "Unifi"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 3478
      to_port     = 3478
      protocol    = "tcp"
      description = "Unifi"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 10001
      to_port     = 10001
      protocol    = "tcp"
      description = "Unifi"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  ingress_with_self = [{
    rule = "all-all"
  }]

  egress_rules = ["all-all"]

  tags = "${var.common_tags}"
}

resource "aws_iam_instance_profile" "unifi" {
  name = "unifi"
  role = "${aws_iam_role.unifi.name}"
}

data "aws_ami" "unifi" {
  most_recent = true
  owners      = ["self"]
  name_regex  = "^Unifi_.*"

  filter {
    name   = "tag:Group"
    values = ["cosmin"]
  }

  filter {
    name   = "tag:Project"
    values = ["unifi"]
  }
}

resource "aws_eip" "unifi" {
  vpc        = true
  instance   = "${aws_instance.unifi.id}"
  depends_on = ["module.vpc"]

  tags = "${merge(
    var.common_tags,
    map(
      "Name", "Unifi"
    )
  )}"
}

data "null_data_source" "unifi" {
  inputs = {
    public_dns = "ec2-${replace(join("", aws_eip.unifi.*.public_ip), ".", "-")}.${data.aws_region.default.name == "us-east-1" ? "compute-1" : "${data.aws_region.default.name}.compute"}.amazonaws.com"
  }
}

resource "cloudflare_record" "unifi" {
  domain = "mec7.com"
  name   = "unifi"
  value  = "${data.null_data_source.unifi.outputs["public_dns"]}"
  type   = "CNAME"
}

resource "tls_private_key" "unifi" {
  algorithm = "RSA"
}

resource "acme_registration" "unifi" {
  account_key_pem = "${tls_private_key.unifi.private_key_pem}"
  email_address   = "${var.email}"
}

resource "acme_certificate" "unifi" {
  account_key_pem = "${acme_registration.unifi.account_key_pem}"
  common_name     = "mec7.com"

  subject_alternative_names = [
    "www.mec7.com",
    "unifi.mec7.com",
  ]

  dns_challenge {
    provider = "cloudflare"

    config = {
      CLOUDFLARE_EMAIL   = "${var.cf_email}"
      CLOUDFLARE_API_KEY = "${var.cf_token}"
    }
  }
}

resource "aws_key_pair" "deploy" {
  key_name   = "deploy"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+4vPJ554LgwIZ7qK2DoipJe9U2yuRwUZpTtjJ4EHqASn+KUbWX8XA7ipwLloQiWO25U5S4UjAxy3jcd2ykkQWD2XeXnE9qZZTgRAJfOpTKNIlng7NBPg9gHJcUADU8EXTd52sYQRl67inQpExb9TnshAAmrShh2T2cVqzybLdHbukchEHRUgKINp/Ci/zPffhv7yWKz4EUzvZdisRVgd3tuHJotvrHk18OOhSaGGlcuiig2AQgpd4MV7+yyyYoT0keOPiRrf3OAAnFMzaQbaoekDvwRg8GmCY3oFZVzsxehB+jTGj1ICz60L8qTN2oeD6zOw1EQWOQldNw5TnTuUz deploy"
}

resource "aws_instance" "unifi" {
  instance_type               = "t2.micro"
  ami                         = "${data.aws_ami.unifi.id}"
  subnet_id                   = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids      = ["${module.unifi_sg.this_security_group_id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.unifi.name}"
  key_name                    = "${aws_key_pair.deploy.key_name}"
  associate_public_ip_address = true

  user_data = <<DATA
#!/usr/bin/env bash
set -euo pipefail
IFS=$$'\n\t'

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo 'Import LetsEncrypt certificates'
mkdir -p /etc/ssl/mec7
echo '${acme_certificate.unifi.private_key_pem}' > /etc/ssl/mec7/privkey.pem
echo '${acme_certificate.unifi.certificate_pem}' > /etc/ssl/mec7/cert.pem
echo '${acme_certificate.unifi.issuer_pem}' > /etc/ssl/mec7/chain.pem

echo 'Update APT'
export DEBIAN_FRONTEND=noninteractive
while ! apt-get -y update; do sleep 1; done
sudo apt-get -q -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' --force-yes upgrade

echo 'Mount EBS'
sudo mkdir -p /data
echo '/dev/xvdg  /data  ext4  defaults,nofail  0  2' | sudo tee -a /etc/fstab
sudo mount -a

echo 'Restore Swarm'
sudo service docker stop
sudo mkdir -p /var/lib/docker/swarm
echo '/data/swarm  /var/lib/docker/swarm  none  defaults,bind  0  2' | sudo tee -a /etc/fstab
sudo mount -a

echo 'Restart services'
sudo service docker start

echo 'Reinitialize cluster'
sudo docker swarm init --force-new-cluster --advertise-addr $$(curl -s  http://169.254.169.254/latest/meta-data/local-ipv4)
sudo service docker restart

echo "FINISHED @ $(date "+%m-%d-%Y %T")" | sudo tee /var/lib/cloud/instance/deployed
DATA

  tags = "${merge(
    var.common_tags,
    map(
      "Name", "Unifi"
    )
  )}"
}

resource "aws_ebs_volume" "unifi_data" {
  availability_zone = "us-west-2a"
  type              = "gp2"
  size              = 10

  tags = "${merge(
    var.common_tags,
    map(
      "Name", "Unifi"
    )
  )}"
}

resource "aws_volume_attachment" "unifi_data_attachment" {
  device_name  = "/dev/sdg"
  instance_id  = "${aws_instance.unifi.id}"
  volume_id    = "${aws_ebs_volume.unifi_data.id}"
  skip_destroy = true
}
