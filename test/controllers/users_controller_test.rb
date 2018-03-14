require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path                                                             #GETリクエストをnewアクションに対して発行 (=送信) せよ。
    assert_response :success                                                    #そうすれば、リクエストに対するレスポンスは[成功]になるはず。
  end

end
