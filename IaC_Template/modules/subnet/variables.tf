variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for subnets"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}
