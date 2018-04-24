require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,           #michaelがarcherををフォロー
                                     followed_id: users(:archer).id)
  end

  test "should be valid" do
    assert @relationship.valid?                                                 #@relationshipが有効か確認
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil                                             #follower_idをnilにする
    assert_not @relationship.valid?                                             #@relationshipが無効か確認
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil                                             #followed_idをnilにする
    assert_not @relationship.valid?                                             #@relationshipが無効か確認
  end
end