class UsersController < ApplicationController
  def new
    @user = User.new(params[:user])                                               #登録に使うuserを作成
  end
  
  def show                                                                      #ユーザ情報ページ用アクション
    @user = User.find(params[:id])                                              #@user取得
  end
  
  def create
    @user = User.new(user_params)                                               #user_paramsで保存する属性を制限
    if @user.save
      flash[:success] = "Welcome to the Sample App!"                            #登録成功時のflash挿入
      redirect_to @user                                                         #@userのページにリダイレクト
    else
      render 'new'
    end
  end
  
  #ここから↓はprivate ... Userコントローラ内部のみで実行されるdef
  private                                                                       

    def user_params                                                             #登録時のuserの属性を制限
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)                      #name, email, password, password_confirmationのみを許可
    end
  
end
