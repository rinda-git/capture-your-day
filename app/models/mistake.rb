class Mistake < ApplicationRecord
  belongs_to :journal
  belongs_to :user
  belongs_to :journal_correction
  validates :original_text, presence: true

  enum :mistake_type, { overall: 0, grammar: 1, spelling: 2, word_choice: 3, expression: 4, translation: 5 }
end
# tense, present perfect, prepositions, gerunds, infinitives, or word order
