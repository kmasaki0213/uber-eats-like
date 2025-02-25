class CreateLineFoods < ActiveRecord::Migration[7.1]
  def change
    create_table :line_foods do |t|
      t.references :food, null: false, foreign_key: true # 商品ID 
      t.references :restaurant, null: false, foreign_key: true # 店舗ID 
      t.references :order, foreign_key: true # 注文ID
      t.integer :count, null: false, default: 0 # 商品の個数
      t.boolean :active, null: false, default: false # active/not activeの状態

      t.timestamps
    end
  end
end
