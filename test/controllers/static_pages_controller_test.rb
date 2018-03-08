require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  #サイトタイトル定義
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  
  #rootページに関するテスト
  test "should get root" do
    get root_url                #GETリクエストをrootに対して発行 (=送信) せよ。
    assert_response :success    #そうすれば、リクエストに対するレスポンスは[成功]になるはず。
  end
  
  #homeページに関するテスト
  test "should get home" do
    get static_pages_home_url   #GETリクエストをhomeアクションに対して発行 (=送信) せよ。
    assert_response :success    #そうすれば、リクエストに対するレスポンスは[成功]になるはず。
    assert_select "title", "Home | #{@base_title}"   #タイトルタグチェック
  end
  #helpページに関するテスト
  test "should get help" do     
    get static_pages_help_url   #GETリクエストをhelpアクションに対して発行 (=送信) せよ。
    assert_response :success    #そうすれば、リクエストに対するレスポンスは[成功]になるはず。
    assert_select "title", "Help | #{@base_title}"   #タイトルタグチェック
  end

    #aboutページに関するテスト
  test "should get about" do     
    get static_pages_about_url   #GETリクエストをaboutアクションに対して発行 (=送信) せよ。
    assert_response :success    #そうすれば、リクエストに対するレスポンスは[成功]になるはず。
    assert_select "title", "About | #{@base_title}"    #タイトルタグチェック
  end
  
      #contactページに関するテスト
  test "should get contact" do     
    get static_pages_contact_url   #GETリクエストをcontactアクションに対して発行 (=送信) せよ。
    assert_response :success    #そうすれば、リクエストに対するレスポンスは[成功]になるはず。
    assert_select "title", "Contact | #{@base_title}"    #タイトルタグチェック
  end
end