# Homelab GitOps Roadmap

## Overview

This homelab is designed using GitOps principles with Terraform as the primary IaC tool, supplemented by Ansible and Python when needed. The infrastructure runs on a 3-node Proxmox cluster with Jenkins handling deployments.

## Architecture Principles

- **GitOps First**: All infrastructure and application changes through Git
- **Terraform Default**: Infrastructure as Code with Terraform
- **Stack-based Organization**: Services grouped by function for easier management
- **Learning Focus**: Each component explained for educational purposes

## Service Stacks

### 🎬 Streaming Stack

**Priority: High | Status: Planning**

- **Plex** - Media server with GPU transcoding
- **Tautulli** - Plex analytics and monitoring
- **Storage**: NFS share on UNAS
- **GPU**: Hardware transcoding on Proxmox host

### 📥 Download Stack

**Priority: High | Status: Planning**

- **Overseerr** - Media request management
- **Sonarr** - TV show automation
- **Radarr** - Movie automation
- **Prowlarr** - Indexer management
- **Bazarr** - Subtitle management
- **Readarr** - Book automation
- **Whisper** - Audio transcription
- **Lidarr** - Music automation
- **Downloaders**:
  - Sabnzbd (NZB)
  - Torrent client
- **NzbHydra2** - NZB indexer aggregator
- **Offline Transcoding** - Pre-transcode media for optimal Plex performance

### 🎮 Game Server Stack

**Priority: Medium | Status: Planning**

- **Minecraft** - Game server hosting

### 📸 Media Stack

**Priority: Medium | Status: Planning**

- **Family Photos** - Photo management and sharing
- **GoPro Content** - Action camera media management
- **Photo Organization** - Automated photo sorting and tagging
- **Backup and Sync** - Photo backup and family sharing

### 🏭 Image Factory Stack

**Priority: Critical | Status: Planning**

- **VM Templates** - Standardized VM images for all services
- **Docker Images** - Container image building and distribution
- **Automated Builds** - CI/CD for image creation
- **Version Control** - Image versioning and rollback

### 📊 Monitoring Stack

**Priority: High | Status: Planning**

- **Dashboard** - Central monitoring dashboard
- **Log Aggregation** - Centralized logging
- **System Monitoring** - Infrastructure health
- **SAS Monitoring** - Service availability monitoring

### 🏗️ Infrastructure Stack

**Priority: Critical | Status: Planning**

- **UniFi** - Network management
- **Synology DSM** - NAS management
- **Proxmox** - Hypervisor management
- **UPS CyberPower** - Power management
- **DNS** - Internal DNS resolution
- **K3s/K8s** - Container orchestration
- **CloudFlare** - External DNS and security

### 🏠 Dashboard Stack

**Priority: Medium | Status: Planning**

- **Homepage** - Admin and family dashboards per site

### 🔒 Security Stack

**Priority: Critical | Status: Planning**

- **Hashicorp Vault Cluster** - Secrets management and PKI
- **SSL & Cert Management** - Automated certificate lifecycle
- **Zero Trust Network** - Identity-based access control
- **Traefik Reverse Proxy** - SSL termination and routing
- **Split Brain DNS** - Internal/external DNS resolution
- **Teleport** - Secure access and session recording
- **SSO Authentication** - Identity provider integration
- **VPN** - Site-to-site and device-to-site
- **Ad Blocking** - Network-level ad filtering

### 🤖 IoT Stack

**Priority: Low | Status: Planning**

- IoT device management and automation

### 🧠 AI Stack

**Priority: Low | Status: Planning**

- AI/ML services and tools

### 🗄️ Database Stack

**Priority: High | Status: Planning**

- **PostgreSQL** - Primary database

### 💾 Backup and Recovery Stack

**Priority: Critical | Status: Planning**

- **NAS Backup**:
  - Synology backup
  - UNAS backup
- **Proxmox Backup** - VM and container backup

### 🔄 GitOps Stack

**Priority: Critical | Status: Planning**

- **Jenkins** - CI/CD pipeline
- **Consul** - Service discovery
- **GitHub** - Source control
- **Ansible** - Configuration management
- **Ticketing System** - Issue tracking

### 🛠️ Utility Stack

**Priority: Low | Status: Planning**

- **it-tools** - IT utilities
- **Stash** - Code repository
- **Web IDE** - Cursor AI on VM
- **Unknown services** - Additional tools as needed

## Repository Structure

```
homelab/
├── stacks/                    # Service stack definitions
│   ├── media/                 # Plex, Tautulli
│   ├── download/              # Sonarr, Radarr, etc.
│   ├── monitoring/            # Dashboards, logging
│   ├── infrastructure/        # Core infrastructure
│   └── security/              # Security services
├── terraform/                 # Terraform configurations
│   ├── modules/               # Reusable Terraform modules
│   ├── environments/          # Environment-specific configs
│   └── providers/             # Provider configurations
├── ansible/                   # Ansible playbooks
├── jenkins/                   # Jenkins pipeline definitions
├── docs/                      # Documentation
└── scripts/                   # Utility scripts
```

## Deployment Strategy

1. **Infrastructure First**: Core infrastructure (Proxmox, networking)
2. **Security Foundation**: SSL, VPN, secrets management
3. **Monitoring**: Observability before applications
4. **Media Services**: Plex and download automation
5. **Additional Stacks**: Based on priority and learning goals

## Learning Objectives

- GitOps workflow mastery
- Terraform best practices
- Proxmox automation
- Container orchestration
- Network security
- Monitoring and observability
