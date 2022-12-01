
# VPC
resource "aws_vpc" "default" {
  cidr_block = var.network_ip_range

  tags = {
    Name = var.network_name
  }
}

# VPC DHCP OPTIONS
resource "aws_default_vpc_dhcp_options" "default" {
  tags = {
    Name = var.network_name
  }
}

resource "aws_vpc_dhcp_options_association" "default" {
  vpc_id          = aws_vpc.default.id
  dhcp_options_id = aws_default_vpc_dhcp_options.default.id
}


# VPC SUBNET
resource "aws_subnet" "default" {
  for_each = { for subnet in var.network_subnet_ranges : subnet => subnet }

  vpc_id            = aws_vpc.default.id
  cidr_block        = each.value
  availability_zone = var.network_zone

  tags = {
    Name = var.network_name
  }
}

# VPC GATEWAY
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = var.network_name
  }
}

# VPC DEFAULT ROUTES
resource "aws_route" "route_gateway" {
  route_table_id         = aws_vpc.default.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# VPC DEFAULT SECURITY GROUP RULES
resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = 2222
  to_port           = 2222
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_vpc.default.default_security_group_id
}

# resource "aws_security_group_rule" "egress" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   ipv6_cidr_blocks  = ["::/0"]
#   security_group_id = aws_vpc.default.default_security_group_id
# }