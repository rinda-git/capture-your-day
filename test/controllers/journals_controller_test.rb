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

  test "should get create" do
    get journals_url
    assert_response :success
  end

  test "should get edit" do
    get edit_journal_url(@journal)
    assert_response :success
  end

  test "should get update" do
    get journal_url(@journal)
    assert_response :success
  end

  test "should get destroy" do
    get journal_url(@journal)
    assert_response :success
  end
end
