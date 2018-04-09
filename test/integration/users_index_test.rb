require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup                                                                     #ユーザ取得
    @user = users(:michael)
    @admin     = users(:michael)                                                #管理者ユーザ
    @non_admin = users(:archer)                                                 #管理者でないユーザ
  end

  test "index including pagination" do                                          #paginationのテスト
    log_in_as(@user)                                                            #@userでログイン
    get users_path                                                              #user一覧ページにアクセス
    assert_template 'users/index'                                               #usersコントローラのindexアクションが呼ばれているか
    assert_select 'div.pagination' , count:2                                    #div paginationクラスが2つあるか
    User.where(activated: true).paginate(page: 1).each do |user|                #１ページ目のuserチェック(activateされているユーザのみ)
      assert_select 'a[href=?]', user_path(user), text: user.name               #userへのリンクとuserへの名前があるか
    end
  end
  
  test "index as admin including pagination and delete links" do                #管理者ユーザの場合、ユーザ一覧のpaginationと削除リンクがうまく表示されているかテスト
    log_in_as(@admin)                                                           #管理者ユーザでログイン
    get users_path                                                              #ユーザ一覧にアクセス
    assert_template 'users/index'                                               #usersコントローラのindexアクションが呼び出されているかどうか
    assert_select 'div.pagination'                                              #div paginationクラスがあるか
    first_page_of_users = User.where(activated: true).paginate(page: 1)         #first_page_of_usersに最初のページのユーザ情報を格納(activateされている人のみ)
    first_page_of_users.each do |user|                                          #first_page_of_usersのユーザを繰り返し
      assert_select 'a[href=?]', user_path(user), text: user.name               #ユーザの名前のリンクがあるか
      unless user == @admin                                                     #管理者ユーザ以外に
        assert_select 'a[href=?]', user_path(user), text: 'delete'              #削除のリンクもあるか
      end
    end
    assert_difference 'User.count', -1 do                                       #削除後、一人ユーザが減るか？
      delete user_path(@non_admin)                                              #@non_adminユーザ削除
    end
  end

  test "index as non-admin" do                                                  #管理者でないユーザのユーザ一覧ページテスト
    log_in_as(@non_admin)                                                       #管理者でないユーザでログイン
    get users_path                                                              #管理者一覧ページにアクセス
    assert_select 'a', text: 'delete', count: 0                                 #削除リンクが無いことを確認
  end
end