class CreateRestaurants < ActiveRecord::Migration[7.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.integer :fee
      t.integer :time_required

      t.timestamps
    end
  end
end
