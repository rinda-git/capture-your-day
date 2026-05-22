require "test_helper"

class MypagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get show" do
    get mypage_url
    assert_response :success
  end
end
