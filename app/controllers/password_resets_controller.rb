class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]                       #パスワード再設定有効期限を参照するため
  def new
  end

  def create                                                                    #パスワード再設定メール送信アクション
    @user = User.find_by(email: params[:password_reset][:email].downcase)       #emailから@userを取得
    if @user                                                                    #@userが見つかった場合
      @user.create_reset_digest                                                 #@userのreset_digest生成
      @user.send_password_reset_email                                           #@userのemailにメール送信
      flash[:info] = "Email sent with password reset instructions"              #email送ったメッセージ表示
      redirect_to root_url                                                      #rootにリダイレクト
    else
      flash.now[:danger] = "Email address not found"                            #email見つからないよメッセージ
      render 'new'                                                              #newアクションにrender
    end
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty?                                          # 新パスワードが空文字になっている場合はエラー
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)                                  # 新パスワードを更新する
      log_in @user
      @user.update_attribute(:reset_digest, nil)                                #パスワードを更新後はもう一度更新できないようにreset_digestをnilに。
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'                                                             # 無効なパスワードであれば失敗させる
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:password, :password_confirmation)           #ユーザ情報の更新はパスワードの再設定のみ許す(StrongParameters)
    end
  
    def get_user
      @user = User.find_by(email: params[:email])                               #パスワード再設定ビューのhidden_tagのemailで@userを取得
    end
    
    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))                        #@userが存在かつ、ativatedかつreset_tokenで認証出来た場合以外
        redirect_to root_url                                                    #rootにリダイレクト
      end
    end
    
    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?                                          #user.rb内のpassword_reset_expired?を実行
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
