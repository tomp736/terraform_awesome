resource "aws_vpc" "network" {
  cidr_block = var.network_ip_range

  tags = {
    name = var.network_name
  }
}

resource "aws_subnet" "subnet" {
  for_each = { for subnet in var.network_subnet_ranges : subnet => subnet }

  vpc_id            = aws_vpc.network.id
  cidr_block        = each.value
  availability_zone = var.network_zone

  tags = {
    name = var.network_name
  }
}

resource "aws_security_group" "ingress_allow_tls_2222" {
  depends_on = [
    aws_vpc.network,
    aws_subnet
  ]

  name        = "ingress_allow_tls_2222"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.network.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 2222
    to_port          = 2222
    protocol         = "tcp"
    cidr_blocks      = [
      aws_vpc.network.cidr_block
    ]
    ipv6_cidr_blocks = [
      aws_vpc.network.ipv6_cidr_block
    ]
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
  vpc_id      = aws_vpc.network.id

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