//Types
import {
  CLOSE_INSERT_DIALOG,
  CLOSE_EPISODE_TOAST,
  DELETE_EPISODE,
  GET_EPISODE,
  INSERT_EPISODE,
  OPEN_INSERT_DIALOG,
  OPEN_EPISODE_TOAST,
  UPDATE_EPISODE,
  DELETE_EXISTING_EPISODE,
  UPDATE_EXISTING_EPISODE,
  GET_SHORTS,
  CLOSE_SHORT_DIALOG,
  OPEN_SHORT_DIALOG,
  INSERT_SHORT__VIDEO,
} from "./EpisodeList.type";



//Define initialState
const initialState = {
  episode: [],
  dialog: false,
  dialogData: null,
  total : null,
  toast: false,
  toastData: null,
  actionFor: null,
};

const episodeListReducer = (state = initialState, action) => {
  switch (action.type) {

    //Get Episode
    case GET_EPISODE:
      return {
        ...state,
        episode: action.payload.data,
        total : action.payload.total
      };

      case GET_SHORTS:
        return {
          ...state,
          episode: action.payload.data,
          total : action.payload.total
        };
  

    //Insert Episode
    case INSERT_SHORT__VIDEO:
      const data = [...state.episode];
      data.unshift(action.payload);
      return {
        ...state,
        episode: data,
      };

    //Update Episode
    case UPDATE_EXISTING_EPISODE:
      return {
        ...state,
        episode: state.episode.map((episode) =>
          episode._id === action.payload.id ? {...episode , ...action.payload.data} : episode
        ),
      };
      
      case DELETE_EXISTING_EPISODE:
        return {
          ...state,
          episode: state.episode.filter((episode) => episode._id !== action.payload),
        };
    

    //Open Dialog
    case OPEN_SHORT_DIALOG:
  
      return {
        ...state,
        dialog : true,
        dialogData: action.payload || null,
      };

    //Close Dialog
    case CLOSE_SHORT_DIALOG:
      return {
        ...state,
        dialog: false,

        dialogData: null,
      };

    //Open and Close Toast
    case OPEN_EPISODE_TOAST:
      return {
        ...state,
        toast: true,
        toastData: action.payload.data || null,
        actionFor: action.payload.for || null,
      };

    case CLOSE_EPISODE_TOAST:
      return {
        ...state,
        toast: false,
        toastData: null,
        actionFor: null,
      };

   

    default:
      return state;
  }
};

export default episodeListReducer;
