class JournalCorrection < ApplicationRecord
  belongs_to :journal
  belongs_to :user
  has_many :mistakes, dependent: :destroy

  validates :original_text, presence: true
  validates :rewritten_text, presence: true
end
