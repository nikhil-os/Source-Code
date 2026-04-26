//axios
import axios from 'axios';
import uploadFileTypes, {
  CLOSE_EPISODE_TOAST,
  DELETE_EXISTING_EPISODE,
  GET_SHORTS,
  INSERT_SHORT__VIDEO,
  UPDATE_EXISTING_EPISODE,
  UPLOAD_MULTIPLE_IMAGE,
} from './EpisodeList.type';

//Type
import {
  GET_EPISODE,
  INSERT_EPISODE,
  OPEN_EPISODE_TOAST,
  UPDATE_EPISODE,
} from './EpisodeList.type';

//toast
import { Toast } from '../../util/Toast_';
import { api } from '../..';

//get Episode

//get season wise episode
export const getMovieOfWebSeriesWiseShortVideo =
  (dialogData, seasons) => (dispatch) => {
    api
      .get(
        `shortVideo/fetchMediaContent?start=${dialogData?.start}&limit=${dialogData?.limit}&movieSeriesId=${dialogData?.movieSeriesId}`
      )
      .then((res) => {
        dispatch({
          type: GET_EPISODE,
          payload: { data: res.data.data, total: res.data.total },
        });
      })
      .catch((error) => {
        console.log(error);
      });
  };

//Insert Episode
export const insertEpisode = (formData) => async (dispatch) => {
  try {
    const res = await axios.post(`shortVideo/addShortVideo`, formData);
    if (res.data?.status) {
      dispatch({ type: INSERT_SHORT__VIDEO, payload: res.data.data });

      Toast('success', 'Short video added successfully');

      dispatch({
        type: OPEN_EPISODE_TOAST,
        payload: { data: res.data.message, for: 'insert' },
      });

      return res;
    } else {
      Toast('error', res.data.message || 'Failed to add short video.');
      return null;
    }
  } catch (error) {
    console.error('Insert episode failed:', error?.response || error);
    Toast('error', 'Something went wrong while adding the short video.');
    return null;
  }
};

export const uploadMultipleImage = (formData) => (dispatch) => {
  return axios
    .post(`file/bulkUploadContent`, formData)
    .then((res) => {
      if (res.data.status === true) {
        dispatch({
          type: UPLOAD_MULTIPLE_IMAGE,
          payload: { data: formData },
        });
        return res; // ✅ return response here
      } else {
        dispatch({
          type: CLOSE_EPISODE_TOAST,
          payload: { data: res.data.message, for: 'insert' },
        });
        Toast('error', res.data.message);
        throw new Error(res.data.message); // ✅ throw for catch/unwrapping
      }
    })
    .catch((error) => {
      console.log(error);
      throw error; // ✅ re-throw to propagate the error
    });
};

//Delete contact
export const deleteEpisode = (shortVideoId) => (dispatch) => {
  axios
    .delete(`shortVideo/destroyShortMedia?shortVideoId=${shortVideoId}`)
    .then((res) => {
      if (res.data.status) {
        dispatch({ type: DELETE_EXISTING_EPISODE, payload: shortVideoId });
      } else {
        console.error(res.data);
      }
    })
    .catch((error) => {
      console.log(error);
    });
};

//Update Episode
export const updateEpisode = (data, mongoId) => (dispatch) => {
  axios
    .post(`shortVideo/modifyShortVideo`, data)
    .then((res) => {
      if (res?.data?.status) {
        dispatch({
          type: UPDATE_EXISTING_EPISODE,
          payload: { data: res.data.data, id: mongoId },
        });

        Toast('success', 'short video update succesfully');

        dispatch({
          type: OPEN_EPISODE_TOAST,
          payload: { data: 'Update Episode Successful ✔', for: 'update' },
        });
      } else {
        Toast('error', res.data.message);
        return res.data.message, 'error';
      }
    })
    .catch((error) => {
      console.log(error);
    });
};

export const getShortVideo = (dialogData, seasons) => (dispatch) => {
  api
    .get(
      `shortVideo/listShortVideos?start=${dialogData?.start}&limit=${dialogData?.limit}`
    )
    .then((res) => {
      dispatch({
        type: GET_SHORTS,
        payload: { data: res.data.data, total: res.data.total },
      });
    })
    .catch((error) => {
      console.log(error);
    });
};
