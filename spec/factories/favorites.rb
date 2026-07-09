FactoryBot.define do
  factory :favorite do
    association :user
    association :mistake
  end
end
