output "aws_network" {
  description = "aws network"
  value       = aws_vpc.default
}

output "aws_subnets" {
  description = "aws subnets"
  value       = { for subnet in var.network_subnet_ranges : subnet => aws_subnet.default[subnet] }
}