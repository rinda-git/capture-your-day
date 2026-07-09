require 'rails_helper'

RSpec.describe "NotificationSettings", type: :request do
  let(:user) { create(:user) }
  before do
    sign_in user
  end

  describe "GET /show" do
    it "returns http success" do
      get "/notification_setting"
      expect(response).to have_http_status(:success)
    end
  end
end
