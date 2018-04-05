class SessionsController < ApplicationController
  def new                                                                       #ログインビュー用
    render 'new'                                                                #newビューを表示
  end
  
  def create                                                                    #session作成（ログイン時）
    @user = User.find_by(email: params[:session][:email].downcase)               #emailを小文字に変換したものでユーザを検索
    if @user && @user.authenticate(params[:session][:password])                   #userが存在してかつ、user.authenticateでpasswordを認証できる場合
      log_in @user                                                               # ユーザーログイン後にユーザー情報のページにリダイレクトする
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)     #チェックボックスがチェックされているときrememberする
      redirect_back_or @user                                                     #session[:forwarding_url]のURLにリダイレクト
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