import * as ActionType from "./liveTv.type";

const initialState = {
  liveTv: [],
  dialogue: false,
  dialogueData: null,
  country: [],
  adminCreateLiveTv: [],
  flag: [],
};

export const liveTvReducer = (state = initialState, action) => {
  switch (action.type) {
    case ActionType.GET_LIVE_TV:
      return {
        ...state,
        liveTv: action.payload,
      };
    case ActionType.OPEN_LIVE_TV_DIALOGUE:
      return {
        ...state,
        dialogue: true,
        dialogueData: action.payload || null,
      };
    case ActionType.CLOSE_LIVE_TV_DIALOGUE:
      return {
        ...state,
        dialogue: false,
        dialogueData: null,
      };
    case ActionType.GET_COUNTRY:
      return {
        ...state,
        country: action.payload,
      };
    case ActionType.GET_LIVE_TV_CREATE_BY_ADMIN:
      return {
        ...state,
        adminCreateLiveTv: action.payload,
      };
    case ActionType.CREATE_LIVE_TV:
      let array = [...state.adminCreateLiveTv];
      array.unshift(action.payload);
      return {
        ...state,
        adminCreateLiveTv: array,
      };
    case ActionType.EDIT_LIVETV_CHANNEL:
      return {
        ...state,
        adminCreateLiveTv: state.adminCreateLiveTv.map((data) =>
          data._id === action.payload.id ? action.payload.data : data
        ),
      };
    case ActionType.DELETE_LIVETV_CHANNEL:
      return {
        ...state,
        adminCreateLiveTv: state.adminCreateLiveTv.filter(
          (data) => data._id !== action.payload && data
        ),
      };
    case ActionType.GET_FLAG:
      return {
        ...state,
        flag: action.payload,
      };
    default:
      return state;
  }
};
