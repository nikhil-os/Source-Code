import axios from 'axios';
import { Toast } from '../../util/Toast_';
import { GET_USER_RES_TICKET, USER_RES_TICKET_ACTION } from './restricted.type';
import { api } from '../..';

//get reels
export const getRaisedTicket = (page, rowsPerPage, status) => (dispatch) => {
  api
    .get(
      `ticketByUser/raisedTickets?start=${page}&limit=${rowsPerPage}&status=${status}`
    )
    .then((result) => {
      dispatch({
        type: GET_USER_RES_TICKET,
        payload: {
          ticketByUser: result.data.ticketByUser,
          totalTickets: result.data.totalTickets,
        },
      });
    })
    .catch((error) => {
      console.log(error);
    });
};

//action for redeem request
export const action = (redeemId) => (dispatch) => {
  axios
    .post(`/ticketByUser/ticketSolve?ticketId=${redeemId}`)
    .then((result) => {
      if (result.status) {
        dispatch({ type: USER_RES_TICKET_ACTION, payload: redeemId });

        Toast('success', 'Raised Ticket Request solved successfully');
      }
    })
    .catch((error) => {
      console.log(error);
    });
};
