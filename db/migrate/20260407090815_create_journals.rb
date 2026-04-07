class CreateJournals < ActiveRecord::Migration[7.2]
  def change
    create_table :journals do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :posted_date, null: false
      t.integer :mood
      t.string :title, null: true
      t.text :body, null: false

      t.timestamps
    end
  end
end
