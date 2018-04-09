require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    user = users(:michael)                                                      #michaelでログイン
    user.activation_token = User.new_token                                      #activation_tokenを生成
    mail = UserMailer.account_activation(user)                                  #メール送付？
    assert_equal "Account activation", mail.subject                             #メールのタイトルのテスト
    assert_equal [user.email], mail.to                                          #宛先のテスト
    assert_equal ["noreply@example.com"], mail.from                             #Fromのテスト
    assert_match user.name,               mail.body.encoded                     #ユーザ名のテスト
    assert_match user.activation_token,   mail.body.encoded                     #Activation_tokenのテスト
    assert_match CGI.escape(user.email),  mail.body.encoded                     #エスケープしたメールアドレスのテスト
  end
end