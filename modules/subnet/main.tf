resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    "Name" = "Public Subnet - ${element(var.availability_zones, count.index)}"
  }
}

resource "aws_subnet" "private" {
  count                   = length(var.availability_zones)
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + length(var.availability_zones))
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    "Name" = "Private Subnet - ${element(var.availability_zones, count.index)}"
  }
}
