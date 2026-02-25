import axios from 'axios';

import {
  GET_SETTING,
  UPDATE_SETTING,
  OPEN_SETTING_TOAST,
  SWITCH_ACCEPT,
} from './setting.type';
import { setToast } from '../../util/Toast';
import { Toast } from '../../util/Toast_';
import { api } from '../..';

export const getSetting = () => (dispatch) => {
  api
    .get('setting')
    .then((res) => {
      if (res.status) {
        dispatch({ type: GET_SETTING, payload: res.data.setting });
        // dispatch({
        //   type: OPEN_SETTING_TOAST,
        //   payload: { data: "Inserted Successfully ✔", for: "insert" },
        // });
      } else {
        console.log('error', res.message);
      }
    })
    .catch((error) => console.log('error', error.message));
};

export const updateSetting = (mongoId, data) => (dispatch) => {
  axios
    .patch(`setting/update?settingId=${mongoId}`, data)
    .then((res) => {
      if (res.data.status) {
        dispatch({ type: GET_SETTING, payload: res.data.setting });
        dispatch({
          type: OPEN_SETTING_TOAST,
          payload: { data: 'Updated Successfully ✔', for: 'update' },
        });
      } else {
        console.log('error', res.data.message);
      }
    })
    .catch((error) => console.log('error', error.message));
};

export const handleSwitch = (mongoId, type, value) => (dispatch) => {
  axios
    .patch(`setting?settingId=${mongoId}&type=${type}`)
    .then((res) => {
      // debugger
      if (res.data.status) {
        dispatch({ type: SWITCH_ACCEPT, payload: res.data.setting });
        dispatch({
          type: OPEN_SETTING_TOAST,
          payload: {},
        });
        Toast(
          'success',
          `${type === 'IptvAPI' ? 'Live TV' : type} is ${value !== true ? 'Active' : 'Enable'
          } `
        );
      } else {
        console.log('error', res.data.message);
        Toast('error', res.data.message)
      }
    })
    .catch((error) => console.log('error', error.message));
};

export const StorageSetting = (payload) => (dispatch) => {
  console.log('payload--action', payload);

  axios
    .patch(
      `setting/toggleStorageOption?settingId=${payload.settingId}&type=${payload.type}`
    )
    .then((res) => {
      if (res.data.status) {
        setToast(res.data.message, 'insert');
      } else {
        setToast(res.data.message, 'error');
      }
    })
    .catch((error) => console.log('error', error.message));
};
