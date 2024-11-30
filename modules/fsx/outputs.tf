output "fsx_id" {
  description = "The ID of the FSx file system"
  value       = aws_fsx_lustre_file_system.fsx.id
}

output "fsx_dns_name" {
  description = "The DNS name of the FSx file system"
  value       = aws_fsx_lustre_file_system.fsx.dns_name
}
