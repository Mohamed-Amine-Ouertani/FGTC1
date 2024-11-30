output "instance_id" {
  value = aws_instance.training[*].id
}
