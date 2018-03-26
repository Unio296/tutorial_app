require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  #テストユーザログイン用
  def setup
    @user = users(:michael)
  end
  
  #無効なログイン情報でのテスト
  test "login with invalid information" do
    get login_path                                                              #ログインページにアクセス
    assert_template 'sessions/new'                                              #sessionsコントローラのnewアクションが実行されている
    post login_path, params: { session: { email: "", password: "" } }           #ログイン情報になにもいれずにPOST実行
    assert_template 'sessions/new'                                              #ログインページにリダイレクトされる
    assert_not flash.empty?                                                     #flashにエラーメッセージが表示される
    get root_path                                                               #rootページにアクセス
    assert flash.empty?                                                         #flashのエラーメッセージが消える
  end
  
  #ログインしてからログアウトまでのテスト
  test "login with valid information followed by logout" do
    get login_path                                                              #ログインページにアクセス
    post login_path, params: { session: { email:    @user.email,                #有効なemailと
                                          password: 'password' } }              #有効なパスワードでログイン
    assert is_logged_in?                                                        #ログインできているかチェック
    assert_redirected_to @user                                                  #リダイレクト先が正しいかチェック
    follow_redirect!                                                            #リダイレクト先のページに移動する
    assert_template 'users/show'                                                #先のページがUsersコントローラのshowアクションが呼ばれているか
    assert_select "a[href=?]", login_path, count: 0                             #ログインへのリンクが無くなっているか
    assert_select "a[href=?]", logout_path                                      #ログアウトのリンクがあるか
    assert_select "a[href=?]", user_path(@user)                                 #ユーザページへのリンクがあるか
    get logout_path                                                             #ログアウト                                   ※注　Tutorialではdeleteだったが通らなかったのでgetに
    assert_not is_logged_in?                                                    #非ログイン状態かチェック
    assert_redirected_to root_url                                               #リダイレクト先がルートかチェック
    follow_redirect!                                                            #リダイレクト先のページに移動
    assert_select "a[href=?]", login_path                                       #ログインのリンクがあるか
    assert_select "a[href=?]", logout_path,      count: 0                       #ログアウトのリンクが無くなっているか
    assert_select "a[href=?]", user_path(@user), count: 0                       #ユーザページへのリンクが無くなっているか
  end
end
