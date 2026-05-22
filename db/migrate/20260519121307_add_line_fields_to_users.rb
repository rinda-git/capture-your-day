class AddLineFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :line_user_id, :string
    add_column :users, :line_notifications_enabled, :boolean, default: false
    add_column :users, :line_link_code, :string
  end
end
