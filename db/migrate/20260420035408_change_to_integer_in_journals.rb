class ChangeToIntegerInJournals < ActiveRecord::Migration[7.2]
  def change
    remove_column :journals, :tone, :string
    add_column :journals, :tone, :integer
  end
end
