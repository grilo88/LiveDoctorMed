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

variable "no_reply_username" {
  description = "Nome de usuário no-reply"
  type        = string
  default     = "no-reply"
}