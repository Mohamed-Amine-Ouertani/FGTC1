variable "environment" {
  description = "The deployment environment (e.g., Dev, Prod)"
  type        = string
}

variable "instance_number" {
  description = "initial number of instances"
  type = number
  validation {
    condition     = var.instance_number >= 1
    error_message = "Instance count must be greater than or equal to 1"
  }
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile for the EC2 instance"
  type        = string
}

variable "fsx_dns_name" {
  description = "The DNS name of the FSx file system"
  type = string
}

