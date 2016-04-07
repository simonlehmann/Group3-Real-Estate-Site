require 'test_helper'

class InfiniteScrollTestControllerTest < ActionController::TestCase
  test "should get infinite_scroll_test" do
    get :infinite_scroll_test
    assert_response :success
  end

end
