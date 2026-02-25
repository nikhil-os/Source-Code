import axios from "axios";

import {
  GET_DASHBOARD,
  GET_ANALYTIC,
  OPEN_DASHBOARD_TOAST,
  GET_COUNTRY_WISE_USER,
  MOVIE_SERIES_ANACLITIC_DATA,
} from "./dashboard.type";
import { api } from "../..";

//get dashboard
export const getDashboard = () => (dispatch) => {
  api
    .get("dashboard/admin")
    .then((res) => {
      dispatch({ type: GET_DASHBOARD, payload: res.data.dashboard });
    })
    .catch((error) => console.log(error));
};

//get user Revenue analytic
export const getAnalytic = (type, start, end) => (dispatch) => {
  
  api
    .get(
      `dashboard/userAnalytic?type=${type}&startDate=${start}&endDate=${end}`
    )
    .then((res) => {
      if (res.status) {
       
        dispatch({ type: GET_ANALYTIC, payload: res.data.analytic });
      } else {
        dispatch({
          type: OPEN_DASHBOARD_TOAST,
          payload: { data: res.message },
        });
      }
    })
    .catch((error) => {
      console.log("error", error.message);
    });
};

export const getMovieSeriesAnalytic = (chartType, start, end) => (dispatch) => {
  api
    .get(
      `dashboard/movieAnalytic?type=${chartType}&startDate=${start}&endDate=${end}`
    )
    .then((res) => {
      if (res.status) {
       
        dispatch({
          type: MOVIE_SERIES_ANACLITIC_DATA,
          payload: res.data.analytic,
        });
      } else {
        dispatch({
          type: OPEN_DASHBOARD_TOAST,
          payload: { data: res.message },
        });
      }
    })
    .catch((error) => {
      console.log("error", error.message);
    });
};
//Get countryWise user
export const getCountryWiseUser = () => (dispatch) => {
  api
    .get("user/countryWiseUser")
    .then((res) => {
      dispatch({ type: GET_COUNTRY_WISE_USER, payload: res.data.user });
    })
    .catch((error) => console.log(error));
};
