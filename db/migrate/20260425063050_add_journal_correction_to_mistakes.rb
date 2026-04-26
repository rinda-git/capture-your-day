class AddJournalCorrectionToMistakes < ActiveRecord::Migration[7.2]
  def change
    add_reference :mistakes, :journal_correction, foreign_key: true
  end
end
