# Create an IAM Role for SSM
resource "aws_iam_role" "ssm_role" {
  name = "${var.environment}-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.environment}-ssm-role"
  }
}

# Attach the necessary policies to the role
resource "aws_iam_role_policy_attachment" "ssm_role_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an IAM instance profile for the EC2 instance
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.environment}-ssm-profile"
  role = aws_iam_role.ssm_role.name
}
