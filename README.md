# Azure Managed Redis with Ruby on Rails

A Ruby on Rails application that demonstrates connecting to Azure Managed Redis using Entra ID authentication, designed to run in GitHub Codespaces.

## Features

- 🚀 Ruby on Rails 8.0 application
- 🔐 Azure Managed Redis with Entra ID authentication
- 🐳 GitHub Codespace ready with dev container
- 🧪 Built-in Redis connectivity testing dashboard
- ⚡ Real-time Redis operations testing

## Quick Start

### 1. Open in GitHub Codespace

Click the "Code" button and select "Create codespace on main" to launch this project in a GitHub Codespace.

### 2. Configure Azure Redis

Copy the environment template:
```bash
cp .env.example .env
```

Fill in your Azure Redis details in `.env`:
```bash
AZURE_REDIS_HOST=your-redis-instance.redis.cache.windows.net
AZURE_REDIS_PORT=6380
AZURE_REDIS_USERNAME=default
AZURE_REDIS_ACCESS_TOKEN=your_entra_id_token
```

### 3. Get Azure Access Token

In the Codespace terminal:
```bash
# Login to Azure
az login

# Get access token for Redis
export AZURE_REDIS_ACCESS_TOKEN=$(az account get-access-token --resource https://redis.azure.com --query accessToken -o tsv)
```

### 4. Start the Application

```bash
bundle exec rails server
```

Access the application via the forwarded port (3000) or click the pop-up notification.

## Testing Redis Connectivity

The application includes a comprehensive dashboard at the root URL (`/`) that provides:

- Real-time connection status
- Redis server information
- Interactive test suite including:
  - Basic ping test
  - Set/Get operations
  - Key expiration testing
  - Hash operations
  - Error handling verification

## Azure Setup

### Prerequisites

1. Azure subscription with Redis instance
2. Redis instance configured with Entra ID authentication
3. User account with appropriate permissions

### Creating Azure Managed Redis

```bash
# Create resource group
az group create --name myResourceGroup --location eastus

# Create Redis instance with Entra ID authentication
az redis create \
  --resource-group myResourceGroup \
  --name myRedisInstance \
  --location eastus \
  --sku Standard \
  --vm-size c1 \
  --enable-non-ssl-port false \
  --redis-version 6 \
  --auth-type EntraId
```

### Configure Access

```bash
# Assign Redis Data Contributor role
az role assignment create \
  --assignee "user@domain.com" \
  --role "Redis Data Contributor" \
  --scope "/subscriptions/{subscription-id}/resourceGroups/myResourceGroup/providers/Microsoft.Cache/Redis/myRedisInstance"
```

## Local Development

For local development without Azure Redis:

1. Install Redis locally
2. Set `REDIS_URL=redis://localhost:6379` in your environment
3. The application will automatically fall back to local Redis

## Architecture

- **Rails 8.0**: Modern Ruby on Rails framework
- **Redis 5.x**: Redis client with Azure authentication support
- **Azure SDK**: Official Azure SDK for Ruby for Redis management
- **MS Rest Azure**: Authentication library for Azure services

## File Structure

```
├── .devcontainer/          # GitHub Codespace configuration
├── app/controllers/        # Rails controllers
│   └── redis_controller.rb # Redis testing controller
├── config/initializers/    # Rails initializers
│   └── redis.rb           # Azure Redis configuration
├── .env.example           # Environment variables template
└── README.md              # This file
```

## Troubleshooting

### Common Issues

1. **Authentication Errors**: Ensure your Entra ID token is valid and the user has appropriate Redis permissions
2. **Network Connectivity**: Verify that your Codespace can reach Azure services
3. **SSL/TLS Issues**: Azure Redis requires SSL connections on port 6380

### Debug Commands

```bash
# Test Redis connectivity manually
bundle exec rails console
> Rails.application.config.redis.ping

# Check environment variables
env | grep AZURE_REDIS

# Verify Azure login
az account show
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test in a Codespace
5. Submit a pull request

## License

This project is provided as-is for demonstration purposes.
