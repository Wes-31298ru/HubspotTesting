# HubSpot MCP Server Integration

This repository contains the configuration for integrating HubSpot with Claude Desktop via the Model Context Protocol (MCP).

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

## Available Tools

The HubSpot MCP server provides the following tool categories:

- **OAuth**: Authentication and user details
- **Objects**: List, search, create, update, and read CRM records
- **Properties**: Manage custom properties for CRM objects
- **Associations**: Create and manage relationships between CRM records
- **Engagements**: Create and manage notes and tasks
- **Workflows**: View and interact with HubSpot workflows
- **Links**: Generate feedback links and direct access URLs

## Next Steps

1. **Restart Claude Desktop** to activate the HubSpot MCP integration
2. Test the connection by asking Claude about your HubSpot data
3. Explore the available tools and capabilities

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

- [HubSpot MCP Documentation](https://developers.hubspot.com/mcp)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [HubSpot Developer Docs](https://developers.hubspot.com/)

## Terms and Conditions

The HubSpot MCP Server is in beta and subject to the [Early Adopter Program terms](https://legal.hubspot.com/early-adopter-program).
