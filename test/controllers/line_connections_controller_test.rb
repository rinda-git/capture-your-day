require "test_helper"

class LineConnectionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get show" do
    get line_connection_url
    assert_response :success
  end
end
