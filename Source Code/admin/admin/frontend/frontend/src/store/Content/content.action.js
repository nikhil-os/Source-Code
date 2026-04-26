//Axios
import axios from 'axios';

//Types
import {
  CLOSE_DIALOG,
  DELETE_CONTENT,
  GET_CONTENT,
  INSERT_CONTENT,
  OPEN_CONTENT_TOAST,
  UPDATE_CONTENT,
} from './content.type';
import { Toast } from '../../util/Toast_';
import { api } from '../..';
import { setToast } from '../../util/Toast';

//Get Genre
export const getContent = () => (dispatch) => {
  api
    .get(`contentPage/listContentPages`)
    .then((res) => {
      dispatch({ type: GET_CONTENT, payload: res.data.data });
    })
    .catch((error) => {
      console.log(error);
    });
};

//Insert Genre
export const insertContent = (data) => (dispatch) => {
  axios
    .post(`contentPage/insertContentPage`, data)
    .then((res) => {
      if (res.status) {
        dispatch({ type: INSERT_CONTENT, payload: res.data });
        dispatch({ type: CLOSE_DIALOG });
        dispatch({
          type: OPEN_CONTENT_TOAST,
          payload: { data: 'Insert Content Successful ✔', for: 'insert' },
        });
      } else {
        dispatch({
          type: OPEN_CONTENT_TOAST,
          payload: { data: res.data.message, for: 'error' },
        });
      }
    })
    .catch((error) => {
      console.log(error);
    });
};

export const updateContent = (data) => (dispatch) => {
  const { contentId, title, description, icon } = data;

  // Build query params
  const params = new URLSearchParams();
  params.append('contentId', contentId);

  // Prepare request body
  const body = {
    ...(title && { title }),
    ...(description && { description }),
    ...(icon && { icon }),
  };

  axios
    .patch(`contentPage/modifyContentPage?${params.toString()}`, body)
    .then((res) => {
      if (res.data.status) {
        dispatch({
          type: UPDATE_CONTENT, // ✅ Rename if it's now updating content
          payload: { data: res.data, id: res.data._id },
        });
        dispatch({ type: CLOSE_DIALOG });
        dispatch({
          type: OPEN_CONTENT_TOAST, // ✅ Rename this too if it's content-based
          payload: { data: 'Update Content Successful ✔', for: 'update' },
        });
      } else {
        Toast('error', res.data.message);
      }
    })
    .catch((error) => {
      console.log('Update Content Error:', error);
    });
};

//Delete genre
export const deleteContent = (contentId) => (dispatch) => {
  axios
    .delete(`contentPage/removeContentPage?contentId=${contentId}`)
    .then((res) => {
      dispatch({ type: DELETE_CONTENT, payload: contentId });
    })
    .catch((error) => {
      console.log(error);
    });
};
