class CreateLineFoods < ActiveRecord::Migration[7.1]
  def change
    create_table :line_foods do |t|
      t.references :food, null: false, foreign_key: true
      t.references :restaurant, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :count
      t.boolean :active

      t.timestamps
    end
  end
end
