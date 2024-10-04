# Define um Security Group para permitir tráfego em portas SSH, HTTP e HTTPS
resource "aws_security_group" "allow_ports" {
  name        = "${var.project}-allow_ports"
  description = "Permite conexoes para a rede do WebMeet"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project}-web"
  }
}

# Regra de entrada para SSH (porta 22)
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.allow_ports.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  # cidr_blocks      = [aws_vpc.main.cidr_block]
  cidr_blocks = ["0.0.0.0/0"]
}

# Regra de entrada para HTTP (porta 80)
resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  security_group_id = aws_security_group.allow_ports.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # cidr_blocks      = [aws_vpc.main.cidr_block]
  cidr_blocks = ["0.0.0.0/0"]
}

# Regra de entrada para HTTPS (porta 443)
resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  security_group_id = aws_security_group.allow_ports.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  # cidr_blocks      = [aws_vpc.main.cidr_block]
  cidr_blocks = ["0.0.0.0/0"]
}

# Regra de saída para permitir todo tráfego
resource "aws_security_group_rule" "allow_all_traffic" {
  from_port         = 0
  to_port           = 0
  type              = "egress"
  security_group_id = aws_security_group.allow_ports.id
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "-1" # Semantically equivalent to all ports
}