# Consul ACL Management Module
# This module manages Consul ACLs, policies, and tokens

# Create ACL policies
resource "consul_acl_policy" "policies" {
  for_each = var.acl_policies

  name        = each.value.name
  description = each.value.description
  rules       = each.value.rules
}

# Create ACL tokens
resource "consul_acl_token" "tokens" {
  for_each = var.acl_tokens

  description = each.value.description
  policies    = each.value.policies
  local       = each.value.local
  ttl         = each.value.ttl
}

# Create service tokens for applications
resource "consul_acl_token" "service_tokens" {
  for_each = var.service_tokens

  description = each.value.description
  policies    = each.value.policies
  local       = each.value.local
  ttl         = each.value.ttl
}

# Create anonymous token policy
resource "consul_acl_policy" "anonymous" {
  name        = "anonymous"
  description = "Anonymous token policy for unauthenticated access"
  rules       = <<-EOT
    # Allow read access to all services
    service_prefix "" {
      policy = "read"
    }

    # Allow read access to all nodes
    node_prefix "" {
      policy = "read"
    }

    # Allow read access to all keys
    key_prefix "" {
      policy = "read"
    }

    # Allow session creation
    session_prefix "" {
      policy = "write"
    }
  EOT
}

# Create terraform state policy
resource "consul_acl_policy" "terraform_state" {
  name        = "terraform-state"
  description = "Policy for Terraform state management"
  rules       = <<-EOT
    # Allow full access to terraform state keys
    key "terraform/state" {
      policy = "write"
    }

    key "terraform/state/*" {
      policy = "write"
    }

    # Allow session management for locking
    session "terraform" {
      policy = "write"
    }

    session_prefix "terraform" {
      policy = "write"
    }
  EOT
}

# Create vault integration policy
resource "consul_acl_policy" "vault_integration" {
  name        = "vault-integration"
  description = "Policy for Vault-Consul integration"
  rules       = <<-EOT
    # Allow Vault to manage tokens
    acl = "write"

    # Allow access to all keys for secret management
    key_prefix "" {
      policy = "write"
    }

    # Allow service registration
    service_prefix "" {
      policy = "write"
    }

    # Allow node registration
    node_prefix "" {
      policy = "write"
    }
  EOT
}

# Create application policy
resource "consul_acl_policy" "application" {
  name        = "application"
  description = "Policy for application services"
  rules       = <<-EOT
    # Allow service registration for applications
    service_prefix "app-" {
      policy = "write"
    }

    # Allow service discovery
    service_prefix "" {
      policy = "read"
    }

    # Allow node discovery
    node_prefix "" {
      policy = "read"
    }

    # Allow key-value access for configuration
    key_prefix "config/" {
      policy = "read"
    }
  EOT
}

# Create monitoring policy
resource "consul_acl_policy" "monitoring" {
  name        = "monitoring"
  description = "Policy for monitoring and observability"
  rules       = <<-EOT
    # Allow read access to all services for monitoring
    service_prefix "" {
      policy = "read"
    }

    # Allow read access to all nodes
    node_prefix "" {
      policy = "read"
    }

    # Allow read access to health checks
    service_prefix "" {
      policy = "read"
    }

    # Allow access to monitoring keys
    key_prefix "monitoring/" {
      policy = "read"
    }
  EOT
}

# Create backup policy
resource "consul_acl_policy" "backup" {
  name        = "backup"
  description = "Policy for backup operations"
  rules       = <<-EOT
    # Allow read access to all keys for backup
    key_prefix "" {
      policy = "read"
    }

    # Allow read access to all services
    service_prefix "" {
      policy = "read"
    }

    # Allow read access to all nodes
    node_prefix "" {
      policy = "read"
    }
  EOT
}
