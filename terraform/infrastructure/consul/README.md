# Consul Management with Terraform

This directory contains Terraform configurations for managing HashiCorp Consul infrastructure as code.

## 🏗️ Architecture

### Directory Structure
```
consul/
├── environments/           # Environment-specific configurations
│   ├── headquarters/       # Main site configuration
│   └── site-rv/           # RV site configuration
├── modules/               # Reusable Consul modules
│   ├── consul-acl/        # ACL management
│   ├── consul-services/   # Service discovery
│   ├── consul-mesh/       # Service mesh
│   └── consul-backup/     # Backup automation
├── scripts/               # Automation scripts
└── docs/                 # Documentation
```

## 🔐 Security Features

### ACL Management
- **Anonymous Policy**: Unauthenticated access
- **Terraform State Policy**: State management
- **Vault Integration Policy**: Vault-Consul integration
- **Application Policy**: Service registration
- **Monitoring Policy**: Observability
- **Backup Policy**: Backup operations

### Service Discovery
- **Infrastructure Services**: Vault, Consul, Terraform
- **Application Services**: Plex, Media, Applications
- **Monitoring Services**: Prometheus, Grafana, Observability
- **Service Mesh**: Traffic management and security

## 🚀 Quick Start

### Prerequisites
1. Consul server running and accessible
2. Consul management token
3. Terraform installed
4. Environment variables set:
   ```bash
   export CONSUL_HTTP_TOKEN="your-consul-token"
   ```

### Deploy Consul Management
```bash
# Navigate to environment
cd environments/headquarters

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply configuration
terraform apply
```

## 📋 Configuration

### Environment Variables
```bash
# Consul Configuration
export CONSUL_HTTP_TOKEN="your-consul-token"
export CONSUL_HTTP_ADDR="https://consul.specterrealm.com"
```

### Terraform Variables
```hcl
# Consul Management Environment
consul_management_token = "your-consul-management-token"
consul_address         = "https://consul.specterrealm.com"
datacenter             = "headquarters"
environment            = "production"
```

## 🔧 Modules

### Consul ACL Module
Manages ACL policies and tokens:
- Infrastructure policies
- Application policies
- Monitoring policies
- Backup policies
- Service tokens

### Consul Services Module
Manages service discovery:
- Service registration
- Health checks
- Service intentions
- Service resolvers
- Service splitters
- Service routers

## 🔄 Vault-Consul Integration

### Dynamic Token Generation
Vault generates dynamic Consul tokens for:
- Terraform state management
- Application service discovery
- Monitoring and observability
- Backup operations

### Configuration
```hcl
# Vault Consul Secret Engine
resource "vault_mount" "consul" {
  path = "consul"
  type = "consul"
}

# Consul Access Configuration
resource "vault_consul_secret_backend" "consul" {
  backend = vault_mount.consul.path
  address = "consul.specterrealm.com:443"
  scheme  = "https"
  token   = var.consul_management_token
}
```

## 📊 Service Discovery

### Infrastructure Services
- **Vault**: Secret management
- **Consul**: Service discovery
- **Terraform**: Infrastructure management

### Application Services
- **Plex**: Media server
- **Applications**: Custom services
- **Databases**: Data services

### Monitoring Services
- **Prometheus**: Metrics collection
- **Grafana**: Dashboards
- **Observability**: Logging and tracing

## 🔄 Service Mesh

### Traffic Management
- **Service Intentions**: Access control
- **Service Resolvers**: Load balancing
- **Service Splitters**: Traffic splitting
- **Service Routers**: Routing rules

### Security
- **mTLS**: Mutual TLS encryption
- **Service-to-Service**: Secure communication
- **Network Segmentation**: Traffic isolation

## 📊 Monitoring

### Health Checks
- Service health status
- Node health status
- ACL token status
- Service mesh status

### Metrics
- Service discovery metrics
- ACL token usage
- Service mesh metrics
- Performance metrics

## 🔄 Backup and Recovery

### Automated Backups
- Daily snapshots
- ACL token backup
- Service configuration backup
- Cross-site replication

### Disaster Recovery
- Service restoration
- ACL token recovery
- Configuration recovery
- Service mesh recovery

## 🚨 Security Best Practices

### ACL Management
- Principle of least privilege
- Token rotation
- Policy auditing
- Access monitoring

### Service Security
- Service authentication
- Network encryption
- Access controls
- Audit logging

### Network Security
- TLS encryption
- Network segmentation
- Firewall rules
- VPN access

## 📚 Documentation

### Additional Resources
- [Consul Documentation](https://www.consul.io/docs)
- [Terraform Consul Provider](https://registry.terraform.io/providers/hashicorp/consul/latest)
- [Consul Best Practices](https://learn.hashicorp.com/consul)

### Support
- GitHub Issues
- HashiCorp Community
- Professional Support

## 🎯 Next Steps

1. **Deploy Consul Management**: Configure ACLs and services
2. **Integrate with Vault**: Set up dynamic token generation
3. **Configure Service Discovery**: Register infrastructure services
4. **Set up Service Mesh**: Configure traffic management
5. **Implement Monitoring**: Configure health checks and metrics
6. **Test Integration**: Verify all components work together

---

**Note**: This configuration is designed for production use with proper security measures. Always review and test in a non-production environment first.
