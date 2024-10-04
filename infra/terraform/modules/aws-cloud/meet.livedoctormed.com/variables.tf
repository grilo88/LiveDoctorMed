variable "region" {
  description = "Região de hospedagem da infraestrutura"
  type        = string
}

variable "access_key" {
  description = "access_key"
  type        = string
}

variable "secret_key" {
  description = "secret_key"
  type        = string
}

variable "base_ami_id" {
  description = "ID da imagem"
  type        = string
}

variable "project" {
  description = "Project Name"
  type        = string
}

variable "domain" {
  description = "Domínio do Site"
  type        = string
}

variable "subdomain" {
  description = "Subdomínio do Site"
  type        = string
}

variable "web_instance_type" {
  description = "Tipo de instância"
  type        = string
}