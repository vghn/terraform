# Prometheus Assets S3 Bucket
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
