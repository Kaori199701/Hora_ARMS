require "test_helper"

class Admins::PdfsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admins_pdfs_index_url
    assert_response :success
  end
end
