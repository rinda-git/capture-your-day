class AddLastWebPushReminderOnToNotificationSettings < ActiveRecord::Migration[8.1]
  def change
    add_column :notification_settings, :last_web_push_reminded_on, :date
  end
end
