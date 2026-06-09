class JournalCorrectionsController < ApplicationController
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

    @journal_corrections = current_user
                           .journal_corrections
                           .includes(:journal, :mistakes)
                           .joins(:journal)
                           .where(journals: { posted_date: @current_month.all_month })
                           .order("journals.posted_date DESC, journal_corrections.journal_id DESC")
                           .page(params[:page])
                           .per(10)
  end

  def show
    @journal_correction = current_user.journal_corrections.includes(:mistakes, :journal).find(params[:id])
    @journal = @journal_correction.journal

    current_journal_id = @journal_correction.journal_id
    @previous_journal_correction = current_user.journal_corrections
                                  .joins(:journal)
                                  .where("journals.posted_date < ? OR (journals.posted_date = ? AND journals.id < ?)",
                                  @journal_correction.journal.posted_date, @journal_correction.journal.posted_date, @journal_correction.journal_id)
                                  .order("journals.posted_date DESC, journals.id DESC").first
    @next_journal_correction = current_user.journal_corrections
                               .joins(:journal)
                               .where("journals.posted_date > ? OR (journals.posted_date = ? AND journals.id > ?)",
                               @journal_correction.journal.posted_date, @journal_correction.journal.posted_date, @journal_correction.journal_id)
                               .order("journals.posted_date ASC, journal_corrections.journal_id ASC").first
  end
end
