resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = "/ecs/app"
  retention_in_days = 7
}

resource "aws_cloudwatch_metric_alarm" "ecs_high_cpu" {
  alarm_name          = "ECSHighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm triggers if ECS service CPU utilization is above 80% for 2 minutes."
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.app.name
  }
  treat_missing_data = "notBreaching"
}
