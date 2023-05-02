require "test_helper"

class Workers::AttendancesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get workers_attendances_index_url
    assert_response :success
  end

  test "should get show" do
    get workers_attendances_show_url
    assert_response :success
  end

  test "should get edit" do
    get workers_attendances_edit_url
    assert_response :success
  end
end
