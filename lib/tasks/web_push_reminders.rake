# namespace:Rake task の名前をグループ分け
namespace :web_push_reminders do
  # タスクの説明文
  desc "Send web push reminder notifications"

  # タスク名
  task send: :environment do
    WebPushReminderBroadcaster.new.call
  end
end
