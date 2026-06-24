FactoryBot.define do
  factory :journal_correction do
    association :journal
    # journalに紐づいているuserを使う
    user { journal.user }

    original_text { "I go to school yesterday." }
    rewritten_text { "I went to school yesterday." }
    advice { "昨日なので、動詞は過去形を使いましょう" }
  end
end
