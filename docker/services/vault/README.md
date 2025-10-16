# Vault Docker Service

This directory contains the Docker Compose configuration for the Vault server.

## Files

- `docker-compose.yml` - Main Vault server configuration
- `README.md` - This documentation

## Configuration

### Service Details

- **Image**: `hashicorp/vault:1.17`
- **Container Name**: `vault`
- **Restart Policy**: `unless-stopped`
- **Network**: `ingress-internal`

### Environment Variables

- `VAULT_API_ADDR`: `https://vault.specterrealm.com`
- `VAULT_CLUSTER_ADDR`: `https://vault.specterrealm.com:8201`

### Volumes

- **Config**: `/volume1/docker/vault/config:/vault/config`
- **Data**: `/volume1/docker/vault/data:/vault/file`
- **TLS**: `/volume1/docker/vault/tls:/vault/tls:ro`

### Traefik Labels

- **Router**: `vault.specterrealm.com`
- **Entrypoint**: `websecure`
- **TLS**: Cloudflare resolver

## Usage

### Start Vault

```bash
cd /Users/michaelheaton/Documents/GitHub/homelab/docker/services/vault
docker-compose up -d
```

### Stop Vault

```bash
docker-compose down
```

### View Logs

```bash
docker-compose logs -f vault
```

### Check Status

```bash
docker-compose ps
```

## Configuration History

### Fixed Issues

- **Cluster Address**: Changed from `https://vault:8201` to `https://vault.specterrealm.com:8201`
- **API Address**: Set to `https://vault.specterrealm.com`
- **Network**: Using `ingress-internal` for Traefik integration

### Previous Issues

- ❌ **Old**: `VAULT_CLUSTER_ADDR: https://vault:8201` (internal DNS)
- ✅ **Fixed**: `VAULT_CLUSTER_ADDR: https://vault.specterrealm.com:8201` (external DNS)

## Security Notes

- Vault data is stored on Synology NAS with RAID 5 protection
- TLS certificates are mounted read-only
- Container runs with `IPC_LOCK` capability for memory locking
- No sensitive data in environment variables

## Troubleshooting

### Common Issues

1. **Cluster address mismatch**: Verify `VAULT_CLUSTER_ADDR` matches external DNS
2. **TLS issues**: Check certificate paths and validity
3. **Storage issues**: Verify NAS mount points and permissions
4. **Network issues**: Check Traefik network configuration

### Debug Commands

```bash
# Check container status
docker ps | grep vault

# View detailed logs
docker logs vault

# Check network connectivity
docker network inspect ingress-internal

# Validate configuration
docker-compose config
```
