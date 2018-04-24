class RelationshipsController < ApplicationController
  before_action :logged_in_user

  #フォローの動作のアクション
  def create
    @user = User.find(params[:followed_id])                                     #フォローする対象のユーザをuserに格納
    current_user.follow(@user)                                                  #current_userがuserをフォロー
    respond_to do |format|                                                      #Ajaxリクエストに対応
      format.html { redirect_to @user }
      format.js
    end
  end

  #アンフォロー動作のアクション
  def destroy
    @user = Relationship.find(params[:id]).followed                             #Relationshipモデルでparams[:id]のユーザを返す
    current_user.unfollow(@user)                                                #current_userがuserをアンフォロー
    respond_to do |format|                                                      #Ajaxリクエストに対応
      format.html { redirect_to @user }
      format.js
    end
  end
end