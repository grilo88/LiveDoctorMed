# Define a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-vpc"
  }
}

# Associação da sub-rede pública à tabela de rotas
resource "aws_route_table_association" "subnet_a_public_association" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.public.id
}

# Associação da sub-rede pública à tabela de rotas
resource "aws_route_table_association" "subnet_b_public_association" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.public.id
}

# Associação da sub-rede pública à tabela de rotas
resource "aws_route_table_association" "subnet_c_public_association" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.public.id
}