require 'rails_helper'

RSpec.describe User, type: :model do
  describe '新規ユーザー作成チェック' do
    it 'すべてのフィールドが有効な場合' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'emailが空白の場合は無効であること' do
      user = build(:user, email: nil)
      expect(user).to be_invalid
    end

    it 'nameが空白の場合は無効であること' do
      user = build(:user, name: nil)
      expect(user).to be_invalid
    end

    it 'passwordが空白の場合は無効であること' do
      user = build(:user, password: nil)
      expect(user).to be_invalid
    end

    it 'emailが重複している場合は無効であること' do
      user1 = create(:user, email: "capture@example.com")
      user2 = build(:user, email: "capture@example.com")
      expect(user2).to be_invalid
      expect(user2.errors[:email]).to include('はすでに存在します')
    end
  end

  describe 'アソシエーション' do
    it 'journalを複数持てること' do
      user = create(:user)
      journal = create(:journal, user: user)

      expect(user.journals).to include(journal)
    end
  end
end
