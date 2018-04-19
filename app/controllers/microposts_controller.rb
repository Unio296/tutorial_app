class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]                      #継承しているApplicationControllerにlogged_in_userがあるので利用できる
  before_action :correct_user,   only: :destroy                                 #destroyする際、ユーザが該当のマイクロポストを保有しているか確認

  def create
    @micropost = current_user.microposts.build(micropost_params)                #入力したmicropostを作成
    if @micropost.save                                                          #micropostを保存
      flash[:success] = "Micropost created!"                                    #flashに成功メッセージ
      redirect_to root_url                                                      #rootにリダイレクト
    else                                                                        #保存できなかった場合
      @feed_items = []
      render 'static_pages/home'                                                #homeアクションでrender
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_back(fallback_location: root_url)                                  #redirect_back(fallback_location: root_url)はDELETEリクエストが発行されたページに戻す
  end

  private

    def micropost_params                                                        #micropostのためのStrongParameter
      params.require(:micropost).permit(:content, :picture)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])             #削除するmicropostがcurrent_userが保有しているか確認
      redirect_to root_url if @micropost.nil?
    end
    
end