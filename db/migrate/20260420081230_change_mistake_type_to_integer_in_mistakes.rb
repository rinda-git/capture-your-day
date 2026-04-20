class ChangeMistakeTypeToIntegerInMistakes < ActiveRecord::Migration[7.2]
  def change
    remove_column :mistakes, :mistake_type, :string
    add_column :mistakes, :mistake_type, :integer
  end
end
