require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear                                         #初期化？
    @user = users(:michael)                                                     #michaelをテストユーザとする
  end

  test "password resets" do
    get new_password_reset_path                                                 #forgot password?のページに移動
    assert_template 'password_resets/new'                                       #password_resetsコントローラのnewアクションが実行されているか？
    # メールアドレスが無効
    post password_resets_path, params: { password_reset: { email: "" } }        #メールアドレスに何もいれない場合
    assert_not flash.empty?                                                     #flashにエラーメッセージ
    assert_template 'password_resets/new'                                       #password_resetsコントローラのnewアクションが実行されているか？
    # メールアドレスが有効
    post password_resets_path,                                                  
         params: { password_reset: { email: @user.email } }                     #michaelの有効なパスワードでPOST
    assert_not_equal @user.reset_digest, @user.reload.reset_digest              #reset_digestが生成されているかチェック
    assert_equal 1, ActionMailer::Base.deliveries.size                          #メールが1通送信されたか？
    assert_not flash.empty?                                                     #flashにメール送信した通知
    assert_redirected_to root_url                                               #rootにリダイレクト
    # パスワード再設定フォームのテスト
    user = assigns(:user)                                                       #reset_token取得のため
    # メールアドレスが無効
    get edit_password_reset_path(user.reset_token, email: "")                   #無効なメールアドレスからのアクセスの場合
    assert_redirected_to root_url                                               #rootにリダイレクト
    # 無効なユーザー
    user.toggle!(:activated)                                                    #activatedがfalseのユーザとして設定
    get edit_password_reset_path(user.reset_token, email: user.email)           #reset_pathをGET
    assert_redirected_to root_url                                               #rootにリダイレクト
    user.toggle!(:activated)                                                    #activatedをtrueに変更
    # メールアドレスが有効で、トークンが無効
    get edit_password_reset_path('wrong token', email: user.email)              #tokenが無効なアクセス
    assert_redirected_to root_url                                               #rootにリダイレクト
    # メールアドレスもトークンも有効
    get edit_password_reset_path(user.reset_token, email: user.email)           #メールアドレスもreset_tokenも有効なアクセス
    assert_template 'password_resets/edit'                                      #password_resetsコントローラのeditアクション
    assert_select "input[name=email][type=hidden][value=?]", user.email         #隠しフィールドのemailが正しいか
    # 無効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }                #無効なパスワードの設定
    assert_select 'div#error_explanation'                                       #エラーメッセージを表示
    # パスワードが空
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }                       #パスワードが空で設定
    assert_select 'div#error_explanation'                                       #エラーメッセージが表示
    # 有効なパスワードとパスワード確認
    patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }                 #正しい形式のパスワードを設定
    assert_nil user.reload.reset_digest                                        #reset_digestがnilに更新されたか？
    assert is_logged_in?                                                        #自動でログインする
    assert_not flash.empty?                                                     #flashにパスワード変更のメッセージ表示
    assert_redirected_to user                                                   #ユーザページにリダイレクト
  end
  
  #パスワード有効期限切れのテスト
  test "expired token" do
    get new_password_reset_path                                                 #forgot password?のページに移動
    post password_resets_path,                                                  #正しいemailでのPOST
         params: { password_reset: { email: @user.email } }

    @user = assigns(:user)                                                      #reset_token取得のため
    @user.update_attribute(:reset_sent_at, 3.hours.ago)                         #reset_sent_atを3時間前に設定
    patch password_reset_path(@user.reset_token),                               #パスワードPATCH要求を送信
          params: { email: @user.email,
                    user: { password:              "foobar",
                            password_confirmation: "foobar" } }
    assert_response :redirect                                                   #アクション実行結果がredirect
    follow_redirect!                                                            #redirectに従う
    assert_match /expired/i, response.body                                      #response.bodyはHTML本文を全て返す。その文章にexpiredがあるかチェック。
  end
  
end