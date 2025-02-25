class CreateFoods < ActiveRecord::Migration[7.1]
  def change
    create_table :foods do |t|
      t.references :restaurant, null: false, foreign_key: true # 店舗のID 
      t.string :name, null: false # 商品名
      t.integer :price, null: false # 商品価格
      t.text :description, null: false # 商品の説明文章

      t.timestamps
    end
  end
end
