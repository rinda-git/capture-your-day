class JournalCorrectionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @journal_corrections = current_user.journal_corrections.includes(:journal, :mistakes).order(created_at: :desc)
  end

  def show
    @journal_correction = current_user.journal_corrections.includes(:mistakes, :journal).find(params[:id])
  end
end
