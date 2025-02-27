class LineFood < ApplicationRecord
  belongs_to :food
  belongs_to :restaurant
  belongs_to :order, optional: true

  validates :count, numericality: { greater_than: 0 }

  scope :active, -> { where(active: true) }
  scope :other_restaurant, -> (picked_restaurant_id) { where.not(restaurant_id: picked_restaurant_id) }

  def total_amount
    food.price * count
  end

  def self.find_or_build_by_food!(ordered_food, count)
    line_food = ordered_food.line_food || ordered_food.build_line_food  #line_foodがあるならline_food,無いならbuild_line_food
    line_food.assign_attributes(
      count: line_food.persisted? ? line_food.count + count : count,  # すでにあるなら数量を加算
      restaurant: ordered_food.restaurant,  # レストラン情報をセット
      active: true  # `active` を true に設定
    )
    line_food
  end
end
