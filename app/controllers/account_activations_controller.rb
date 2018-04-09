class AccountActivationsController < ApplicationController
    
  def edit
    user = User.find_by(email: params[:email])                                  #userをemailで取得
    if user && !user.activated? && user.authenticated?(:activation, params[:id])#userが取得でき、かつuserが未アクティベートかつ、authenticated?がtrueの場合
      user.activate                                                             #ユーザモデルオブジェクト経由でアクティベーションtrue
      log_in user                                                               #userでログイン
      flash[:success] = "Account activated!"                                    #flashにアクティベーション成功を表示
      redirect_to user                                                          #userページにリダイレクト
    else
      flash[:danger] = "Invalid activation link"                                #flashにアクティベーション失敗を表示
      redirect_to root_url                                                      #rootにリダイレクト
    end
  end
    
end
