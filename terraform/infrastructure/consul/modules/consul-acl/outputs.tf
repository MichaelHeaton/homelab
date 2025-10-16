# Outputs for Consul ACL Management Module

output "acl_policies" {
  description = "Created ACL policies"
  value = {
    for k, v in consul_acl_policy.policies : k => {
      name = v.name
      id   = v.id
    }
  }
}

output "acl_tokens" {
  description = "Created ACL tokens"
  value = {
    for k, v in consul_acl_token.tokens : k => {
      id    = v.id
      token = v.secret_id
    }
  }
  sensitive = true
}

output "service_tokens" {
  description = "Created service tokens"
  value = {
    for k, v in consul_acl_token.service_tokens : k => {
      id    = v.id
      token = v.secret_id
    }
  }
  sensitive = true
}

output "terraform_state_policy" {
  description = "Terraform state policy information"
  value = {
    name = consul_acl_policy.terraform_state.name
    id   = consul_acl_policy.terraform_state.id
  }
}

output "vault_integration_policy" {
  description = "Vault integration policy information"
  value = {
    name = consul_acl_policy.vault_integration.name
    id   = consul_acl_policy.vault_integration.id
  }
}
