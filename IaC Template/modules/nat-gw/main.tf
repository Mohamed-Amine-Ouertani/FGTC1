resource "aws_eip" "nat" {
  count = length(var.availability_zones)
}

resource "aws_nat_gateway" "main" {
  count         = length(var.availability_zones)
  subnet_id     = element(var.public_subnet_ids, count.index)
  allocation_id = element(aws_eip.nat[*].id, count.index)

  tags = {
    "Name" = "NAT - ${element(var.availability_zones, count.index)}"
  }
}
