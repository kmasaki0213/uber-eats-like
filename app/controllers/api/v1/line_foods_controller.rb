module Api
  module V1
    class LineFoodsController < ApplicationController
      before_action :set_food, only: %i[create, replace]  # createアクション、replaceアクションの前にset_foodアクションを実行

      def index
        line_foods = LineFood.active  # アクティブな (active: true) LineFood のデータを取得
      
        if line_foods.exists?  # もしアクティブな LineFood が1つでも存在する場合
          render json: {
            line_food_ids: line_foods.map { |line_food| line_food.id },  # すべての LineFood の ID を配列として取得
            restaurant: line_foods.first.restaurant,  # 最初の LineFood に紐づくレストラン情報を返す
            count: line_foods.sum { |line_food| line_food[:count] },  # LineFood の合計数を計算
            amount: line_foods.sum { |line_food| line_food.total_amount },  # LineFood の合計金額を計算
          }, status: :ok  # 200 OK を返す
        else
          render json: {}, status: :no_content  # LineFood が存在しない場合は 204 No Content を返す
        end
      end
      

      def create
        # 他のレストランの LineFood が既に存在する場合はエラーを返す
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?
          render json: {
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,  # 既存のレストラン名
            new_restaurant: Food.find(params[:food_id]).restaurant.name,  # 新しく注文しようとしたレストラン名
          }, status: :not_acceptable  # 406エラーを返す
        end

        @line_food = LineFood.find_or_build_by_food!(@ordered_food, params[:count].to_i)  
        @line_food.save!  # ✅ Controller で `save!` して、エラーハンドリングを行う
    
        render json: { line_food: @line_food }, status: :created  # ✅ 201 Created（成功時）
    
        rescue ActiveRecord::RecordInvalid  # ❌ バリデーションエラー
          render json: {}, status: :unprocessable_entity  # 422 Unprocessable Entity
      
        rescue StandardError => e  # ❌ 予期しないエラー
          render json: { error: "予期しないエラーが発生しました", details: e.message }, status: :internal_server_error  # 500 Internal Server Error
      end

      def replace
        @line_food = LineFood.find_or_build_by_food!(@ordered_food, params[:count].to_i)  
        @line_food.save!  # ✅ Controller で `save!` して、エラーハンドリングを行う
    
        render json: { line_food: @line_food }, status: :created  # ✅ 201 Created（成功時）
    
        rescue ActiveRecord::RecordInvalid  # ❌ バリデーションエラー
          render json: {}, status: :unprocessable_entity  # 422 Unprocessable Entity
      
        rescue StandardError => e  # ❌ 予期しないエラー
          render json: { error: "予期しないエラーが発生しました", details: e.message }, status: :internal_server_error  # 500 Internal Server Error
      end

      private

        # 注文する Food を取得し、@ordered_food に格納
        def set_food
          @ordered_food = Food.find(params[:food_id])
        end
    end
  end
end
