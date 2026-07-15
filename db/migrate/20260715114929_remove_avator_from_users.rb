class RemoveAvatorFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :avatar, :string
  end
end
