class AiUsageLog < ApplicationRecord
  belongs_to :user
  validates :used_on, presence: true
end
