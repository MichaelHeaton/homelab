# Docker Compose Files

This directory contains Docker Compose files for the homelab infrastructure services.

## Structure

```
docker/
├── README.md                    # This file
├── docker-compose.yml           # Main orchestration file
└── services/                    # Service-specific configurations
    ├── traefik/                 # Reverse proxy and load balancer
    ├── vault/                   # Secret management
    ├── consul/                  # Service discovery
    ├── whoami/                  # Test service for Traefik
    ├── homepage/                # Dashboard for homelab services
    └── monitoring/              # Observability stack
```

## Current Services

### Traefik (Reverse Proxy)

- **File**: `services/traefik/docker-compose.yml`
- **Description**: Reverse proxy, load balancer, and SSL termination
- **Key Features**:
  - Automatic service discovery
  - SSL/TLS certificate management
  - Load balancing and routing
  - Dashboard with authentication
  - Cloudflare DNS integration

### Vault (Secret Management)

- **File**: `services/vault/docker-compose.yml`
- **Description**: HashiCorp Vault for secret management
- **Key Features**:
  - Secure secret storage
  - Dynamic credential generation
  - Access control and policies
  - Consul integration
  - TLS configuration

### Consul (Service Discovery)

- **File**: `services/consul/docker-compose.yml`
- **Description**: HashiCorp Consul for service discovery
- **Key Features**:
  - Service registration and discovery
  - Health checking
  - Key-value storage
  - ACL management
  - Service mesh capabilities

### Whoami (Test Service)

- **File**: `services/whoami/docker-compose.yml`
- **Description**: Test service for Traefik validation
- **Key Features**:
  - HTTP request information display
  - Traefik integration testing
  - SSL/TLS validation
  - Load balancing testing
  - Debugging and troubleshooting

### Homepage (Dashboard)

- **File**: `services/homepage/docker-compose.yml`
- **Description**: Beautiful dashboard for homelab services
- **Key Features**:
  - Admin dashboard (admin.specterrealm.com)
  - Family dashboard (home.specterrealm.com)
  - Service health monitoring
  - Customizable widgets and themes
  - Multi-user support with different access levels

### Usage

#### Start All Services

```bash
cd /Users/michaelheaton/Documents/GitHub/homelab/docker
docker-compose up -d
```

#### Start Individual Services

```bash
# Start Traefik (required first)
docker-compose up -d traefik

# Start Vault
docker-compose up -d vault

# Start Consul
docker-compose up -d consul

# Start Whoami (test service)
docker-compose up -d whoami

# Start Homepage dashboards
docker-compose up -d homepage-admin homepage-family
```

#### Stop Services

```bash
# Stop all services
docker-compose down

# Stop individual service
docker-compose stop vault
```

#### View Logs

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f traefik
docker-compose logs -f vault
docker-compose logs -f consul
docker-compose logs -f whoami
docker-compose logs -f homepage-admin
docker-compose logs -f homepage-family
```

## Configuration Notes

### Vault Configuration

- **External Access**: `https://vault.specterrealm.com`
- **Cluster Address**: `https://vault.specterrealm.com:8201`
- **Storage**: `/volume1/docker/vault/` on Synology NAS
- **Network**: `ingress-internal` (Traefik network)

### Environment Variables

- `VAULT_API_ADDR`: `https://vault.specterrealm.com`
- `VAULT_CLUSTER_ADDR`: `https://vault.specterrealm.com:8201`

## Maintenance

### Adding New Services

1. Create service directory: `mkdir services/{service-name}`
2. Add Docker Compose file: `services/{service-name}/docker-compose.yml`
3. Update this README with service information
4. Document usage instructions

### Updating Existing Services

1. Update the relevant Docker Compose file
2. Test the configuration: `docker-compose config`
3. Update documentation if needed
4. Commit changes with descriptive message

## File Naming Convention

- **Service-specific**: `docker-compose-{service}.yml`
- **Environment-specific**: `docker-compose-{service}-{env}.yml`
- **Fixed versions**: `docker-compose-{service}-fixed.yml`

## Security Notes

- Never commit sensitive environment variables
- Use `.env` files for local overrides
- Document any required secrets or API keys
- Keep TLS certificates secure and up-to-date

## Troubleshooting

### Common Issues

1. **Port conflicts**: Check if ports are already in use
2. **Network issues**: Verify Traefik network configuration
3. **Storage issues**: Check NAS mount points and permissions
4. **TLS issues**: Verify certificate paths and validity

### Debug Commands

```bash
# Check service status
docker-compose ps

# View service logs
docker-compose logs {service}

# Validate configuration
docker-compose config

# Check network connectivity
docker network ls
```
