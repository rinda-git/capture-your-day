class JournalCorrectionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @journal_corrections = current_user
                           .journal_corrections
                           .includes(:journal, :mistakes)
                           .joins(:journal)
                           .where(journals: { posted_date: Date.current.all_month })
                           .order("journals.posted_date DESC")
  end

  def show
    @journal_correction = current_user.journal_corrections.includes(:mistakes, :journal).find(params[:id])
  end
end
