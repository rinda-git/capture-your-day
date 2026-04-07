class Mistake < ApplicationRecord
  belongs_to :journal
  belongs_to :user
  validates :original_text, presence: true
end
