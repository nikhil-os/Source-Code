//Types
import {
  CLOSE_CONTENT_TOAST,
  CLOSE_DIALOG,
  DELETE_CONTENT,
  GET_CONTENT,
  INSERT_CONTENT,
  OPEN_CONTENT_DIALOG,
  OPEN_CONTENT_TOAST,
  UPDATE_CONTENT,
} from './content.type';

//Define InitialState
const initialState = {
  content: [],
  dialog: false,
  dialogData: null,
  toast: false,
  toastData: null,
  actionFor: null,
};

const contentReducer = (state = initialState, action) => {
  switch (action.type) {
    //Get Content
    case GET_CONTENT:
      return {
        ...state,
        content: action.payload,
      };

    //Insert Content
    case INSERT_CONTENT:
      const data = [...state.content];
      data.unshift(action.payload);
      return {
        ...state,
        content: data,
      };

    //Update Genre
    case UPDATE_CONTENT:
      return {
        ...state,
        content: state.content.map((content) =>
          content._id === action.payload.data._id
            ? action.payload.data
            : content
        ),
      };

    //Delete Genre
    case DELETE_CONTENT:
      return {
        ...state,
        content: state.content.filter(
          (content) => content._id !== action.payload
        ),
      };

    //Open Dialog
    case OPEN_CONTENT_DIALOG:
      return {
        ...state,
        dialog: true,
        dialogData: action.payload || null,
      };

    //Close Dialog
    case CLOSE_DIALOG:
      return {
        ...state,
        dialog: false,
        dialogData: null,
      };

    //Open Toast
    case OPEN_CONTENT_TOAST:
      return {
        ...state,
        toast: true,
        toastData: action.payload.data || null,
        actionFor: action.payload.for || null,
      };

    //Close Toast
    case CLOSE_CONTENT_TOAST:
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

export default contentReducer;
