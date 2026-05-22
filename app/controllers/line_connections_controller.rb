class LineConnectionsController < ApplicationController
  before_action :authenticate_user!
  def show
  end
  # LINE連携ページとして使う
  # 連携コードを発行する
  def create
    current_user.update!(
      line_link_code: SecureRandom.hex(3)
    )
    redirect_to line_connection_path, notice:"連携コードを発行しました"
  end

  def destroy
    current_user.update!(
      line_user_id: nil,
      line_link_code: nil,
      line_notifications_enabled: false
    )
    redirect_to line_connection_path, notice: "LINE連携を解除しました"
  end
end
