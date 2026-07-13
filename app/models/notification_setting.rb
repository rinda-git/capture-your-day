class NotificationSetting < ApplicationRecord
  belongs_to :user

  enum :scene_type, { light: 0, dark: 1 }

  validates :notification_time, presence: true, if: :reminder_enabled?
end
