class NotificationSetting < ApplicationRecord
  belongs_to :user

  validates :notification_time, presence: true, if: :reminder_enabled?
end
