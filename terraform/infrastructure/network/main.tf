# UniFi Network Infrastructure
# This configuration manages your UniFi network using Terraform

terraform {
  required_version = ">= 1.0"
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
# Credentials are now sourced from HashiCorp Vault for security
provider "unifi" {
  username       = local.unifi_username
  password       = local.unifi_password
  api_url        = var.unifi_api_url
  site           = var.unifi_site
  allow_insecure = var.unifi_allow_insecure
}

# Note: ubiquiti-community/unifi provider doesn't support unifi_site data source
# Site is configured directly in the provider block above
