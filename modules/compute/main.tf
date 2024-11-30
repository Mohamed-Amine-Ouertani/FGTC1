resource "aws_instance" "training" {
  count = var.instance_number
  ami                  = var.ami_id
  instance_type        = var.instance_type
    network_interface {
    network_interface_id = aws_network_interface.network_interface_for_taraining_instances[count.index].id
    device_index = count.index
  }
  associate_public_ip_address = false
  iam_instance_profile = var.iam_instance_profile

  user_data = base64encode(<<EOT
    #!/bin/bash
    mkdir -p /mnt/fsx
    mount -t lustre ${var.fsx_dns_name}@tcp:/ /mnt/fsx
    echo "${var.fsx_dns_name}@tcp:/ /mnt/fsx lustre defaults,_netdev 0 0" >> /etc/fstab
  EOT
  )

  tags = {
    Name        = "AI-Training-Instance"
    Environment = var.environment
  }
}

resource "aws_network_interface" "network_interface_for_taraining_instances" {
  count = var.instance_number
  subnet_id = element(var.private_subnet_ids, (count.index + 2) % length(var.private_subnet_ids))
  interface_type = "efa"
}

# count ec2 instances 
data "aws_instances" "all" {
}

# Create a Launch Template for EC2 Instances
resource "aws_launch_template" "training_template" {
  name_prefix   = "${var.environment}-training"
  image_id      = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile {
    name = var.iam_instance_profile
  }

  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = element(var.private_subnet_ids, length(data.aws_instances.all.ids) % length(var.private_subnet_ids))
    interface_type = "efa"
  }

  user_data = base64encode(<<EOT
    #!/bin/bash
    mkdir -p /mnt/fsx
    mount -t lustre ${var.fsx_dns_name}@tcp:/ /mnt/fsx
    echo "${var.fsx_dns_name}@tcp:/ /mnt/fsx lustre defaults,_netdev 0 0" >> /etc/fstab
  EOT
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.environment}-AI-Training"
      Environment = var.environment
    }
  }
}

# Auto Scaling Group (ASG)
resource "aws_autoscaling_group" "training_asg" {
  launch_template {
    id      = aws_launch_template.training_template.id
    version = "$Latest"
  }

  min_size         = var.instance_number
  desired_capacity = var.instance_number
  max_size = 9200000000000000000

  vpc_zone_identifier = var.private_subnet_ids
  health_check_type   = "EC2"
  health_check_grace_period = 300


}

# Scaling Policies
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.environment}-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.training_asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.environment}-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.training_asg.name
}

# CloudWatch Alarm for High CPU
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.environment}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 90

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.training_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

# CloudWatch Alarm for Low CPU
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.environment}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 40

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.training_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}