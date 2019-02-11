# Prometheus Data Lifecycle Manager (DLM) lifecycle policy for managing snapshots
resource "aws_iam_role" "prometheus_dlm_lifecycle_role" {
  name = "prometheus-dlm-lifecycle-role"
  description = "Prometheus Data Lifecycle Manager (DLM) lifecycle role for managing snapshots"
  assume_role_policy =  "${data.aws_iam_policy_document.prometheus_dlm_lifecycle_assume_role.json}"
}

data "aws_iam_policy_document" "prometheus_dlm_lifecycle_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["dlm.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "prometheus_dlm_lifecycle" {
  name = "prometheus-dlm-lifecycle-policy"
  role = "${aws_iam_role.prometheus_dlm_lifecycle_role.id}"
  policy = "${data.aws_iam_policy_document.prometheus_dlm_lifecycle.json}"
}

data "aws_iam_policy_document" "prometheus_dlm_lifecycle" {
  statement {
    sid = "AllowSnapshots"

    actions = [
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
    ]

    resources = ["*"]
  }

  statement {
    sid = "AllowSnasphotTagging"

    actions = [
      "ec2:CreateTags",
    ]

    resources = ["arn:aws:ec2:*::snapshot/*"]
  }
}

resource "aws_dlm_lifecycle_policy" "prometheus" {
  description        = "Prometheus DLM lifecycle policy"
  execution_role_arn = "${aws_iam_role.prometheus_dlm_lifecycle_role.arn}"
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "2 weeks of daily snapshots"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["09:09"]
      }

      retain_rule {
        count = 14
      }

      tags_to_add {
        SnapshotCreator = "DLM"
      }

      copy_tags = true
    }

    target_tags {
      Snapshot = "true"
    }
  }
}
