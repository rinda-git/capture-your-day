class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @year = params[:year]&.to_i || Date.current.year
    @month = params[:month]&.to_i || Date.current.month
    @current_month = Date.new(@year, @month, 1)

    previous_month = @current_month.prev_month
    next_month = @current_month.next_month

    @prev_year = previous_month.year
    @prev_month = previous_month.month
    @next_year = next_month.year
    @next_month = next_month.month

    @mistakes = current_user.favorite_mistakes
                .includes(:journal, :journal_correction)
                .where(journals: { posted_date: @current_month.all_month })
                .order("journals.posted_date DESC, mistakes.id DESC")
                .page(params[:page])
                .per(10)
  end

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
