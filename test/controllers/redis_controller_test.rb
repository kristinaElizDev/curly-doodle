require "test_helper"

class RedisControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get redis_index_url
    assert_response :success
  end

  test "should get test" do
    get redis_test_url
    assert_response :success
  end
end
