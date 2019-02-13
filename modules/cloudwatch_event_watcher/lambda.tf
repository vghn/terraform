# Lambda execution role
resource "aws_iam_role" "lambda" {
  name               = "cloudwatch-event-watcher"
  description        = "CloudWatch Event Watcher"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Lambda IAM Policy
resource "aws_iam_policy_attachment" "lambda" {
  name       = "${var.name}-lambda"
  roles      = ["${aws_iam_role.lambda.name}"]
  policy_arn = "${aws_iam_policy.lambda.arn}"
}

resource "aws_iam_policy" "lambda" {
  name   = "${var.name}-lambda"
  policy = "${data.aws_iam_policy_document.lambda.json}"
}

data "aws_iam_policy_document" "lambda" {
  statement {
    sid       = "AllowGettingSSMParameters"
    actions   = ["ssm:Get*"]
    resources = ["arn:aws:ssm:*:*:parameter/*"]
  }

  statement {
    sid = "AllowLogging"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

# Archive Files
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

# Lambda Function
resource "aws_lambda_function" "lambda" {
  function_name    = "${var.name}"
  description      = "Manages AWS CloudWatch Events"
  filename         = "${data.archive_file.lambda.output_path}"
  handler          = "main.handler"
  memory_size      = 128
  role             = "${aws_iam_role.lambda.arn}"
  runtime          = "python3.7"
  source_code_hash = "${base64sha256(file(data.archive_file.lambda.output_path))}"
}
