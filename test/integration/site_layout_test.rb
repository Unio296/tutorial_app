require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  #レイアウトのリンクに対するテスト⇒おそらくページ全体の構造に関するテスト
  test "layout links" do
    #rootページのテスト
    get root_path                                                               #GETリクエストをhomeアクションに対して発行 (=送信) せよ。
    assert_template 'static_pages/home'                                         #Homeページが正しいビューを描画しているか確認
    assert_select "title", full_title("")                                       #titleに"Ruby on Rails Tutorial Sample App"が入っているか
    assert_select "a[href=?]", root_path, count: 2                              #root_pathのリンクが2つあるか
    assert_select "a[href=?]", help_path                                        #help_pathのリンクが1つあるか
    assert_select "a[href=?]", about_path                                       #about_pathのリンクが1つあるか
    assert_select "a[href=?]", contact_path                                     #contact_pathのリンクが1つあるか
    #Contactページのテスト
    get contact_path                                                            #GETリクエストをcontactアクションに対して発行 (=送信) せよ。
    assert_select "title", full_title("Contact")                                #titleに"Contact | Ruby on Rails Tutorial Sample App"が入っているか
    #Sign upページのテスト
    get signup_path                                                            #GETリクエストをUsers/newアクションに対して発行 (=送信) せよ。
    assert_select "title", full_title("Sign up")                                #titleに"Sign up | Ruby on Rails Tutorial Sample App"が入っているか
  end
  
  #ログイン後のレイアウトのチェックのためログイン用ユーザ取得
  def setup
    @user       = users(:michael)
  end

  test "layout links when logged in" do
    log_in_as(@user)                                                            #@userでログイン
    get root_path                                                               #rootにアクセス
    assert_template 'static_pages/home'                                          #Homeページが正しいビューを描画しているか確認
    assert_select "a[href=?]", users_path                                       #users_pathのリンクが1つあるか
    assert_select "a[href=?]", user_path(@user)                                 #user_path(@user)のリンクが1つあるか
    assert_select "a[href=?]", edit_user_path(@user)                            #edit_user_path(@user)のリンクが1つあるか
    assert_select "a[href=?]", logout_path                                      #logout_pathのリンクが1つあるか
  end
  
  
end