variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}
variable "vpc_id" {
  description = "S3 VPC that allowed to access the S3 bucket"
}

variable "private_subnet_ids" {
  description = "subnets to access the S3"
  type = list(string)
}

variable "private_subnet_cidrs" {
  description = "subnets cidr_blocks"
  type = list(string)
}

variable "users_ip_addresses" {
  description = "users machines IP adresses that need to Access the S3 bucket (full access CRUD)"
  type = list(string)
}

variable "fsx_ip" {
  description = "the IP address of the FSX storage that is allowed to access (get/put/update/delete) the S3 Bucket"
  type = string
}

variable "region" {
  description = "curent region"
  type = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}
