variable "vpc_id" {
  description = "the corresponding virtual private networ"
  type = string
}

variable "private_subnet_cidrs" {
  description = "subnets cidr_blocks"
  type = list(string)
}

variable "users_ip_addresses" {
  description = "users machines IP adresses that need to Access the S3 bucket (full access CRUD)"
  type = list(string)
}

variable "storage_capacity" {
  description = "Storage capacity of the FSx Lustre file system in GiB"
  type        = number
  default     = 1200
}

variable "subnet_ids" {
  description = "List of subnet IDs for the FSx file system"
  type        = list(string)
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket linked to FSx"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)"
  type        = string
}
