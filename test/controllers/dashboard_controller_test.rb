require 'test_helper'



class DashboardControllerTest < ActionController::TestCase

  test "should not get index" do
    get :index
    assert_response :redirect
  end

end
