import uploadFileTypes from './movie.type';
//Type
import {
  GET_MOVIE,
  INSERT_MOVIE,
  CLOSE_DIALOG,
  UPDATE_MOVIE,
  DELETE_MOVIE,
  OPEN_MOVIE_TOAST,
  IS_NEW_RELEASE_SWITCH,
  MOVIE_DETAILS,
  GET_TOP_10_MOVIE,
  GET_TOP_10_WEB_SERIES,
  GET_COMMENT,
  DELETE_COMMENT,
  MOVIE_DETAILS_TMDB,
} from './movie.type';

//axios
import axios from 'axios';
import { Alert } from 'antd';
import { Toast } from '../../util/Toast_';
import { useHistory } from 'react-router-dom';
import { baseURL, secretKey } from '../../util/config';
import { CLOSE_LOADER } from '../Loader/loader.type';
import { setToast } from '../../util/Toast';
import { api } from '../..';
import { type } from 'jquery';

//get movie
export const getMovie = (start, limit, search) => (dispatch) => {
  api
    .get(
      `${baseURL}movie/all?type=MOVIE&start=${start}&limit=${limit}&search=${search}`
    )
    .then((result) => {
      if (result.status) {
        dispatch({
          type: GET_MOVIE,
          payload: {
            movie: result.data.movie,
            totalMoviesWebSeries: result?.data.totalMoviesWebSeries,
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
      dispatch({ type: GET_MOVIE, payload: res.data.movie });
    })
    .catch((error) => {
      console.log(error);
    });
};

//get top 10 movie
export const getTop10Movie = () => (dispatch) => {
  api
    .get(`movie/AllTop10?type=MOVIE`)
    .then((res) => {
      dispatch({ type: GET_TOP_10_MOVIE, payload: res.data.movie });
    })
    .catch((error) => {
      console.log(error);
    });
};

//get top 10 web-series
export const getTop10WebSeries = () => (dispatch) => {
  api
    .get(`movie/AllTop10?type=WEB-SERIES`)
    .then((res) => {
      dispatch({ type: GET_TOP_10_WEB_SERIES, payload: res.data.movie });
    })
    .catch((error) => {
      console.log(error);
    });
};

//update movie
export const updateMovie = (data, movieId) => (dispatch) => {
  axios
    .patch(`movie/update?movieId=${movieId}`, data)
    .then((res) => {
      if (res.status) {
        dispatch({
          type: UPDATE_MOVIE,
          payload: { data: res.data.movie, id: movieId },
        });

        // dispatch({
        //   type: OPEN_MOVIE_TOAST,
        //   payload: { data: "Update Movie Successful ✔", for: "update" },
        // });
        setToast('Update Movie Successful ✔', 'update');
      } else {
        return res.data.message, 'error';
      }
    })
    .catch((error) => {
      console.log(error);
    });
};

//delete movie
export const deleteMovie = (movieId) => (dispatch) => {
  axios
    .delete(`movie/delete?movieId=${movieId}`)
    .then((result) => {
      dispatch({ type: DELETE_MOVIE, payload: movieId });
    })
    .catch((error) => {
      console.log(error);
    });
};

//isNewRelease switch
export const newRelease = (movieId) => (dispatch) => {
  axios
    .patch(`movie/isNewRelease?movieId=${movieId}`)
    .then((res) => {
      if (res.data.status) {
        dispatch({
          type: IS_NEW_RELEASE_SWITCH,
          payload: { data: res.data.movie, id: movieId },
        });

        Toast('success', 'Update Successfully');
      } else {
        Toast('error', res.data.message);
      }
    })
    .catch((error) => {
      console.log(error);
    });
};

//view movie details
export const viewDetails = (movieId) => (dispatch) => {
  api
    .get(`movie/details?movieId=${movieId}`)
    .then((result) => {
      dispatch({ type: MOVIE_DETAILS, payload: result.data.movie });
    })
    .catch((error) => {
      console.log(error);
    });
};

//get comment
export const getComment = (movieId, type) => (dispatch) => {
  api
    .get(`comment/getComments?movieId=${movieId}`)
    .then((res) => {
      if (res.status) {
        dispatch({ type: GET_COMMENT, payload: res.data.comment });
      } else {
        dispatch({ type: GET_COMMENT, payload: res.data.comment });
      }
    })
    .catch((error) => console.log('error', error.message));
};

//delete comment
export const deleteComment = (commentId) => (dispatch) => {
  axios
    .delete(`comment?commentId=${commentId}`)
    .then((res) => {
      if (res.status) {
        dispatch({ type: DELETE_COMMENT, payload: commentId });
      } else {
        console.log('error', res.message);
      }
    })
    .catch((error) => console.log('error', error.message));
};

export const setUploadFile = (data) => ({
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

export const uploadFile = (files, data, movieId, update) => (dispatch) => {
  if (files.length && data.videoType == 7) {
    files.map((file, index) => {
      if (!movieId) {
        const formPayload = new FormData();
        formPayload.append('videoType', data.videoType);
        formPayload.append('link', file.file);
        axios
          .post(
            `movie/getStore?TmdbMovieId=${data.tmdbMovieId}&type=MOVIE`,
            formPayload,
            {
              onUploadProgress: (progress) => {
                const { loaded, total } = progress;
                const percentageProgress = Math.floor((loaded / total) * 100);
                dispatch(setUploadProgress(file.id, percentageProgress));
              },
            }
          )
          .then((res) => {
            if (res.data.status) {
              dispatch(successUploadFile(file.id));
              Toast('success', 'Insert Movie Successful ✔');
            } else {
              return res.data.message, 'error';
            }
          })

          .catch((res) => {
            dispatch(failureUploadFile(file.id));
          });
      } else {
        const formPayload = new FormData();
        for (var i = 0; i < data.genres?.length; i++) {
          formPayload.append('genre', data.genres[i]);
        }

        formPayload.append('title', data.title);
        formPayload.append('description', data.description);
        formPayload.append('year', data.year);
        formPayload.append('image', data.image);
        formPayload.append('type', data.type);
        formPayload.append('thumbnail', data.thumbnail);
        formPayload.append('runtime', data.runtime);
        formPayload.append('videoType', data.videoType);
        formPayload.append('region', data.country);
        formPayload.append('link', file.file);

        axios
          .patch(`movie/update?movieId=${movieId}`, formPayload, {
            onUploadProgress: (progress) => {
              const { loaded, total } = progress;
              const percentageProgress = Math.floor((loaded / total) * 100);
              dispatch(setUploadProgress(file.id, percentageProgress));
            },
          })
          .then((res) => {
            dispatch(successUploadFile(file.id));

            if (res.status) {
              dispatch({
                type: UPDATE_MOVIE,
                payload: { data: res.data.movie, id: movieId },
              });

              if (update == 'update') {
                Toast('info', 'Update Movie Successful ✔');
              }
            } else {
              return res.data.message, 'error';
            }
          })
          .catch((error) => {
            dispatch(failureUploadFile(file.id));
          });
      }
    });
  }
  if (movieId && data.videoType != 7) {
    const formPayload = new FormData();
    for (var i = 0; i < data.genres?.length; i++) {
      formPayload.append('genre', data.genres[i]);
    }

    formPayload.append('title', data.title);
    formPayload.append('description', data.description);
    formPayload.append('year', data.year);
    formPayload.append('image', data.image);
    formPayload.append('type', data.type);
    formPayload.append('thumbnail', data.thumbnail);
    formPayload.append('runtime', data.runtime);
    formPayload.append('videoType', data.videoType);
    formPayload.append('region', data.country);
    formPayload.append('TmdbMovieId', data.TmdbMovieId);
    if (data.videoType == 0) {
      formPayload.append('link', data.youtubeUrl);
    } else if (data.videoType == 1) {
      formPayload.append('link', data.m3u8Url);
    } else if (data.videoType == 2) {
      formPayload.append('link', data.movUrl);
    } else if (data.videoType == 3) {
      formPayload.append('link', data.mp4Url);
    } else if (data.videoType == 4) {
      formPayload.append('link', data.mkvUrl);
    } else if (data.videoType == 5) {
      formPayload.append('link', data.webmUrl);
    } else {
      formPayload.append('link', data.embedUrl);
    }

    axios
      .patch(`movie/update?movieId=${movieId}`, formPayload)
      .then((res) => {
        if (res.data.status) {
          dispatch({
            type: UPDATE_MOVIE,
            payload: { data: res.data.movie, id: movieId },
          });

          if (update == 'update') {
            Toast('info', 'Update Movie Successful ✔');
          }
        } else {
          return res.data.message, 'error';
        }
      })
      .catch((error) => {
        console.log(error);
      });
  }
  if (!movieId && data.videoType != 7 && files.length === 0) {
    const formPayload = new FormData();
    formPayload.append('videoType', data.videoType);
    if (data.videoType == 0) {
      formPayload.append('link', data.youtubeUrl);
    } else if (data.videoType == 1) {
      formPayload.append('link', data.m3u8Url);
    } else if (data.videoType == 2) {
      formPayload.append('link', data.movUrl);
    } else if (data.videoType == 3) {
      formPayload.append('link', data.mp4Url);
    } else if (data.videoType == 4) {
      formPayload.append('link', data.mkvUrl);
    } else if (data.videoType == 5) {
      formPayload.append('link', data.webmUrl);
    } else {
      formPayload.append('link', data.embedUrl);
    }

    axios
      .post(
        `movie/getStore?TmdbMovieId=${data.tmdbMovieId}&type=MOVIE`,
        formPayload
      )
      .then((res) => {
        if (res.data.status) {
          dispatch({ type: INSERT_MOVIE, payload: res.data.movie });
          Toast('success', 'Insert Movie Successful ✔');
        } else {
          return res.data.message, 'error';
        }
      })
      .catch((error) => console.log(error));
  }
};

export const setUploadFileManual = (data) => ({
  type: uploadFileTypes.SET_UPLOAD_FILE_MANUAL,
  payload: data,
});

export const setUploadProgressManual = (id, progress) => ({
  type: uploadFileTypes.SET_UPLOAD_PROGRESS_MANUAL,
  payload: {
    id,
    progress,
  },
});

export const successUploadFileManual = (id) => ({
  type: uploadFileTypes.SUCCESS_UPLOAD_FILE_MANUAL,
  payload: id,
});

export const failureUploadFileManual = (id) => ({
  type: uploadFileTypes.FAILURE_UPLOAD_FILE_MANUAL,
  payload: id,
});

//create manual movie
export const manualMovie = (files, data) => (dispatch) => {
  if (files.length && data.videoType == 7) {
    files.map((file, index) => {
      const formPayload = new FormData();

      for (var i = 0; i < data.genres?.length; i++) {
        formPayload.append('genre', data.genres[i]);
      }
      formPayload.append('videoType', data.videoType);
      formPayload.append('link', file.file);
      formPayload.append('title', data.title);
      formPayload.append('description', data.description);
      formPayload.append('year', data.year);
      formPayload.append('region', data.country);
      formPayload.append('image', data.image);
      formPayload.append('type', data.type);
      formPayload.append('thumbnail', data.thumbnail);
      formPayload.append('runtime', data.runtime);
      formPayload.append('trailerName', data.trailerName);
      formPayload.append('trailerType', data.trailerType);
      formPayload.append('trailerVideoType', data.trailerVideoType);
      formPayload.append('trailerImage', data.trailerImage);
      formPayload.append(
        'trailerVideoUrl',
        data.trailerVideoType == 0 ? data.trailerVideoUrl : data.trailerVideo
      );

      axios
        .post(`movie/create`, formPayload, {
          onUploadProgress: (progress) => {
            const { loaded, total } = progress;
            const percentageProgress = Math.floor((loaded / total) * 100);
            dispatch(setUploadProgressManual(file.id, percentageProgress));
          },
        })
        .then((res) => {
          if (res.data.status) {
            dispatch(successUploadFileManual(file.id));
            Toast('success', 'Insert Movie Successful ✔');
          } else {
            return res.data.message, 'error';
          }
        })

        .catch((error) => {
          console.error('error', error);
          dispatch(failureUploadFileManual(file.id));
        });
    });
  }
};

//get movie detail from tmdb
export const loadMovieData = (tmdbId, tmdbTitle) => (dispatch) => {
  const url = tmdbId
    ? `movie/getStoredetails?IMDBid=${tmdbId}&type=MOVIE`
    : `movie/getStoredetails?title=${tmdbTitle}&type=MOVIE`;
  api
    .get(url)
    .then((res) => {
      // debugger;
      if (res.data.status == true) {
        dispatch({ type: MOVIE_DETAILS_TMDB, payload: res.data.movie });
        Toast('success', 'Data Imported Successfully ✔');
      } else {
        Toast('error', 'No data found in database.');
      }
    })
    .catch((error) => {
      console.log(error);
    });
};

export const createManual = (formData) => (dispatch) => {
  axios
    .post('movie/create', formData)
    .then((res) => {
      if (res.data.status) {
        Toast('success', 'Movie Create  SuccessFully');
        dispatch({ type: INSERT_MOVIE, payload: res.data.movie });
      } else {
        Toast('error', res.data.message);
      }
    })
    .catch((error) => {
      console.log('error', error);
    });
};

export const ImdbMovieCreate = (data) => (dispatch) => {
  axios
    .post(`movie/getStore?TmdbMovieId=${data.tmdbId}&type=MOVIE`, data)
    .then((res) => {
      if (res.data.status) {
        dispatch({ type: INSERT_MOVIE, payload: res.data.movie });
        Toast('success', 'Movie Create  SuccessFully');
      } else {
        Toast('error', res.data.message);
      }
      dispatch({ type: CLOSE_LOADER });
    })
    .catch((error) => console.log('error', error));
};
