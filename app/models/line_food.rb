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

  def self.replace_for_ordered_food!(ordered_food)
    ActiveRecord::Base.transaction do  # トランザクション開始
      # すでにアクティブな LineFood で異なるレストランのものを無効化
      LineFood.active.other_restaurant(ordered_food.restaurant.id).each do |line_food|
        line_food.update!(:active, false)  # `update!` で失敗時にロールバック
      end

      set_line_food(ordered_food)  # `@ordered_food` に紐づく LineFood を新しくセット

      @line_food.save!  # `save!` で保存（失敗時は例外発生）
      line_food
    end
    rescue ActiveRecord::RecordInvalid => e
      raise e  # Controller にエラーを伝えるためにそのまま例外を投げる
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
