# MCP Server Integration for Claude Desktop

This repository contains the configuration for integrating multiple MCP servers with Claude Desktop via the Model Context Protocol (MCP), including HubSpot and AWS Serverless.

## Setup Complete

The HubSpot MCP server has been configured and is ready to use with Claude Desktop.

### Configuration Details

- **MCP Server**: @hubspot/mcp-server (v0.4.0)
- **Client**: Claude Desktop
- **Config Location**: `~/.config/claude/claude_desktop_config.json`

### What You Can Do Now

Once you restart Claude Desktop, you'll have access to powerful HubSpot integration tools:

#### Get Insights from Your HubSpot Data
- Get me the latest update about Acme Inc. from my HubSpot account.
- Summarize all deals in the "Decision maker bought in" stage in my HubSpot pipeline with deal value > $1000.
- Summarize the last five tickets created for Alex Smith in my HubSpot account.

#### Create and Update CRM Records
- Update the address for John Smith in my HubSpot account.
- Create a new contact "John.Johnson@email.com" for Acme Inc. in my HubSpot account.

#### CRM Associations
- List all associated contacts and their roles for Acme Inc. from my HubSpot account.
- Associate John Smith with Acme Inc. as a company in my HubSpot account.

#### Add Engagements
- Add a task to send a thank-you note to jane@example.com in my HubSpot account.
- Add a note for Acme Inc. in my HubSpot account.
- List my overdue HubSpot tasks.

## AWS Serverless MCP Server Integration

In addition to HubSpot, you can add the AWS Serverless MCP server for AI-powered serverless development.

### Configuration

Add the following to your `~/.config/claude/claude_desktop_config.json` file (or see `claude_desktop_config.example.json` in this repo):

```json
{
  "mcpServers": {
    "hubspot": {
      "command": "npx",
      "args": ["-y", "@hubspot/mcp-server@0.4.0"],
      "env": {
        "HUBSPOT_ACCESS_TOKEN": "your-token-here"
      }
    },
    "aws-serverless": {
      "command": "npx",
      "args": ["-y", "@awslabs/aws-serverless-mcp-server"],
      "env": {
        "AWS_PROFILE": "default",
        "AWS_REGION": "us-east-1"
      }
    }
  }
}
```

### AWS Configuration Options

You can configure the AWS Serverless MCP server using these environment variables:

- **AWS_PROFILE**: AWS CLI profile to use for credentials (recommended)
- **AWS_REGION**: AWS region to use (default: us-east-1)
- **AWS_ACCESS_KEY_ID** / **AWS_SECRET_ACCESS_KEY**: Explicit AWS credentials (alternative to AWS_PROFILE)
- **AWS_SESSION_TOKEN**: Session token for temporary credentials
- **FASTMCP_LOG_LEVEL**: Logging level (ERROR, WARNING, INFO, DEBUG)

### What You Can Do with AWS Serverless MCP

The AWS Serverless MCP server provides:

- **AI-Powered Serverless Development**: Contextual guidance for building serverless applications aligned with AWS best practices
- **Comprehensive Tooling**: Tools for initialization, deployment, monitoring, and troubleshooting of serverless applications
- **Read-Only Mode**: Runs in read-only mode by default for safer production environments

### Prerequisites

Before using the AWS Serverless MCP server:

1. Install and configure the AWS CLI
2. Set up AWS credentials using `aws configure` or AWS profiles
3. Ensure you have appropriate IAM permissions for serverless services

## Available Tools

### HubSpot MCP Server

The HubSpot MCP server provides the following tool categories:

- **OAuth**: Authentication and user details
- **Objects**: List, search, create, update, and read CRM records
- **Properties**: Manage custom properties for CRM objects
- **Associations**: Create and manage relationships between CRM records
- **Engagements**: Create and manage notes and tasks
- **Workflows**: View and interact with HubSpot workflows
- **Links**: Generate feedback links and direct access URLs

## Next Steps

1. **Configure AWS Credentials** (if adding AWS Serverless MCP):
   - Run `aws configure` to set up your AWS credentials
   - Or configure an AWS profile that matches the AWS_PROFILE in your config

2. **Update Claude Desktop Config**:
   - Edit `~/.config/claude/claude_desktop_config.json`
   - Add the AWS Serverless MCP server configuration (see example above)

3. **Restart Claude Desktop** to activate both MCP integrations

4. **Test the Connections**:
   - Ask Claude about your HubSpot data
   - Ask Claude to help with AWS serverless development tasks
   - Explore the available tools and capabilities from both servers

## Security Notes

- The access token is stored in `~/.config/claude/claude_desktop_config.json`
- Consider using read-only scopes initially for testing
- You can manage scopes in HubSpot Settings > Integrations > Private Apps

## Troubleshooting

If you encounter issues:
- Ensure Node.js and npm are installed
- Verify your HubSpot private app has the necessary scopes
- Check that Claude Desktop has been restarted after configuration
- Visit https://modelcontextprotocol.io/quickstart/user for more information

## Resources

### HubSpot MCP Server
- [HubSpot MCP Documentation](https://developers.hubspot.com/mcp)
- [HubSpot Developer Docs](https://developers.hubspot.com/)

### AWS Serverless MCP Server
- [AWS Serverless MCP Server Documentation](https://awslabs.github.io/mcp/servers/aws-serverless-mcp-server)
- [AWS Serverless MCP Server Blog Post](https://aws.amazon.com/blogs/compute/introducing-aws-serverless-mcp-server-ai-powered-development-for-modern-applications/)
- [AWS Serverless Documentation](https://aws.amazon.com/serverless/)

### General
- [Model Context Protocol](https://modelcontextprotocol.io/)

## Terms and Conditions

The HubSpot MCP Server is in beta and subject to the [Early Adopter Program terms](https://legal.hubspot.com/early-adopter-program).
