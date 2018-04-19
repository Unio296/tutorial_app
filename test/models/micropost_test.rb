require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)                                                     #user取得
    @micropost = @user.microposts.build(content: "Lorem ipsum")                 #userを使ってmicropostを生成
  end

#userカラムに対するテスト
  #バリデーションのテスト
  test "should be valid" do
    assert @micropost.valid?                                                    #バリデーションを通し、通ればtrue、通らなければfalseが返る
  end

  #user_idが無い投稿のテスト
  test "user id should be present" do
    @micropost.user_id = nil                                                    
    assert_not @micropost.valid?                                                #user_idがない場合は通ってはいけない
  end
  
#contentカラムに対するテスト
  #存在性テスト
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  #140文字以上の投稿のテスト
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end
  
#その他のテスト
  #新しいマイクロポストが最初に来るテスト
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
  
  
end
