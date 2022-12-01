
# VPC
resource "aws_vpc" "default" {
  cidr_block = var.network_ip_range

  tags = {
    name = var.network_name
  }
}

# VPC DHCP OPTIONS
resource "aws_default_vpc_dhcp_options" "default" {
  tags = {
    name = var.network_name
  }
}

resource "aws_vpc_dhcp_options_association" "default" {
  vpc_id          = aws_vpc.default.id
  dhcp_options_id = aws_default_vpc_dhcp_options.default.id
}

# VPC GATEWAY
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    name = var.network_name
  }
}

resource "aws_internet_gateway_attachment" "default" {
  internet_gateway_id = aws_internet_gateway.default.id
  vpc_id              = aws_vpc.default.id
}

# VPC SUBNET
resource "aws_subnet" "default" {
  for_each = { for subnet in var.network_subnet_ranges : subnet => subnet }

  vpc_id            = aws_vpc.default.id
  cidr_block        = each.value
  availability_zone = var.network_zone

  tags = {
    name = var.network_name
  }
}

resource "aws_security_group" "default" {
  depends_on = [
    aws_vpc.default,
    aws_subnet.default
  ]

  name        = "default"
  description = "default"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "TLS from VPC"
    from_port   = 2222
    to_port     = 2222
    protocol    = "tcp"
    cidr_blocks = [
      var.network_ip_range
    ]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    name = "default"
  }
}