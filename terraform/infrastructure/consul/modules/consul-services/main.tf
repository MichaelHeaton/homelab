# Consul Service Discovery Module
# This module manages Consul services, health checks, and service mesh

# Register infrastructure services
resource "consul_service" "infrastructure" {
  for_each = var.infrastructure_services

  name    = each.value.name
  node    = each.value.node
  port    = each.value.port
  address = each.value.address

  tags = each.value.tags

  meta = each.value.meta

  check {
    http     = each.value.check.http
    interval = each.value.check.interval
    timeout  = each.value.check.timeout
  }
}

# Register application services
resource "consul_service" "applications" {
  for_each = var.application_services

  name    = each.value.name
  node    = each.value.node
  port    = each.value.port
  address = each.value.address

  tags = each.value.tags

  meta = each.value.meta

  check {
    http     = each.value.check.http
    interval = each.value.check.interval
    timeout  = each.value.check.timeout
  }
}

# Register monitoring services
resource "consul_service" "monitoring" {
  for_each = var.monitoring_services

  name    = each.value.name
  node    = each.value.node
  port    = each.value.port
  address = each.value.address

  tags = each.value.tags

  meta = each.value.meta

  check {
    http     = each.value.check.http
    interval = each.value.check.interval
    timeout  = each.value.check.timeout
  }
}

# Create service intentions for service mesh
resource "consul_config_entry" "service_intentions" {
  for_each = var.service_intentions

  kind = "service-intentions"
  name = each.key

  config_json = jsonencode({
    Sources = each.value.sources
  })
}

# Create service resolvers for load balancing
resource "consul_config_entry" "service_resolvers" {
  for_each = var.service_resolvers

  kind = "service-resolver"
  name = each.key

  config_json = jsonencode({
    LoadBalancer = each.value.load_balancer
    Failover     = each.value.failover
  })
}

# Create service splitters for traffic splitting
resource "consul_config_entry" "service_splitters" {
  for_each = var.service_splitters

  kind = "service-splitter"
  name = each.key

  config_json = jsonencode({
    Splits = each.value.splits
  })
}

# Create service routers for routing rules
resource "consul_config_entry" "service_routers" {
  for_each = var.service_routers

  kind = "service-router"
  name = each.key

  config_json = jsonencode({
    Routes = each.value.routes
  })
}

# Create proxy defaults for service mesh
resource "consul_config_entry" "proxy_defaults" {
  count = var.proxy_defaults != null ? 1 : 0

  kind = "proxy-defaults"
  name = "global"

  config_json = jsonencode(var.proxy_defaults)
}

# Create mesh gateway configuration
resource "consul_config_entry" "mesh_gateway" {
  count = var.mesh_gateway != null ? 1 : 0

  kind = "mesh-gateway"
  name = "mesh-gateway"

  config_json = jsonencode(var.mesh_gateway)
}
