resource "aws_cloudwatch_metric_alarm" "failed_build_alarm" {
  alarm_name                = "${var.resource_prefix}-down-alarm"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "service_number_of_running_pods"
  namespace                 = "ContainerInsights"
  period                    = "120"
  statistic                 = "Maximum"
  threshold                 = "1"
  alarm_description         = "Metric to monitor rest"
  insufficient_data_actions = []
  dimensions = {
    ClusterName  = var.cluster_id
    Namespace = "default"
    Service = "sre-challenge-rest"
  }
  actions_enabled           = "true"
  alarm_actions             = [aws_sns_topic.rest_service_down.arn]
}

resource "aws_sns_topic" "rest_service_down" {
  name = "${var.resource_prefix}-service-down-sns"
}

resource "aws_sns_topic_subscription" "rest_service_down_sqs_target" {
  topic_arn = aws_sns_topic.rest_service_down.arn
  protocol  = "sms"
  endpoint  = var.alerting_sms_number
}