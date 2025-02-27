import React, { Fragment, useEffect, useReducer } from 'react';
import styled from 'styled-components';
import { Link } from "react-router-dom";


// components
import { LocalMallIcon } from '../components/Icons';
import { FoodWrapper } from '../components/FoodWrapper';
import Skeleton from '@mui/material/Skeleton';

// Reducer
import {
  initialState as foodsInitialState,
  foodsActionTypes,
  foodsReducer,
} from '../reducers/foods';

// API
import { fetchFoods } from '../apis/foods';

// images
import MainLogo from '../images/logo.png';
import FoodImage from '../images/food-image.jpg';

// constants
import { COLORS } from '../style_constants';
import { REQUEST_STATE } from '../constants';

const MainLogoImage = styled.img`
  height: 90px;
`

const FoodsList = styled.div`
  display: flex;
  justify-content: space-around;
  flex-wrap: wrap;
  margin-bottom: 50px;
`;

const ItemWrapper = styled.div`
  margin: 16px;
`;

const HeaderWrapper = styled.div`
  display: flex;
  justify-content: space-between;
  padding: 8px 32px;
`;

const BagIconWrapper = styled.div`
  padding-top: 24px;
`;

const ColoredBagIcon = styled(LocalMallIcon)`
  color: ${COLORS.MAIN};
`;

// `Foods` コンポーネント（レストランのフード一覧を表示）
export const Foods = ({ match }) => {
  // `useReducer` を使って `foodsState` を管理
  const [foodsState, dispatch] = useReducer(foodsReducer, foodsInitialState);

  // コンポーネントがマウントされたら API からデータを取得
  useEffect(() => {
    dispatch({ type: foodsActionTypes.FETCHING });  // データ取得開始（ローディング状態にする）

    fetchFoods(match.params.restaurantsId)  // `match.params.restaurantsId`（レストランID）を渡す
      .then((data) => {
        dispatch({
          type: foodsActionTypes.FETCH_SUCCESS,  // データ取得成功時
          payload: {
            foods: data.foods,  // `foodsList` にAPIのデータをセット
          },
        });
      });
  }, [match.params.restaurantsId]);  // 初回のみ実行（`match.params.restaurantsId` が変更されても再取得しない）
  return (
    <Fragment>
      <HeaderWrapper>
        <Link to="/restaurants">
          <MainLogoImage src={MainLogo} alt="main logo" />
        </Link>
        <BagIconWrapper>
          <Link to="/orders">
            <ColoredBagIcon fontSize="large" />
          </Link>
        </BagIconWrapper>
      </HeaderWrapper>
      <FoodsList>
        {
          foodsState.fetchState === REQUEST_STATE.LOADING ?
            <Fragment>
              {
                [...Array(12).keys()].map(i =>
                  <ItemWrapper key={i}>
                    <Skeleton key={i} variant="rect" width={450} height={180} />
                  </ItemWrapper>
                )
              }
            </Fragment>
            :
            foodsState.foodsList.map(food =>
              <ItemWrapper key={food.id}>
                <FoodWrapper
                  food={food}
                  onClickFoodWrapper={(food) => console.log(food)}
                  imageUrl={FoodImage}
                />
              </ItemWrapper>
            )
        }
      </FoodsList>
    </Fragment>
  );
};
