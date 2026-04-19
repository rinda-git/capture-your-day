class JournalsController < ApplicationController
  before_action :authenticate_user!
  def index
    @journals =current_user.journals.order(created_at: :desc)
  end

  def show
    @journal = current_user.journals.find(params[:id])
    @overall = @journal.mistakes.find_by(mistake_type: "overall")
    @mistake = @journal.mistakes.first
    @mistakes = @journal.mistakes.where.not(mistake_type: "overall")
  end

  def new
    @journal = current_user.journals.new
  end

  def create
    # @journal = current_user.journals.new(journal_params)
    # Rails.logger.debug "=== journal_params: #{journal_params.inspect}"
    # 1 フォームから本文の文字列を受け取る
    body = params[:journal][:body]
    tone = params[:journal][:tone]

    raise "tone is nil!" if tone.blank?

    # 2 AIへの指示(プロンプト)を作成する

    prompt = <<~PROMPT
    You are a bilingual Japanese-English writing coach and a native speaker of American English.

    The user may write in Japanese or English.

    Your job is to REWRITE the user's message into natural, emotionally authentic American English without changing the original meaning.

    Important:
    - Do NOT translate literally.
    - Do NOT preserve awkward wording.
    - Preserve the original meaning, emotional nuance, and timeline.
    - Do not over-specify what is only implied.
    - If the original text is vague, keep it naturally vague.
    - Do not move motives from one event to another.
    - Rewrite into natural American English a real person would use.
    - Understand Japanese nuance deeply before rewriting into natural American English.
    - Preserve the original meaning, emotional nuance, and timeline.
    - If the text is in Japanese, follow the flow of the original Japanese writing and rewrite the intended meaning into natural American English.
    #{' '}
    Tone:
    polite:
    Calm, thoughtful, emotionally mature natural American English.
    Kind, steady, and respectful.
    Slightly polished, but still simple and human.
    Use everyday vocabulary, not formal or fancy words.
    Gentle emotional restraint.
    Longer smooth sentences are okay.
    Reserved emotional tone.

    standard:
    Warm, natural everyday American English.
    Honest, balanced, believable.
    Like a real native American writing privately.
    Default natural tone.


    casual:
    Warm, relaxed, conversational natural American English.
    More spontaneous and emotionally close.
    Use simple wording and natural flow.
    Simple wording should not oversimplify meaning.
    More immediate and human.


    Current tone: #{tone}

    Correction Rules:
    - Return ALL corrections without any limit on the number.
    - Include EVERY grammar, spelling, word_choice, expression, and translation issue found.
    - Do NOT summarize or skip any issues, even if the text is long.
    - Do NOT stop at 3, 5, or any fixed number. Return every single issue.
    - For each issue, classify it using exactly one of these mistake_type values:
        "grammar"     : 文法の誤り
        "spelling"    : スペルの誤り
        "word_choice" : 単語選択の誤り
        "expression"  : 不自然な言い回し
        "translation" : 日本語から英語への翻訳ポイント
    - Explain each issue briefly in Japanese.
    - Avoid overexplaining grammar.

      Input text:
      "#{body}"

      Return Only this JSON format:
      {
        "rewritten_text": "添削後の英文をここに",
        "notes":[
          {
            "original_text": "元の文章",
            "corrected_text": "正しい表現",
            "mistake_type": "grammar or spelling or word_choice or expression or translation",
            "explanation": "日本語で簡潔な説明"
          }
        ]
      }

      If the input is Japanese, return translation notes explaining key phrasing choices.
      key translation choices (e.g. why a particular word or phrase was chosen).
      If there are no notes, return "notes": []
      PROMPT

      # 3 OpenAI APIクライアントを初期化する
      client = OpenAI::Client.new

      # 4 APIにリクエストを送信する
      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [ { role: "user", content: prompt } ],
          response_format: { type: "json_object" },

          temperature: 0.7
        }
      )

      # 5 AIからのJSON応答をパースする
      raw_response = response.dig("choices", 0, "message", "content")
      result = JSON.parse(raw_response)

      # 6 DBに保存する
      @journal = current_user.journals.build(
        **journal_params  # title, posted_date, mood, body, tone が全部入る
      )

      if @journal.save

        # 7. 添削後の全文と各指摘をmistakesに保存する
        @journal.mistakes.create!(
          user_id: current_user.id,
          original_text: body,
          corrected_text: result["rewritten_text"],
          mistake_type: :overall
          )

          # 8 個別の指摘をmistakesに1件ずつ保存する
          (result["notes"] || []).each do |note|
            @journal.mistakes.create!(
              user_id: current_user.id,
              original_text: note["original_text"],
              corrected_text: note["corrected_text"],
              mistake_type: note["mistake_type"],
              explanation: note["explanation"]
          )
        end

        redirect_to @journal, notice: "添削が完了しました！"
      else
        # Rails.logger.debug "=== journal errors: #{@journal.errors.full_messages}"
        flash.now[:alert] = "ジャーナルの作成に失敗しました。"
        render :new, status: :unprocessable_entity
      end
    end

  # tone = params[:tone]
  # result = JournalCorrectionService.new(@journal.body, tone).call

  # #JSONのまま保存
  # @journal.corrected_body = result["corrected_body"]
  # @journal.overall_comment = result["overall_comment"]
  # @journal.correction_points = result["points"] #Jsonbカラム
  # @journal.tone = tone

  #   if @journal.save
  #     redirect_to journals_path, success: "ジャーナルが作成されました。"
  #   else
  #     flash.now[:alert] = "ジャーナルの作成に失敗しました。"
  #     render :new, status: :unprocessable_entity
  #   end
  # end

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
    params.require(:journal).permit(:title, :posted_date, :mood, :body, :tone)
  end
end
