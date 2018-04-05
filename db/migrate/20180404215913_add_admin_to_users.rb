class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean, default: false                         #admin属性がdefaultではfalseになるように(default: falseが無いと全員trueになる)
  end
end
