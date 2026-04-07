class CreateNotificationSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :notification_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :reminder_enabled, default: false
      t.time :notification_time
      t.integer :scene_type, default: 0

      t.timestamps
    end
  end
end
