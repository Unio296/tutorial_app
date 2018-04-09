class User < ApplicationRecord                                                  #Userモデルに関する属性の定義

  attr_accessor :remember_token, :activation_token                               #アクセス可能なremember_tokenを作成

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
