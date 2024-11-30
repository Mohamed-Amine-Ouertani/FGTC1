# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.environment}-ec2-role"
  }
}

# IAM Policy for EC2 Role (Optional: Expand based on requirements)
resource "aws_iam_policy" "ec2_policy" {
  name        = "${var.environment}-ec2-policy"
  description = "Policy for EC2 instance access to S3 and other services"
  policy      = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = ["fsx:*"],
        Resource  = "*"
      },
      {
        Effect    = "Allow",
        Action    = ["s3:*"],
        Resource  = "*"
      },
      {
        Effect    = "Allow",
        Action    = ["ec2:*"],
        Resource  = "*"
      },
            {
        Effect    = "Allow",
        Action    = ["ssm:*"],
        Resource  = "*"
      }
    ]
  })
}

# Attach the Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# Create an IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}