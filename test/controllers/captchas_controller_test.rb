require "test_helper"

class CaptchasControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get captchas_index_url
    assert_response :success
  end
end
