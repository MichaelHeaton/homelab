# Homelab GitOps

A comprehensive homelab setup using GitOps principles, Terraform, and modern DevOps practices.

## 🏗️ Architecture

- **Infrastructure**: 3-node Proxmox cluster
- **IaC**: Terraform (primary), Ansible (configuration)
- **CI/CD**: Jenkins for GitOps deployments
- **Storage**: NFS shares on UNAS
- **Networking**: UniFi managed network

## 🚀 Quick Start

1. Clone this repository
2. Review the [ROADMAP.md](ROADMAP.md) for planned services
3. Start with the Plex stack (see `stacks/media/`)

## 📁 Repository Structure

```
homelab/
├── stacks/           # Service stack definitions
├── terraform/        # Infrastructure as Code
├── ansible/          # Configuration management
├── jenkins/          # CI/CD pipelines
├── docs/             # Documentation
└── scripts/          # Utility scripts
```

## 🎯 Current Focus

**Plex Stack** - Media server with GPU transcoding and NFS storage

## 📚 Learning Goals

This homelab is designed for learning GitOps, Terraform, and modern infrastructure practices. Each component includes educational documentation.

## 🔧 Prerequisites

- Proxmox cluster (3 nodes)
- UNAS for NFS storage
- UniFi network infrastructure
- Jenkins for CI/CD
- GitHub for source control

## 📖 Documentation

- [Roadmap](ROADMAP.md) - Complete service planning
- [Architecture](docs/architecture.md) - Technical architecture
- [Deployment Guide](docs/deployment.md) - Step-by-step setup
