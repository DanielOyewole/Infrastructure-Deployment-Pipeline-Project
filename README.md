# AWS Infrastructure Deployment Pipeline

This project demonstrates a complete deployment pipeline for a web application using AWS services and modern DevOps practices.

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
