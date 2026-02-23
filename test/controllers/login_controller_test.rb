require "test_helper"

class LoginControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "valid credentials redirect to articles and set session" do
    post login_url, params: { user: { username: "testuser1", password: "password123" } }
    assert_redirected_to articles_path
    assert_equal users(:one).id, session[:curr_userid]
  end

  test "wrong password returns error" do
    post login_url, params: { user: { username: "testuser1", password: "wrongpassword" } }
    assert_response :unauthorized
    assert_equal true, response.parsed_body["error"]
  end

  test "unknown user returns error" do
    post login_url, params: { user: { username: "nobody123", password: "password123" } }
    assert_response :unauthorized
    assert_equal true, response.parsed_body["error"]
  end

  test "logout clears session and redirects to root" do
    post login_url, params: { user: { username: "testuser1", password: "password123" } }
    assert_equal users(:one).id, session[:curr_userid]
    delete login_url
    assert_redirected_to root_path
    assert_nil session[:curr_userid]
  end
end
