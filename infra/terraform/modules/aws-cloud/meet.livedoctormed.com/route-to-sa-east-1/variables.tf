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

variable "meet_project" {
  description = "Project Name"
  type        = string
}

variable "domain" {
  description = "Domínio do Site"
  type        = string
}

variable "meet_subdomain" {
  description = "Subdomínio do Site"
  type        = string
}

variable "meet_base_ami_id" {
  description = "ID da imagem"
  type        = string
}

variable "meet_web_instance_type" {
  description = "Tipo de instância"
  type        = string
}

variable "aws_lb_app_lb_dns_name" {
  description = "aws_lb_app_lb_dns_name"
  type        = string
}

variable "aws_lb_app_lb_zone_id" {
  description = "aws_lb_app_lb_zone_id"
  type        = string
}