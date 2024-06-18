require "test_helper"

class MyAnimeListControllerTest < ActionDispatch::IntegrationTest
  test "should get oauth_callback" do
    get my_anime_list_oauth_callback_url
    assert_response :success
  end
end
