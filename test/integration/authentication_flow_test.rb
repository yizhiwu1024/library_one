require "test_helper"

class AuthenticationFlowTest < ActionDispatch::IntegrationTest
  test "member can sign in and sign out" do
    user = users(:member)

    post login_path, params: { email: user.email, password: "Password123!" }
    assert_redirected_to root_path

    follow_redirect!
    assert_response :success

    delete logout_path
    assert_redirected_to login_path
  end

  test "suspended user is denied access" do
    user = users(:suspended_member)

    post login_path, params: { email: user.email, password: "Password123!" }
    assert_redirected_to login_path

    get books_path
    assert_redirected_to login_path
  end
end

