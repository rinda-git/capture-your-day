class NotificationSettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @notification_setting = current_user.notification_setting || current_user.create_notification_setting!
  end

  def update
    @notification_setting = current_user.notification_setting || current_user.build_notification_setting

    if @notification_setting.update(notification_setting_params)
      redirect_to notification_setting_path, notice: "リマインダー通知設定を更新しました。"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def notification_setting_params
    params.require(:notification_setting).permit(:reminder_enabled, :notification_time)
  end
end
