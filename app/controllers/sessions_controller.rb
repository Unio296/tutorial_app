class SessionsController < ApplicationController
  def new                                                                       #ログインビュー用
    render 'new'                                                                #newビューを表示
  end
  
  def create                                                                    #session作成（ログイン時）
    @user = User.find_by(email: params[:session][:email].downcase)              #emailを小文字に変換したものでユーザを検索
    if @user && @user.authenticate(params[:session][:password])                 #userが存在してかつ、user.authenticateでpasswordを認証できる場合
      if @user.activated?                                                        #さらにuserがアクティベート済みの場合
        log_in @user                                                             #userでログイン
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user) #remember_meをするかどうか
        redirect_back_or @user                                                   #リダイレクト
      else
        message  = "Account not activated. "                                    #「アクティベートされていない」というメッセージ
        message += "Check your email for the activation link."                  #「メールのリンクを確認してください」というメッセージ
        flash[:warning] = message                                               #flashでメッセージを表示
        redirect_to root_url                                                    #rootにリダイレクト
      end
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination'                 #エラーメッセージを表示
      render 'new'
    end
  end
  
  def destroy                                                                   #session削除（ログアウト時）
    log_out if logged_in?                                                       #ログアウト処理 SessionsHelperに定義
    redirect_to root_url                                                        #ルートにリダイレクト
  end
  
end