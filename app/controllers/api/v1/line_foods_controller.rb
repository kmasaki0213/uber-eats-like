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

        set_line_food(@ordered_food)  # `@ordered_food` に紐づく LineFood を新しくセット

        if @line_food.save
          render json: { line_food: @line_food }, status: :created  # 201 Created を返す（成功時）
        else
          render json: {}, status: :internal_server_error  # 500 エラーを返す（失敗時）
        end
      end

      def replace
        ActiveRecord::Base.transaction do  # トランザクション開始
          # すでにアクティブな LineFood があり、異なるレストランのものがある場合、それらを無効化（active: false にする）
          LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food|
            line_food.update!(:active, false)  # `update!` で失敗時にロールバック
          end

          set_line_food(@ordered_food)  # `@ordered_food` に紐づく LineFood を新しくセット

          @line_food.save!  # `save!` で保存（失敗時は例外発生）
          render json: { line_food: @line_food }, status: :created  # 201 Created（新しく作成されたリソース）
        end

        rescue ActiveRecord::RecordInvalid  # `update!` や `save!` が失敗した場合
          render json: {}, status: :unprocessable_entity  # 422 Unprocessable Entity

        rescue StandardError => e  # その他の予期しないエラー（データベース障害など）
          render json: { error: "予期しないエラーが発生しました", details: e.message }, status: :internal_server_error  # 500 Internal Server Error
      end

      private

        # 注文する Food を取得し、@ordered_food に格納
        def set_food
          @ordered_food = Food.find(params[:food_id])
        end

        # `@line_food` を作成または更新
        def set_line_food(ordered_food)
          if ordered_food.line_food.present?
            # すでに `LineFood` が存在する場合 → 数量を更新
            @line_food = ordered_food.line_food
            @line_food.attributes = {
              count: ordered_food.line_food.count + params[:count],  # 注文数を加算
              active: true  # `active` を true に設定
            }
          else
            # `LineFood` が存在しない場合 → 新しく作成
            @line_food = ordered_food.build_line_food(
              count: params[:count],  # 注文数を設定
              restaurant: ordered_food.restaurant,  # レストラン情報を紐づけ
              active: true  # `active` を true に設定
            )
          end
        end
    end
  end
end
