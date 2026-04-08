class Journal < ApplicationRecord
  belongs_to :user
  has_many :mistakes, dependent: :destroy

  validates :posted_date, presence: true
  validates :body, presence: true
  validates :title, length: { maximum: 255 }

  enum :mood, { great: 0, good: 1, neutral: 2, bad: 3 }
end
