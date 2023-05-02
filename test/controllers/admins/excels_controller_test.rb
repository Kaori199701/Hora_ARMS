require "test_helper"

class Admins::ExcelsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admins_excels_index_url
    assert_response :success
  end
end
