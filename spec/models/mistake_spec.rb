require 'rails_helper'

RSpec.describe Mistake, type: :model do
  describe 'バリデーションチェック' do
    it 'すべてのフィールドが有効な場合' do
      mistake = build(:mistake)
      expect(mistake).to be_valid
    end

    it 'original_textが空白の場合は無効' do
      mistake = build(:mistake, original_text: nil)
      expect(mistake).to be_invalid
      expect(mistake.errors[:original_text]).to include('を入力してください')
    end

    it 'mistake_typeに設定できること' do
        mistake = build(:mistake, mistake_type: 'grammar' )
        expect(mistake.grammar?).to be true
    end
  end

    describe '関連付けチェック' do
      it 'userに紐づいていること' do
        mistake = build(:mistake, user: nil)
        expect(mistake).to be_invalid
        expect(mistake.errors[:user]).to include('を入力してください')
      end

      it 'journalに紐づいていること' do
        mistake = build(:mistake, journal: nil, user: build(:user))
        expect(mistake).to be_invalid
        expect(mistake.errors[:journal]).to include('を入力してください')
      end

      it 'journal_correctionに紐づいていること' do
        user = build(:user)
        journal = build(:journal, user: user)
        mistake = build(:mistake, journal_correction: nil, journal: journal, user: user)
        expect(mistake).to be_invalid
        expect(mistake.errors[:journal_correction]).to include('を入力してください')
      end
    end
end
