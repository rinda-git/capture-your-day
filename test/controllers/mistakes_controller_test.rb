require "test_helper"

class MistakesControllerTest < ActionDispatch::IntegrationTest
# Deviseのログイン用メソッドをテストで使えるようにする
include Devise::Test::IntegrationHelpers

setup do
  # ① テスト用のユーザーをfixturesから取得する
  @user = users(:one)
  # ② そのユーザーでログインする
  sign_in @user
  # ③ テスト用のmistakeをfixturesから取得する
  @mistake = mistakes(:one)
end

  test "should get index" do
    get mistakes_url
    assert_response :success
  end

  test "should get show" do
    get mistakes_url(@mistake)
    assert_response :success
  end

  test "should get new" do
    get new_mistake_url
    assert_response :success
  end
end
