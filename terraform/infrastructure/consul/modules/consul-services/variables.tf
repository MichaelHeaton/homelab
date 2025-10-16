# Variables for Consul Service Discovery Module

variable "infrastructure_services" {
  description = "Map of infrastructure services to register"
  type = map(object({
    name    = string
    node    = string
    port    = number
    address = string
    tags    = list(string)
    meta    = map(string)
    check = object({
      http     = string
      interval = string
      timeout  = string
    })
  }))
  default = {}
}

variable "application_services" {
  description = "Map of application services to register"
  type = map(object({
    name    = string
    node    = string
    port    = number
    address = string
    tags    = list(string)
    meta    = map(string)
    check = object({
      http     = string
      interval = string
      timeout  = string
    })
  }))
  default = {}
}

variable "monitoring_services" {
  description = "Map of monitoring services to register"
  type = map(object({
    name    = string
    node    = string
    port    = number
    address = string
    tags    = list(string)
    meta    = map(string)
    check = object({
      http     = string
      interval = string
      timeout  = string
    })
  }))
  default = {}
}

variable "service_intentions" {
  description = "Map of service intentions for service mesh"
  type = map(object({
    sources = list(object({
      name   = string
      action = string
    }))
  }))
  default = {}
}

variable "service_resolvers" {
  description = "Map of service resolvers for load balancing"
  type = map(object({
    load_balancer = object({
      policy = string
    })
    failover = optional(object({
      targets = list(object({
        service = string
      }))
    }))
  }))
  default = {}
}

variable "service_splitters" {
  description = "Map of service splitters for traffic splitting"
  type = map(object({
    splits = list(object({
      weight         = number
      service        = string
      service_subset = optional(string)
    }))
  }))
  default = {}
}

variable "service_routers" {
  description = "Map of service routers for routing rules"
  type = map(object({
    routes = list(object({
      match = object({
        http = object({
          path_prefix = string
        })
      })
      destination = object({
        service        = string
        service_subset = optional(string)
      })
    }))
  }))
  default = {}
}

variable "proxy_defaults" {
  description = "Proxy defaults configuration for service mesh"
  type = object({
    config = object({
      protocol = string
    })
  })
  default = null
}

variable "mesh_gateway" {
  description = "Mesh gateway configuration"
  type = object({
    listeners = list(object({
      port     = number
      protocol = string
    }))
  })
  default = null
}
