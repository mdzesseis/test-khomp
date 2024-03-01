output "subnet_id" {
  description = "Id Subnet AWS"
  value       = aws_subnet.khomp-test-subnet.id
}

output "security_group_id" {
  description = "Id security group AWS"
  value       = aws_security_group.khomp-test-security-group.id
}

output "security_group_web_id" {
  description = "Id security group AWS"
  value       = aws_security_group.khomp-web-test-security-group.id
}