require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup                                                                     #@userと@other_userを用意
    @user       = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should redirect index when not logged in" do                            #ログインしていない状態でのユーザ一覧ページにアクセステスト
    get users_path                                                              #users_pathにアクセス
    assert_redirected_to login_url                                              #ログインurlにリダイレクトするか？
  end
  
  test "should get new" do
    get signup_path                                                             #GETリクエストをnewアクションに対して発行 (=送信) せよ。
    assert_response :success                                                    #そうすれば、リクエストに対するレスポンスは[成功]になるはず。
  end

  #ログインせずにPATCH送信するテスト
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }            #PATCH送信
    assert_not flash.empty?                                                     #flashにエラーメッセージ
    assert_redirected_to login_url                                              #login_urlにリダイレクト
  end

  #Web経由でadminの書き換えがされないかテスト(StrongParameterが正常に動作するか)
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)                                                      #@other_userでログイン
    assert_not @other_user.admin?                                               #@other_userのadminがfalse
    patch user_path(@other_user), params: {
                                    user: { password:              @other_user.password,
                                            password_confirmation: @other_user.password,
                                            admin: true } }                     #admin属性をtrueにしようとするPATCH送信
    assert_not @other_user.reload.admin?                                        #@other_userを再取得し、adminがfalseか確認
  end

  #違うユーザで別のユーザの編集画面にアクセスしようとしたときのテスト
  test "should redirect edit when logged in as wrong user" do                   #ログインしているユーザと違うuserの情報をeditしようとしたときのテスト
    log_in_as(@other_user)                                                      #@other_userでログイン
    get edit_user_path(@user)                                                   #@userのedit_pathにアクセス
    assert_not flash.empty?                                                     #flashでエラーメッセージ表示
    assert_redirected_to root_url                                               #root_urlにリダイレクト
  end
  
  #違うユーザで別のユーザ情報のUPDATEを行おうとしたときのテスト
  test "should redirect update when logged in as wrong user" do                 #ログインしているユーザと違うuserの情報をupdateしようとしたときのテスト
    log_in_as(@other_user)                                                      #@other_userでログイン
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }            #@userをupdateしようとする
    assert_not flash.empty?                                                     #エラーメッセージが表示
    assert_redirected_to root_url                                               #root_urlにリダイレクト
  end

  test "should redirect destroy when not logged in" do                          #ログインなしでdestroyしようとするテスト
    assert_no_difference 'User.count' do                                        #ユーザ削除しても失敗して人数が変わらなければOK
      delete user_path(@user)                                                   #ユーザDELETE
    end
    assert_redirected_to login_url                                              #ログインフォームにリダイレクト
  end

  test "should redirect destroy when logged in as a non-admin" do               #管理者じゃないユーザでdestroyしようとするテスト
    log_in_as(@other_user)                                                      #管理者じゃないユーザでログイン
    assert_no_difference 'User.count' do                                        #ユーザ削除しても失敗して人数が変わらなければOK
      delete user_path(@user)                                                   #ユーザDELETE
    end
    assert_redirected_to root_url                                               #rootにリダイレクトされる
  end
  
  #ログインせずにフォローリストのリンクにアクセスしたときのテスト
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  #ログインせずにフォロワーリストのリンクにアクセスしたときのテスト
  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end