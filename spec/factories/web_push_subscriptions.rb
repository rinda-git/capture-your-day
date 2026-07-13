FactoryBot.define do
  factory :web_push_subscription do
    user
    endpoint do
      "https://example.com/push/#{SecureRandom.hex(8)}"
    end
    p256dh { "dummy_p256dh" }
    auth { "dummy_auth" }
  end
end
