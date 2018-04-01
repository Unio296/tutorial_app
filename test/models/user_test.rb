require 'test_helper'

class UserTest < ActiveSupport::TestCase
  #Exampleユーザを作成する
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                         password: "foobar", password_confirmation: "foobar")   #パスワード情報追加(6.39)
  end

  #Exampleユーザの有効性のテスト
  test "should be valid" do
    assert @user.valid?                                                         #valid?がtrueであればOK
  end
  
  #name属性の存在性テスト
  test "name should be present" do
    @user.name = "     "                                                        #name属性に空白を挿入
    assert_not @user.valid?                                                     #nameが空白になったのでvalid?がfalseとなればOK
  end
  
  #email属性の存在性テスト
  test "email should be present" do
    @user.email = "     "                                                       #email属性に空白を挿入
    assert_not @user.valid?                                                     #emailが空白になったのでvalid?がfalseとなればOK
  end
  
  #name属性の長さのテスト
  test "name should not be too long" do                                         
    @user.name = "a" * 51                                                       #aが51文字並ぶユーザ名を設定
    assert_not @user.valid?                                                     #そのnameが有効でなければOK
  end

  #email属性の長さのテスト
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"                                    #aが244文字並ぶemailを設定
    assert_not @user.valid?                                                     #そのemailが有効でなければOK
  end
  
  #有効なemailのテスト
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]                    #有効なメールアドレスリスト
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"           #第２引数でエラーメッセージを表示（どのアドレスでエラーだったのか分かるようにするため）
    end
  end
  
  #無効なemailのテスト
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com,foo@bar..com]        #無効なメールアドレスリスト
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"   #第２引数でエラーメッセージを表示（どのアドレスでエラーだったのか分かるようにするため）
    end
  end
  
  #メールアドレスの一意性のテスト
  test "email addresses should be unique" do
    duplicate_user = @user.dup                                                  #@userをduplicate_userにコピー
    duplicate_user.email = @user.email.upcase                                   #（大文字と小文字の違いが登録できてしまわないかのテストのため）
    @user.save                                                                  #@userを保存
    assert_not duplicate_user.valid?                                            #duplicate_userが有効でなければOK
  end
  
  #保存前にメールアドレスが小文字に変換できているかのテスト
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"                                        #mixed_case_email：大文字小文字が混ざったメールアドレス
    @user.email = mixed_case_email                                              #@userのemailに代入
    @user.save                                                                  #@userを保存
    assert_equal mixed_case_email.downcase, @user.reload.email                  #mixed_case_email.downcaseと@user.emailが同じであればOK
  end
  
  #passwordの存在性テスト
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6                      #半角スペース6文字をパスワードにセット
    assert_not @user.valid?                                                     #有効にならなければOK
  end

  #passwordの最小文字数のテスト
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5                      #aを5文字連ねたパスワードをセット
    assert_not @user.valid?                                                     #有効にならなければOK
  end
  
  #authenticated?メソッドがnilの場合、エラーではなくfalseを返すテスト
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
  
end
