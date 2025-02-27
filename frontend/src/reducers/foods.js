// 定数をインポート（リクエスト状態の管理用）
import { REQUEST_STATE } from '../constants';

// ✅ `foodsReducer` の初期状態（fetchStateは`INITIAL`、foodsListは空配列）
export const initialState = {
  fetchState: REQUEST_STATE.INITIAL,
  foodsList: [],
};

// ✅ Action Type（アクションの種類を定義）
export const foodsActionTypes = {
  FETCHING: 'FETCHING',
  FETCH_SUCCESS: 'FETCH_SUCCESS'
};

// ✅ Reducer 関数（`state` を更新する処理）
export const foodsReducer = (state, action) => {
  switch (action.type) {
    case foodsActionTypes.FETCHING:  // データ取得中はfetchStateを`LOADING`に変更
      return {
        ...state,
        fetchState: REQUEST_STATE.LOADING,
      };

    case foodsActionTypes.FETCH_SUCCESS:  // データ取得が成功したら fetchStateを`OK` に変更、フードリストを `foodsList` に格納
      return {
        fetchState: REQUEST_STATE.OK,
        foodsList: action.payload.foods,
      };

    default:
      throw new Error();  // 定義されていないアクションが来た場合はエラーを投げる
  }
};
