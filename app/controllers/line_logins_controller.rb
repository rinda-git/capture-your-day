require "net/http"
require "uri"
require "json"
require "securerandom"
class LineLoginsController < ApplicationController
before_action :authenticate_user!

  # LINE連携開始
  def new
    # CSRF対策用のランダムの字列
    state = SecureRandom.hex(16)

    # callback時に照合するため、sessionに保存する
    session[:line_login_state] = state

    # LINE Loginの許可URLに渡すパラメータ
    query = {
      response_type: "code",
      client_id: ENV.fetch("LINE_LOGIN_CHANNEL_ID"),
      redirect_uri: ENV.fetch("LINE_LOGIN_CALLBACK_URL"),
      state: state,
      scope: "profile openid",
      bot_prompt: "normal"
    }

    # LINEの許可URLを作る
    line_authorize_url =  "https://access.line.me/oauth2/v2.1/authorize?#{query.to_query}"

    # LINEの許可画面へ移動する
    redirect_to line_authorize_url, allow_other_host: true
  end

  # LINE認証・許可後に戻ってくる処理
  def callback
    # stateが一致しない場合、不正なアクセスとして止める
    unless params[:state] == session.delete(:line_login_state)
        redirect_to root_path, alert: "LINE連携に失敗しました。もう一度お試しください。"
        return
  end

  # LINEから返ってきた認可コード
  code = params[:code]

  # 認可コードをアクセストークン・IDトークンに交換する
  token_response = fetch_line_token(code)
  access_token = token_response["access_token"]
  id_token = token_response["id_token"]

  # IDトークンを検証し、LINEユーザーIDを取得する
  profile = verify_id_token(id_token)
  line_user_id = profile["sub"]

  # 公式LINEを友達追加しているか確認する
  friendship_status = fetch_friendship_status(access_token)
  line_friend = friendship_status["friendFlag"]

  # RailsのログインユーザーにLINE情報を保存する
  current_user.update!(
    line_user_id: line_user_id,
    line_friend: line_friend,
    line_notifications_enabled: line_friend
  )

  redirect_to line_connection_path, notice:"LINE連携が完了しました"
  rescue => e
    Rails.logger.error("[LINE Login Error] #{e.class}: #{e.message}")
    redirect_to line_connection_path, alert: "LINE連携に失敗しました"
  end

  private

  # 認可コードをLINEのアクセストークンに交換する
  def fetch_line_token(code)
    uri = URI.parse("https://api.line.me/oauth2/v2.1/token")
    response = Net::HTTP.post_form(
      uri,
      {
        grant_type: "authorization_code",
        code: code,
        redirect_uri: ENV.fetch("LINE_LOGIN_CALLBACK_URL"),
        client_id: ENV.fetch("LINE_LOGIN_CHANNEL_ID"),
        client_secret: ENV.fetch("LINE_LOGIN_CHANNEL_SECRET")
      }    
    )
    JSON.parse(response.body)
  end

  # IDトークンを検証して、LINEユーザー情報を取得する
  def verify_id_token(id_token)
    uri = URI.parse("https://api.line.me/oauth2/v2.1/verify")
    response = Net::HTTP.post_form(
      uri,
      {
        id_token: id_token,
        client_id: ENV.fetch("LINE_LOGIN_CHANNEL_ID")
      }
    )

    JSON.parse(response.body)
  end

  # 公式LINEを友達に追加しているか確認する
  def fetch_friendship_status(access_token)
    uri = URI.parse("https://api.line.me/friendship/v1/status")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{access_token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

  JSON.parse(response.body)
  end
end
