output "vm-khomp-test-ip" {
  description = "IP vm in AWS"
  value       = aws_instance.khomp-test-vm.public_ip
}