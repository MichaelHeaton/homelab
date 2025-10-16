# FW-U36 Environment Configuration
# This configuration manages the FW-U36 UniFi site

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
provider "unifi" {
  api_key        = module.vault.unifi_api_key
  api_url        = var.unifi_api_url
  site           = var.unifi_site
  allow_insecure = var.unifi_allow_insecure
}

# Include shared Vault integration
module "vault" {
  source = "../../shared"

  site_name              = var.site_name
  unifi_api_url          = var.unifi_api_url
  unifi_site             = var.unifi_site
  unifi_allow_insecure   = var.unifi_allow_insecure
  dns_servers            = var.dns_servers
  dhcp_lease_time        = var.dhcp_lease_time
  enable_dhcp            = var.enable_dhcp
  vlan_purpose           = var.vlan_purpose
  enable_firewall        = var.enable_firewall
  enable_guest_isolation = var.enable_guest_isolation
  enable_monitoring      = var.enable_monitoring
  monitoring_retention   = var.monitoring_retention
}

# UniFi Network Resources
# These resources are imported from the existing FW-U36 configuration

# Note: The actual resource definitions are in separate files:
# - dns-records.tf: DNS records
# - firewall-groups.tf: Firewall groups
# - static-routes.tf: Static routes
# - vlans.tf: VLANs (networks)
# - wlans.tf: WLANs
# - user-groups.tf: User groups
