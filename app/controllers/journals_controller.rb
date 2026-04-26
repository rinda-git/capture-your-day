class JournalsController < ApplicationController
  helper MistakesHelper
  before_action :authenticate_user!
  def index
    # @journals =current_user.journals.order(created_at: :desc)
    @journals =current_user.journals.includes(:journal_correction).order(created_at: :desc)
  end

  def show
    @journal = current_user.journals.find(params[:id])
    # @overall = @journal.mistakes.find_by(mistake_type: "overall")
    # @mistake = @journal.mistakes.first
    # @mistakes = @journal.mistakes.where.not(mistake_type: "overall")
    @journal_correction = @journal.journal_correction
    @mistakes = @journal_correction&.mistakes || []
  end

  def new
    @journal = current_user.journals.new(posted_date: Date.current)
  end

  def create
    @journal = current_user.journals.new(journal_params)
    if @journal.invalid?
      flash.now[:alert] = "ジャーナルの作成に失敗しました"
      render :new, status: :unprocessable_entity
      return
    end

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

    ====================
    REWRITE RULES
    ====================
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
    ====================
    CORRECTION RULES
    ====================
    - Return all important corrections found in the text.
    - Do not skip clear mistakes.

    For each issue, use one mistake_type only:
    grammar
    spelling
    word_choice
    expression
    translation

    For every note, return:
    - original_text
    - corrected_text
    - mistake_type
    - explanation (Japanese)

    GRAMMAR EXPLANATIONS:
    - Be practical and beginner-friendly.
    - Explain what was wrong in THIS sentence.
    - Show how to write it correctly next time.
    - Prefer reusable patterns over abstract grammar labels.
    - Explanations must help the learner write the sentence correctly next time.

    Examples:
    go to + place
    want to + verb
    a + singular noun
    yesterday + past tense
    He/She/It + verb-s

    Good example:
    「前置詞：『部屋へ行く』は go to + place を使います。」
    「時制：yesterday があるので過去形 went を使います。」

    OTHER TYPES:
    - Keep explanations short and clear.
    - Focus on what sounds natural and how to improve.

    - Use this format:
    「ルール名：今回なぜ直すのか。どう考えればよいか。」
      Example: 「時制の誤り：yesterday があるので、現在形ではなく過去形 went を使います。」
      Example: 「主語と動詞の不一致：主語が三人称単数のときは動詞に -s が必要です。」
    - For other mistake types, explain briefly in Japanese.
    - Avoid overexplaining non-grammar issues.

    ====================
    ENGLISH FEEDBACK
    ====================
    Based only on THIS text, return:

    - strengths (what user does well)
    - mistake_patterns (repeated tendencies)
    - advice (one short tip)

    Be honest, helpful, supportive.

    ====================
    INPUT
    ====================
      Input text:
      "#{body}"

    ====================
    OUTPUT JSON ONLY
    ====================
      Do not omit any keys.
      Return Only this JSON format
      Use exactly this structure:
      {
        "rewritten_text": "添削後の英文をここに",
        "notes":[
          {
            "original_text": "元の文章",
            "corrected_text": "正しい表現",
            "mistake_type": "grammar or spelling or word_choice or expression or translation",
            "explanation": "日本語で簡潔な説明"
          }
        ],
      "english_feedback": {
        "strengths": [
        "point": "英語表現上のよかった点",
        "evidence": "元の文または修正文の具体例",
        "why_it_works": "なぜよいのかを日本語で1文"
        ],
        "mistake_patterns": [
          "point": "この文で見られた英語の傾向や弱点を分かりやすく。",
          "evidence": "元の文の具体例",
          "explanation": "このミスがなぜ起きているか、どう直すべきかを日本語で1〜2文。前置詞であればどうすべきか、時制ならどうすべきかなど具体的に"
        ],
        "advice": {
          "point": "この文から言える短い改善アドバイス",
          "evidence": "どのミスを根拠にしているか"
        }
       }
      }

      ====================
      ENGLISH FEEDBACK
      ====================
      Analyze the user's ENGLISH usage only.
      Do NOT comment on emotions, story content, personality, or life situation.
      Focus only on English writing.
      Focus only on:
      - grammar tendencies
      - common mistake patterns
      - vocabulary usage
      - sentence structure
      - naturalness of English
      - If the original input is primarily Japanese, return "strengths": [].

      Return:
      - strengths = what the user does well in English
      - mistake_patterns = repeated English mistakes or weak areas
      - advice = one short practical study tip in Japanese based only on the mistakes in this text
      - If there is not enough evidence, return an empty array.
      - Do not make the feedback overly short.
      - Each explanation should be concrete and specific to this text.
      - Strengths must describe specific English skills shown in THIS text.
      - Avoid generic comments.


      Examples of good strengths:
      - 状況説明の語順が自然です
      - 会話で使える自然な表現を選べています
      - 文の流れが自然です

      Examples of good mistake_patterns:
      - 前置詞が抜けやすいです
      - 時制が混ざりやすいです
      - 冠詞 a / the を忘れやすいです
      - 日本語直訳の語順になりやすいです

      Bad examples:
      - 気持ちがよく伝わります
      - 内容が具体的です
      - 感情表現が豊かです
      - 出来事をよく振り返れています
      - 感情を英語で表現できています
      - 文の流れが自然です

      Examples of advice:
      - 移動を表す go は go to + 場所 を意識すると自然になります。

      Do NOT analyze personality or emotional content.
      Use only this text as evidence.

      If the input contains Japanese text, classify all rewriting choices as "translation" type.
      For each translation note, explain in Japanese why the specific English word or phrase was chosen to express the original Japanese nuance.
      english_feedback must be based only on THIS text.Be practical, modest, and helpful.
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

          temperature: 1.0
        }
      )

      # 5 AIからのJSON応答をパースする
      raw_response = response.dig("choices", 0, "message", "content")
      result = JSON.parse(raw_response)
      Rails.logger.debug "=== result: #{result.inspect}"
      Rails.logger.debug "=== english_feedback: #{result['english_feedback'].inspect}"

      # 6 DBに保存する
      # @journal = current_user.journals.build(
      #   **journal_params  # title, posted_date, mood, body, tone が全部入る
      # )

      if @journal.save

        # 7.添削後の全文をjournal_correctionsに保存する
        # mistakesにデータを保存する
        correction = @journal.create_journal_correction!(
          user_id: current_user.id,
          original_text: body,
          rewritten_text: result["rewritten_text"],
          strengths: result.dig("english_feedback", "strengths"),
          mistake_patterns: result.dig("english_feedback", "mistake_patterns"),
          advice: result.dig("english_feedback", "advice", "point")
        )

        (result["notes"] || []).each do |note|
          correction.mistakes.create!(
            journal: @journal,
            user: current_user,
            original_text: note["original_text"],
            corrected_text: note["corrected_text"],
            mistake_type: note["mistake_type"],
            explanation: note["explanation"]
          )
        end

        # 7. 添削後の全文と各指摘をmistakesに保存する
        # @journal.mistakes.create!(
        #   user_id: current_user.id,
        #   original_text: body,
        #   corrected_text: result["rewritten_text"],
        #   mistake_type: :overall
        #   )

        # 8 個別の指摘をmistakesに1件ずつ保存する
        #   (result["notes"] || []).each do |note|
        #     @journal.mistakes.create!(
        #       user_id: current_user.id,
        #       original_text: note["original_text"],
        #       corrected_text: note["corrected_text"],
        #       mistake_type: note["mistake_type"],
        #       explanation: note["explanation"]
        #   )
        # end
        # 追加
        # @overall = @journal.mistakes.find_by(mistake_type: "overall")
        # @mistakes = @journal.mistakes.where.not(mistake_type: "overall")
        # @english_feedback = result["english_feedback"]



        redirect_to @journal, notice: "添削が完了しました！"
      else
        # Rails.logger.debug "=== journal errors: #{@journal.errors.full_messages}"
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
    params.require(:journal).permit(:title, :posted_date, :mood, :body, :tone)
  end
end
