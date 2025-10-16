# Vault Management for Headquarters Site
# This configuration manages Vault policies, auth methods, and secret engines

terraform {
  backend "consul" {
    address = "consul.specterrealm.com:443"
    path    = "terraform/state/vault/headquarters"
    scheme  = "https"
    lock    = true
  }

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.0"
    }
  }
}

# Configure the Vault Provider
provider "vault" {
  address = "https://vault.specterrealm.com"
  # Token will be read from VAULT_TOKEN environment variable
}

# Configure the Consul Provider
provider "consul" {
  address    = "https://consul.specterrealm.com"
  datacenter = "headquarters"
  # Token will be read from CONSUL_HTTP_TOKEN environment variable
}

# Vault Policies Management
module "vault_policies" {
  source = "../../modules/vault-policies"

  policies = {
    "homelab-infrastructure" = {
      name   = "homelab-infrastructure"
      policy = <<-EOT
        # Homelab infrastructure policy
        path "homelab/*" {
          capabilities = ["create", "read", "update", "delete", "list"]
        }

        path "sys/mounts/*" {
          capabilities = ["create", "read", "update", "delete", "list"]
        }

        path "sys/auth/*" {
          capabilities = ["create", "read", "update", "delete", "list"]
        }

        path "sys/policies/*" {
          capabilities = ["create", "read", "update", "delete", "list"]
        }
      EOT
    }
    "proxmox-management" = {
      name   = "proxmox-management"
      policy = <<-EOT
        # Proxmox management policy
        path "homelab/infrastructure/proxmox/*" {
          capabilities = ["create", "read", "update", "delete", "list"]
        }

        path "homelab/infrastructure/proxmox/headquarters/*" {
          capabilities = ["create", "read", "update", "delete", "list"]
        }
      EOT
    }
    "unifi-management" = {
      name   = "unifi-management"
      policy = <<-EOT
        # UniFi management policy
        path "homelab/infrastructure/unifi/*" {
          capabilities = ["create", "read", "update", "delete", "list"]
        }

        path "homelab/infrastructure/unifi/headquarters/*" {
          capabilities = ["create", "read", "update", "delete", "list"]
        }
      EOT
    }
  }
}

# Vault Authentication Management
module "vault_auth" {
  source = "../../modules/vault-auth"

  ldap_enabled       = false
  aws_enabled        = false
  kubernetes_enabled = false
}

# Vault Secret Engines Management
module "vault_secrets" {
  source = "../../modules/vault-secrets"

  aws_enabled      = false
  database_enabled = false
  pki_enabled      = true
  transit_enabled  = true

  pki_common_name = "specterrealm.com"
  pki_ttl         = "8760h" # 1 year

  pki_roles = {
    "homelab-certs" = {
      allowed_domains    = ["specterrealm.com", "*.specterrealm.com"]
      allow_subdomains   = true
      allow_glob_domains = true
      allow_any_name     = false
      enforce_hostnames  = true
      allow_ip_sans      = true
      server_flag        = true
      client_flag        = true
      ttl                = "720h"  # 30 days
      max_ttl            = "8760h" # 1 year
    }
  }

  transit_keys = {
    "homelab-encryption" = {
      type                   = "aes256-gcm96"
      exportable             = false
      allow_plaintext_backup = false
    }
  }

  kv_secrets = {
    "homelab-structure" = {
      data = {
        description = "Homelab secrets organization"
        created_by  = "terraform"
        environment = "production"
        datacenter  = "headquarters"
      }
    }
  }
}

# Consul Secret Engine for Vault-Consul integration
resource "vault_mount" "consul" {
  path        = "consul"
  type        = "consul"
  description = "Consul secret engine for dynamic token generation"
}

# Configure Consul access for Vault
resource "vault_consul_secret_backend" "consul" {
  backend = vault_mount.consul.path
  address = "consul.specterrealm.com:443"
  scheme  = "https"
  token   = var.consul_management_token
}

# Create Consul role for Terraform
resource "vault_consul_secret_backend_role" "terraform" {
  backend  = vault_mount.consul.path
  name     = "terraform"
  policies = ["terraform-state"]
}

# Create Consul role for applications
resource "vault_consul_secret_backend_role" "applications" {
  backend  = vault_mount.consul.path
  name     = "applications"
  policies = ["application"]
}

# Create Consul role for monitoring
resource "vault_consul_secret_backend_role" "monitoring" {
  backend  = vault_mount.consul.path
  name     = "monitoring"
  policies = ["monitoring"]
}

# Create AppRole for Terraform with Consul integration
resource "vault_approle_auth_backend_role" "terraform_consul" {
  backend        = module.vault_auth.approle_backend_path
  role_name      = "terraform-consul"
  token_policies = ["homelab-infrastructure", "proxmox-management", "unifi-management"]

  bind_secret_id = true
  secret_id_ttl  = "24h"
  token_ttl      = "1h"
  token_max_ttl  = "4h"

  secret_id_num_uses = 1
}

# Create AppRole for CI/CD
resource "vault_approle_auth_backend_role" "cicd_consul" {
  backend        = module.vault_auth.approle_backend_path
  role_name      = "cicd-consul"
  token_policies = ["homelab-infrastructure"]

  bind_secret_id = true
  secret_id_ttl  = "1h"
  token_ttl      = "30m"
  token_max_ttl  = "1h"

  secret_id_num_uses = 1
}

# Outputs
output "vault_policies" {
  description = "Created Vault policies"
  value       = module.vault_policies.policies
}

output "vault_auth_methods" {
  description = "Created Vault auth methods"
  value       = module.vault_auth.auth_methods
}

output "vault_secret_engines" {
  description = "Created Vault secret engines"
  value       = module.vault_secrets.secret_engines
}

output "consul_integration" {
  description = "Vault-Consul integration configuration"
  value = {
    consul_backend_path = vault_mount.consul.path
    terraform_role      = vault_consul_secret_backend_role.terraform.name
    applications_role   = vault_consul_secret_backend_role.applications.name
    monitoring_role     = vault_consul_secret_backend_role.monitoring.name
  }
}

output "approle_credentials" {
  description = "AppRole credentials for automation"
  value = {
    terraform_role_id = vault_approle_auth_backend_role.terraform_consul.role_id
    cicd_role_id      = vault_approle_auth_backend_role.cicd_consul.role_id
  }
  sensitive = true
}
