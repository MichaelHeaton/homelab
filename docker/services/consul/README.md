# Consul Docker Service

This directory contains the Docker Compose configuration for HashiCorp Consul.

## 🏗️ Configuration

### Service Details
- **Image**: `hashicorp/consul:1.17`
- **Container**: `consul`
- **Network**: `ingress-internal`
- **Restart Policy**: `unless-stopped`

### Volumes
- **Config**: `/volume1/docker/consul/config:/consul/config:ro`
- **Data**: `/volume1/docker/consul/data:/consul/data`
- **Secrets**: `/volume1/docker/consul/secrets/ui-admin:/run/secrets/consul_ui_admin:ro`

### Environment Variables
- `SKIP_CHOWN: "true"` - Skip ownership changes
- `CONSUL_HTTP_TOKEN_FILE: "/run/secrets/consul_ui_admin"` - Token file location

## 🌐 Networking

### Traefik Configuration
- **HTTPS**: `consul.specterrealm.com` with TLS
- **HTTP**: Redirect to HTTPS
- **IP Whitelist**: `172.16.0.0/12,10.0.0.0/8` (internal networks only)

### Ports
- **8500**: Consul HTTP API
- **8501**: Consul HTTPS API (via Traefik)

## 🔐 Security

### Access Control
- **IP Whitelist**: Restricted to internal networks
- **TLS**: HTTPS only via Traefik
- **Token Authentication**: Uses file-based token

### Network Security
- **Internal Network**: `ingress-internal` only
- **No External Ports**: All access via Traefik
- **TLS Termination**: Handled by Traefik

## 🚀 Usage

### Start Consul
```bash
# From the docker/services/consul directory
docker-compose up -d
```

### Stop Consul
```bash
# From the docker/services/consul directory
docker-compose down
```

### View Logs
```bash
# From the docker/services/consul directory
docker-compose logs -f consul
```

## 🔧 Configuration Files

### Required Files
- `/volume1/docker/consul/config/consul.hcl` - Consul configuration
- `/volume1/docker/consul/secrets/ui-admin` - Admin token file

### Example Consul Configuration
```hcl
# /volume1/docker/consul/config/consul.hcl
datacenter = "headquarters"
data_dir = "/consul/data"
log_level = "INFO"

# Server configuration
server = true
bootstrap_expect = 1

# UI configuration
ui_config {
  enabled = true
}

# ACL configuration
acl = {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true
}

# Network configuration
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

# Connect configuration
connect {
  enabled = true
}
```

## 📊 Monitoring

### Health Checks
- **Consul Health**: `https://consul.specterrealm.com/v1/status/leader`
- **UI Access**: `https://consul.specterrealm.com/ui`

### Logs
- **Container Logs**: `docker-compose logs -f consul`
- **Consul Logs**: Available in container at `/consul/data/logs`

## 🔄 Backup

### Data Backup
- **Data Directory**: `/volume1/docker/consul/data`
- **Config Directory**: `/volume1/docker/consul/config`
- **Secrets Directory**: `/volume1/docker/consul/secrets`

### Backup Strategy
- **Snapshots**: Use Consul snapshot API
- **Data Directory**: Backup `/volume1/docker/consul/data`
- **Configuration**: Backup `/volume1/docker/consul/config`

## 🚨 Troubleshooting

### Common Issues
1. **Token File Missing**: Ensure `/volume1/docker/consul/secrets/ui-admin` exists
2. **Config File Missing**: Ensure `/volume1/docker/consul/config/consul.hcl` exists
3. **Permission Issues**: Check file ownership and permissions
4. **Network Issues**: Verify Traefik configuration

### Debug Commands
```bash
# Check container status
docker-compose ps

# Check logs
docker-compose logs consul

# Check network
docker network ls | grep ingress-internal

# Check Traefik labels
docker inspect consul | grep -A 20 Labels
```

## 📚 Documentation

### Additional Resources
- [Consul Documentation](https://www.consul.io/docs)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [Traefik Documentation](https://doc.traefik.io/traefik/)

### Support
- GitHub Issues
- HashiCorp Community
- Professional Support
