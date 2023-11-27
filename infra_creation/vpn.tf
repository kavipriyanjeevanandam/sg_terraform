# # Create a Virtual Private Gateway (VPG)
# resource "aws_vpn_gateway" "hub_vpn_gateway" {
#   vpc_id = aws_vpc.SIG_hub.id
#   tags = {
#     Name = "Hub VPN Gateway"
#   }
# }

# # Attach the VPG to the Hub VPC
# resource "aws_vpn_gateway_attachment" "hub_vpn_attachment" {
#   vpc_id         = aws_vpc.SIG_hub.id
#   vpn_gateway_id = aws_vpn_gateway.hub_vpn_gateway.id
# }

# # Create a Customer Gateway (representing the other VPC)
# resource "aws_customer_gateway" "other_vpc_customer_gateway" {
#   bgp_asn    = 65000            # BGP ASN
#   ip_address = "20.204.6.140" # Public IP address of the other VPC's VPN endpoint
#   type       = "ipsec.1"
#   tags = {
#     Name = "SIG Customer Gateway"
#   }
# }

# # Create a VPN Connection
# resource "aws_vpn_connection" "hub_to_other_vpc" {
#   customer_gateway_id = aws_customer_gateway.other_vpc_customer_gateway.id
#   vpn_gateway_id      = aws_vpn_gateway.hub_vpn_gateway.id
#   type                = "ipsec.1"
#   static_routes_only = true
# }
# resource "aws_vpn_connection_route" "other_vpc_cidr" {
#   destination_cidr_block = "172.17.36.0/22"  # IP Prefix
#   vpn_connection_id      = aws_vpn_connection.hub_to_other_vpc.id
# }

# # Update Route Tables in Hub VPC to route traffic to the VPN Connection
# resource "aws_route" "hub_to_other_vpc_route" {
#   route_table_id         = aws_vpc.SIG_hub.main_route_table_id #  hub VPC's main route table
#   destination_cidr_block = "172.17.36.0/22"                       # Destination CIDR block of the other VPC
#   gateway_id             = aws_vpn_gateway.hub_vpn_gateway.id
# }

