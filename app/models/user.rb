class User < ApplicationRecord                                                  #Userモデルに関する属性の定義
  has_many :microposts, dependent: :destroy                                     #複数のmicropostを所有する関連付け、かつユーザが削除された場合micropostsも同時に削除する
  has_many :active_relationships, class_name:  "Relationship",                  #クラス名
                                  foreign_key: "follower_id",                   #外部キー
                                  dependent:   :destroy                         #ユーザが削除された場合Relationshipも削除
  has_many :passive_relationships, class_name:  "Relationship",                 #クラス名
                                   foreign_key: "followed_id",                  #外部キー
                                   dependent:   :destroy                        #ユーザが削除された場合Relationshipも削除
  has_many :following, through: :active_relationships, source: :followed        #「:followingは:followedの集合である」という関連付け
  has_many :followers, through: :passive_relationships, source: :follower       #「:followersは:followerの集合である」という関連付け
  
  attr_accessor :remember_token, :activation_token, :reset_token                #アクセス可能なremember_token, activation_token, reset_tokenを作成

  before_save :downcase_email                                                    #保存前にはemailを小文字に変換
  before_create :create_activation_digest                                       #ユーザ作成前にactivation_digestを生成
  #validationの定義
  validates :name, presence: true ,length: {maximum: 50}                        #name属性は必須かつ50文字以内
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i        #emailの正規表現（emailのフォーマットのようなもの）
  validates :email, presence: true ,length: {maximum: 255},                     #email属性は必須かつ255文字以内
                                    format: { with: VALID_EMAIL_REGEX },        #emailのフォーマットに合致するか
                                    uniqueness: { case_sensitive: false }       #一意性のため（大文字と小文字は区別しない）
 has_secure_password
 validates :password, presence: true, length: { minimum: 6 }, allow_nil: true   #Passwordは必須、６文字以上、だが編集時にはnilを許す
 
 class << self                                                                  #Userクラスで実行されるメソッド
   # 渡された文字列のハッシュ値を返す                                           #テスト用ユーザデータのパスワードを生成するため
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :    #costの定義。コストが高いほどセキュリティ上安全。テストでは最小にする。
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)                                 #ハッシュ化したパスワードを生成（引数はstringがパスワード生データ、cost）
  end
  
  # ランダムなトークンを返す
  def new_token
    SecureRandom.urlsafe_base64                                                 #A–Z、a–z、0–9、"-"、"_"のいずれかの文字 (64種類) からなる長さ22のランダムな文字列
  end
 end                                                                            #Userクラスのメソッドはここまで
 
   # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token                                        #ユーザトークンを生成
    update_attribute(:remember_digest, User.digest(remember_token))             #バリデーションを素通りするためのupdate_attributeを使い、remember_digestにremember_tokenのハッシュ値を格納
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)                                          #引数のremember_tokenはブラウザに保存されていたもので、上記で定義しているものとは別
    digest = send("#{attribute}_digest")                                        #remember_digestかactivation_digestのどちらかを判断するため
    return false if digest.nil?                                                 #引数のremember_tokenがnilならfalseを返す
    BCrypt::Password.new(digest).is_password?(token)                            #おそらくis_password?はremember_tokenをハッシュしてremember_digestと比較して一致したらtrue
  end
 
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)                                     #remember_digestにnilを代入し、cookieでログインできないようにする
  end
  
  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)                #アクティベーション有効化と日時記録
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token                                           #reset_tokenを生成
    #update_attribute(:reset_digest,  User.digest(reset_token))                  #reset_digest属性にハッシュ化したreset_tokenを設定
    #update_attribute(:reset_sent_at, Time.zone.now)                             #reset_sent_atに現在時間を設定
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)  #データベースへの問合せが１回で済む
  end
  
  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
 
   # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago                                               #2時間の期限が切れている場合はtrueを返す
  end
 
   # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
 
   # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
 
 
 private
    # メールアドレスをすべて小文字にする
    def downcase_email
      email.downcase!
    end
    
    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
 
end
