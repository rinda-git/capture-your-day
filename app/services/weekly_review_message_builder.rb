
# LINE用メッセージ本文を作る
class WeeklyReviewMessageBuilder
  def initialize(user:, result:)
    @user = user
    @total_count = result[:total_count]
    @items = result[:items].first(3)
  end

  def call
    return nil if items.blank?

    lines = []
    lines << "#{user.name}さん、今週もお疲れさまです😊"
    lines << "この1週間で学んだフレーズは#{total_count}個です🎉その中でも次も使いやすい表現をピックアップしました。"
    lines << ""
    lines << "【今週学んだ表現】"

    items.each.with_index(1) do |item, index|
      lines << "#{index}. #{item[:pattern]}"
      lines << "【意味】#{item[:meaning]}" if item[:meaning].present?
      lines << "【添削後】"
      lines << item[:corrected_text].to_s
      lines << "【ポイント】"
      lines << item[:grammar_point].to_s
    end
      lines << ""
      lines << "他の表現も復習する："
      lines << "https://capture-your-day.onrender.com/journal_corrections"

  lines.join("\n").strip
  end

  private

  attr_reader :user, :total_count, :items
end
