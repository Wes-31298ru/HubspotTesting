#!/bin/bash

# AWS Serverless MCP Server Setup Script
# This script helps you install AWS CLI and configure it for use with Claude Desktop

set -e

echo "======================================"
echo "AWS Serverless MCP Server Setup"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if AWS CLI is installed
check_aws_cli() {
    if command -v aws &> /dev/null; then
        AWS_VERSION=$(aws --version 2>&1 | cut -d' ' -f1 | cut -d'/' -f2)
        print_success "AWS CLI is already installed (version $AWS_VERSION)"
        return 0
    else
        print_warning "AWS CLI is not installed"
        return 1
    fi
}

# Install AWS CLI
install_aws_cli() {
    echo ""
    print_info "Installing AWS CLI v2..."

    # Detect OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Detected Linux system"

        # Download AWS CLI
        print_info "Downloading AWS CLI installer..."
        curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"

        # Check if unzip is installed
        if ! command -v unzip &> /dev/null; then
            print_error "unzip is not installed. Please install it first:"
            echo "  Ubuntu/Debian: sudo apt-get install unzip"
            echo "  RHEL/CentOS: sudo yum install unzip"
            exit 1
        fi

        # Unzip and install
        print_info "Extracting installer..."
        unzip -q /tmp/awscliv2.zip -d /tmp/

        print_info "Installing AWS CLI (may require sudo password)..."
        sudo /tmp/aws/install

        # Cleanup
        rm -rf /tmp/awscliv2.zip /tmp/aws

        print_success "AWS CLI installed successfully!"

    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Detected macOS system"

        # Check if Homebrew is available
        if command -v brew &> /dev/null; then
            print_info "Installing via Homebrew..."
            brew install awscli
        else
            print_info "Downloading AWS CLI installer..."
            curl -s "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "/tmp/AWSCLIV2.pkg"

            print_info "Installing AWS CLI (may require sudo password)..."
            sudo installer -pkg /tmp/AWSCLIV2.pkg -target /

            # Cleanup
            rm /tmp/AWSCLIV2.pkg
        fi

        print_success "AWS CLI installed successfully!"
    else
        print_error "Unsupported operating system: $OSTYPE"
        print_info "Please install AWS CLI manually from: https://aws.amazon.com/cli/"
        exit 1
    fi
}

# Configure AWS credentials
configure_aws() {
    echo ""
    echo "======================================"
    echo "AWS Credentials Configuration"
    echo "======================================"
    echo ""

    print_info "You'll need:"
    echo "  1. AWS Access Key ID"
    echo "  2. AWS Secret Access Key"
    echo ""
    print_info "Get these from: AWS Console → IAM → Users → Security credentials → Create access key"
    echo ""

    read -p "Do you want to configure AWS credentials now? (y/n): " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        read -p "Enter profile name (default: default): " PROFILE_NAME
        PROFILE_NAME=${PROFILE_NAME:-default}

        if [ "$PROFILE_NAME" == "default" ]; then
            aws configure
        else
            aws configure --profile "$PROFILE_NAME"
        fi

        print_success "AWS credentials configured for profile: $PROFILE_NAME"
        echo ""

        # Save profile name for later use
        AWS_PROFILE="$PROFILE_NAME"
    else
        print_warning "Skipping AWS configuration. You can run 'aws configure' manually later."
        AWS_PROFILE="default"
    fi
}

# Get AWS region
get_aws_region() {
    echo ""
    read -p "Enter your preferred AWS region (default: us-east-1): " AWS_REGION
    AWS_REGION=${AWS_REGION:-us-east-1}
    print_success "Using AWS region: $AWS_REGION"
}

# Update Claude Desktop config
update_claude_config() {
    echo ""
    echo "======================================"
    echo "Claude Desktop Configuration"
    echo "======================================"
    echo ""

    # Detect Claude Desktop config location
    if [[ "$OSTYPE" == "darwin"* ]]; then
        CLAUDE_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
    else
        CLAUDE_CONFIG="$HOME/.config/claude/claude_desktop_config.json"
    fi

    print_info "Claude Desktop config location: $CLAUDE_CONFIG"
    echo ""

    read -p "Do you want to update Claude Desktop config automatically? (y/n): " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Create config directory if it doesn't exist
        mkdir -p "$(dirname "$CLAUDE_CONFIG")"

        # Check if config file exists
        if [ -f "$CLAUDE_CONFIG" ]; then
            print_info "Backing up existing config..."
            cp "$CLAUDE_CONFIG" "${CLAUDE_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
            print_success "Backup created"

            # Check if config already has AWS Serverless MCP server
            if grep -q "aws-serverless" "$CLAUDE_CONFIG"; then
                print_warning "AWS Serverless MCP server already exists in config"
                read -p "Do you want to update it? (y/n): " -n 1 -r
                echo ""
                if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                    print_info "Skipping config update"
                    return
                fi
            fi

            # Use Python/jq to update JSON (if available)
            if command -v jq &> /dev/null; then
                print_info "Updating config with jq..."

                TMP_FILE=$(mktemp)
                jq --arg profile "$AWS_PROFILE" --arg region "$AWS_REGION" \
                   '.mcpServers["aws-serverless"] = {
                       "command": "npx",
                       "args": ["-y", "@awslabs/aws-serverless-mcp-server"],
                       "env": {
                           "AWS_PROFILE": $profile,
                           "AWS_REGION": $region
                       }
                   }' "$CLAUDE_CONFIG" > "$TMP_FILE"

                mv "$TMP_FILE" "$CLAUDE_CONFIG"
                print_success "Claude Desktop config updated!"
            else
                print_warning "jq not found. Please update config manually."
                print_info "Add this to your $CLAUDE_CONFIG:"
                echo ""
                cat <<EOF
{
  "mcpServers": {
    "aws-serverless": {
      "command": "npx",
      "args": ["-y", "@awslabs/aws-serverless-mcp-server"],
      "env": {
        "AWS_PROFILE": "$AWS_PROFILE",
        "AWS_REGION": "$AWS_REGION"
      }
    }
  }
}
EOF
            fi
        else
            print_info "Creating new Claude Desktop config..."
            cat > "$CLAUDE_CONFIG" <<EOF
{
  "mcpServers": {
    "aws-serverless": {
      "command": "npx",
      "args": ["-y", "@awslabs/aws-serverless-mcp-server"],
      "env": {
        "AWS_PROFILE": "$AWS_PROFILE",
        "AWS_REGION": "$AWS_REGION"
      }
    }
  }
}
EOF
            print_success "Claude Desktop config created!"
        fi
    else
        print_info "Manual configuration required. See claude_desktop_config.example.json for reference."
    fi
}

# Verify AWS connection
verify_aws_connection() {
    echo ""
    echo "======================================"
    echo "Verifying AWS Connection"
    echo "======================================"
    echo ""

    if [ "$AWS_PROFILE" != "default" ]; then
        export AWS_PROFILE
    fi

    print_info "Testing AWS connection..."

    if aws sts get-caller-identity &> /dev/null; then
        IDENTITY=$(aws sts get-caller-identity 2>/dev/null)
        ACCOUNT=$(echo "$IDENTITY" | grep -o '"Account": "[^"]*"' | cut -d'"' -f4)
        USER_ARN=$(echo "$IDENTITY" | grep -o '"Arn": "[^"]*"' | cut -d'"' -f4)

        print_success "Successfully connected to AWS!"
        echo ""
        echo "  Account: $ACCOUNT"
        echo "  User/Role: $USER_ARN"
    else
        print_error "Failed to connect to AWS. Please check your credentials."
        echo ""
        print_info "You can reconfigure by running: aws configure"
    fi
}

# Main execution
main() {
    echo ""

    # Step 1: Check/Install AWS CLI
    if ! check_aws_cli; then
        read -p "Would you like to install AWS CLI now? (y/n): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_aws_cli
        else
            print_error "AWS CLI is required. Exiting."
            exit 1
        fi
    fi

    # Step 2: Configure AWS credentials
    configure_aws

    # Step 3: Get AWS region preference
    get_aws_region

    # Step 4: Update Claude Desktop config
    update_claude_config

    # Step 5: Verify connection
    verify_aws_connection

    # Final instructions
    echo ""
    echo "======================================"
    echo "Setup Complete!"
    echo "======================================"
    echo ""
    print_success "AWS Serverless MCP Server is configured"
    echo ""
    print_info "Next steps:"
    echo "  1. Restart Claude Desktop to activate the integration"
    echo "  2. Test by asking Claude to help with AWS serverless development"
    echo "  3. Explore serverless best practices and deployment tools"
    echo ""
    print_warning "Remember: The MCP server runs in read-only mode by default for safety"
    echo ""
}

# Run main function
main
