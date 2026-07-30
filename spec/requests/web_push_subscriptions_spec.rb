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

    it "ログインユーザーの購読情報を保存する" do
      expect {
        post "/web_push_subscriptions",
            params: {
              endpoint: "https://example.com/push",
              p256dh: "dummy_p256dh",
              auth: "dummy_auth"
             }
            }.to change(user.web_push_subscriptions, :count).by(1)

      subscription = user.web_push_subscriptions.last

      expect(subscription).to have_attributes(
          endpoint: "https://example.com/push",
          p256dh: "dummy_p256dh",
          auth: "dummy_auth"
      )
    end

    it "同じendpointの購買情報を重複登録せず更新する" do
      subscription = create(
        :web_push_subscription,
        user: user,
        endpoint: "https://example.com/push",
        p256dh: "old_p256dh",
        auth: "old_auth"
      )

    expect {
      post "/web_push_subscriptions",
           params: {
           endpoint: subscription.endpoint,
           p256dh: "new_p256dh",
           auth: "new_auth"
           }
          }.not_to change(WebPushSubscription, :count)
      expect(subscription.reload).to have_attributes(
        p256dh: "new_p256dh",
        auth: "new_auth"
      )
    end
  end
end
