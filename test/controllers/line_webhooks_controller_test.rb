require "test_helper"

class LineWebhooksControllerTest < ActionDispatch::IntegrationTest
  test "should receive webhook" do
    parser = Minitest::Mock.new
    parser.expect(:parse, [], body: "{}", signature: "dummy_signature")

    Line::Bot::V2::WebhookParser.stub(:new, parser) do
    post line_webhook_url,
         params: "{}",
         headers: {
          "CONTENT_TYPE" => "application/json",
          "X-Line-Signature" => "dummy_signature"
         }
    assert_response :success
  end

  parser.verify
end
end
