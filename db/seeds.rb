# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# 既存データをリセット
Journal.destroy_all
User.destroy_all

# ユーザーを1人作成して変数に入れる
user = User.create!(
  name: "Kay",
  email: "kay@example.com",
  password: "password",
  password_confirmation: "password"
)

# 10.timesブロックで10人のユーザーを生成
# 各ユーザーはランダムな姓、名、ユニークなメールアドレス、固定のパスワードが設定されます
10.times do
  User.create!(name: Faker::Name.name,
               email: Faker::Internet.unique.email,
               password: "password",
               password_confirmation: "password")
end

10.times do |i|
  Journal.create!(
    user: user,
    posted_date: i.days.ago,
    title: Faker::Lorem.sentence(word_count: 3),
    body: Faker::Lorem.paragraph(sentence_count: 3)
  )
end

puts "✅ #{Journal.count}件の日記を作成しました"
