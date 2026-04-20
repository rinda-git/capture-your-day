module MistakesHelper
  def mistake_type_label(mistake_type)
    case mistake_type.to_s
    when "grammar" then "grammar(文法)"
    when "spelling" then "spelling(スペル)"
    when "word_choice" then "word choice(単語選択)"
    when "expression" then "expression(表現)"
    when "translation" then "translation(翻訳)"
    when "overall" then "overall(全体)"
    else mistake_type
    end
  end
end
