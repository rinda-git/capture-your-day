# 週次LINE配信全体を管理するクラス
class WeeklyReviewBroadcaster
  def initialize(date: Date.current)
    @date = date
  end

  def call
    target_users.find_each do |user|
      deliver_to(user)
    end
  end

  private

  attr_reader :date

  def target_users
    User.where.not(line_user_id: [ nil, "" ])
  end

  def deliver_to(user)
    from = date.prev_week(:monday)
    to = from + 6.days

    result = WeeklyLearningAnalyzer.new(
      user: user,
      from: from,
      to: to
    ).call

    message = WeeklyReviewMessageBuilder.new(
      user: user,
      result: result
    ).call

    return if message.blank?

    LineMessageSender.new(
      user: user,
      message: message
    ).call
  rescue => e
    Rails.logger.error("[WeeklyReviewBroadcaster] user_id=#{user.id} #{e.class}: #{e.message}")
  end
end
