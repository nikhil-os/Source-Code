//Axios
import axios from 'axios';

//Types
import {
  CLOSE_DIALOG,
  DELETE_REGION,
  GET_REGION,
  INSERT_REGION,
  OPEN_REGION_TOAST,
  UPDATE_REGION,
} from './region.type';
import { setToast } from '../../util/Toast';
import { Toast } from '../../util/Toast_';
import { api } from '../..';

//Get Region
export const getRegion = () => (dispatch) => {
  api
    .get(`region`)
    .then((res) => {
      dispatch({ type: GET_REGION, payload: res.data.region });
    })
    .catch((error) => {
      console.log('error', error);
    });
};

//Insert Region
export const insertRegion = (data) => (dispatch) => {
  axios
    .post(`region/create`, data)
    .then((res) => {
      if (res.data.status) {
        dispatch({ type: INSERT_REGION, payload: res.data.region });
        dispatch({ type: CLOSE_DIALOG });
        dispatch({
          type: OPEN_REGION_TOAST,
          payload: { data: 'Insert Region Successful ✔', for: 'insert' },
        });
      } else {
        dispatch({
          type: OPEN_REGION_TOAST,
          payload: { data: res.data.message, for: 'insert' },
        });
      }
    })
    .catch((error) => {
      console.log(error);
    });
};

//Update Region
export const updateRegion = (regionId, data) => (dispatch) => {
  axios
    .patch(`region/update?regionId=${regionId}&name=${data}`)
    .then((res) => {
      if (res.data.status) {
        dispatch({ type: CLOSE_DIALOG });
        dispatch({
          type: UPDATE_REGION,
          payload: { data: res.data.region, id: regionId },
        });

        dispatch({
          type: OPEN_REGION_TOAST,
          payload: { data: 'Update Region Successful ✔', for: 'update' },
        });
      } else {
        Toast('error', res.data.message);
      }
    })
    .catch((error) => {
      console.log(error);
    });
};

//Delete Region
export const deleteRegion = (regionId) => (dispatch) => {
  axios
    .delete(`region/delete/?regionId=${regionId}`)
    .then((res) => {
      dispatch({ type: DELETE_REGION, payload: regionId });
    })
    .catch((error) => {
      console.log(error);
    });
};
