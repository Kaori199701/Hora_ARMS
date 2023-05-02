require "test_helper"

class Admins::WorkersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admins_workers_new_url
    assert_response :success
  end

  test "should get index" do
    get admins_workers_index_url
    assert_response :success
  end

  test "should get show" do
    get admins_workers_show_url
    assert_response :success
  end

  test "should get edit" do
    get admins_workers_edit_url
    assert_response :success
  end
end
