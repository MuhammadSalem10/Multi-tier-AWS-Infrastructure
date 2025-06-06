# Multi-tier AWS Infrastructure with Terraform

[![Terraform](https://img.shields.io/badge/Terraform-v1.0+-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A production-ready, multi-tier AWS infrastructure deployment using Terraform that demonstrates enterprise-level cloud architecture patterns, Infrastructure as Code (IaC) best practices, and scalable web application hosting.

## 🏗️ Architecture Overview

This project implements a robust 3-tier architecture following AWS Well-Architected Framework principles:

```
┌─────────────────────────────────────────────────────────────┐
│                    Internet Gateway                          │
└─────────────────────┬───────────────────────────────────────┘
                      │
        ┌─────────────┴─────────────┐
        │    Application Load       │
        │      Balancer (ALB)       │
        │   (Public Subnets)        │
        └─────────────┬─────────────┘
                      │
        ┌─────────────┴─────────────┐
        │   Auto Scaling Group      │
        │    EC2 Instances          │
        │  (Private Subnets)        │
        └─────────────┬─────────────┘
                      │
        ┌─────────────┴─────────────┐
        │   RDS MySQL Database      │
        │      S3 Storage           │
        │  (Private Subnets)        │
        └───────────────────────────┘
```

## ✨ Features

### Infrastructure Components
- **🔗 Virtual Private Cloud (VPC)** - Isolated network environment with custom CIDR
- **🌐 Multi-AZ Deployment** - High availability across multiple availability zones
- **⚖️ Application Load Balancer** - Intelligent traffic distribution with health checks
- **📈 Auto Scaling Group** - Dynamic scaling based on demand
- **🛡️ Security Groups** - Network-level security with least privilege access
- **🗄️ RDS MySQL Database** - Managed relational database with automated backups
- **☁️ S3 Storage** - Scalable object storage with encryption
- **🔒 NAT Gateway** - Secure internet access for private resources

### DevOps Best Practices
- **📦 Modular Architecture** - Reusable, maintainable Terraform modules
- **🎯 Remote State Management** - S3 backend with DynamoDB locking
- **🔧 Parameterized Configuration** - Environment-specific deployments
- **🏷️ Consistent Tagging** - Resource organization and cost tracking
- **📝 Comprehensive Documentation** - Clear setup and usage instructions
- **🔐 Security-First Design** - Private subnets, encryption, and access controls

## 🚀 Quick Start

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- An AWS account with necessary permissions

### 1. Clone the Repository

```bash
git clone https://github.com/MuhammadSalem10/Multi-tier-AWS-Infrastructure.git
cd terraform-aws-multi-tier
```

### 2. Set Up Remote State (One-time setup)


### 3. Configure Variables

Create a `terraform.tfvars` file:

```hcl
aws_region = "us-east-1"
project_name = "webapp"
environment = "dev"
key_name = "your-ssh-key-name"
db_password = "your-secure-password"

# Optional: Customize other variables
instance_type = "t3.micro"
asg_desired_capacity = 2
db_instance_class = "db.t3.micro"
```

### 4. Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Deploy the infrastructure
terraform apply
```

### 5. Access Your Application

After deployment, get the load balancer URL:

```bash
terraform output alb_dns_name
```

Visit the URL in your browser to see your deployed web application!

## 📁 Project Structure

```
├── main.tf                 # Root module configuration
├── variables.tf            # Variable declarations
├── outputs.tf              # Output values
├── terraform.tfvars        # Variable assignments (create this)
├── backend.tf              # Remote state configuration
├── README.md               # This file
└── modules/
    ├── networking/         # VPC, subnets, routing
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security/           # Security groups and rules
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── compute/            # EC2, ALB, Auto Scaling
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── database/           # RDS and S3 resources
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## 🛠️ Configuration Options

### Environment Customization

Deploy multiple environments by changing the `environment` variable:

```bash
# Development
terraform workspace new dev
terraform apply -var="environment=dev"

# Staging
terraform workspace new staging
terraform apply -var="environment=staging"

# Production
terraform workspace new prod
terraform apply -var="environment=prod" -var="instance_type=t3.small"
```

### Key Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `aws_region` | AWS region for deployment | `us-east-1` | `us-west-2` |
| `project_name` | Project identifier | `webapp` | `myapp` |
| `environment` | Environment name | `dev` | `prod` |
| `instance_type` | EC2 instance type | `t3.micro` | `t3.medium` |
| `db_instance_class` | RDS instance class | `db.t3.micro` | `db.t3.small` |
| `asg_desired_capacity` | Number of EC2 instances | `2` | `5` |

## 🔒 Security Features

- **Network Isolation**: Private subnets for application and database tiers
- **Security Groups**: Restrictive inbound/outbound rules
- **Encryption**: S3 server-side encryption enabled
- **Access Control**: Database accessible only from application servers
- **NAT Gateway**: Secure internet access for private resources

## 📊 Monitoring and Scaling

### Auto Scaling Configuration
- **Min Size**: 1 instance
- **Max Size**: 3 instances
- **Desired Capacity**: 2 instances
- **Health Checks**: ALB target group health checks

### Load Balancer Features
- **Health Checks**: Automated instance health monitoring
- **Multi-AZ**: Traffic distribution across availability zones
- **Sticky Sessions**: Optional session persistence


### Cost Reduction Tips
- Use smaller instance types for development
- Enable RDS automated backups retention (7 days)
- Implement lifecycle policies for S3
- Consider Reserved Instances for production

## 🧪 Testing

### Infrastructure Testing
```bash
# Validate Terraform configuration
terraform validate

# Check formatting
terraform fmt -check

# Security scanning (with tfsec)
tfsec .

# Plan without applying
terraform plan -detailed-exitcode
```

### Application Testing
```bash
# Test load balancer endpoint
curl -I http://$(terraform output -raw alb_dns_name)

# Test auto scaling (increase load)
ab -n 1000 -c 10 http://$(terraform output -raw alb_dns_name)/
```

## 🔄 CI/CD Integration

Example GitHub Actions workflow:

```yaml
name: Terraform Deploy
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: hashicorp/setup-terraform@v2
      - name: Terraform Init
        run: terraform init
      - name: Terraform Plan
        run: terraform plan
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve
```

## 🧹 Cleanup

To avoid ongoing AWS charges:

```bash
# Destroy all resources
terraform destroy

# Verify cleanup
aws ec2 describe-instances --query 'Reservations[].Instances[?Tags[?Key==`Project`&&Value==`webapp`]]'
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Troubleshooting

### Common Issues

**Issue**: `Error: Backend configuration changed`
```bash
terraform init -reconfigure
```

**Issue**: `Error: DuplicateLoadBalancerName`
```bash
# Change project_name in terraform.tfvars
project_name = "webapp-unique"
```

**Issue**: `Error: InvalidKeyName`
```bash
# Create an EC2 key pair in the AWS console first
aws ec2 create-key-pair --key-name your-key-name
```

## 📚 Learning Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

## 🏆 Technical Skills Demonstrated

This project showcases proficiency in:

- **Infrastructure as Code (IaC)** with Terraform
- **AWS Cloud Services** architecture and implementation  
- **DevOps Best Practices** including modularization and remote state
- **Network Security** with VPCs, security groups, and private subnets
- **High Availability** design with multi-AZ deployment
- **Auto Scaling** and load balancing configuration
- **Database Management** with RDS and backup strategies
- **Cost Optimization** and resource tagging
- **Documentation** and project organization

---

⭐ **Star this repository if it helped you learn Terraform and AWS!**

For questions or support, please open an issue or reach out via [LinkedIn](https://www.linkedin.com/in/muhammad--salem/).