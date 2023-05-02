require "test_helper"

class Workers::HomesControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get workers_homes_top_url
    assert_response :success
  end
end
