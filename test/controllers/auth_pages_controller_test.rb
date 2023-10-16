require "test_helper"

class AuthPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get auth_pages_index_url
    assert_response :success
  end

  test "should get contact" do
    get auth_pages_contact_url
    assert_response :success
  end
end
