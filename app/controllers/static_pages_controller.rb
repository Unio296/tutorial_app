class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build                               #ログインしていればマイクロポストのオブジェクト取得
      @feed_items = current_user.feed.paginate(page: params[:page])             #feedのマイクロポストを取得
    end                    
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
