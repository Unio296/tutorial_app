module SessionsHelper
  #渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 永続セッションとしてユーザーを記憶する
  def remember(user)                                                            #userはユーザオブジェクト
    user.remember                                                               #user.rbのrememberメソッドを実行。remember_digest属性に値を生成
    cookies.permanent.signed[:user_id] = user.id                                #暗号化したユーザIDのCookieを作成
    cookies.permanent[:remember_token] = user.remember_token                    #記憶トークンのCookieを作成。
  end
  
  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end
  
  # 現在のsessionが無ければ記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])                                            #sessionがある場合
      @current_user ||= User.find_by(id: user_id)                               #current_userを返す
    elsif (user_id = cookies.signed[:user_id])                                  #sessionがなくてcookiesがある場合
      user = User.find_by(id: user_id)                                          #cookiesのユーザIDに対応するuserを取得
      if user && user.authenticated?(:remember, cookies[:remember_token])       #userが存在して、かつ記憶トークンとremember_digestと一致する場合
        log_in user                                                             #ログインを実行する
        @current_user = user                                                    #current_userにuserを代入
      end
    end
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?                                                                #current_user=nil -> false, current_user!=nil -> true
    !current_user.nil?
  end
  
  # 永続的セッションを破棄する
  def forget(user)
    user.forget                                                                 #サーバ側のremember_digestを削除し、ブラウザ側の既存のremember_tokenではログイン不可にする
    cookies.delete(:user_id)                                                    #ブラウザ側のuser_idのCookieを削除
    cookies.delete(:remember_token)                                             #ブラウザ側のremember_tokenのCookieを削除
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)                                                        #永続セッション無効化
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)                            #session[:forwarding_url]のURLにリダイレクト。またはdefaultにリダイレクト。
    session.delete(:forwarding_url)                                             #session[:forwarding_url]を削除
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?             #session[:forwarding_url]にrequestしたURLを保存
  end
  
end
