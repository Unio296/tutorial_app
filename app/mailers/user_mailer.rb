class UserMailer < ApplicationMailer

  def account_activation(user)                                                  #アカウント有効化メール
    @user = user                                                                #user取得
    mail to: user.email, subject: "Account activation"                          #宛先、メールタイトル設定
  end


  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
