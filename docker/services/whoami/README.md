# Whoami Docker Service

This directory contains the Docker Compose configuration for the whoami test service.

## 🏗️ Configuration

### Service Details

- **Image**: `traefik/whoami:v1.10`
- **Container**: `whoami`
- **Network**: `ingress-internal`
- **Restart Policy**: `unless-stopped`

### Purpose

The whoami service is a simple HTTP service that returns information about the request, making it perfect for testing Traefik configuration and routing.

## 🌐 Networking

### Traefik Integration

- **URL**: `https://whoami.specterrealm.com`
- **HTTP Redirect**: Automatic HTTP → HTTPS redirect
- **SSL/TLS**: Automatic certificate management via Cloudflare
- **Load Balancer**: Single instance on port 80

### Network Configuration

- **No Host Ports**: Access only through Traefik
- **No MacVLAN**: Uses internal Docker network
- **Traefik Network**: `ingress-internal` for service communication

## 🔧 Features

### Request Information

The whoami service returns detailed information about each request:

- **Client IP**: Source IP address
- **Headers**: All HTTP headers
- **Host**: Requested hostname
- **Method**: HTTP method (GET, POST, etc.)
- **Path**: Requested path
- **Protocol**: HTTP/HTTPS version
- **Query**: URL query parameters

### Use Cases

- **Traefik Testing**: Validate reverse proxy configuration
- **SSL/TLS Testing**: Check certificate management
- **Load Balancing**: Test traffic distribution
- **Debugging**: Troubleshoot routing issues
- **Health Checks**: Verify service availability

## 🚀 Usage

### Start Whoami

```bash
# From the docker/services/whoami directory
docker-compose up -d
```

### Stop Whoami

```bash
# From the docker/services/whoami directory
docker-compose down
```

### View Logs

```bash
# From the docker/services/whoami directory
docker-compose logs -f whoami
```

### Test Service

```bash
# Test HTTPS access
curl -k https://whoami.specterrealm.com

# Test HTTP redirect
curl -L http://whoami.specterrealm.com
```

## 📊 Monitoring

### Health Checks

- **Service Status**: Container health
- **Traefik Integration**: Automatic service discovery
- **SSL/TLS**: Certificate validation
- **HTTP/HTTPS**: Protocol handling

### Response Information

The service provides comprehensive request details:

```json
{
  "Hostname": "whoami-container",
  "IP": "172.16.5.10",
  "Port": "80",
  "Headers": {
    "Accept": "*/*",
    "User-Agent": "curl/7.68.0",
    "X-Forwarded-For": "192.168.1.100",
    "X-Forwarded-Proto": "https"
  },
  "Method": "GET",
  "Path": "/",
  "Query": "",
  "Protocol": "HTTP/1.1"
}
```

## 🔐 Security

### Access Control

- **HTTPS Only**: All external access via HTTPS
- **Internal Network**: No direct external access
- **Traefik Protection**: Reverse proxy security

### Network Security

- **No Port Exposure**: No host ports exposed
- **Internal Communication**: Uses Docker internal network
- **TLS Termination**: Handled by Traefik

## 🚨 Troubleshooting

### Common Issues

1. **Service Not Accessible**: Check Traefik configuration
2. **SSL/TLS Issues**: Verify certificate management
3. **HTTP Redirect**: Check Traefik middleware configuration
4. **Network Issues**: Verify Docker network configuration

### Debug Commands

```bash
# Check container status
docker-compose ps

# Check logs
docker-compose logs whoami

# Test service directly
docker exec whoami curl localhost:80

# Check Traefik service discovery
curl -s https://traefik-internal.specterrealm.com/api/http/services
```

### Validation Steps

1. **Container Status**: Verify whoami is running
2. **Traefik Discovery**: Check service registration
3. **SSL Certificate**: Verify certificate validity
4. **HTTP Redirect**: Test redirect functionality
5. **Response Data**: Validate request information

## 📚 Documentation

### Additional Resources

- [Traefik Whoami](https://github.com/traefik/whoami)
- [Traefik Docker Provider](https://doc.traefik.io/traefik/providers/docker/)
- [Traefik Middleware](https://doc.traefik.io/traefik/middlewares/overview/)

### Configuration Examples

- **Basic Service**: Simple HTTP/HTTPS routing
- **Custom Headers**: Add custom response headers
- **Load Balancing**: Multiple whoami instances
- **Middleware**: Custom request/response processing

## 🎯 Best Practices

### Testing

- Use whoami for all Traefik configuration testing
- Validate SSL/TLS certificate management
- Test HTTP → HTTPS redirects
- Verify load balancing behavior

### Development

- Deploy whoami before other services
- Use as a health check endpoint
- Monitor request patterns and headers
- Test different routing scenarios

### Production

- Replace with actual services after testing
- Use for debugging production issues
- Monitor service performance
- Implement proper logging

---

**Note**: This is a test service for development and debugging. Replace with actual services in production environments.
