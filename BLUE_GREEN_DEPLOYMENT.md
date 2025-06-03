# Blue/Green Deployment Strategy for AWS ECS

## What is Blue/Green Deployment?
Blue/green deployment is a release management strategy that reduces downtime and risk by running two identical production environments (Blue and Green). Traffic is switched from Blue (current) to Green (new) after testing, allowing instant rollback if needed.

## How to Implement with AWS ECS, ALB, and CodeDeploy
- **ECS Service:** Use CodeDeploy to manage two task sets (Blue and Green) behind the same ALB.
- **ALB:** Routes traffic to the active task set.
- **CodeDeploy:** Handles traffic shifting and rollback.

## Terraform Scaffold Example

```hcl
resource "aws_codedeploy_app" "ecs" {
  name = "ecs-codedeploy-app"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "ecs" {
  app_name               = aws_codedeploy_app.ecs.name
  deployment_group_name  = "ecs-codedeploy-dg"
  service_role_arn       = aws_iam_role.codedeploy.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  ecs_service {
    cluster_name = aws_ecs_cluster.main.name
    service_name = aws_ecs_service.app.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.http.arn]
      }
      target_group {
        name = aws_lb_target_group.app.name
      }
    }
  }
}

resource "aws_iam_role" "codedeploy" {
  name = "CodeDeployRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "codedeploy.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForECS"
}
```

## How it Works
- Deploy new version to Green (new task set).
- Test Green environment.
- CodeDeploy shifts traffic from Blue to Green.
- Rollback is instant if issues are detected.

## References
- [AWS Blue/Green Deployments with ECS](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-type-blue-green.html)
- [Terraform AWS CodeDeploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) 