FactoryBot.define do
  factory :notification_setting do
  user
  reminder_enabled { false }
  notification_time { "21:00" }
  end
end
