FactoryBot.define do
  factory :journal do
    association :user
    posted_date { Date.current }
    mood { :good }
    tone { :standard }
    sequence(:body) { |n| "本文#{n}" }
  end
end
