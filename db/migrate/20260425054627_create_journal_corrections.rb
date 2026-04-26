class CreateJournalCorrections < ActiveRecord::Migration[7.2]
  def change
    create_table :journal_corrections do |t|
      t.references :journal, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :original_text, null: false
      t.text :rewritten_text, null: false
      t.json :strengths
      t.json :mistake_patterns
      t.text :advice

      t.timestamps
    end
  end
end
