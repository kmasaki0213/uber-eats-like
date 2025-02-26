import React from 'react';  // Reactの基本機能をインポート
import './App.css';  // スタイルを適用

// React Routerの機能をインポート
import {
  BrowserRouter as Router,  // ルーティングを可能にするコンポーネント
  Switch,  // ルートの切り替えを行うコンポーネント
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
      <Switch>  {/* ルートの切り替えを管理 */}

        {/* 店舗一覧ページ（"/restaurants" にアクセスしたとき） */}
        <Route exact path="/restaurants">
          <Restaurants />
        </Route>

        {/* フード一覧ページ（"/foods" にアクセスしたとき） */}
        <Route exact path="/foods">
          <Foods />
        </Route>

        {/* 注文ページ（"/orders" にアクセスしたとき） */}
        <Route exact path="/orders">
          <Orders />
        </Route>

        <Route exact path="/restaurants/:restaurantsId/foods"
          render={({ match }) =>
            <Foods match={match} />
          }
        />

      </Switch>
    </Router>
  );
}

export default App;  // `App` コンポーネントをエクスポート
