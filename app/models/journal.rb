class Journal < ApplicationRecord
  belongs_to :user
  has_many :mistakes, dependent: :destroy

  validates :posted_date, presence: true
  validates :body, presence: true
  validates :title, length: { maximum: 255 }
  validates :tone, presence: true

  enum :mood, { great: 0, good: 1, neutral: 2, bad: 3 }
  enum :tone, { polite: 0, standard: 1, casual: 2 }
end
