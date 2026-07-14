# 通知対象ユーザーを探し、Webプッシュ通知を送信する
class WebPushReminderBroadcaster
  def initialize(now: Time.current)
    @now = now
  end

  def call
    target_settings.find_each do |setting|
      deliver_to(setting)
    end
  end

  private

  attr_reader :now

  def target_settings
    NotificationSetting
      .includes(user: :web_push_subscriptions)
      .where(reminder_enabled: true)
      .where(notification_time: target_time)
    #   .where("last_web_push_reminded_on IS NULL OR last_web_push_reminded_on != ?", today)
  end

  def deliver_to(setting)
    subscriptions = setting.user.web_push_subscriptions
    return if subscriptions.empty?

    subscriptions.find_each do |subscription|
      WebPushNotificationSender.new(subscription).call(
        title: "英語ジャーナリングの時間です",
        body: "今日の出来事を書いてみましょう",
        path: "/journals/new"
      )
    end

    setting.update!(last_web_push_reminded_on: today)
  rescue => e
    Rails.logger.error(
      "[WebPushReminderBroadcaster] user_id=#{setting.user_id} #{e.class}: #{e.message}"
    )
  end

  def target_time
    Time.zone.parse(now.strftime("%H:%M"))
  end

  def today
    now.to_date
  end
end
