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

variable "organization" {
  default = "Organization Name"
  type = string
}

variable "www_project" {
  description = "Project Name"
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

variable "www_subdomain" {
  description = "Subdomínio do Site"
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

variable "mail_workmail_users" {
  type = list(object({
    id      = string
    user    = string
    display = string
  }))
  description = "Lista de emails para os usuários do WorkMail"
}