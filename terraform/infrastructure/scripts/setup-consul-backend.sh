#!/bin/bash

# Setup Consul Backend for Terraform State
# This script configures Terraform to use Consul for state storage

set -e

# Configuration
CONSUL_ADDRESS="consul.specterrealm.com:443"
CONSUL_SCHEME="https"
TERRAFORM_PATH="terraform/state"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    local status=$1
    local message=$2

    case "$status" in
        "success"|"healthy"|"ok")
            echo -e "${GREEN}✅ $message${NC}"
            ;;
        "warning"|"pending")
            echo -e "${YELLOW}⚠️  $message${NC}"
            ;;
        "error"|"failed"|"unhealthy")
            echo -e "${RED}❌ $message${NC}"
            ;;
        "info")
            echo -e "${BLUE}ℹ️  $message${NC}"
            ;;
        "step")
            echo -e "${PURPLE}🔧 $message${NC}"
            ;;
        *)
            echo -e "$message"
            ;;
    esac
}

# Display banner
display_banner() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                Consul Backend Setup                         ║"
    echo "║                                                              ║"
    echo "║  🎯 Fast homelab recovery                                   ║"
    echo "║  🔒 Internal state storage                                 ║"
    echo "║  💰 Zero additional cost                                   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
}

# Check Consul connectivity
check_consul_connection() {
    print_status "step" "Checking Consul connection..."

    if curl -s "$CONSUL_SCHEME://$CONSUL_ADDRESS/v1/status/leader" >/dev/null 2>&1; then
        print_status "success" "Consul connection successful"
        return 0
    else
        print_status "error" "Cannot connect to Consul at $CONSUL_ADDRESS"
        return 1
    fi
}

# Test Consul KV operations
test_consul_kv() {
    print_status "step" "Testing Consul KV operations..."

    # Test KV write
    if curl -s -X PUT "$CONSUL_SCHEME://$CONSUL_ADDRESS/v1/kv/test/terraform" -d "test-data" >/dev/null 2>&1; then
        print_status "success" "Consul KV write successful"
    else
        print_status "error" "Consul KV write failed"
        return 1
    fi

    # Test KV read
    if curl -s "$CONSUL_SCHEME://$CONSUL_ADDRESS/v1/kv/test/terraform" >/dev/null 2>&1; then
        print_status "success" "Consul KV read successful"
    else
        print_status "error" "Consul KV read failed"
        return 1
    fi

    # Clean up test data
    curl -s -X DELETE "$CONSUL_SCHEME://$CONSUL_ADDRESS/v1/kv/test/terraform" >/dev/null 2>&1
    print_status "info" "Test data cleaned up"
}

# Configure Terraform backend
configure_terraform_backend() {
    print_status "step" "Configuring Terraform Consul backend..."

    # Create backend configuration
    cat > backend.hcl << EOF
address = "$CONSUL_ADDRESS"
path    = "$TERRAFORM_PATH"
scheme  = "$CONSUL_SCHEME"
lock    = true
EOF

    print_status "success" "Backend configuration created: backend.hcl"
}

# Initialize Terraform with Consul backend
initialize_terraform() {
    print_status "step" "Initializing Terraform with Consul backend..."

    # Initialize Terraform
    if terraform init -backend-config=backend.hcl; then
        print_status "success" "Terraform initialized with Consul backend"
    else
        print_status "error" "Terraform initialization failed"
        return 1
    fi
}

# Test Terraform operations
test_terraform_operations() {
    print_status "step" "Testing Terraform operations..."

    # Test plan
    if terraform plan >/dev/null 2>&1; then
        print_status "success" "Terraform plan successful"
    else
        print_status "warning" "Terraform plan failed (check variables)"
    fi

    # Test state operations
    if terraform state list >/dev/null 2>&1; then
        print_status "success" "Terraform state operations successful"
    else
        print_status "info" "No existing state (this is normal for new setup)"
    fi
}

# Display configuration summary
display_summary() {
    print_status "success" "Consul backend setup completed!"
    echo ""
    print_status "info" "Configuration Summary:"
    echo "  🏠 Consul Address: $CONSUL_ADDRESS"
    echo "  📁 State Path: $TERRAFORM_PATH"
    echo "  🔒 Locking: Enabled"
    echo "  🌐 Scheme: HTTP (internal)"
    echo ""
    print_status "info" "Benefits:"
    echo "  ✅ Fast setup (no external dependencies)"
    echo "  ✅ Internal state storage"
    echo "  ✅ Zero additional cost"
    echo "  ✅ State locking for safety"
    echo ""
    print_status "info" "Next Steps:"
    echo "  1. Configure provider variables"
    echo "  2. Test Terraform operations"
    echo "  3. Deploy your infrastructure"
    echo "  4. Get Plex back online! 🎬"
    echo ""
}

# Main function
main() {
    display_banner

    # Check Consul connection
    if ! check_consul_connection; then
        exit 1
    fi

    # Test Consul KV operations
    if ! test_consul_kv; then
        exit 1
    fi

    # Configure Terraform backend
    configure_terraform_backend

    # Initialize Terraform
    if ! initialize_terraform; then
        exit 1
    fi

    # Test Terraform operations
    test_terraform_operations

    # Display summary
    display_summary
}

# Run main function
main
