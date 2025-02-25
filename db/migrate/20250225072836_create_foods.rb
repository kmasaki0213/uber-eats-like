class CreateFoods < ActiveRecord::Migration[7.1]
  def change
    create_table :foods do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :name
      t.integer :price
      t.text :description

      t.timestamps
    end
  end
end
