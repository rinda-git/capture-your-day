class AddToneToJournals < ActiveRecord::Migration[7.2]
  def change
    add_column :journals, :tone, :string
  end
end
