require 'rails_helper'

RSpec.describe "WebPushSubscriptions", type: :request do
  let(:user) { create(:user) }
  before do
    sign_in user
  end

  describe "POST /create" do
    it "returns http success" do
      post "/web_push_subscriptions",
            params: {
              endpoint: "https://example.com/push",
              p256dh: "dummy_p256dh",
              auth: "dummy_auth"
            }

      expect(response).to have_http_status(:success)
    end
  end
end
