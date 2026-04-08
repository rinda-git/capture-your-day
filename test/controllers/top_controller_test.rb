require "test_helper"

class TopControllerTest < ActionDispatch::IntegrationTest
 # Deviseのログインヘルパーを使えるようにする
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end
  
  test "should get index" do
    get root_url
    assert_response :success
  end
end
