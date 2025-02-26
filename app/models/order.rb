class Order < ApplicationRecord
  has_many :line_foods

  validates :total_price, numericality: { greater_than: 0 }

  # line_foods（配列）を受け取り、関連データを更新して保存するメソッド
  def save_with_update_line_foods!(line_foods)  
    ActiveRecord::Base.transaction do  # トランザクション開始（全て成功しないとデータが保存されない）
      self.save!  # self（現在の Order インスタンス）を保存
      line_foods.each do |line_food| 
        line_food.update!(active: false, order: self)  # 各 line_food の active を false にし、order（self）に関連付ける
      end
    end  # トランザクション終了（全て成功すればコミット、エラーがあればロールバック）
  end  
  rescue ActiveRecord::RecordInvalid => e
      raise e  # Controller にエラーを伝えるためにそのまま例外を投げる
end
