import React, { useState, useEffect } from 'react';

//react-router-dom
import { Link, useHistory } from 'react-router-dom';

// material-ui
import { DialogActions, Typography } from '@mui/material';

//react-redux
import { useDispatch, useSelector } from 'react-redux';
import { connect } from 'react-redux';

//action
import { getMovieCategory } from '../../store/Movie/movie.action';
import {
  updateTeamMember,
  insertTeamMember,
} from '../../store/TeamMember/teamMember.action';
import { CLOSE_DIALOG } from '../../store/TeamMember/teamMember.type';
import placeholderImage from '../assets/images/defaultUserPicture.jpg';

//Alert
import { uploadFile } from '../../util/AwsFunction';
import { folderStructurePath } from '../../util/config';

import noImage from '../../Component/assets/images/noImage.png';
import { CLOSE_LOADER, OPEN_LOADER } from '../../store/Loader/loader.type';

const SeriesTeamMemberForm = (props) => {
  const history = useHistory();
  const dispatch = useDispatch();

  const movieTitle = sessionStorage.getItem('seriesTitle');
  const tvSeriesId = sessionStorage.getItem('tvSeriesId');

  //Get Data from Local Storage
  const dialogData = JSON.parse(sessionStorage.getItem('updateTeamMemberData'));

  const [name, setName] = useState('');
  const [position, setPosition] = useState('');
  const [image, setImage] = useState(null);
  const [imagePath, setImagePath] = useState('');
  const [movies, setMovies] = useState('');
  const [mongoId, setMongoId] = useState('');
  const [resUrl, setResUrl] = useState('');
  const [error, setError] = useState({
    name: '',
    position: '',
    movies: '',
    image: '',
  });



  const tmdbId = JSON.parse(sessionStorage.getItem('updateMovieData'));

  const [movieData, setMovieData] = useState([]);

  useEffect(() => {
    dispatch(getMovieCategory());
  }, [dispatch]);

  const { movie } = useSelector((state) => state.movie);
  useEffect(() => {
    setMovieData(movie);
  }, [movie]);

  //Empty Data After Insertion
  useEffect(() => {
    setName('');
    setPosition('');
    // setSeason("");
    setMovies('');
    setImagePath('');
    setError({
      name: '',
      position: '',
      // season: "",
      movies: '',
      image: '',
    });
  }, []);

  useEffect(() => {
    setImagePath(
      dialogData?.image === 'https://www.themoviedb.org/t/p/originalnull'
        ? placeholderImage
        : dialogData?.image
    );

    setName(dialogData?.name);
    setPosition(dialogData?.position);
    // setSeason(dialogData.season);
    setMongoId(dialogData?._id);
    setMovies(dialogData?.movie?._id);
  }, []);

  //Insert and update Data Functionality

  //Close Dialog
  const handleClose = () => {
    sessionStorage.removeItem('updateTeamMemberData');
    history.replace('/admin/web_series/cast');
  };

  let folderStructureMovieImage = folderStructurePath + 'seriesRole';
  //  Image Load
  // const imageLoad = async (event) => {
  //   setImage(event.target.files[0]);
  //   const { resDataUrl, imageURL } = await uploadFile(
  //     event.target.files[0],
  //     folderStructureMovieImage
  //   );

  //   setResUrl(resDataUrl);

  //   setImagePath(imageURL);
  // };

  const imageLoad = (event) => {
    const file = event.target.files[0];
    if (file) {
      setImage(file); // Store file
      setImagePath(URL.createObjectURL(file)); // Show preview only
    }
  };

  //  const handleSubmit = (e) => {
  //     
  //     e.preventDefault();

  //     if (!mongoId) {
  //       if (!image || !imagePath || !name || !position) {
  //         const error = {};
  //         if (!name) error.name = 'Name is Required!';
  //         if (!image || !imagePath) error.image = 'Image is Required!';
  //         if (!position) error.position = 'Position is Required !';

  //         return setError({ ...error });
  //       }
  //     } else {
  //       if (!image && !imagePath && !name && !position && !movies) {
  //         if (!name) error.name = 'Name is Required!';
  //         if (image.length === 0 && !imagePath)
  //           error.image = 'Image is Required!';
  //         if (!position) error.position = 'Position is Required !';
  //         if (!movies) error.movies = 'Movie is Required !';
  //         return setError({ ...error });
  //       }
  //     }
  //     
  //     if (mongoId) {
  //       if (resUrl) {
  //         let objData = {
  //           name,
  //           movieId: tvSeriesId,
  //           position,
  //           image: resUrl,
  //         };
  //         props.updateTeamMember(mongoId, objData);
  //       } else {
  //         let objData = {
  //           name,
  //           movieId: tvSeriesId,
  //           position,
  //         };

  //         props.updateTeamMember(mongoId, objData);
  //       }
  //     } else {
  //       let objData = {
  //         name,
  //         movieId: tvSeriesId,
  //         position,
  //         image: resUrl,
  //       };
  //       props.insertTeamMember(objData);
  //     }
  //     dispatch({ type: CLOSE_DIALOG });
  //     sessionStorage.removeItem('updateTeamMemberData');
  //     // history.push("/admin/web_series/cast");
  //     setTimeout(() => {
  //       history.replace('/admin/web_series/cast');
  //     }, [1000]);
  //   };

  const handleSubmit = async (e) => {
    e.preventDefault();

    dispatch({ type: OPEN_LOADER }); // ✅ Start loader

    const error = {};
    if (!name) error.name = 'Name is Required!';
    if (!position) error.position = 'Position is Required!';
    if (!image && !imagePath) error.image = 'Image is Required!';

    if (Object.keys(error).length > 0) {
      setError(error);
      dispatch({ type: CLOSE_LOADER }); // ❌ Stop loader if validation fails
      return;
    }

    try {
      let uploadedImageUrl = imagePath;

      if (image && typeof image !== 'string') {
        // upload only when user selects a new image
        const { resDataUrl } = await uploadFile(
          image,
          folderStructurePath + 'seriesRole'
        );
        uploadedImageUrl = resDataUrl;
      }

      const objData = {
        name,
        movieId: tvSeriesId,
        position,
        image: uploadedImageUrl,
      };

      if (mongoId) {
        props.updateTeamMember(mongoId, objData);
      } else {
        props.insertTeamMember(objData);
      }

      dispatch({ type: CLOSE_DIALOG });
      sessionStorage.removeItem('updateTeamMemberData');

      setTimeout(() => {
        history.replace('/admin/web_series/cast');
      }, 1000);
    } catch (err) {
      console.error('Submit Error:', err);
      dispatch({ type: CLOSE_LOADER }); // ❌ Stop loader on error
    }
  };

  return (
    <>
      <div
        id="content-page"
        class="content-page"
      >
        <div class="container-fluid">


          <div className="iq-card mt-4">

            <div className="iq-card-header">
              <h4 class="card-title">Episode</h4>
            </div>
            <div className='iq-card-header'>

              <form className='w-100'>
                <div className="form-group">
                  <div className="row">
                    <div className="col-md-12 my-2 ">
                      <label className="float-left styleForTitle">
                        Name
                      </label>
                      <input
                        type="text"
                        placeholder="Name"
                        className="form-control form-control-line"
                        required
                        value={name}
                        onChange={(e) => {
                          setName(
                            e.target.value.charAt(0).toUpperCase() +
                            e.target.value.slice(1)
                          );
                          if (!e.target.value) {
                            return setError({
                              ...error,
                              name: 'Name is Required!',
                            });
                          } else {
                            return setError({
                              ...error,
                              name: '',
                            });
                          }
                        }}
                      />
                      {error.name && (
                        <div className="pl-1 text-left">
                          <Typography
                            variant="caption"
                            style={{
                              fontFamily: 'Circular-Loom',
                              color: '#ee2e47',
                            }}
                          >
                            {error.name}
                          </Typography>
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="row">
                    <div className="col-md-12 my-2 ">
                      <label className="float-left styleForTitle">
                        Role
                      </label>
                      <input
                        type="text"
                        placeholder="Position"
                        className="form-control form-control-line"
                        required
                        value={position}
                        onChange={(e) => {
                          setPosition(e.target.value);

                          if (!e.target.value) {
                            return setError({
                              ...error,
                              position: 'Position is Required!',
                            });
                          } else {
                            return setError({
                              ...error,
                              position: '',
                            });
                          }
                        }}
                      />
                      {error.position && (
                        <div className="pl-1 text-left">
                          <Typography
                            variant="caption"
                            color="error"
                            style={{
                              fontFamily: 'Circular-Loom',
                              color: '#ee2e47',
                            }}
                          >
                            {error.position}
                          </Typography>
                        </div>
                      )}
                    </div>
                  </div>
                  <div className="row">
                    <div className="col-md-12 my-2 styleForTitle">
                      <label htmlFor="earning ">Web Series</label>

                      <input
                        type="text"
                        placeholder="Name"
                        className="form-control form-control-line"
                        value={movieTitle}
                      />
                      {error.movies && (
                        <div className="pl-1 text-left">
                          <Typography
                            variant="caption"
                            color="error"
                            style={{
                              fontFamily: 'Circular-Loom',
                              color: '#ee2e47',
                            }}
                          >
                            {error.movies}
                          </Typography>
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="row">
                    <div className="col-md-12 my-2">
                      <label className="float-left styleForTitle">
                        Image
                      </label>
                      <input
                        type="file"
                        className="form-control"
                        id="customFile"
                        accept="image/png, image/jpeg ,image/jpg"
                        Required=""
                        onChange={imageLoad}
                      />
                      <p className='extention-show'>Accept only .png, .jpeg, .jpeg</p>

                      {imagePath ? (
                        <>
                          {imagePath ? (
                            <img
                              height="100px"
                              width="100px"
                              alt="app"
                              src={imagePath}
                              onError={(e) => {
                                e.target.onerror = null; // Prevents infinite loop
                                e.target.src = noImage; // Default image path
                              }}
                              style={{
                                boxShadow:
                                  ' rgba(105, 103, 103, 0) 0px 5px 15px 0px',
                                border:
                                  '0.5px solid rgba(255, 255, 255, 0.2)',
                                borderRadius: '10px',
                                marginTop: '10px',
                                float: 'left',
                              }}
                            />
                          ) : (
                            ''
                          )}

                          <div
                            className="img-container"
                            style={{
                              display: 'inline',
                              position: 'relative',
                              float: 'left',
                              objectFit: 'cover',
                            }}
                          ></div>
                        </>
                      ) : (
                        <div className="pl-1 text-left">
                          <Typography
                            variant="caption"
                            color="error"
                            style={{
                              fontFamily: 'Circular-Loom',
                              color: '#ee2e47',
                            }}
                          >
                            {error.image}
                          </Typography>
                        </div>
                      )}
                    </div>
                  </div>
                </div>


              </form>
            </div>

            <div className='iq-card-footer'>
              <DialogActions>
                {dialogData ? (
                  <button
                    type="button"
                    className="btn btn-success btn-sm px-3 py-1 mr-3"
                    onClick={handleSubmit}
                  >
                    Update
                  </button>
                ) : (
                  <button
                    type="button"
                    className="btn btn-success btn-sm px-3 py-1 mr-3"
                    onClick={handleSubmit}
                  >
                    Insert
                  </button>
                )}
                <button
                  type="button"
                  className="btn btn-danger btn-sm px-3 py-1 mr-3 "
                  onClick={handleClose}
                >
                  Cancel
                </button>
              </DialogActions>
            </div>






          </div>
        </div>
      </div>

      {/* </div> */}
    </>
  );
};

export default connect(null, {
  insertTeamMember,
  updateTeamMember,
  getMovieCategory,
})(SeriesTeamMemberForm);
