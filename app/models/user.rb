class User < ApplicationRecord                                                  #Userモデルに関する属性の定義
  before_save { email.downcase! }                                               #保存前にはemailを小文字に変換
  #validationの定義
  validates :name, presence: true ,length: {maximum: 50}                        #name属性は必須かつ50文字以内
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i        #emailの正規表現（emailのフォーマットのようなもの）
  validates :email, presence: true ,length: {maximum: 255},                     #email属性は必須かつ255文字以内
                                    format: { with: VALID_EMAIL_REGEX },        #emailのフォーマットに合致するか
                                    uniqueness: { case_sensitive: false }       #一意性のため（大文字と小文字は区別しない）
 has_secure_password
 validates :password, presence: true, length: { minimum: 6 }
 
   # 渡された文字列のハッシュ値を返す                                           #テスト用ユーザデータのパスワードを生成するため
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :    #costの定義。コストが高いほどセキュリティ上安全。テストでは最小にする。
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)                                 #ハッシュ化したパスワードを生成（引数はstringがパスワード生データ、cost）
  end
 
end
