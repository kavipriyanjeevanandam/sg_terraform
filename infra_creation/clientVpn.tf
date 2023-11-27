# resource "aws_ec2_client_vpn_endpoint" "my_client_vpn" {
#   server_certificate_arn = "arn:aws:acm:ap-south-1:447568380028:certificate/f621d63d-5f98-4b03-92d3-fc1fdaa6f585"  # server certificate ARN
#   client_cidr_block      = "10.0.0.0/16"
#   vpc_id                 = aws_vpc.SIG_hub.id
#   split_tunnel = true
#   authentication_options {
#     type          = "certificate-authentication"
#     root_certificate_chain_arn = "arn:aws:acm:ap-south-1:447568380028:certificate/f621d63d-5f98-4b03-92d3-fc1fdaa6f585"  #  root certificate ARN
#   }
#   connection_log_options {
#     enabled       = false
#   }
#   tags = {
#      Name = "SIG_Point_to_Site"
#   }
# }

# resource "aws_ec2_client_vpn_network_association" "my_network_association" {
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.my_client_vpn.id
#   subnet_id              = aws_subnet.SIG_management_subnet.id
# }

# resource "aws_ec2_client_vpn_authorization_rule" "hub_subnet_authorization_rule" {
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.my_client_vpn.id
#   target_network_cidr   = aws_subnet.SIG_management_subnet.cidr_block # replace with your VPC subnet CIDR block
#   authorize_all_groups   = true
# }

# resource "aws_ec2_client_vpn_authorization_rule" "spoke_subnet_authorization_rule" {
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.my_client_vpn.id
#   target_network_cidr   = aws_subnet.SIG_production_subnet.cidr_block # replace with your VPC subnet CIDR block
#   authorize_all_groups   = true
# }


# resource "aws_ec2_client_vpn_route" "spoke_route" {
#   client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.my_client_vpn.id
#   destination_cidr_block = aws_vpc.SIG_spoke.cidr_block
#   target_vpc_subnet_id   = aws_subnet.SIG_management_subnet.id
# }
