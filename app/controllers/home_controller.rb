class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @journals = current_user.journals.order(posted_date: :desc).limit(3)
    @monthly_count = current_user.journals.where(posted_date: Date.current.beginning_of_month..Date.current.end_of_month).count
  end
end
