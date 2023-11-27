
output "sig_management_subnet_id" {
  value = aws_subnet.SIG_management_subnet.id
}

output "sig_production_subnet_id" {
  value = aws_subnet.SIG_production_subnet.id
}

output "sg_hub_id"{
  value = aws_security_group.SIG_hub_sg.id
}

output "sg_spoke_id"{
  value = aws_security_group.SIG_spoke_sg.id
}