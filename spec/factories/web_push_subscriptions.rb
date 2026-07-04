FactoryBot.define do
  factory :web_push_subscription do
    user { nil }
    endpoint { "MyText" }
    p256dh { "MyString" }
    auth { "MyString" }
  end
end
