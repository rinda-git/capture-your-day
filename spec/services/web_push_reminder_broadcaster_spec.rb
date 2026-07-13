require "rails_helper"

RSpec.describe WebPushReminderBroadcaster do
  describe "#call" do
    let(:now) do
      Time.zone.local(2026, 7, 13, 21, 0, 0)
    end

    it "設定時刻が一致する通知ONのユーザーに送信する" do
      user = create(:user)
      setting = create(
        :notification_setting,
        user: user,
        reminder_enabled: true,
        notification_time: "21:00"
      )
      subscription = create(:web_push_subscription, user: user)
      sender = instance_double(WebPushNotificationSender, call: true)

      allow(WebPushNotificationSender)
        .to receive(:new)
        .with(subscription)
        .and_return(sender)

      described_class.new(now: now).call

      expect(sender).to have_received(:call)
      expect(setting.reload.last_web_push_reminded_on).to eq(now.to_date)
    end

    it "リマインダーOFFのユーザーには送信しない" do
      user = create(:user)
      create(
        :notification_setting,
        user: user,
        reminder_enabled: false,
        notification_time: "21:00"
      )
      create(:web_push_subscription, user: user)

      allow(WebPushNotificationSender).to receive(:new)

      described_class.new(now: now).call

      expect(WebPushNotificationSender).not_to have_received(:new)
    end
  end
end
