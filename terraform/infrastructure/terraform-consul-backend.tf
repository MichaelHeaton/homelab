# Terraform Consul Backend Configuration
# This configuration uses Consul for state storage with proper authentication

terraform {
  backend "consul" {
    address = "consul.specterrealm.com:443"
    path    = "terraform/state"
    scheme  = "https"
    lock    = true
  }

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
    unifi = {
      source  = "ubiquiti-community/unifi"
      version = "~> 0.1"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.1"
    }
  }
}

# Configure providers
provider "vault" {
  address = "https://vault.specterrealm.com"
  token   = var.vault_token
}

provider "unifi" {
  username = var.unifi_username
  password = var.unifi_password
  api_url  = var.unifi_api_url
  site     = var.unifi_site
  insecure = var.unifi_insecure
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
  insecure = var.proxmox_insecure
}
