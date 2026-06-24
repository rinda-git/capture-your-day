FactoryBot.define do
  factory :mistake do
    association :journal_correction

    journal { journal_correction.journal }
    user { journal_correction.user }

    original_text { "I go to school yesterday." }
    corrected_text { "I went to school yesterday." }
    mistake_type { "grammar" }
    learning_points { { pattern: "past tense" } }
  end
end
