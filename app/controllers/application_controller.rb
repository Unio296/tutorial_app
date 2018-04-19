class ApplicationController < ActionController::Base  #アプリケーションコントローラ
  protect_from_forgery with: :exception
  include SessionsHelper

  private
  
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?                                                         #loginしていない場合
        store_location                                                          #session[:forwarding_url]のURLを記憶
        flash[:danger] = "Please log in."                                       #flashでエラーメッセージを表示
        redirect_to login_url                                                   #ログインページにリダイレクト
      end
    end
end