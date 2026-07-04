require 'rails_helper'

RSpec.describe "WebPushSubscriptions", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/web_push_subscriptions/create"
      expect(response).to have_http_status(:success)
    end
  end
end
