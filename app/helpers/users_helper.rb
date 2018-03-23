module UsersHelper
  
    # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, size: 80)                                #userオブジェクトと画像のサイズを引数に設定
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)                   #emailからgravatar_idを生成
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"#プロフィール画像のurl生成
    image_tag(gravatar_url, alt: user.name, class: "gravatar")                  #画像取得
  end
  
end
