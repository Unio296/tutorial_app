require 'test_helper'
#永続セッションのテスト
class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)                                                     #@userにmichaelを取得
    remember(@user)                                                             #@userをremember(@user.remember_digestとcookiesを生成)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user                                            #current_userにちゃんと@userが入っているか
    assert is_logged_in?                                                        #ログインしているか？
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))       #@userのremember_digestを更新すると
    assert_nil current_user                                                     #ちゃんとcurrent_userがnilになるか
  end
end