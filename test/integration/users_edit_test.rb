require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do                                                   #ユーザeditが失敗するテスト
    log_in_as(@user)                                                            #@userでログイン
    get edit_user_path(@user)                                                   #editにアクセス
    assert_template 'users/edit'                                                #usersコントローラのeditアクションが実行されている
    patch user_path(@user), params: { user: { name:  "",                        
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }  #失敗するユーザ情報でPATCH

    assert_template 'users/edit'                                                #usersコントローラのeditアクションが実行されている
    #assert_select "div.alert-danger","The form contains 4 errors."               #divタグのalert-dangerのクラスに第２引数のテキストがあるかをチェック
  end
  
  test "successful edit" do                                                     #ユーザeditが成功するテスト
    log_in_as(@user)                                                            #@userでログイン
    get edit_user_path(@user)                                                   #editにアクセス
    assert_template 'users/edit'                                                #usersコントローラのeditアクションが実行されている
    name  = "Foo Bar"                                                           #nameと
    email = "foo@bar.com"                                                       #emailを定義
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }     #nameとemailをPATCH
    assert_not flash.empty?                                                     #flashに更新成功のメッセージが入っているか
    assert_redirected_to @user                                                  #@userにredirectされるか
    @user.reload                                                                #@userを再読み込み
    assert_equal name,  @user.name                                              #nameと
    assert_equal email, @user.email                                             #emailが更新されているか確認
  end
  
  test "should redirect edit when not logged in" do                             #ログインせずに@userのユーザ編集画面に行ったときのテスト
    get edit_user_path(@user)                                                   #@userのedit_user_pathにアクセス
    assert_not flash.empty?                                                     #flashにエラーメッセージがあるか？
    assert_redirected_to login_url                                              #ログインページにリダイレクトされるか？
  end

  test "should redirect update when not logged in" do                           #ログインせずにupdateアクションを実行したときのテスト
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }            #ユーザ編集
    assert_not flash.empty?                                                     #flashにエラーメッセージがあるか？
    assert_redirected_to login_url                                              #ログインページにリダイレクトされるか？
  end
  
  test "successful edit with friendly forwarding" do                            #edit成功したあとの
    get edit_user_path(@user)                                                   #@userの編集ページにアクセスするが、ログインしていないのでログインページに飛ばされる
    assert_equal session[:forwarding_url], edit_user_url(@user)                 #session[:forwarding_url]とedit_user_url(@user)が同じか？
    log_in_as(@user)                                                            #@userでログイン
    assert_nil session[:forwarding_url]                                         #session[:forwarding_url]がnilになったかチェック
    assert_redirected_to edit_user_url(@user)                                   #@userの編集ページにリダイレクト
    name  = "Foo Bar"                                                           #nameを設定
    email = "foo@bar.com"                                                       #emailを設定
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }     #nameとemailをPATCH
    assert_not flash.empty?                                                     #flashに更新成功のメッセージが入っているか
    assert_redirected_to @user                                                  #@userにredirectされるか
    @user.reload                                                                #@userを再読み込み
    assert_equal name,  @user.name                                              #nameと
    assert_equal email, @user.email                                             #emailが更新されているか確認
  end
  
end