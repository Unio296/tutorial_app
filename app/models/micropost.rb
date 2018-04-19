class Micropost < ApplicationRecord
  belongs_to :user                                                              #ユーザに所属する関連付け
  default_scope -> { order(created_at: :desc) }                                 #新しい投稿から表示する順序付け
  mount_uploader :picture, PictureUploader                                      #画像投稿用
  validates :user_id, presence: true                                            #user_idの存在性
  validates :content, presence: true, length: { maximum: 140 }                  #contentの存在性と文字数
  validate  :picture_size

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
  
  
  
end
