class RedisController < ApplicationController
  def index
    @redis_info = get_redis_info
    @abs_info = AbsInfoService.call
  end

  def test
    @test_results = perform_redis_tests
    render :index
  end

  private

  def get_redis_info
    begin
      redis = Rails.application.config.redis
      {
        connected: redis.ping == "PONG",
        info: redis.info,
        server_version: redis.info["redis_version"],
        memory_usage: redis.info["used_memory_human"],
        connected_clients: redis.info["connected_clients"]
      }
    rescue => e
      {
        connected: false,
        error: e.message,
        suggestion: "Check your Azure Redis configuration and network connectivity"
      }
    end
  end

  def perform_redis_tests
    results = []
    redis = Rails.application.config.redis

    begin
      # Test 1: Basic ping
      results << {
        test: "Ping Test",
        result: redis.ping == "PONG" ? "PASS" : "FAIL",
        details: "Basic connectivity test"
      }

      # Test 2: Set and Get
      test_key = "test_key_#{Time.now.to_i}"
      test_value = "Hello Azure Redis!"
      redis.set(test_key, test_value)
      retrieved_value = redis.get(test_key)

      results << {
        test: "Set/Get Test",
        result: retrieved_value == test_value ? "PASS" : "FAIL",
        details: "Set: #{test_value}, Got: #{retrieved_value}"
      }

      # Test 3: Expiration
      redis.setex("expiring_key", 1, "This will expire")
      sleep(2)
      expired_value = redis.get("expiring_key")

      results << {
        test: "Expiration Test",
        result: expired_value.nil? ? "PASS" : "FAIL",
        details: "Key expired as expected: #{expired_value.nil?}"
      }

      # Test 4: Hash operations
      hash_key = "test_hash_#{Time.now.to_i}"
      redis.hset(hash_key, "field1", "value1")
      redis.hset(hash_key, "field2", "value2")
      hash_value = redis.hgetall(hash_key)

      results << {
        test: "Hash Operations",
        result: hash_value.length == 2 ? "PASS" : "FAIL",
        details: "Hash contents: #{hash_value}"
      }

      # Cleanup
      redis.del(test_key, hash_key)

    rescue => e
      results << {
        test: "Redis Operations",
        result: "ERROR",
        details: "Error during testing: #{e.message}"
      }
    end

    results
  end
end
