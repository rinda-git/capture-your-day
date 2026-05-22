class AddLineFriendToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :line_friend, :boolean, default: false, null: false
  end
end
