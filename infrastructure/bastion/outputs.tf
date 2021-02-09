output "bastion_ip" {
  value = aws_eip.bastion.public_ip
}

output "aws_security_group_bastion" {
  value = aws_security_group.bastion_sg.id
}
