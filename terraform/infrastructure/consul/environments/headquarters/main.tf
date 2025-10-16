# Consul Management for Headquarters Site
# This configuration manages Consul ACLs, services, and integrations

terraform {
  # backend "consul" {
  #   address = "consul.specterrealm.com:443"
  #   path    = "terraform/state/consul/headquarters"
  #   scheme  = "https"
  #   lock    = true
  # }

  required_providers {
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

# Configure the Consul Provider
provider "consul" {
  address    = "https://consul.specterrealm.com"
  datacenter = "headquarters"
  # Token will be read from CONSUL_HTTP_TOKEN environment variable
}

# Configure the Vault Provider
provider "vault" {
  address = "https://vault.specterrealm.com"
  # Token will be read from VAULT_TOKEN environment variable
}

# Vault integration for Consul credentials
data "vault_kv_secret_v2" "consul_credentials" {
  mount = "homelab"
  name  = "infrastructure/consul/headquarters/management-credentials"
}

# Local values for Consul configuration
locals {
  consul_management_token = data.vault_kv_secret_v2.consul_credentials.data["management_token"]
  consul_datacenter       = "headquarters"
  consul_environment      = "production"
}

# Consul ACL Management
module "consul_acl" {
  source = "../../modules/consul-acl"

  acl_policies = {
    "homelab-infrastructure" = {
      name        = "homelab-infrastructure"
      description = "Policy for homelab infrastructure services"
      rules       = <<-EOT
        # Allow service registration for infrastructure
        service_prefix "vault" {
          policy = "write"
        }

        service_prefix "consul" {
          policy = "write"
        }

        service_prefix "terraform" {
          policy = "write"
        }

        # Allow key-value access for configuration
        key_prefix "homelab/" {
          policy = "write"
        }
      EOT
    }
  }

  acl_tokens = {
    "vault-integration" = {
      description = "Token for Vault-Consul integration"
      policies    = ["vault-integration"]
      local       = false
      ttl         = "24h"
    }
    "terraform-state" = {
      description = "Token for Terraform state management"
      policies    = ["terraform-state"]
      local       = false
      ttl         = "1h"
    }
  }

  service_tokens = {
    "vault-service" = {
      description = "Token for Vault service registration"
      policies    = ["homelab-infrastructure"]
      local       = false
      ttl         = "24h"
    }
    "consul-service" = {
      description = "Token for Consul service registration"
      policies    = ["homelab-infrastructure"]
      local       = false
      ttl         = "24h"
    }
  }
}

# Consul Service Discovery
module "consul_services" {
  source = "../../modules/consul-services"

  infrastructure_services = {
    "vault" = {
      name    = "vault"
      node    = "homelab-server"
      port    = 8200
      address = "vault.specterrealm.com"
      tags    = ["infrastructure", "secrets", "vault"]
      meta = {
        environment = "production"
        datacenter  = "headquarters"
        service     = "vault"
      }
      check = {
        http     = "https://vault.specterrealm.com/v1/sys/health"
        interval = "30s"
        timeout  = "5s"
      }
    }
    "consul" = {
      name    = "consul"
      node    = "homelab-server"
      port    = 8500
      address = "consul.specterrealm.com"
      tags    = ["infrastructure", "service-discovery", "consul"]
      meta = {
        environment = "production"
        datacenter  = "headquarters"
        service     = "consul"
      }
      check = {
        http     = "https://consul.specterrealm.com/v1/status/leader"
        interval = "30s"
        timeout  = "5s"
      }
    }
  }

  application_services = {
    "plex" = {
      name    = "plex"
      node    = "homelab-server"
      port    = 32400
      address = "plex.specterrealm.com"
      tags    = ["application", "media", "plex"]
      meta = {
        environment = "production"
        datacenter  = "headquarters"
        service     = "plex"
      }
      check = {
        http     = "http://plex.specterrealm.com:32400/web"
        interval = "30s"
        timeout  = "5s"
      }
    }
  }

  monitoring_services = {
    "prometheus" = {
      name    = "prometheus"
      node    = "homelab-server"
      port    = 9090
      address = "prometheus.specterrealm.com"
      tags    = ["monitoring", "metrics", "prometheus"]
      meta = {
        environment = "production"
        datacenter  = "headquarters"
        service     = "prometheus"
      }
      check = {
        http     = "http://prometheus.specterrealm.com:9090/-/healthy"
        interval = "30s"
        timeout  = "5s"
      }
    }
    "grafana" = {
      name    = "grafana"
      node    = "homelab-server"
      port    = 3000
      address = "grafana.specterrealm.com"
      tags    = ["monitoring", "dashboard", "grafana"]
      meta = {
        environment = "production"
        datacenter  = "headquarters"
        service     = "grafana"
      }
      check = {
        http     = "http://grafana.specterrealm.com:3000/api/health"
        interval = "30s"
        timeout  = "5s"
      }
    }
  }

  service_intentions = {
    "vault" = {
      sources = [
        {
          name   = "consul"
          action = "allow"
        },
        {
          name   = "terraform"
          action = "allow"
        }
      ]
    }
    "consul" = {
      sources = [
        {
          name   = "vault"
          action = "allow"
        },
        {
          name   = "terraform"
          action = "allow"
        }
      ]
    }
  }

  proxy_defaults = {
    config = {
      protocol = "http"
    }
  }
}

# Outputs
output "consul_acl_tokens" {
  description = "Created Consul ACL tokens"
  value       = module.consul_acl.acl_tokens
  sensitive   = true
}

output "consul_service_tokens" {
  description = "Created Consul service tokens"
  value       = module.consul_acl.service_tokens
  sensitive   = true
}

output "consul_services" {
  description = "Registered Consul services"
  value = {
    infrastructure = module.consul_services.infrastructure_services
    applications   = module.consul_services.application_services
    monitoring     = module.consul_services.monitoring_services
  }
}
