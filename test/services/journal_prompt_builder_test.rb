require "test_helper"

class JournalPromptBuilderTest < ActiveSupport::TestCase
  test "learning point requires a complete expression from corrected text" do
    prompt = JournalPromptBuilder.new(
      body: "最近、日記を書いていなかったことに気づいた。",
      tone: "standard"
    ).build

    assert_includes prompt, "one complete, natural English expression copied exactly from corrected_text"
    assert_includes prompt, "Never use Japanese or English placeholders in learning_points.pattern."
    assert_includes prompt, "I realized I haven't been journaling lately."
    assert_includes prompt, "Do not create extra notes merely to reach a target count."
  end
end
