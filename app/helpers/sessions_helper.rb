module SessionsHelper
  #渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])                       #@current_userがnilの場合、idでuserを検索。それ以外の場合は@current_userをそのまま返す
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?                                                                #current_user=nil -> false, current_user!=nil -> true
    !current_user.nil?
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
