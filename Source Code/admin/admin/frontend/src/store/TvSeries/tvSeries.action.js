import uploadFileTypes, { MANUAL_CREATE_SERIES } from "./tvSeries.type";
//Type
import {
  GET_TV_SERIES,
  INSERT_TV_SERIES,
  // CLOSE_DIALOG,
  UPDATE_TV_SERIES,
  DELETE_TV_SERIES,
  OPEN_TV_SERIES_TOAST,
  IS_NEW_RELEASE_SWITCH,
  TV_SERIES_DETAILS,
  GET_COMMENT,
  DELETE_COMMENT,
  TV_SERIES_DETAILS_TMDB,
} from "./tvSeries.type";

//axios
import axios from "axios";
// import { Alert } from 'antd';
import { Toast } from "../../util/Toast_";
import { baseURL } from "../../util/config";
import { CLOSE_LOADER } from "../Loader/loader.type";
import { api } from "../..";

//get movie
export const getSeries = (start, limit, search) => (dispatch) => {
  api
    .get(
      `${baseURL}movie/all?type=WEBSERIES&&start=${start}&&limit=${limit}&search=${search}`,
    )
    .then((res) => {
      if (res.status) {
        dispatch({
          type: GET_TV_SERIES,
          payload: {
            movie: res.data.movie,
            totalSeries: res?.data.totalMoviesWebSeries,
          },
        });
        dispatch({ type: CLOSE_LOADER });
      }
    })
    .catch((error) => {
      console.log(error);
    });
};

//get movie only if category web series
export const getMovieCategory = () => (dispatch) => {
  api
    .get(`episode/series?type=SERIES`)
    .then((res) => {
      dispatch({ type: GET_TV_SERIES, payload: res.data.movie });
    })
    .catch((error) => {
      console.log(error);
    });
};

//get top 10 movie
// export const getTop10Movie = () => (dispatch) => {
//   axios
//     .get(`movie/AllTop10?type=MOVIE`)
//     .then((res) => {
//
//       dispatch({ type: GET_TOP_10_MOVIE, payload: res.data.movie });
//     })
//     .catch((error) => {
//       console.log(error);
//     });
// };

//get top 10 web-series
// export const getTop10WebSeries = () => (dispatch) => {
//   axios
//     .get(`movie/AllTop10?type=WEB-SERIES`)
//     .then((res) => {
//
//       dispatch({ type: GET_TOP_10_WEB_SERIES, payload: res.data.movie });
//     })
//     .catch((error) => {
//       console.log(error);
//     });
// };

//update movie
// export const updateMovie = (data, movieId) => (dispatch) => {
//   console.log(movieId);

//   axios
//     .patch(`movie/movieId?movieId=${movieId}`, data)
//     .then((res) => {
//       if (res.status) {
//
//         dispatch({
//           type: UPDATE_MOVIE,
//           payload: { data: res.data.movie, id: movieId },
//         });

//         dispatch({
//           type: OPEN_MOVIE_TOAST,
//           payload: { data: "Update Movie Successful ✔", for: "update" },
//         });
//       } else {
//         return res.data.message, "error";
//       }
//     })
//     .catch((error) => {
//       console.log(error);
//     });
// };

//delete movie
export const deleteSeries = (seriesId) => (dispatch) => {
  axios
    .delete(`movie/delete?movieId=${seriesId}`)
    .then((result) => {
      dispatch({ type: DELETE_TV_SERIES, payload: seriesId });
    })
    .catch((error) => {
      console.log(error);
    });
};

//isNewRelease switch
export const newRelease = (seriesId) => (dispatch) => {
  axios
    .patch(`movie/isNewRelease?movieId=${seriesId}`)
    .then((res) => {
      dispatch({
        type: IS_NEW_RELEASE_SWITCH,
        payload: { data: res.data.movie, id: seriesId },
      });
      Toast("success", "New release update successfully..");
    })
    .catch((error) => {
      console.log(error);
    });
};

//view movie details
export const viewDetails = (seriesId) => (dispatch) => {
  api
    .get(`movie/details?movieId=${seriesId}`)
    .then((result) => {
      dispatch({ type: TV_SERIES_DETAILS, payload: result.data.movie });
    })
    .catch((error) => {
      console.log(error);
    });
};

//get comment
export const getComment = (seriesId, type) => (dispatch) => {
  api
    .get(`comment/getComments?movieId=${seriesId}`)
    .then((res) => {
      if (res.status) {
        dispatch({ type: GET_COMMENT, payload: res.data.comment });
      } else {
        dispatch({ type: GET_COMMENT, payload: res.data.comment });
      }
    })
    .catch((error) => console.log("error", error.message));
};

//delete comment
export const deleteComment = (commentId) => (dispatch) => {
  axios
    .delete(`comment?commentId=${commentId}`)
    .then((res) => {
      if (res.status) {
        dispatch({ type: DELETE_COMMENT, payload: commentId });
      } else {
        console.log("error", res.message);
      }
    })
    .catch((error) => console.log("error", error.message));
};

export const setUploadTvFile = (data) => ({
  type: uploadFileTypes.SET_UPLOAD_FILE,
  payload: data,
});

export const setUploadProgress = (id, progress) => ({
  type: uploadFileTypes.SET_UPLOAD_PROGRESS,
  payload: {
    id,
    progress,
  },
});

export const successUploadFile = (id) => ({
  type: uploadFileTypes.SUCCESS_UPLOAD_FILE,
  payload: id,
});

export const failureUploadFile = (id) => ({
  type: uploadFileTypes.FAILURE_UPLOAD_FILE,
  payload: id,
});

//   const formPayload = new FormData();
//   for (var i = 0; i < data.genres?.length; i++) {
//     formPayload.append("genre", data.genres[i]);
//   }
//   formPayload.append("title", data.title);
//   formPayload.append("description", data.description);
//   formPayload.append("year", data.year);
//   formPayload.append("image", data.image);
//   formPayload.append("type", data.type);
//   formPayload.append("thumbnail", data.thumbnail);
//   formPayload.append("runtime", data.runtime);
//   formPayload.append("region", data.country);

//   if (!seriesId && !files?.length && data) {
//     ;
//     axios
//       .post(`movie/getStore?TmdbMovieId=${data.tmdbMovieId}&type=WEBSERIES`)
//       .then((res) => {
//         if (res.data.status === true) {
//           ;
//
//           dispatch(successUploadFile());

//           dispatch({
//             type: OPEN_TV_SERIES_TOAST,
//             payload: { data: "Insert TV Series Successful ✔", for: "insert" },
//           });
//         } else {
//           return res.data.message, "error";
//         }
//       })
//       .catch((error) => {
//
//       });
//   } else {
//     ;
//     axios
//       .patch(`movie/movieId?movieId=${seriesId}`, formPayload)
//       .then((res) => {
//         ;
//         if (res.status) {
//
//           dispatch({
//             type: UPDATE_TV_SERIES,
//             payload: { data: res.data.movie, id: seriesId },
//           });

//           dispatch({
//             type: OPEN_TV_SERIES_TOAST,
//             payload: { data: "Update TV Series Successful ✔", for: "update" },
//           });
//         } else {
//           return res.data.message, "error";
//         }
//       })
//       .catch((error) => {
//       });
//   }
// };

export const uploadTvFile = (files, data, seriesId, update) => (dispatch) => {
  if (files.length) {
    files.forEach((file) => {
      const formPayload = new FormData();
      for (var i = 0; i < data.genres?.length; i++) {
        formPayload.append("genre", data.genres[i]);
      }
      formPayload.append("title", data.title);
      formPayload.append("description", data.description);
      formPayload.append("year", data.year);
      formPayload.append("image", data.image);
      formPayload.append("type", data.type);
      formPayload.append("thumbnail", data.thumbnail);
      formPayload.append("runtime", data.runtime);
      formPayload.append("region", data.country);

      if (!seriesId) {
        axios
          .post(
            `movie/getStore?TmdbMovieId=${data.tmdbMovieId}&type=WEBSERIES`,

            {
              onUploadProgress: (progress) => {
                const { loaded, total } = progress;
                const percentageProgress = Math.floor((loaded / total) * 100);
                dispatch(setUploadProgress(file.id, percentageProgress));
              },
            },
          )
          .then((res) => {
            if (res.data.status) {
              dispatch(successUploadFile(file.id));

              dispatch({
                type: OPEN_TV_SERIES_TOAST,
                payload: {
                  data: "Insert TV Series Successful ✔",
                  for: "insert",
                },
              });
            } else {
              return "error";
            }
          })

          .catch((res) => {
            dispatch(failureUploadFile(file.id));
          });
      }
    });
  }

  if (!seriesId && files.length === 0) {
    const formData = new FormData();

    axios
      .post(
        `movie/getStore?TmdbMovieId=${data.tmdbMovieId}&type=WEBSERIES`,
        formData,
      )
      .then((res) => {
        if (res.data.status) {
          dispatch(successUploadFile());

          dispatch({
            type: OPEN_TV_SERIES_TOAST,
            payload: { data: "Insert TV Series Successful ✔", for: "insert" },
          });
        } else {
          return "error";
        }
      })
      .catch((error) => {
        console.log(error);
      });
  }
};

//get movie detail from tmdb
export const loadSeriesData = (tmdbId, tmdbTitle) => (dispatch) => {
  const url = tmdbId
    ? `movie/getStoredetails?IMDBid=${tmdbId}&type=WEBSERIES`
    : `movie/getStoredetails?title=${tmdbTitle}&type=WEBSERIES`;
  api
    .get(url)
    .then((res) => {
      console.log("res", res);

      if (res.data.status === true) {
        dispatch({ type: TV_SERIES_DETAILS_TMDB, payload: res.data.series });
        Toast("success", "Data Imported Successfully ✔");
      } else {
        Toast("error", "No data found in database.");
      }
    })
    .catch((error) => {
      console.log(error);
    });
};

export const createManualSeries = (fromData) => (dispatch) => {
  axios
    .post(`movie/createSeries`, fromData)
    .then((res) => {
      if (res.data.status) {
        dispatch({ type: MANUAL_CREATE_SERIES, payload: res.data.movie });
        Toast("success", "Insert TV Series Successful ✔");
      } else {
        Toast("error", res.data.message);
      }
    })
    .catch((error) => console.log(error));
};

export const updateTvSeries = (seriesId, data) => (dispatch) => {
  axios
    .patch(`movie/update?movieId=${seriesId}`, data)
    .then((res) => {
      dispatch({
        type: UPDATE_TV_SERIES,
        payload: { data: res.data.movie, id: seriesId },
      });
      setTimeout(() => {
        Toast("success", "Web Series Updated Succesfully");
      }, 1000);
    })
    .catch((error) => console.log("error", error));
};

export const ImdbSeriesCreate = (data) => (dispatch) => {
  axios
    .post(`movie/getStore?TmdbMovieId=${data?.tmdbId}&type=WEBSERIES`, data)
    .then((res) => {
      if (res.data.status) {
        dispatch({ type: INSERT_TV_SERIES, payload: res.data.movie });
        Toast("success", "Web-Series Create  SuccessFully");
      } else {
        Toast("error", res.data.message);
      }
    })
    .catch((error) => console.log("error", error));
};
