require 'rails_helper'

RSpec.describe Journal, type: :model do
  it "is valid with valid attributes" do
    # Journalを作る。そのJournalがバリデーション上有効であることを確認する
    expect(build(:journal)).to be_valid
  end
end
