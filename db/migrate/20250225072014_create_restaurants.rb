class CreateRestaurants < ActiveRecord::Migration[7.1]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false # 店舗名
      t.integer :fee, null: false, default: 0 # 配送手数料
      t.integer :time_required, null: false  # 配送にかかる時間

      t.timestamps
    end
  end
end
