class RemoveUnusedColumns < ActiveRecord::Migration[8.1]
  def change
    remove_column :journal_corrections, :advice, :text
    remove_column :journal_corrections, :mistake_patterns, :json
    remove_column :journal_corrections, :native_phrases, :json
    remove_column :journal_corrections, :strengths, :json 
  end
end
