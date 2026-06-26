class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :mistake

  validates :mistake_id, uniqueness: { scope: :user_id }
end
