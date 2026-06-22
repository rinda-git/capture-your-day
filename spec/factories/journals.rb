FactoryBot.define do
  factory :journal do
    association :user
    posted_date { Date.current }
    mood { :good }
    tone { :standard }
    title { "My Journal" }
    body { "Have a good day." }
  end
end
