class AddNativePhrasesToJournalCorrections < ActiveRecord::Migration[7.2]
  def change
    add_column :journal_corrections, :native_phrases, :json
  end
end
