class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    # mistakes テーブル全体から、指定されたidのMistakeを1件探す
    @mistake = Mistake.find(params[:mistake_id])
    # ログイン中のユーザーが、そのmistakeをお気に入りする
    current_user.favorite(@mistake)
    # redirect_back fallback_location: mistakes_path
  end

  def destroy
    # 「ログイン中ユーザーが作成したmistakesの中から、指定されたidのMistakeを探す
    @mistake = current_user.mistakes.find(params[:mistake_id])
    current_user.unfavorite(@mistake)
    # redirect_back fallback_location: mistakes_path
  end
end
