require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear                                         
  end

  #signup失敗テスト
  test "invalid signup information" do                                          
    get signup_path                                                             #/signupにアクセス
    assert_no_difference 'User.count' do                                        #登録が失敗するのでUser.countが変わらなければＯＫ
      post signup_path, params: { user: { name:  "",                             
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }       #nameが空欄かつパスワード入力をミスのユーザを作成しようとする
    end
    assert_template 'users/new'                                                 #登録失敗後、newアクションが呼ばれているはずなのでそのテスト
    
    #エラーメッセージのテスト
    assert_select 'div#error_explanation'                                       #error_explanationというidがある
    assert_select 'div.alert'                                                   #alertというclassがある
    
    #登録失敗後のフォームテスト
    assert_select 'form[action="/signup"]'
  end
  
  #signup成功テスト
  test "valid signup information with account activation" do                                            
    get signup_path                                                             #/signupにアクセス
    assert_difference 'User.count' do                                           #登録が成功してUser.countが変わればＯＫ
      post users_path,params: { user: { name: "Exlample User",                 
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "password"}}     #有効なuser登録を行う
    end
     assert_equal 1, ActionMailer::Base.deliveries.size                         #配信されたメッセージが1つであるか確認
    user = assigns(:user)                                                       #インスタンス変数にアクセスするためassign
    assert_not user.activated?                                                  #userがアクティベートされていない状態かどうか確認
    assert user.activated_at.nil?                                               #activated_atがnilになっているか
    # 有効化していない状態でログインしてみる
    log_in_as(user)                                                             #userでログイン
    assert_not is_logged_in?                                                    #ログインが通らないことを確認
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)        #不正なトークンでアクティベーションを行う
    assert_not is_logged_in?                                                    #ログインが通らないことを確認
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')     #メールアドレスが不正なものでアクティベーションを行う
    assert_not is_logged_in?                                                    #ログインが通らないことを確認
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)  #正しいアクティベーションを行う
    assert user.reload.activated?                                               #userをリロードして、正常にアクティベーションフラグが立ったかを確認
    assert_not user.reload.activated_at.nil?                                    #activated_atにnilではなく日付が入っているか
    follow_redirect!                                                            #リダイレクトが行われる
    assert_template 'users/show'                                                #userのshowアクションが呼ばれる
    assert is_logged_in?                                                        #ログインもしているかチェック is_logged_in?はtest_helper内で定義
    assert_not flash.nil?                                                       #flashが空でなければＯＫ

  end
end