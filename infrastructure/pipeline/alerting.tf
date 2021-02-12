resource "aws_cloudwatch_metric_alarm" "failed_build_alarm" {
  alarm_name                = "${var.resource_prefix}-failed-build-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "FailedBuilds"
  namespace                 = "AWS/CodeBuild"
  period                    = "120"
  statistic                 = "Maximum"
  threshold                 = "1"
  alarm_description         = "Metric to monitor failed builds"
  insufficient_data_actions = []
  actions_enabled           = "true"
  alarm_actions             = [aws_sns_topic.build_failed_sns.arn]
}

resource "aws_sns_topic" "build_failed_sns" {
  name = "${var.resource_prefix}-failed-build-sns"
}

resource "aws_sns_topic_subscription" "build_failed_sns_sqs_target" {
  topic_arn = aws_sns_topic.build_failed_sns.arn
  protocol  = "sms"
  endpoint  = var.alerting_sms_number
}