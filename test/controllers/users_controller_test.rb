require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  # Deviseのログインヘルパーを使えるようにする
  include Devise::Test::IntegrationHelpers

  setup do
    # ① テスト用のユーザーをfixturesから取得する
    @user = users(:one)
    # ② そのユーザーでログインする
    sign_in @user
  end

  test "should get show" do
    get user_url
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url
    assert_response :success
  end
end
