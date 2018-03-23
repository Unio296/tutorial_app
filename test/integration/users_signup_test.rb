require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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
  test "valid signup information" do                                            
    get signup_path                                                             #/signupにアクセス
    assert_difference 'User.count' do                                           #登録が成功してUser.countが変わればＯＫ
      post signup_path,params: { user: { name: "Exlample User",                 
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "password"}}     #有効なuser登録を行う
    end
    follow_redirect!                                                            #リダイレクトが行われる
    assert_template 'users/show'                                                #userのshowアクションが呼ばれる
    assert_not flash.nil?                                                       #flashが空でなければＯＫ
  end
end