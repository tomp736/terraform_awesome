resource "aws_vpc" "default" {
  cidr_block = var.network_ip_range

  tags = {
    name = var.network_name
  }
}

resource "aws_default_vpc_dhcp_options" "default" {
  tags = {
    name = var.network_name
  }
}
resource "aws_vpc_dhcp_options_association" "default" {
  vpc_id          = aws_vpc.network.id
  dhcp_options_id = aws_vpc_dhcp_options.default.id
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.network.id

  tags = {
    name = var.network_name
  }
}
resource "aws_internet_gateway_attachment" "default" {
  internet_gateway_id = aws_internet_gateway.default.id
  vpc_id              = aws_vpc.default.id
}

resource "aws_subnet" "default" {
  for_each = { for subnet in var.network_subnet_ranges : subnet => subnet }

  vpc_id            = aws_vpc.default.id
  cidr_block        = each.value
  availability_zone = var.network_zone

  tags = {
    name = var.network_name
  }
}

resource "aws_security_group" "ingress_allow_tls_2222" {
  depends_on = [
    aws_vpc.default,
    aws_subnet.default
  ]

  name        = "ingress_allow_tls_2222"
  description = "Allow TLS inbound traffic"
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
    name = "ingress_allow_tls_2222"
  }
}

resource "aws_security_group" "egress_allow_all" {
  name        = "egress_allow_all"
  description = "Allow all egress"
  vpc_id      = aws_vpc.default.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    name = "egress_allow_all"
  }
}