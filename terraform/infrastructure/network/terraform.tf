# Terraform Configuration for Network Infrastructure
# This configuration manages UniFi network infrastructure using Consul backend

terraform {
  # Using local backend for testing
  # TODO: Migrate to Consul backend after authentication is configured
  # backend "consul" {
  #   address = "consul.specterrealm.com:443"
  #   path    = "terraform/state/network"
  #   scheme  = "https"
  #   lock    = true
  # }

  required_providers {
    unifi = {
      source  = "ubiquiti-community/unifi"
      version = "~> 0.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

# Configure the UniFi Provider
# Using API key authentication from Vault for better reliability
provider "unifi" {
  api_key        = local.unifi_api_key
  api_url        = var.unifi_api_url
  site           = var.unifi_site
  allow_insecure = var.unifi_allow_insecure
}

# Configure the Vault Provider
provider "vault" {
  address = "https://vault.specterrealm.com"
  # Vault token will be read from VAULT_TOKEN environment variable
}
