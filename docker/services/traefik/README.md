# Traefik Docker Service

This directory contains the Docker Compose configuration for Traefik reverse proxy and load balancer.

## 🏗️ Configuration

### Service Details
- **Image**: `traefik:v3.1`
- **Container**: `traefik`
- **Network**: `vlan5_macvlan` (172.16.5.9) + `ingress-internal`
- **Restart Policy**: `unless-stopped`

### Networks
- **vlan5_macvlan**: External network with static IP 172.16.5.9
- **ingress-internal**: Internal Docker network for service communication

### Environment Variables
- `CLOUDFLARE_DNS_API_TOKEN`: Cloudflare API token for DNS challenges
- `TRAEFIK_TIMEZONE`: Timezone configuration
- `TRAEFIK_API_USER`: Basic auth username for dashboard
- `TRAEFIK_API_HASH`: Basic auth password hash for dashboard

## 🌐 Networking

### Static IP Configuration
- **IP Address**: 172.16.5.9 (vlan5_macvlan network)
- **Dual Network**: Both external and internal network access
- **Ports**: 80 (HTTP), 443 (HTTPS)

### SSL/TLS Configuration
- **Certificate Resolver**: Cloudflare DNS challenge
- **ACME Storage**: `/letsencrypt/acme.json`
- **Email**: admin@specterrealm.com
- **Provider**: Cloudflare DNS

## 🔧 Features

### Reverse Proxy
- **Docker Provider**: Automatic service discovery
- **File Provider**: Dynamic configuration from files
- **Network**: `ingress-internal` for service communication
- **Exposed by Default**: Disabled (security)

### Entry Points
- **Web**: Port 80 (HTTP)
- **WebSecure**: Port 443 (HTTPS)
- **Global Redirect**: HTTP → HTTPS for all services

### Dashboard
- **URL**: `https://traefik-internal.specterrealm.com`
- **Authentication**: Basic auth required
- **Access Control**: LAN IP whitelist (172.16.0.0/12, 10.0.0.0/8)
- **API**: Enabled for monitoring

## 📁 Volumes

### Required Volumes
- **Docker Socket**: `/var/run/docker.sock:/var/run/docker.sock:ro`
- **ACME Storage**: `/volume1/docker/traefik/acme:/letsencrypt`
- **Dynamic Config**: `/volume1/docker/traefik/dynamic:/etc/traefik/dynamic:ro`

### Directory Structure
```
/volume1/docker/traefik/
├── acme/
│   └── acme.json          # ACME certificates storage
└── dynamic/
    ├── traefik.yml        # Dynamic configuration
    └── middleware.yml     # Custom middleware
```

## 🚀 Usage

### Start Traefik
```bash
# From the docker/services/traefik directory
docker-compose up -d
```

### Stop Traefik
```bash
# From the docker/services/traefik directory
docker-compose down
```

### View Logs
```bash
# From the docker/services/traefik directory
docker-compose logs -f traefik
```

### Restart Traefik
```bash
# From the docker/services/traefik directory
docker-compose restart traefik
```

## 🔐 Security

### Access Control
- **Dashboard**: Basic authentication required
- **IP Whitelist**: Restricted to internal networks
- **HTTPS Only**: All external access via HTTPS
- **Docker Socket**: Read-only access

### Network Security
- **Static IP**: Fixed IP address for consistent routing
- **Dual Network**: Isolated internal communication
- **TLS Termination**: Handles SSL/TLS for all services

## 📊 Monitoring

### Health Checks
- **Ping Endpoint**: Built-in health check
- **Dashboard**: Real-time service status
- **API**: Programmatic access to metrics

### Metrics
- **Service Discovery**: Automatic service registration
- **Load Balancing**: Traffic distribution
- **SSL/TLS**: Certificate management
- **Performance**: Request/response metrics

## 🔄 Service Integration

### Automatic Discovery
Traefik automatically discovers services with these labels:
```yaml
labels:
  - traefik.enable=true
  - traefik.http.routers.service-name.rule=Host(`service.domain.com`)
  - traefik.http.routers.service-name.entrypoints=websecure
  - traefik.http.routers.service-name.tls.certresolver=cf
```

### Common Patterns
- **HTTPS Redirect**: Automatic HTTP → HTTPS
- **SSL/TLS**: Automatic certificate management
- **Load Balancing**: Multiple service instances
- **Middleware**: Custom request/response processing

## 🚨 Troubleshooting

### Common Issues
1. **Certificate Issues**: Check Cloudflare API token
2. **Service Discovery**: Verify Docker network configuration
3. **Dashboard Access**: Check basic auth credentials
4. **SSL/TLS**: Verify DNS configuration

### Debug Commands
```bash
# Check container status
docker-compose ps

# Check logs
docker-compose logs traefik

# Check network configuration
docker network ls | grep vlan5_macvlan
docker network ls | grep ingress-internal

# Check Traefik configuration
docker exec traefik traefik version
docker exec traefik traefik api --help
```

### Configuration Validation
```bash
# Validate Traefik configuration
docker exec traefik traefik config --help

# Check service discovery
curl -s https://traefik-internal.specterrealm.com/api/http/services
```

## 📚 Documentation

### Additional Resources
- [Traefik Documentation](https://doc.traefik.io/traefik/)
- [Docker Provider](https://doc.traefik.io/traefik/providers/docker/)
- [Cloudflare Provider](https://doc.traefik.io/traefik/https/acme/#dnschallenge)
- [Middleware](https://doc.traefik.io/traefik/middlewares/overview/)

### Configuration Examples
- **Basic Service**: Simple HTTP/HTTPS routing
- **Authentication**: Basic auth and OAuth
- **Load Balancing**: Multiple backend services
- **Middleware**: Request/response processing

## 🎯 Best Practices

### Security
- Use HTTPS for all external services
- Implement proper authentication
- Restrict dashboard access to internal networks
- Regular certificate renewal monitoring

### Performance
- Enable HTTP/2 and HTTP/3
- Use appropriate load balancing strategies
- Monitor service health and performance
- Implement proper caching strategies

### Maintenance
- Regular Traefik updates
- Certificate monitoring
- Service discovery validation
- Performance monitoring

---

**Note**: This configuration is designed for production use with proper security measures. Always review and test in a non-production environment first.
