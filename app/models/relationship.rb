class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  #バリデーション定義 followerとfollowedは両方無いとダメ
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
