variable "address" {
  type = string
  description = "vault api adress"
}

variable "backend" {
  type = string
  description = "cloud provider"
}

variable "role" {
  type = string
  default = "role provided by vault to terraform to access the backend(cloud Provider)"
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "environment" {
  type = string
  description = "The environment (e.g., Dev, Prod)"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}


variable "instance_number" {
  description = "initial number of instances"
  type = number
  default = 3
}

variable "instance_type" {
  type        = string
  description = "EC2 instance Type"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instance"
}

variable "storage_users_ip_addresses" {
  description = "users machines IP adresses that need to Access the S3 bucket (full access CRUD)"
  type = list(string)
}

variable "fsx_storage_capacity" {
  description = "the desired amount of storagre for the fsx for Luster "
  type = number # we are using FSx for Luster storage
}
