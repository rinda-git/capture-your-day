require "test_helper"

class RegistrationLayoutTest < ActionDispatch::IntegrationTest
  test "sign up page does not render the shared header" do
    get new_user_registration_path

    assert_response :success
    assert_select "header.navbar", count: 0
  end
end
