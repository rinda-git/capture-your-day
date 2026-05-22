class LineWebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  # LINEサーバーからWebhookが届いた時の処理
  # LINEで送られたコードを受け取ってUserと紐づける
  def create
    Rails.logger.info "LINEからWebhook来た!"
    # event = params[:events][0]
    # Rails.logger.info event["message"]["text"]

    body = request.body.read
    Rails.logger.info body

    # LINEの署名確認
    signature = request.env["HTTP_X_LINE_SIGNATURE"]

    events = parser.parse(body: body, signature: signature)

    events.each do |event|
      # # LINEの中身確認
      # Rails.logger.info event.class
      # # user_id取得
      # Rails.logger.info event.source.user_id
      # if event.is_a?(LINE::Bot::V2::Webhook::MessageEvent)
      #   Rails.logger.info event.message.text
      # end

      # MessageEvent以外はスキップ
      next unless event.is_a?(Line::Bot::V2::Webhook::MessageEvent)
      message_text = event.message.text
      # LINEのuser_id
      line_user_id = event.source.user_id

      Rails.logger.info "message_text: #{message_text}"
      Rails.logger.info "line_user_id: #{line_user_id}"

      # line_link_code一致ユーザー検索
      user = User.find_by(
        line_link_code: message_text
      )

      # 見つからなければ終了
      next unless user

      user.update!(
        line_user_id: line_user_id,
        line_notifications_enabled: true
      )

      Rails.logger.info "LINE連携成功"
    end

    head :ok
  end

  private

  def parser
    @parser ||= Line::Bot::V2::WebhookParser.new(
      channel_secret: Rails.application.credentials.dig(:line, :channel_secret)
    )
  end
end
