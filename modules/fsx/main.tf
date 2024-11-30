resource "aws_fsx_lustre_file_system" "fsx" {
  storage_capacity = var.storage_capacity # in GiB
  subnet_ids       = var.subnet_ids
  security_group_ids = [aws_security_group.fsx_sg.id]
  deployment_type  = "SCRATCH_2" # Optimized for short-term, high-performance workloads

  import_path = "s3://${var.s3_bucket_name}"
  export_path = "s3://${var.s3_bucket_name}" 

  tags = {
    Name        = "${var.environment}-fsx"
    Environment = var.environment
  }
}

resource "aws_security_group" "fsx_sg" {
  name        = "${var.environment}-fsx-sg"
  vpc_id      = var.vpc_id
  description = "Security group for FSx file system"

  ingress {
    from_port   = 988
    to_port     = 988
    protocol    = "tcp"
    cidr_blocks =concat(var.private_subnet_cidrs , [for ip in var.users_ip_addresses : "${ip}/32"])
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-fsx-sg"
    Environment = var.environment
  }
}
