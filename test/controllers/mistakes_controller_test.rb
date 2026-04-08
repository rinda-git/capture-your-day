require "test_helper"

class MistakesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mistakes_index_url
    assert_response :success
  end

  test "should get show" do
    get mistakes_show_url
    assert_response :success
  end

  test "should get new" do
    get mistakes_new_url
    assert_response :success
  end

  test "should get create" do
    get mistakes_create_url
    assert_response :success
  end

  test "should get destroy" do
    get mistakes_destroy_url
    assert_response :success
  end
end
