variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}
