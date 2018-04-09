class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]       #indexとeditとupdateとdestroyのアクションは実行前にlogged_in_userを実行してログインの有無を確認する
  before_action :correct_user,   only: [:edit, :update]                         #editとupdateのアクションは実行前にlogged_in_userが実行して正しいユーザかどうかを確認する
  before_action :admin_user,     only: :destroy                                 #destroyの前に管理者かどうかチェックするアクション
    
  def index                                                                     #ユーザ一覧ページ用アクション
    @users = User.where(activated: true).paginate(page: params[:page])           #アクティベーションされているユーザ取得(ページ毎のユーザのみ)
  end
  
  def new
    @user = User.new(params[:user])                                             #登録に使うuserを作成
  end
  
  def show                                                                      #ユーザ情報ページ用アクション
    @user = User.find(params[:id])                                              #@user取得
    redirect_to root_url and return unless @user.activated?                     #アクティベートされていなければrootにリダイレクト
  end
  
  def create
    @user = User.new(user_params)                                               #user_paramsで保存する属性を制限
    if @user.save
      @user.send_activation_email                                               #ユーザモデルオブジェクトからメールを送信
      flash[:info] = "Please check your email to activate your account."        #flashでアクティベーションのメッセージ
      redirect_to root_url                                                      #rootにリダイレクト
    else
      render 'new'
    end
  end
  
  def edit                                                                      #ユーザ情報編集ページ

  end
  
  def update
    if @user.update_attributes(user_params)                                     #更新を実行して成功した場合
      flash[:success] = "Profile updated"                                       #flashに成功メッセージ挿入
      redirect_to @user                                                         #@userにリダイレクト
    else
      render 'edit'                                                             #editにrender
    end
  end
  
  def destroy                                                                   #ユーザ削除のアクション
    User.find(params[:id]).destroy                                              #params[:id]のuserを削除
    flash[:success] = "User deleted"                                            #flashに成功メッセージ表示
    redirect_to users_url                                                       #ユーザ一覧ページにリダイレクト
  end
  
  #ここから↓はprivate ... Userコントローラ内部のみで実行されるdef
  private                                                                       

    def user_params                                                             #登録時のuserの属性を制限
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)                      #name, email, password, password_confirmationのみを許可
    end
  
    # beforeアクション

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?                                                         #loginしていない場合
        store_location                                                          #session[:forwarding_url]のURLを記憶
        flash[:danger] = "Please log in."                                       #flashでエラーメッセージを表示
        redirect_to login_url                                                   #ログインページにリダイレクト
      end
    end
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])                                            #現在のuserをparamsで取得
      unless current_user?(@user)                                               #current_userと比較して同じでなければ
        flash[:danger] = "Can't edit other's settings"                          #flashでエラーメッセージを表示
        redirect_to root_url                                                    #root_urlにリダイレクト
      end
    end
  
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?                          #adminユーザでなければrootにリダイレクト
    end
  
end
