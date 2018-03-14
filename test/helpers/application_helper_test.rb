#app/helpers/application_helper.rbに対するテスト
require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  #full_titleに対するテスト
  test "full title helper" do
    assert_equal full_title,         "Ruby on Rails Tutorial Sample App"        #引数無しでfulltitleを返すか
    assert_equal full_title("Help"), "Help | Ruby on Rails Tutorial Sample App" #引数有りで引数 | fulltitleを返すか
  end
end