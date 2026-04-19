class AddTypeToMistakes < ActiveRecord::Migration[7.2]
  def change
    add_column :mistakes, :mistake_type, :string
  end
end
