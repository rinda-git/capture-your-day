class RemoveTitleFromJournals < ActiveRecord::Migration[8.1]
  def change
    remove_column :journals, :title, :string
  end
end
