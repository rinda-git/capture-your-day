require "test_helper"

class JounalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get jounals_index_url
    assert_response :success
  end

  test "should get show" do
    get jounals_show_url
    assert_response :success
  end

  test "should get new" do
    get jounals_new_url
    assert_response :success
  end

  test "should get create" do
    get jounals_create_url
    assert_response :success
  end

  test "should get edit" do
    get jounals_edit_url
    assert_response :success
  end

  test "should get update" do
    get jounals_update_url
    assert_response :success
  end

  test "should get destroy" do
    get jounals_destroy_url
    assert_response :success
  end
end
