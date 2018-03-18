class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name                                                            #nameカラム生成
      t.string :email                                                           #emailカラム生成

      t.timestamps                                                              #created_at,updated_atカラム生成
    end
  end
end
