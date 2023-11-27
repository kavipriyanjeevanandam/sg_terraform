# Define the AWS provider
provider "aws" {
  region = "ap-south-1"
}
# Create the hub VPC
resource "aws_vpc" "SIG_hub" {
  cidr_block = "172.17.42.0/24"
  tags = {
    Name = "SIG_hub"
  }
}
# Create the spoke VPC
resource "aws_vpc" "SIG_spoke" {
  cidr_block = "192.168.136.0/24"
  tags = {
    Name = "SIG_spoke"
  }
}
# Create Internet Gateway for the spoke VPC
resource "aws_internet_gateway" "SIG_igw" {
  vpc_id = aws_vpc.SIG_spoke.id
  tags = {
    Name = "SIG_igw"
  }
}
# Create a subnet in the hub VPC for management
resource "aws_subnet" "SIG_management_subnet" {
  vpc_id                  = aws_vpc.SIG_hub.id
  cidr_block              = "172.17.42.0/27"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "SIG_management_subnet"
  }
}
# Create a subnet in the spoke VPC for production/non-production
resource "aws_subnet" "SIG_production_subnet" {
  vpc_id                  = aws_vpc.SIG_spoke.id
  cidr_block              = "192.168.136.0/26"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "SIG_production_subnet"
  }
}
# Get the main route table ID for the hub VPC
data "aws_vpc" "hub_vpc" {
  id = aws_vpc.SIG_hub.id
}
# Associate the management subnet with the hub's main route table
resource "aws_route_table_association" "hub_management_subnet_association" {
  subnet_id      = aws_subnet.SIG_management_subnet.id
  route_table_id = data.aws_vpc.hub_vpc.main_route_table_id
}
# Create VPC peering connection from spoke to hub
resource "aws_vpc_peering_connection" "SIG_spoke_and_hub" {
  peer_vpc_id = aws_vpc.SIG_hub.id
  vpc_id      = aws_vpc.SIG_spoke.id
  tags = {
    Name = "SIG_spoke_and_hub"
  }
}
# Accept the VPC peering connection on the spoke VPC
resource "aws_vpc_peering_connection_accepter" "SIG_spoke_and_hub_accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.SIG_spoke_and_hub.id
  auto_accept               = true
}
# Get the main route table ID for the spoke VPC
data "aws_vpc" "spoke_vpc" {
  id = aws_vpc.SIG_spoke.id
}
# Associate the production subnet with the spoke's main route table
resource "aws_route_table_association" "spoke_production_subnet_association" {
  subnet_id      = aws_subnet.SIG_production_subnet.id
  route_table_id = data.aws_vpc.spoke_vpc.main_route_table_id
}
# Create a route in the spoke's main route table for the hub VPC
resource "aws_route" "spoke_to_hub" {
  route_table_id            = aws_vpc.SIG_spoke.main_route_table_id
  destination_cidr_block    = "172.17.42.0/24"
  vpc_peering_connection_id = aws_vpc_peering_connection.SIG_spoke_and_hub.id
}
# Create a route in the hub's main route table for the spoke VPC
resource "aws_route" "hub_to_spoke" {
  route_table_id            = aws_vpc.SIG_hub.main_route_table_id
  destination_cidr_block    = "192.168.136.0/24"
  vpc_peering_connection_id = aws_vpc_peering_connection.SIG_spoke_and_hub.id
}
# Create a route in the spoke's main route table for internet access via the Internet Gateway
resource "aws_route" "spoke_to_internet" {
  route_table_id         = aws_vpc.SIG_spoke.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.SIG_igw.id
}

resource "aws_security_group" "SIG_hub_sg" {
  name        = "SIG-sg"
  description = "Security group for SIG EC2 instances"
  vpc_id      = aws_vpc.SIG_hub.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "SIG_spoke_sg" {
  name        = "SIG-sg"
  description = "Security group for SIG EC2 instances"
  vpc_id      = aws_vpc.SIG_spoke.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

