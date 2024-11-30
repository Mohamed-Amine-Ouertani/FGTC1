# Create an S3 Bucket
resource "aws_s3_bucket" "training_data" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# Enable Versioning for the S3 Bucket
resource "aws_s3_bucket_versioning" "training_data_versioning" {
  bucket = aws_s3_bucket.training_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Add Lifecycle Rules for Cost Management
resource "aws_s3_bucket_lifecycle_configuration" "training_data_lifecycle" {
  bucket = aws_s3_bucket.training_data.id

  rule {
    id     = "lifecycle"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA" # Transition to Infrequent Access
    }

    transition {
      days          = 90
      storage_class = "GLACIER" # Transition to Glacier for long-term storage
    }

    expiration {
      days = 365 # Delete objects after one year
    }
  }
}

# Enable Server-Side Encryption for the S3 Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "training_data_encryption" {
  bucket = aws_s3_bucket.training_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create a VPC Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${var.region}.s3" # Dynamic region support
  private_dns_enabled = true
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.s3_endpoint_sg.id] # Reference S3 endpoint SG

  tags = {
    Name        = "s3-endpoint"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "training_data_policy" {
  bucket = aws_s3_bucket.training_data.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action   = "s3:*",
        Resource = [
          "${aws_s3_bucket.training_data.arn}",
          "${aws_s3_bucket.training_data.arn}/*"
        ],
        Condition = {
          StringEquals = {
            "aws:sourceVpce" = aws_vpc_endpoint.s3.id
          }
        }
      },
      {
        Effect = "Allow",
        Principal = "*",
        Action   = "s3:*",
        Resource = [
          "${aws_s3_bucket.training_data.arn}",
          "${aws_s3_bucket.training_data.arn}/*"
        ],
        Condition = {
          IpAddress = {
            "aws:SourceIp" = var.users_ip_addresses
          }
        }
      }

    ]
  })
}


# Create a Security Group for the S3 Endpoint
resource "aws_security_group" "s3_endpoint_sg" {
  name        = "s3-endpoint-sg"
  vpc_id      = var.vpc_id
  description = "Security group for S3 VPC endpoint"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = concat(var.private_subnet_cidrs , [for ip in var.users_ip_addresses : "${ip}/32"])
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "s3-endpoint-sg"
    Environment = var.environment
  }
}
