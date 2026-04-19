class ChangePostedDateToDateInJournals < ActiveRecord::Migration[7.2]
  def change
    change_column :journals, :posted_date, :date
  end
end
