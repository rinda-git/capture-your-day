class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  # Devise のデフォルトで用意されているカラム（email, password など）以外に、独自のカラム（例：username）を追加したい場合に必要になる設定
  before_action :configure_permitted_parameters, if: :devise_controller?


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end
    # protected
  #   # アカウント更新（編集）時に :username カラムを許可する場合
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  # end
end
