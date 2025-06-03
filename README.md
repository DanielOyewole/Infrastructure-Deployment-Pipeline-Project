# AWS Infrastructure Deployment Pipeline

This project demonstrates a complete deployment pipeline for a web application using AWS services and modern DevOps practices.

## Three-Tier AWS Architecture Overview

This project demonstrates a robust, production-grade three-tier web application architecture on AWS, following best DevOps and cloud-native practices. The architecture includes:

### 1. Presentation Layer
- **CloudFront (CDN):** Delivers content globally with low latency and high transfer speeds.
- **AWS WAF:** Protects against common web exploits and attacks at Layer 7.
- **Application Load Balancer (ALB):** Distributes incoming HTTP/HTTPS traffic across web servers in multiple Availability Zones (AZs).

### 2. Web & Application Layer
- **Web Tier (EC2 or ECS):** Hosts the front-end application, deployed in public subnets across at least two AZs for high availability.
- **App Tier (EC2 or ECS):** Hosts the business logic, deployed in private subnets. Only accessible from the web tier for security.
- **Auto Scaling Groups:** Automatically scale the number of instances/tasks based on demand (CPU, memory, or custom metrics).
- **Blue/Green Deployment:** Enables zero-downtime deployments and instant rollback by running two parallel environments (Blue and Green) and switching traffic between them using CodeDeploy and ALB.

### 3. Data Layer
- **RDS MySQL (Multi-AZ):** Managed relational database deployed in private subnets for high availability and security. Only accessible from the app tier.

### 4. Networking & Security
- **VPC:** Isolated network environment with public and private subnets across multiple AZs.
- **NAT Gateway:** Allows private subnets to access the internet for updates without exposing resources to inbound traffic.
- **Security Groups & NACLs:** Enforce least-privilege access between tiers and to/from the internet.
- **IAM Roles:** Grant least-privilege permissions to EC2, ECS, and CodeDeploy.

### 5. CI/CD Pipeline
- **GitHub Actions:** Automates build, test, and deployment of application and infrastructure.
- **Automated Testing:** Ensures only healthy builds are deployed.
- **Terraform:** Manages all AWS resources as code, with state stored in S3 for collaboration and safety.

### 6. Observability
- **CloudWatch Logs & Metrics:** Centralized logging and monitoring for all tiers.
- **CloudWatch Alarms:** Alert on high CPU, memory, or error rates.

### 7. Global Reach & Security
- **CloudFront CDN:** Ensures fast, secure content delivery to users worldwide.
- **AWS WAF:** Protects against web attacks and enforces security at the edge.

---

## Visual Diagram

```
                        +-------------------+
                        |    Users/Clients  |
                        +---------+---------+
                                  |
                                  v
                    +-----------------------------+
                    |   AWS CloudFront (CDN)      |
                    |   + AWS WAF (Layer 7 Sec)   |
                    +-------------+---------------+
                                  |
                                  v
                        +-------------------+
                        |   ALB (Public)    |
                        +-------------------+
                          /               \
                         /                 \
                        v                   v
         +-------------------+   +-------------------+
         |  ECS Service (Blue) | | ECS Service (Green)|
         |  (Auto-Scaling)     | | (Blue/Green Deploy)|
         +-------------------+   +-------------------+
                         \                 /
                          \               /
                           v             v
                        +-------------------+
                        |   Private Subnets |
                        +-------------------+
                                  |
                                  v
                        +-------------------+
                        |   RDS MySQL (HA)  |
                        +-------------------+
                                  |
                                  v
                        +-------------------+
                        |   CloudWatch Logs |
                        |   & Alarms        |
                        +-------------------+
```

## Architecture Overview

The infrastructure includes:
- VPC with public and private subnets
- ECS Fargate for container management
- Application Load Balancer
- Auto-scaling configuration
- CloudWatch monitoring and logging
- GitHub Actions CI/CD pipeline
- Blue/Green deployment strategy

## Prerequisites

- AWS Account with appropriate permissions
- AWS CLI configured
- Terraform installed
- GitHub account
- Docker installed locally

## Required AWS Services

- VPC
- ECS (Fargate)
- ECR
- Application Load Balancer
- CloudWatch
- IAM
- Route53 (optional for custom domain)

## Setup Instructions

1. Configure AWS credentials:
```bash
aws configure
```

2. Initialize Terraform:
```bash
cd terraform
terraform init
```

3. Apply Terraform configuration:
```bash
terraform plan
terraform apply
```

4. Set up GitHub repository secrets:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- ECR_REPOSITORY
- ECS_CLUSTER
- ECS_SERVICE

## Project Structure

```
.
├── terraform/               # Infrastructure as Code
│   ├── main.tf             # Main Terraform configuration
│   ├── variables.tf        # Variable definitions
│   ├── outputs.tf          # Output definitions
│   ├── vpc.tf              # VPC configuration
│   ├── ecs.tf              # ECS configuration
│   ├── alb.tf              # Load balancer configuration
│   ├── security.tf         # Security groups and IAM
│   └── monitoring.tf       # CloudWatch configuration
├── .github/                # GitHub Actions workflows
│   └── workflows/
│       └── deploy.yml      # CI/CD pipeline configuration
├── app/                    # Sample application
│   ├── Dockerfile         # Container definition
│   └── src/               # Application source code
└── README.md              # Project documentation
```

## Security Considerations

- IAM roles follow least privilege principle
- Security groups are tightly configured
- Secrets are managed through AWS Secrets Manager
- Network traffic is encrypted
- Regular security scanning in CI/CD pipeline

## Monitoring and Logging

- CloudWatch metrics for application and infrastructure
- CloudWatch Logs for application logs
- CloudWatch Alarms for critical metrics
- X-Ray for distributed tracing (this is optional)

## Deployment Strategy

The project implements a blue/green deployment strategy using ECS:
1. New version is deployed alongside existing version
2. Traffic is gradually shifted to new version
3. Old version is removed after successful deployment

## Cost Optimization

- Auto-scaling based on demand
- Fargate for serverless container management
- Appropriate instance types
- Resource tagging for cost allocation 

resource "aws_cloudwatch_metric_alarm" "ecs_high_cpu" {
  alarm_name          = "ECSHighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.app.name
  }
}
