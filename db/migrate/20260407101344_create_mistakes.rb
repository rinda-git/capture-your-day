class CreateMistakes < ActiveRecord::Migration[7.2]
  def change
    create_table :mistakes do |t|
      t.references :journal, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :original_text, null: false
      t.text :corrected_text
      t.text :explanation

      t.timestamps
    end
  end
end
