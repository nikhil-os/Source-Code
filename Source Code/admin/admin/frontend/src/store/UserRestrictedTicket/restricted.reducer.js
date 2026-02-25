import { GET_USER_RES_TICKET, USER_RES_TICKET_ACTION } from "./restricted.type";


const initialState = {
  ticketByUser: [],
  totalTickets: 0,
};

const userRestrictedReducer = (state = initialState, action) => {
  switch (action.type) {
    case GET_USER_RES_TICKET:
      
      return {
        ...state,
        ticketByUser: action.payload.ticketByUser,
        totalTickets: action.payload.totalTickets,
      };
    case USER_RES_TICKET_ACTION:
      
      return {
        ...state,
        ticketByUser: state.ticketByUser.filter((ticketByUser) => ticketByUser._id !== action.payload),
      };
    default:
      return state;
  }
};

export default userRestrictedReducer;
