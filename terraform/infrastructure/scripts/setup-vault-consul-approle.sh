#!/bin/bash

# Setup Vault-Consul AppRole Integration
# This script configures Vault to generate dynamic Consul tokens for Terraform

set -e

# Configuration
VAULT_ADDR="https://vault.specterrealm.com"
CONSUL_ADDRESS="consul.specterrealm.com:443"
CONSUL_SCHEME="https"

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
    echo "║                Vault-Consul AppRole Setup                  ║"
    echo "║                                                              ║"
    echo "║  🔐 Dynamic token generation                                ║"
    echo "║  🔒 Secure authentication                                   ║"
    echo "║  📊 Audit trail in Vault                                    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
}

# Check Vault connection
check_vault_connection() {
    print_status "step" "Checking Vault connection..."

    if vault status >/dev/null 2>&1; then
        print_status "success" "Vault connection successful"
    else
        print_status "error" "Cannot connect to Vault at $VAULT_ADDR"
        exit 1
    fi
}

# Enable Consul secret engine
enable_consul_secret_engine() {
    print_status "step" "Enabling Consul secret engine..."

    if vault secrets list | grep -q "consul/"; then
        print_status "info" "Consul secret engine already enabled"
    else
        if vault secrets enable -path=consul consul; then
            print_status "success" "Consul secret engine enabled"
        else
            print_status "error" "Failed to enable Consul secret engine"
            exit 1
        fi
    fi
}

# Configure Consul access
configure_consul_access() {
    print_status "step" "Configuring Consul access..."

    print_status "info" "Please provide your Consul management token:"
    read -s CONSUL_MANAGEMENT_TOKEN
    echo ""

    if vault write consul/config/access \
        address="$CONSUL_ADDRESS" \
        scheme="$CONSUL_SCHEME" \
        token="$CONSUL_MANAGEMENT_TOKEN"; then
        print_status "success" "Consul access configured"
    else
        print_status "error" "Failed to configure Consul access"
        exit 1
    fi
}

# Create Consul ACL policy
create_consul_policy() {
    print_status "step" "Creating Consul ACL policy..."

    if vault write consul/policy/terraform-state \
        rules='key "terraform/state" {
  policy = "write"
}

key "terraform/state/*" {
  policy = "write"
}

session "terraform" {
  policy = "write"
}'; then
        print_status "success" "Consul ACL policy created"
    else
        print_status "error" "Failed to create Consul ACL policy"
        exit 1
    fi
}

# Create AppRole
create_approle() {
    print_status "step" "Creating AppRole..."

    if vault write auth/approle/role/terraform \
        token_policies="consul-terraform" \
        token_ttl=1h \
        token_max_ttl=4h \
        bind_secret_id=true; then
        print_status "success" "AppRole created"
    else
        print_status "error" "Failed to create AppRole"
        exit 1
    fi
}

# Get credentials
get_credentials() {
    print_status "step" "Getting AppRole credentials..."

    ROLE_ID=$(vault read -field=role_id auth/approle/role/terraform/role-id)
    SECRET_ID=$(vault write -field=secret_id -f auth/approle/role/terraform/secret-id)

    print_status "success" "AppRole credentials obtained"
    echo ""
    print_status "info" "Role ID: $ROLE_ID"
    print_status "info" "Secret ID: $SECRET_ID"
    echo ""
    print_status "info" "Save these credentials for Terraform configuration"

    # Save credentials to file
    cat > approle-credentials.txt << EOF
# Vault AppRole Credentials for Terraform
# Generated: $(date)

ROLE_ID=$ROLE_ID
SECRET_ID=$SECRET_ID

# Use these in your Terraform configuration
export TF_VAR_vault_role_id="$ROLE_ID"
export TF_VAR_vault_secret_id="$SECRET_ID"
EOF

    print_status "success" "Credentials saved to approle-credentials.txt"
}

# Test the setup
test_setup() {
    print_status "step" "Testing Vault-Consul integration..."

    # Test token generation
    if vault write -field=token consul/creds/terraform-state >/dev/null 2>&1; then
        print_status "success" "Consul token generation successful"
    else
        print_status "error" "Consul token generation failed"
        exit 1
    fi
}

# Display summary
display_summary() {
    print_status "success" "Vault-Consul AppRole setup completed!"
    echo ""
    print_status "info" "Configuration Summary:"
    echo "  🔐 Vault Address: $VAULT_ADDR"
    echo "  🏠 Consul Address: $CONSUL_ADDRESS"
    echo "  🔑 AppRole: terraform"
    echo "  ⏰ Token TTL: 1 hour (max 4 hours)"
    echo ""
    print_status "info" "Next Steps:"
    echo "  1. Configure Terraform with AppRole credentials"
    echo "  2. Test Terraform with dynamic Consul tokens"
    echo "  3. Deploy your infrastructure"
    echo "  4. Get Plex back online! 🎬"
    echo ""
    print_status "info" "Benefits:"
    echo "  ✅ Dynamic token generation"
    echo "  ✅ Secure authentication"
    echo "  ✅ Audit trail in Vault"
    echo "  ✅ Automatic token rotation"
    echo ""
}

# Main function
main() {
    display_banner

    check_vault_connection
    enable_consul_secret_engine
    configure_consul_access
    create_consul_policy
    create_approle
    get_credentials
    test_setup
    display_summary
}

# Run main function
main
