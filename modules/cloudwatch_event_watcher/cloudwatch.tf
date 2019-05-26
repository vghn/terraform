# Trigger the Lambda function with these ASG and EC2 events
resource "aws_cloudwatch_event_rule" "events" {
  name = "${var.name}-events"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.autoscaling",
    "aws.ec2",
    "aws.ssm",
    "aws.signin"
  ],
  "detail-type": [
    "EC2 Instance Launch Successful",
    "EC2 Instance Launch Unsuccessful",
    "EC2 Instance Terminate Successful",
    "EC2 Instance Terminate Unsuccessful",
    "EC2 Instance State-change Notification",
    "Parameter Store Change",
    "AWS Console Sign In via CloudTrail"
  ]
}
PATTERN

}

resource "aws_cloudwatch_event_target" "events" {
  target_id = "${var.name}-events"
  rule = aws_cloudwatch_event_rule.events.name
  arn = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "events" {
  statement_id = "${var.name}-events"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.events.arn
}

# Also trigger it with a schedule to regularly call your Lambda function in order to keep it warm

resource "aws_cloudwatch_event_rule" "warmer" {
  name = "${var.name}-warmer"
  schedule_expression = "rate(15 minutes)"
}

resource "aws_cloudwatch_event_target" "warmer" {
  target_id = "${var.name}-warmer"
  rule = aws_cloudwatch_event_rule.warmer.name
  arn = aws_lambda_function.lambda.arn
}

resource "aws_lambda_permission" "warmer" {
  statement_id = "${var.name}-warmer"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.warmer.arn
}

