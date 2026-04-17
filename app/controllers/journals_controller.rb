class JournalsController < ApplicationController
  before_action :authenticate_user!
  def index
    @journals =current_user.journals.order(created_at: :desc)
    # @journals =current_user.journals.order(created_at: :desc).limit(3)
  end

  def show
    @journal = current_user.journals.find(params[:id])
    @mistake = @journal.mistakes.first
  end

  def new
    @journal = current_user.journals.new
  end

  def create
    @journal = current_user.journals.new(journal_params)

    # tone = params[:tone]
    # result = JournalCorrectionService.new(@journal.body, tone).call

    # #JSONのまま保存
    # @journal.corrected_body = result["corrected_body"]
    # @journal.overall_comment = result["overall_comment"]
    # @journal.correction_points = result["points"] #Jsonbカラム
    # @journal.tone = tone

    if @journal.save
      redirect_to journals_path, success: "ジャーナルが作成されました。"
    else
      flash.now[:alert] = "ジャーナルの作成に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @journal = current_user.journals.find(params[:id])
  end

  def update
    @journal = current_user.journals.find(params[:id])
    if @journal.update(journal_params)
      redirect_to journal_path(@journal), success: "ジャーナルが更新されました。"
    else
      flash.now[:alert] = "ジャーナルの更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @journal = current_user.journals.find(params[:id])
    @journal.destroy
    redirect_to journals_path, success: "ジャーナルが削除されました。", status: :see_other
  end

  private
  def journal_params
    params.require(:journal).permit(:title, :posted_date, :mood, :body)
  end
end
