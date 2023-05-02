require "test_helper"

class Workers::WorkersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get workers_workers_show_url
    assert_response :success
  end

  test "should get edit" do
    get workers_workers_edit_url
    assert_response :success
  end
end
