class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, unique: true                                      #モデルに保存されるデータがemailで一意性を強制されるようにする
  end
end
