import React from 'react';  // Reactの基本機能をインポート
import './App.css';  // スタイルを適用

// React Routerの機能をインポート
import {
  BrowserRouter as Router,  // ルーティングを可能にするコンポーネント
  Routes,  // ルートの切り替えを行うコンポーネント
  Route,  // ルートごとのコンポーネントを定義
} from "react-router-dom";

// `containers/` にあるページコンポーネントをインポート
import { Restaurants } from './containers/Restaurants.jsx';  // 店舗一覧ページ
import { Foods } from './containers/Foods.jsx';  // フード一覧ページ
import { Orders } from './containers/Orders.jsx';  // 注文ページ

// アプリのメインコンポーネント
function App() {
  return (
    <Router>  {/* ルーティング機能を有効化 */}
      <Routes>  {/* ルートの切り替えを管理 */}

        <Route path="/restaurants"
          element={<Restaurants />}
        />
        <Route path="/foods"
          element={<Foods />}
        />
        <Route path="/orders"
          element={<Orders />}
        />

        <Route exact path="/restaurants/:restaurantsId/foods"
          element={<Foods />}
        />

      </Routes>
    </Router>
  );
}

export default App;  // `App` コンポーネントをエクスポート
