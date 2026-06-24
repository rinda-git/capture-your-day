require 'rails_helper'

RSpec.describe Journal, type: :model do
  # クラス名やメソッドの処理内容などを記載す
  describe "ジャーナリングバリデーションチェック" do
    # テストケースの説明
    it "すべてのフィールドが有効な場合" do
      # Journalを作る。そのJournalがバリデーション上有効であることを確認する
      journal = build(:journal)
      expect(build(:journal)).to be_valid
    end

    it "本文が空白の場合は無効であること" do
      journal = build(:journal, body: nil)
      expect(journal).to be_invalid
    end

    it "日付が空白の場合は無効であること" do
      journal = build(:journal, posted_date: nil)
      expect(journal).to be_invalid
    end

    it "トーンが未設定の場合は無効であること" do
      journal = build(:journal, tone: nil)
      expect(journal).to be_invalid
    end
  end
end
