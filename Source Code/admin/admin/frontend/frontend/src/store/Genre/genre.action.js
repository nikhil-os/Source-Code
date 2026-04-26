//Axios
import axios from 'axios';

//Types
import {
  CLOSE_DIALOG,
  DELETE_GENRE,
  GET_GENRE,
  INSERT_GENRE,
  OPEN_GENRE_TOAST,
  UPDATE_GENRE,
} from './genre.type';
import { Toast } from '../../util/Toast_';
import { api } from '../..';

//Get Genre
export const getGenre = () => (dispatch) => {
  api
    .get(`genre`)
    .then((res) => {
      dispatch({ type: GET_GENRE, payload: res.data.genre });
    })
    .catch((error) => {
      console.log(error);
    });
};

//Insert Genre
export const insertGenre = (data) => (dispatch) => {
  axios
    .post(`genre/create`, data)
    .then((res) => {
      if (res.data.status) {
        dispatch({ type: INSERT_GENRE, payload: res.data.genre });
        dispatch({ type: CLOSE_DIALOG });
        dispatch({
          type: OPEN_GENRE_TOAST,
          payload: { data: 'Insert Genre Successful ✔', for: 'insert' },
        });
      } else {
        dispatch({
          type: OPEN_GENRE_TOAST,
          payload: { data: res.data.message, for: 'error' },
        });
      }
    })
    .catch((error) => {
      console.log(error);
    });
};

export const updateGenre = (data) => (dispatch) => {
  // Build query params only for defined values
  const params = new URLSearchParams();
  params.append('genreId', data.genreId);
  if (data.name) params.append('name', data.name);
  if (data.image) params.append('image', data.image);

  axios
    .patch(`genre/update?${params.toString()}`)
    .then((res) => {
      if (res.data.status) {
        dispatch({
          type: UPDATE_GENRE,
          payload: { data: res.data.genre, id: res.data.genreId },
        });
        dispatch({ type: CLOSE_DIALOG });
        dispatch({
          type: OPEN_GENRE_TOAST,
          payload: { data: 'Update Genre Successful ✔', for: 'update' },
        });
      } else {
        Toast('error', res.data.message);
      }
    })
    .catch((error) => {
      console.log(error);
    });
};

//Delete genre
export const deleteGenre = (genreId) => (dispatch) => {
  axios
    .delete(`genre/delete/?genreId=${genreId}`)
    .then((res) => {
      dispatch({ type: DELETE_GENRE, payload: genreId });
    })
    .catch((error) => {
      console.log(error);
    });
};
