require 'rails_helper'

RSpec.describe JournalCorrection, type: :model do
  describe 'バリデーションチェック' do
    it 'すべてのフィールドが有効な場合' do
      journal_correction = build(:journal_correction)
      expect(journal_correction).to be_valid
    end

    it 'original_textが空白の場合、無効であること' do
      journal_correction = build(:journal_correction, original_text: nil)
      expect(journal_correction).to be_invalid
      expect(journal_correction.errors[:original_text]).to include('を入力してください')
    end

    it 'rewritten_textが空白の場合、無効であること' do
      journal_correction = build(:journal_correction, rewritten_text: nil)
      expect(journal_correction).to be_invalid
      expect(journal_correction.errors[:rewritten_text]).to include('を入力してください')
    end
  end

  describe '関連付け' do
    it 'userに紐づいていること' do
      journal_correction = build(:journal_correction, user: nil)
      expect(journal_correction).to be_invalid
      expect(journal_correction.errors[:user]).to include('を入力してください')
    end

    it 'journalに紐づいていること' do
      journal_correction = build(:journal_correction, journal: nil, user: build(:user))
      expect(journal_correction).to be_invalid
      expect(journal_correction.errors[:journal]).to include('を入力してください')
    end
  end
end
