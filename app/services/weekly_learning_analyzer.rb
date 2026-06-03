# 1週間分の学習候補からAIで最大3つ選ぶ
class WeeklyLearningAnalyzer
  MAX_CANDIDATES = 50
  # 直近1週間の日記を対象に、ユーザーが学んだ表現を抽出するサービスクラス
  def initialize(user:, from: 7.days.ago.to_date, to: Date.current)
    @user = user
    @from = from
    @to = to
  end

  def call
    candidates = learning_items.first(MAX_CANDIDATES)
    return { total_count: 0, items: [] } if candidates.blank?

    {
      total_count: candidates&.size,
      items: select_items_with_ai(candidates)
    }
  rescue => e
    Rails.logger.error("[WeeklyLearningAnalyzer] #{e.class}: #{e.message}")
    {
      total_count: candidates&.size || 0,
      items: candidates.to_a.first(3)
    }
  end


  private

  attr_reader :user, :from, :to

  def learning_items
    mistakes.map.with_index(1) do |mistake, index|
    {
      candidate_id: index,
      date: mistake.journal.posted_date,
      original_text: mistake.original_text,
      corrected_text: mistake.corrected_text,
      explanation: mistake.explanation,
      pattern: mistake.learning_points["pattern"],
      meaning: mistake.learning_points["meaning"],
      review_tag: mistake.learning_points["review_tag"],
      related_phrases: mistake.learning_points["related_phrases"]
    }
    end
  end

  def select_items_with_ai(candidates)
    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "user", content: prompt(candidates) }
        ],
        response_format: { type: "json_object" },
        temperature: 0.7
      }
    )
    raw_response = response.dig("choices", 0, "message", "content")
    result = JSON.parse(raw_response)

    Array(result["items"]).first(3).map do |item|
      {
        candidate_id: item["candidate_id"],
        pattern: item["pattern"],
        meaning: item["meaning"],
        corrected_text: item["corrected_text"],
        grammar_point: item["grammar_point"]
      }
    end
  end

  def prompt(candidates)
    <<~PROMPT
      あなたは日本人英語学習者向けの英語コーチです。

      以下は、ユーザーが今週の日記添削で学んだ候補です。
      この中から、LINEで復習する価値が高いものを最大3つ選んでください。

       今回の目的:
      - 便利フレーズ紹介ではなく、添削前後を比べて「なぜ直すのか」を学べる復習にする
      - 次に同じミスを減らせるようにする

      優先して選ぶ候補:
      - original_text と corrected_text の違いが分かりやすい
      - 文法・語法の説明がしやすい
      - 次の日記でも同じルールを使えそう
      - 日本人学習者が間違えやすい

      特に優先する文法・語法:
      - 動詞の形: to do / doing / 原形
      - 前置詞: in / on / at / to / for / with など
      - 冠詞: a / an / the / 無冠詞
      - 時制: 過去形 / 現在完了 / 現在形
      - 語順
      - 他動詞・自動詞
      - コロケーション

      優先度を下げる候補:
      - original_text と corrected_text の違いが分かりにくいもの
      - 「自然な表現です」以上の説明がしにくいもの
      - その日記でしか使いにくい個人的すぎる内容
      - 長すぎる文


      grammar_point の書き方:
      - grammar_point は「次に自分で使うための文法・ニュアンスメモ」として書いてください
      - 以下のうち、候補に合うものを1〜2文で説明してください
          1. その表現の意味・ニュアンス
          2. 形のルール
          3. 同じルールで使える代表例を1〜3個
      - original_text と corrected_text の違いが明確な場合は、どこをどう直したかも説明してください
      - 「自然な表現です」「便利です」だけの説明は禁止です

      良い grammar_point の例:
      - have been thinking about は、ある時点から今まで考え続けている状態を表します。about など前置詞の後ろに動詞を置くとき
      は、going / studying のように動名詞にします。
      - enjoy の後ろに動詞を置くときは、to do ではなく doing を使います。同じように動名詞が続きやすい動詞には finish /
      avoid / consider などがあります。
      - look forward to の to は前置詞なので、後ろは see ではなく seeing のように動名詞にします。同じ形で be used to + 動名
      詞 も使えます。
      - I wonder if は「〜かなと思う」とやわらかく言いたいときに使います。if の後ろには主語 + 動詞の文を続けます

      悪い grammar_point:
      - 自然な表現です
      - ネイティブらしい表現です
      - 文脈に合っています
      - より自然に聞こえます
      - この表現を覚えると便利です

      出力ルール:
      - JSONのみ返してください
      - items は最大3件
      - candidate_id は、選んだ候補の candidate_id をそのまま返してください
      - 候補にない表現を新しく作らないでください
      - pattern は候補の pattern をそのまま使ってください
      - meaning は候補の meaning をそのまま使ってください
      - corrected_text は候補の corrected_text を基本的に使ってください
      - grammar_point はLINE向けに短く、具体的にしてください
    #{'    '}
        出力形式:
        {
          "items": [
            {
              "candidate_id": "candidate_idの値をそのまま",
              "pattern": "英語表現",
              "meaning": "日本語の意味",
              "corrected_text": "自然な例文",
              "grammar_point": "どこをどう直すと自然になるかを1文で説明",
              "reason": "選んだ理由",
              "usefulness_score": "1-5の数値で、ユーザーにとってどれだけ役立つか"
            }
          ]
        }

        候補:
        #{candidates.to_json}
      PROMPT
    end

  def mistakes
    user.mistakes
        .includes(:journal)
        .joins(:journal)
        .where(journals: { posted_date: from..to })
        .where("learning_points ->> 'pattern' IS NOT NULL")
        .where.not("learning_points ->> 'pattern' = ''")
        .order("journals.posted_date DESC, mistakes.id DESC")
  end
end
