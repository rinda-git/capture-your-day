class UsersController < ApplicationController
  def show
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update(user_params)
      redirect_to mypage_path, success: "プロフィールを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    reset_session
    redirect_to unauthenticated_root_path, notice: "退会が完了しました"
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end
end
