resource "aws_vpc" "main" { 
  cidr_block = var.cidr_block

  tags = {
    "Name" = var.name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = var.name
  }
}
