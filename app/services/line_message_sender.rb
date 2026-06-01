class LineMessageSender
  def initialize(user:, message:)
      @user = user
      @message = message
  end

  def call
    return false if user.line_user_id.blank?
    return false if message.blank?

    client.push_message(push_message_request: push_message_request)
    true
  end

  private

  attr_reader :user, :message

  def client
    @client ||= Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: Rails.application.credentials.dig(:line, :channel_token)
    )
  end

  def push_message_request
    Line::Bot::V2::MessagingApi::PushMessageRequest.new(
      to: user.line_user_id,
      messages: [
        Line::Bot::V2::MessagingApi::TextMessage.new(text: message)
      ]
    )
    end
end
