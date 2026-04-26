require "test_helper"

class JournalCorrectionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    sign_in @user
    @journal = journals(:one)
    @journal_correction = JournalCorrection.create!(
      journal: @journal,
      user: @user,
      original_text: "Original text",
      rewritten_text: "Rewritten text"
    )
  end

  test "should get index" do
    get journal_corrections_url
    assert_response :success
  end

  test "should get show" do
    get journal_correction_url(@journal_correction)
    assert_response :success
  end
end
