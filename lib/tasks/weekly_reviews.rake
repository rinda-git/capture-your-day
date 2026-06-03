
# namespace:Rake task の名前をグループ分け
namespace :weekly_reviews do
  # タスクの説明文
  desc "Send weekly LINE review messages to users with LINE user ID"

  # タスク名
  task send: :environment do
    WeeklyReviewBroadcaster.new.call
  end
end
