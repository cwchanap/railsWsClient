require "test_helper"

class LoginControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  # TODO: Fix LoginController to use has_secure_password authenticate method
  # test "should post login" do
  #   post login_new_url, params: { user: { username: "testuser1", password: "password123" } }
  #   assert_redirected_to articles_path
  #   assert_equal users(:one).id, session[:curr_userid]
  # end
end
