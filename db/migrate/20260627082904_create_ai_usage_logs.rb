class CreateAiUsageLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :ai_usage_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.date :used_on

      t.timestamps
    end
    add_index :ai_usage_logs, [ :user_id, :used_on ]
  end
end
