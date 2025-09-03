output "monitoring_server_ip" {
  description = "Public IP of the monitoring server"
  value       = aws_instance.monitoring.public_ip
}

output "app_instance_ips" {
  description = "Public IPs of the app instances"
  value       = [for instance in aws_instance.apps : instance.public_ip]
}

output "monitoring_server_private_ip" {
  description = "Private IP of monitoring server"
  value       = aws_instance.monitoring.private_ip
}

output "app_instance_private_ips" {
  description = "Private IPs of the app instances"
  value       = [for instance in aws_instance.apps : instance.private_ip]
}

