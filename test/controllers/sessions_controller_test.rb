require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  #ログインページのテスト
  test "should get new" do
    get login_path                                                              #ログインページを開く
    assert_response :success                                                    #
  end

end
