# Variables for Vault Management Environment

variable "consul_management_token" {
  description = "Consul management token for Vault-Consul integration"
  type        = string
  sensitive   = true
}

variable "vault_address" {
  description = "Vault server address"
  type        = string
  default     = "https://vault.specterrealm.com"
}

variable "consul_address" {
  description = "Consul server address"
  type        = string
  default     = "https://consul.specterrealm.com"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "datacenter" {
  description = "Datacenter name"
  type        = string
  default     = "headquarters"
}
