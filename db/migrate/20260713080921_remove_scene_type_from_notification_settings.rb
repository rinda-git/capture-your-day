class RemoveSceneTypeFromNotificationSettings < ActiveRecord::Migration[8.1]
  def change
    remove_column :notification_settings, :scene_type, :integer
  end
end
