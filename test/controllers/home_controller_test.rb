require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get unauthenticated_root_url
    assert_response :success
  end
end
