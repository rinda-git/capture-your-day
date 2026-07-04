class User < ApplicationRecord
  DAILY_AI_LIMIT = 5
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :journals, dependent: :destroy
  has_many :mistakes, dependent: :destroy
  has_one :notification_setting, dependent: :destroy
  has_many :journal_corrections, dependent: :destroy
  has_one_attached :profile_image, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # お気に入りしたmistakes一覧(user.favoritesを経由して、favoriteに紐づくmistake)
  has_many :favorite_mistakes, through: :favorites, source: :mistake
  has_many :ai_usage_logs, dependent: :destroy
  has_many :web_push_subscriptions, dependent: :destroy

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  validates :name, presence: true

  def total_journal_count
    journals.distinct.count
  end

  def this_month_journal_count
    journals.where(posted_date: Date.current.all_month).distinct.count
  end

  def total_learning_count
    mistakes.joins(:journal)
            .where("learning_points ->> 'pattern' IS NOT NULL")
            .where.not("learning_points ->> 'pattern' = ''")
            .distinct
            .count
  end

  def this_month_learning_count
    mistakes.joins(:journal)
            .where(journals: { posted_date: Date.current.all_month })
            .where("learning_points ->> 'pattern' IS NOT NULL")
            .where.not("learning_points ->> 'pattern' = ''")
            .distinct
            .count
  end

  def streak_dates
    posted_dates = journals.distinct.pluck(:posted_date)

    count = 0
    date = posted_dates.include?(Date.current) ? Date.current : Date.yesterday

    while posted_dates.include?(date)
      count += 1
      date -= 1.day
    end
    count
  end

  def favorite(mistake)
    favorite_mistakes << mistake
  end

  def unfavorite(mistake)
    favorite_mistakes.destroy(mistake)
  end

  def favorite?(mistake)
    favorite_mistakes.exists?(mistake.id)
  end


  def ai_usage_limit_exempt?
    ENV.fetch("AI_LIMIT_EXEMPT_EMAILS", "")
    .split(",")
  end

  def ai_usage_count_today
    ai_usage_logs.where(used_on: Date.current).count
  end

  def ai_usage_limit_reached?
    return false if ai_usage_limit_exempt?
    ai_usage_count_today >= DAILY_AI_LIMIT
  end
  # AIの利用履歴を記録
  def record_ai_usage!
    ai_usage_logs.create!(used_on: Date.current)
  end
end
