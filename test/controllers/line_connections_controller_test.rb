require "test_helper"

class LineConnectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get line_connections_show_url
    assert_response :success
  end
end
