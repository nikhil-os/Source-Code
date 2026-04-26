//Axios
import axios from 'axios';
import { Toast } from '../../util/Toast_';

//Types
import {
  DELETE_SEASON,
  GET_SEASON,
  INSERT_SEASON,
  UPDATE_SEASON,
} from './season.type';
import { setToast } from '../../util/Toast';
import { api } from '../..';

//Get Region
export const getSeason = (id) => (dispatch) => {
  api
    .get(`season/movieIdWise?movieId=${id}`)
    .then((res) => {
      dispatch({ type: GET_SEASON, payload: res.data.season });
    })
    .then((error) => {
      console.log(error);
    });
};

//Create  Season
export const CreateSeason = (formData) => (dispatch) => {
  axios
    .post(`season/create`, formData)
    .then((res) => {
      if (res.data.status) {
        dispatch({ type: INSERT_SEASON, payload: res.data.season });
        Toast('success', res.data.message);
      }
    })
    .then((error) => {
      console.log(error);
    });
};

//Update  Season
export const updateSeason = (formData, id) => (dispatch) => {
  axios
    .patch(`/season/update?seasonId=${id}`, formData)
    .then((res) => {
      if (res.data.status) {
        dispatch({
          type: UPDATE_SEASON,
          payload: { data: res.data.season, id },
        });
        Toast('success', res.data.message);
      }
    })
    .then((error) => {
      console.log(error);
    });
};

// delete season
export const deleteSeason = (id) => (dispatch) => {
  axios
    .delete(`/season/delete?seasonId=${id}`)
    .then((res) => {
      if (res.data.status) {
        dispatch({ type: DELETE_SEASON, payload: id });
        Toast('success', 'Delete Season Successfully ');
      } else {
        Toast('error', res.data.message);
      }
    })
    .then((error) => {
      console.log(error);
    });
};
