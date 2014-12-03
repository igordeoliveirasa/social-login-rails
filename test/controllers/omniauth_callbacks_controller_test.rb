require 'test_helper'


class OmniauthCallbacksControllerTest < ActionController::TestCase

  test "should get index" do
    user = User.new
    user.provider = "ae"
    user.uid = "aeee"
    request.env["omniauth.auth"] = user
    get :facebook
    assert_response :success
  end

end