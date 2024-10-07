# Geração de um par de chaves localmente
resource "tls_private_key" "ec2_instance" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload da chave pública para AWS
resource "aws_key_pair" "deployer" {
  key_name   = "${var.project}-deployer-key"
  public_key = tls_private_key.ec2_instance.public_key_openssh
}

# Salvando a chave privada em um arquivo local
resource "local_file" "private_key" {
  filename        = "${path.module}/private-key-${var.subdomain}-${var.region}.pem"
  content         = tls_private_key.ec2_instance.private_key_pem
  file_permission = "0400" # Somente leitura pelo proprietário
}
