require "test_helper"

class JournalsControllerTest < ActionDispatch::IntegrationTest
# Deviseのログイン用メソッドをテストで使えるようにする
include Devise::Test::IntegrationHelpers

setup do
  # ① テスト用のユーザーをfixturesから取得する
  @user = users(:one)
  # ② そのユーザーでログインする
  sign_in @user
  # ③ テスト用のジャーナルをfixturesから取得する
  @journal = journals(:one)
end

  test "should get index" do
    get journals_url
    assert_response :success
  end

  test "should get show" do
    get journal_url(@journal)
    assert_response :success
  end

  test "should get new" do
    get new_journal_url
    assert_response :success
  end

  test "should create journal" do
    assert_difference("Journal.count", 1) do
      post journals_url, params: {
        journal: {
          posted_date: Date.today,
          mood: "great",
          title: "test",
          body: "test",
          tone: "tone"
        }
      }
    end
    assert_response :redirect
  end

  test "should get edit" do
    get edit_journal_url(@journal)
    assert_response :success
  end

  test "should update journal" do
    patch journal_url(@journal), params: { 
          journal: { 
            posted_date: @journal.posted_date,
            mood: @journal.nood,
            title: "updated",
            body: @journal.body,
            tone: @journal.tone
            } }
    assert_response :redirect
  end

  test "should destroy journal" do
    assert_difference("Journal.count", -1) do
      delete journal_url(@journal)
    end
    assert_response :redirect
    end
end
