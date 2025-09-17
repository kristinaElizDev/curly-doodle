# Azure Redis configuration initializer
require 'redis'
require 'ms_rest_azure'

# Configuration for Azure Managed Redis with Entra ID authentication
class AzureRedisConfig
  class << self
    def configure
      # Get Azure credentials from environment or use DefaultAzureCredential
      auth_token = get_auth_token
      
      if auth_token
        Redis.new(
          host: ENV['AZURE_REDIS_HOST'] || 'your-redis-instance.redis.cache.windows.net',
          port: ENV['AZURE_REDIS_PORT'] || 6380,
          ssl: true,
          username: ENV['AZURE_REDIS_USERNAME'] || 'default',
          password: auth_token,
          ssl_params: {
            verify_mode: OpenSSL::SSL::VERIFY_PEER
          }
        )
      else
        Rails.logger.warn "No Azure authentication token available. Using local Redis configuration."
        Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379')
      end
    rescue Redis::ConnectionError => e
      Rails.logger.error "Redis connection failed: #{e.message}"
      # Return a Redis instance that will allow the app to start but will fail on actual operations
      Redis.new(url: 'redis://localhost:6379')
    end

    private

    def get_auth_token
      # In a real application, you would use Azure Identity SDK
      # For now, we'll check for environment variable or return nil
      ENV['AZURE_REDIS_ACCESS_TOKEN']
    end
  end
end

# Initialize Redis connection
Rails.application.configure do
  config.redis = AzureRedisConfig.configure
end