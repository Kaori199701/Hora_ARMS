require "test_helper"

class Admins::WorkingHoursControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admins_working_hours_index_url
    assert_response :success
  end

  test "should get edit" do
    get admins_working_hours_edit_url
    assert_response :success
  end
end
