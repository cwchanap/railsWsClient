require "test_helper"

class MainControllerTest < ActionDispatch::IntegrationTest
  test "should get heaven" do
    get heaven_url
    assert_response :success
  end
end
