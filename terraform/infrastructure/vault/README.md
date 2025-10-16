# Vault Management with Terraform

This directory contains Terraform configurations for managing HashiCorp Vault infrastructure as code.

## 🏗️ Architecture

### Directory Structure

```
vault/
├── environments/           # Environment-specific configurations
│   ├── headquarters/      # Main site configuration
│   └── site-rv/           # RV site configuration
├── modules/               # Reusable Vault modules
│   ├── vault-policies/    # RBAC policies management
│   ├── vault-auth/        # Authentication methods
│   ├── vault-secrets/     # Secret engines
│   ├── vault-backup/      # Backup automation
│   ├── vault-monitoring/  # Monitoring and observability
│   └── vault-offline-sync/ # Offline synchronization
├── scripts/               # Automation scripts
└── docs/                 # Documentation
```

## 🔐 Security Features

### RBAC Policies

- **Admin Policy**: Full access to Vault
- **Terraform Policy**: Infrastructure management
- **Application Policy**: Secret access only
- **Audit Policy**: Read-only monitoring
- **Backup Policy**: Automated backups
- **Emergency Policy**: Disaster recovery

### Authentication Methods

- **AppRole**: CI/CD and automation
- **LDAP**: Human user authentication
- **AWS IAM**: Cloud integration
- **Kubernetes**: Container authentication

### Secret Engines

- **KV v2**: Application secrets
- **AWS**: Dynamic AWS credentials
- **Database**: Database credentials
- **PKI**: Certificate management
- **Transit**: Encryption as a service
- **Consul**: Dynamic Consul tokens

## 🚀 Quick Start

### Prerequisites

1. Vault server running and accessible
2. Vault token with admin privileges
3. Terraform installed
4. Environment variables set:
   ```bash
   export VAULT_ADDR="https://vault.specterrealm.com"
   export VAULT_TOKEN="your-vault-token"
   ```

### Deploy Vault Management

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
# Vault Configuration
export VAULT_ADDR="https://vault.specterrealm.com"
export VAULT_TOKEN="your-vault-token"

# Consul Configuration (for Vault-Consul integration)
export CONSUL_HTTP_TOKEN="your-consul-token"
```

### Terraform Variables

```hcl
# Vault Management Environment
consul_management_token = "your-consul-management-token"
vault_address          = "https://vault.specterrealm.com"
consul_address         = "https://consul.specterrealm.com"
environment            = "production"
datacenter             = "headquarters"
```

## 🔧 Modules

### Vault Policies Module

Manages RBAC policies and permissions:

- Infrastructure policies
- Application policies
- Monitoring policies
- Backup policies
- Emergency policies

### Vault Auth Module

Manages authentication methods:

- AppRole configuration
- LDAP integration
- AWS IAM authentication
- Kubernetes authentication

### Vault Secrets Module

Manages secret engines:

- KV v2 configuration
- AWS secret engine
- Database secret engine
- PKI certificate management
- Transit encryption

## 🔄 Vault-Consul Integration

### Dynamic Token Generation

Vault can generate dynamic Consul tokens for:

- Terraform state management
- Application service discovery
- Monitoring and observability
- Backup operations

### Configuration

```hcl
# Consul Secret Engine
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

## 📊 Monitoring

### Health Checks

- Vault server health
- Secret engine status
- Authentication method status
- Policy compliance

### Metrics

- Authentication attempts
- Secret access patterns
- Policy violations
- Performance metrics

## 🔄 Backup and Recovery

### Automated Backups

- Daily snapshots
- Encrypted storage
- Retention policies
- Cross-site replication

### Disaster Recovery

- Emergency policies
- Token recovery
- Secret restoration
- Service recovery

## 🚨 Security Best Practices

### Token Management

- Short-lived tokens
- Automatic rotation
- Audit logging
- Access monitoring

### Secret Management

- Encryption at rest
- Access controls
- Audit trails
- Compliance reporting

### Network Security

- TLS encryption
- Network segmentation
- Firewall rules
- VPN access

## 📚 Documentation

### Additional Resources

- [Vault Documentation](https://www.vaultproject.io/docs)
- [Terraform Vault Provider](https://registry.terraform.io/providers/hashicorp/vault/latest)
- [Vault Best Practices](https://learn.hashicorp.com/vault)

### Support

- GitHub Issues
- HashiCorp Community
- Professional Support

## 🎯 Next Steps

1. **Deploy Vault Management**: Configure policies and auth methods
2. **Integrate with Consul**: Set up dynamic token generation
3. **Configure Secret Engines**: Enable AWS, Database, PKI
4. **Set up Monitoring**: Configure health checks and metrics
5. **Implement Backup**: Configure automated backups
6. **Test Integration**: Verify all components work together

---

**Note**: This configuration is designed for production use with proper security measures. Always review and test in a non-production environment first.
