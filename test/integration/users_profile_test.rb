require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

#プロフィール表示のテスト
  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    
    #followingとfollowersの表示テスト
    #構造テスト
    assert_select 'div.stats strong#following.stat'
    assert_select 'div.stats strong#followers.stat'
    #数テスト
    assert_select 'strong#following.stat', @user.following.count.to_s
    assert_select 'strong#followers.stat', @user.followers.count.to_s
    
  end
end