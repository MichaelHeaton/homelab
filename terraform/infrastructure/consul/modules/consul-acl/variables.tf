# Variables for Consul ACL Management Module

variable "acl_policies" {
  description = "Map of ACL policies to create"
  type = map(object({
    name        = string
    description = string
    rules       = string
  }))
  default = {}
}

variable "acl_tokens" {
  description = "Map of ACL tokens to create"
  type = map(object({
    description = string
    policies    = list(string)
    local       = bool
    ttl         = optional(string)
  }))
  default = {}
}

variable "service_tokens" {
  description = "Map of service tokens to create"
  type = map(object({
    description = string
    policies    = list(string)
    local       = bool
    ttl         = optional(string)
  }))
  default = {}
}
