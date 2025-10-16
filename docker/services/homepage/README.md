# Homepage Docker Service

This directory contains the Docker Compose configuration for Homepage dashboard service.

## 🏗️ Configuration

### Service Details

- **Image**: `ghcr.io/gethomepage/homepage:latest`
- **Containers**: `homepage-admin`, `homepage-family`
- **Network**: `ingress-internal` + `vlan5_macvlan` (family only)
- **Restart Policy**: `unless-stopped`

### Purpose

Homepage provides a beautiful, customizable dashboard for managing homelab services with separate admin and family views.

## 🌐 Networking

### Admin Dashboard

- **URL**: `https://admin.specterrealm.com`
- **Purpose**: Full administrative access to all services
- **Network**: `ingress-internal` only
- **Security**: Enhanced rate limiting and security headers

### Family Dashboard

- **URL**: `https://home.specterrealm.com`
- **Purpose**: Family-friendly view with limited services
- **Network**: `ingress-internal` + `vlan5_macvlan`
- **Security**: Standard rate limiting and security headers

### SSL/TLS Configuration

- **Certificate Resolver**: Cloudflare DNS challenge
- **TLS**: Automatic certificate management
- **Security Headers**: Custom middleware for enhanced security

## 🔧 Features

### Dashboard Customization

- **Service Groups**: Organize services by category
- **Custom Icons**: Personalize service appearance
- **Widgets**: Weather, system stats, and more
- **Themes**: Light and dark mode support
- **Responsive**: Mobile-friendly design

### Service Integration

- **Automatic Discovery**: Service health monitoring
- **Status Indicators**: Real-time service status
- **Quick Access**: Direct links to services
- **Service Information**: Descriptions and documentation

### Multi-User Support

- **Admin View**: Full access to all services
- **Family View**: Curated selection of services
- **Customizable**: Different layouts per user
- **Access Control**: Role-based service visibility

## 📁 Volumes

### Required Volumes

- **Admin Config**: `/volume1/docker/homepage/dashboards/admin:/app/config`
- **Family Config**: `/volume1/docker/homepage/dashboards/family:/app/config`
- **Assets**: `/volume1/docker/homepage/assets:/app/public/images:ro`

### Directory Structure

```
/volume1/docker/homepage/
├── dashboards/
│   ├── admin/
│   │   ├── services.yaml      # Admin service configuration
│   │   ├── settings.yaml      # Admin dashboard settings
│   │   └── widgets.yaml       # Admin widgets
│   └── family/
│       ├── services.yaml      # Family service configuration
│       ├── settings.yaml      # Family dashboard settings
│       └── widgets.yaml       # Family widgets
└── assets/
    ├── icons/                 # Custom service icons
    └── images/               # Dashboard images
```

## 🚀 Usage

### Start Homepage

```bash
# From the docker/services/homepage directory
docker-compose up -d
```

### Stop Homepage

```bash
# From the docker/services/homepage directory
docker-compose down
```

### View Logs

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f homepage-admin
docker-compose logs -f homepage-family
```

### Restart Services

```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart homepage-admin
```

## 🔐 Security

### Access Control

- **Admin Dashboard**: Enhanced security headers and rate limiting
- **Family Dashboard**: Standard security with family-friendly access
- **HTTPS Only**: All external access via HTTPS
- **Network Isolation**: Admin on internal network only

### Middleware Configuration

- **Security Headers**: Custom security middleware
- **Rate Limiting**: Different limits for admin vs family
- **TLS Termination**: Handled by Traefik
- **Network Segmentation**: Admin isolated from external network

## 📊 Configuration

### Service Configuration

Each dashboard requires a `services.yaml` file:

```yaml
- Plex:
    href: https://plex.specterrealm.com
    description: Media server
    icon: plex.png
    status: https://plex.specterrealm.com/status
    ping: https://plex.specterrealm.com/ping
```

### Settings Configuration

Each dashboard requires a `settings.yaml` file:

```yaml
title: "SpecterRealm Homelab"
subtitle: "Admin Dashboard"
theme: "dark"
language: "en"
```

### Widget Configuration

Each dashboard can have a `widgets.yaml` file:

```yaml
- system:
    host: "homelab-server"
    cpu: true
    memory: true
    disk: true
    network: true
```

## 🚨 Troubleshooting

### Common Issues

1. **Dashboard Not Loading**: Check Traefik configuration
2. **Services Not Showing**: Verify service configuration files
3. **Icons Missing**: Check assets directory permissions
4. **Network Issues**: Verify Docker network configuration

### Debug Commands

```bash
# Check container status
docker-compose ps

# Check logs
docker-compose logs homepage-admin
docker-compose logs homepage-family

# Test service access
curl -k https://admin.specterrealm.com
curl -k https://home.specterrealm.com

# Check configuration files
ls -la /volume1/docker/homepage/dashboards/
```

### Configuration Validation

```bash
# Validate YAML configuration
docker exec homepage-admin yaml-lint /app/config/services.yaml
docker exec homepage-family yaml-lint /app/config/services.yaml

# Check file permissions
ls -la /volume1/docker/homepage/
```

## 📚 Documentation

### Additional Resources

- [Homepage Documentation](https://gethomepage.dev/)
- [Service Configuration](https://gethomepage.dev/docs/services/)
- [Widget Configuration](https://gethomepage.dev/docs/widgets/)
- [Customization Guide](https://gethomepage.dev/docs/customization/)

### Configuration Examples

- **Basic Services**: Simple service links
- **Service Groups**: Organized service categories
- **Custom Widgets**: System monitoring and weather
- **Themes**: Custom styling and appearance

## 🎯 Best Practices

### Security

- Use HTTPS for all external access
- Implement proper rate limiting
- Regular security updates
- Monitor access logs

### Performance

- Optimize service configuration
- Use appropriate caching
- Monitor resource usage
- Regular maintenance

### User Experience

- Organize services logically
- Use descriptive names and icons
- Provide helpful descriptions
- Regular updates and improvements

---

**Note**: This configuration provides separate admin and family dashboards with appropriate security measures. Always review and test configurations before deploying to production.
