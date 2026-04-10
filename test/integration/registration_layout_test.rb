require "test_helper"

class RegistrationLayoutTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "sign up page does not render the shared header" do
    get new_user_registration_path

    assert_response :success
    assert_select "header.navbar", count: 0
  end

  test "sign up shows a flash message after success" do
    assert_difference("User.count", 1) do
      post user_registration_path, params: {
        user: {
          name: "flash user",
          email: "flash_signup@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    follow_redirect!

    assert_response :success
    assert_select "[role=alert]", text: /アカウント登録が完了しました。/
  end

  test "sign in shows a flash message after success" do
    post user_session_path, params: {
      user: {
        email: users(:one).email,
        password: "password"
      }
    }

    follow_redirect!

    assert_response :success
    assert_select "[role=alert]", text: /ログインしました。/
  end

  test "sign out shows a flash message after success" do
    sign_in users(:one)

    delete destroy_user_session_path

    assert_redirected_to new_user_session_path

    follow_redirect!

    assert_response :success
    assert_select "[role=alert]", text: /ログアウトしました。/
  end
end
