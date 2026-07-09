class WebPushNotificationSender
  def initialize(subscription)
    @subscription = subscription
  end

  def call(title:, body:, path: "/")
    WebPush.payload_send(
      message: {
        title: title,
        options: {
          body: body,
          data: {
            path: path
          }
        }
      }.to_json,
      endpoint: @subscription.endpoint,
      p256dh: @subscription.p256dh,
      auth: @subscription.auth,
      vapid: {
        subject: Rails.application.credentials.dig(:webpush, :vapid_subject),
        public_key: Rails.application.credentials.dig(:webpush, :vapid_public_key),
        private_key: Rails.application.credentials.dig(:webpush, :vapid_secret_key)
      }
    )
  end
end
