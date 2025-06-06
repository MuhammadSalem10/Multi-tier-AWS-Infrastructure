variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "IDs of the public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "IDs of the private subnets"
  type        = list(string)
}

variable "app_security_group_id" {
  description = "ID of the app security group"
  type        = string
}

variable "alb_security_group_id" {
  description = "ID of the ALB security group"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "max_size" {
  description = "Maximum size of the auto scaling group"
  type        = number
}

variable "min_size" {
  description = "Minimum size of the auto scaling group"
  type        = number
}

variable "desired_capacity" {
  description = "Desired capacity of the auto scaling group"
  type        = number
}
