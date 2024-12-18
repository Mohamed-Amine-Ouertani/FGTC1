variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "igw_id" {
  description = "The ID of the Internet Gatway"
}

variable "public_subnet_ids" {
  description = "The ID of a Public Subnet"
  type = list(string)
}

variable "private_subnet_ids" {
  description = "The ID of a Private Subnet"
  type = list(string)
}

variable "nat_gateway_ids" {
  description = "the ID of the NAT Gateway"
  type = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}


