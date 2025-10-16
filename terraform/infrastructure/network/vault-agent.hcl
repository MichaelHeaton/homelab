# Vault Agent Configuration
# This file configures the Vault agent for local authentication

# Vault server address
vault {
  address = "https://vault.specterrealm.com"
}

# Auto-auth configuration
auto_auth {
  method "token" {
    config = {
      # Token should be provided via VAULT_TOKEN environment variable
      # token = "your-vault-token-here"
    }
  }

  sink "file" {
    config = {
      path = "/tmp/vault-token"
    }
  }
}

# Template for environment variables
template {
  source      = "/Users/michaelheaton/Documents/GitHub/homelab/terraform/infrastructure/network/vault-env.tpl"
  destination = "/tmp/vault-env"
  perms      = 0600
  command    = "source /tmp/vault-env"
}