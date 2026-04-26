import React, { useState, useEffect } from "react";

//react-router-dom
import { useHistory, useLocation } from "react-router-dom";

// material-ui
import { DialogActions, Typography } from "@mui/material";

//react-redux
import { useDispatch, useSelector } from "react-redux";
import { connect } from "react-redux";

//action
import { getMovie, getMovieCategory } from "../../store/Movie/movie.action";
import {
  insertTrailer,
  updateTrailer,
} from "../../store/Trailer/trailer.action";

//alert

import { uploadFile } from "../../util/AwsFunction";
import { folderStructurePath } from "../../util/config";
import noImage from "../../Component/assets/images/noImage.png";
import { CLOSE_LOADER, OPEN_LOADER } from "../../store/Loader/loader.type";

const SeriesTrailerForm = (props) => {
  const history = useHistory();
  const movieTitle = sessionStorage.getItem("seriesTitle");
  const tvSeriesId = sessionStorage.getItem("tvSeriesId");
  const dispatch = useDispatch();

  //Get Data from Local Storage
  const dialogData = JSON.parse(sessionStorage.getItem("updateTrailerData"));
  const [name, setName] = useState("");
  const [type, setType] = useState("");
  const [video, setVideo] = useState([]);
  const [videoPath, setVideoPath] = useState("");
  const [image, setImage] = useState([]);
  const [imagePath, setImagePath] = useState("");
  const [movie, setMovie] = useState("");
  const [videoType, setVideoType] = useState("");
  const [mongoId, setMongoId] = useState("");
  const [videoUrl, setVideoUrl] = useState(null);
  const [updateType, setUpdateType] = useState("");
  const [convertUpdateType, setConvertUpdateType] = useState({
    trailerImage: "",
    videoUrl: "",
  });
  // const [showURL, setShowURL] = useState({
  //   trailerImageShowURL: "",
  //   trailerVideoShowURL: "",
  // });
  const [resURL, setResURL] = useState({
    trailerImageResURL: "",
    trailerVideoResURL: "",
  });
  const [error, setError] = useState({
    name: "",
    type: "",
    video: "",
    videoUrl: "",
    videoType: "",
    movie: "",
    image: "",
  });

  const tmdbId = JSON.parse(sessionStorage.getItem("updateMovieData1"));

  const { movie: movieList } = useSelector((state) => state.movie);

  // useEffect(() => {
  //   setName("");
  //   setType("");
  //   setVideoUrl("");
  //   setVideoType("");
  //   setVideo("");
  //   setVideoPath("");
  //   setMovie("");
  //   setImagePath("");
  //   setError({
  //     name: "",
  //     movie: "",
  //     videoUrl: "",
  //     videoType: "",
  //     video: "",
  //     videoPath: "",
  //     image: "",
  //   });
  // }, []);

  //Set Value For Update
  useEffect(() => {
    setName(dialogData?.name);
    setType(dialogData?.type);
    setMongoId(dialogData?._id);
    setUpdateType(dialogData?.updateType);
    setUpdateType(dialogData?.updateType);
    setConvertUpdateType({
      trailerImage: dialogData?.convertUpdateType?.trailerImage
        ? dialogData?.convertUpdateType?.trailerImage
        : "",
      videoUrl: dialogData?.convertUpdateType?.videoUrl
        ? dialogData?.convertUpdateType?.videoUrl
        : "",
    });
    setMovie(dialogData?.movieId);
    setImagePath(dialogData?.trailerImage);
    setVideoType(dialogData?.videoType);

    if (dialogData?.videoType == 0) {
      setVideoUrl(dialogData?.videoUrl);
    } else if (dialogData?.videoType == 1) {
      setVideoPath(dialogData?.videoUrl);
    }
  }, []);

  //useEffect for getmovie
  useEffect(() => {
    dispatch(getMovie());
  }, [dispatch]);

  //Insert Data
  // const insertSubmit = () => {
  //   if (!name || !type || type === 'select Trails' || videoType == 'select') {
  //     const error = {};
  //     if (!name) error.name = 'Name is Required !';
  //     if (videoType == 'select') error.videoType = 'Video0 Type is Required';

  //     if (!videoType) {
  //       if (!videoUrl) {
  //         error.videoUrl = 'Youtube URL is Required !';
  //       }
  //     } else if (videoType == 1) {
  //       if (video.length === 0 && !videoPath) {
  //         error.video = 'Video is Required !';
  //       }
  //     }

  //     if (!type || type === 'select Trails') error.type = 'Type is Required !';

  //     if (!imagePath) error.image = 'Image is Require !';

  //     return setError({ ...error });
  //   } else {
  //     

  //     if (dialogData) {
  //       if (resURL?.trailerImageResURL || resURL?.trailerVideoResURL) {
  //         const objData = {
  //           name,
  //           type,
  //           videoType,
  //           updateType,
  //           convertUpdateType,
  //           movie: tvSeriesId,
  //           trailerImage: resURL?.trailerImageResURL,
  //           videoUrl: videoType == 0 ? videoUrl : resURL?.trailerVideoResURL,
  //         };
  //         props.updateTrailer(objData, dialogData?._id);
  //       } else {
  //         const objData = {
  //           name,
  //           type,
  //           videoType,
  //           updateType,
  //           convertUpdateType,
  //           movie: tvSeriesId,
  //         };

  //         props.updateTrailer(objData, dialogData?._id);
  //         sessionStorage.removeItem('updateTrailerData');
  //       }
  //     } else {
  //       const objData = {
  //         name,
  //         type,
  //         videoType,
  //         updateType,
  //         convertUpdateType,
  //         movie: tvSeriesId,
  //         trailerImage: resURL?.trailerImageResURL,
  //         videoUrl: videoType == 0 ? videoUrl : resURL?.trailerVideoResURL,
  //       };
  //       props.insertTrailer(objData);
  //     }

  //     history.push('/admin/web_series/trailer');
  //   }
  // };
  //Empty Data After Insertion

  let folderStructureTrailerImage = folderStructurePath + "trailerImage";
  //  Image Load
  // const imageLoad = async (event) => {
  //   setImage(event.target.files[0]);
  //   setUpdateType(1);
  //   setConvertUpdateType({
  //     ...convertUpdateType,
  //     trailerImage: 1,
  //   });
  //   setImagePath(URL.createObjectURL(event.target.files[0]));
  //   const { resDataUrl, imageURL } = await uploadFile(
  //     event.target.files[0],
  //     folderStructureTrailerImage
  //   );

  //   setResURL({ ...resURL, trailerImageResURL: resDataUrl });
  //   // setShowURL({ ...showURL, trailerImageShowURL: imageURL });
  // };

  const imageLoad = (event) => {
    const file = event.target.files[0];
    if (file) {
      setImage(file); // sirf state me rakho
      setImagePath(URL.createObjectURL(file)); // preview ke liye
      setUpdateType(1);
      setConvertUpdateType((prev) => ({
        ...prev,
        trailerImage: 1,
      }));
    }
  };

  let folderStructureTrailerVideo = folderStructurePath + "trailerVideo";
  //Video Load
  // const videoLoad = async (event) => {
  //   setVideo(event.target.files[0]);
  //   setUpdateType(1);
  //   setConvertUpdateType({
  //     ...convertUpdateType,
  //     videoUrl: 1,
  //   });
  //   const { resDataUrl, imageURL } = await uploadFile(
  //     event.target.files[0],
  //     folderStructureTrailerVideo
  //   );

  //   setResURL({ ...resURL, trailerVideoResURL: resDataUrl });
  //   // setShowURL({ ...showURL, trailerVideoShowURL: imageURL });

  //   setVideoPath(URL.createObjectURL(event.target.files[0]));
  // };

  const videoLoad = (event) => {
    const file = event.target.files[0];
    if (file) {
      setVideo(file); // sirf state me rakho
      setVideoPath(URL.createObjectURL(file)); // preview ke liye
      setUpdateType(1);
      setConvertUpdateType((prev) => ({
        ...prev,
        videoUrl: 1,
      }));
    }
  };

  //Close Dialog
  const handleClose = () => {
    sessionStorage.removeItem("updateTrailerData");
    history.replace("/admin/web_series/trailer");
  };

  const insertSubmit = async () => {
    dispatch({ type: OPEN_LOADER });

    try {
      if (
        !name ||
        !type ||
        type === "select Trails" ||
        videoType === "select"
      ) {
        // error handling same as before
        const error = {};
        if (!name) error.name = "Name is Required !";
        if (videoType === "select") error.videoType = "Video Type is Required";
        if (videoType == 0 && !videoUrl)
          error.videoUrl = "Youtube URL is Required!";
        if (videoType == 1 && video.length === 0 && !videoPath)
          error.video = "Video is Required!";
        if (!type || type === "select Trails")
          error.type = "Type is Required !";
        if (!imagePath) error.image = "Image is Required!";

        setError({ ...error });
        dispatch({ type: CLOSE_LOADER });
        return;
      }

      // ✅ Image & Video upload yahin karna hai
      let trailerImageResURL = "";
      let trailerVideoResURL = "";

      // Upload trailer image if selected
      if (image) {
        const { resDataUrl } = await uploadFile(
          image,
          folderStructurePath + "trailerImage"
        );
        trailerImageResURL = resDataUrl;
      }

      // Upload trailer video if selected and type == 1
      if (videoType == 1 && video) {
        const { resDataUrl } = await uploadFile(
          video,
          folderStructurePath + "trailerVideo"
        );
        trailerVideoResURL = resDataUrl;
      }

      // ✅ prepare final payload
      const objData = {
        name,
        type,
        videoType,
        updateType,
        convertUpdateType,
        movie: tvSeriesId,
        trailerImage: trailerImageResURL || imagePath,
        videoUrl: videoType == 0 ? videoUrl : trailerVideoResURL,
      };

      if (dialogData) {
        props.updateTrailer(objData, dialogData?._id);
        sessionStorage.removeItem("updateTrailerData");
      } else {
        props.insertTrailer(objData);
      }

      history.push("/admin/web_series/trailer");
    } catch (error) {
      console.error("insertSubmit error:", error);
    } finally {
      dispatch({ type: CLOSE_LOADER }); // 🟢 Close loader always
    }
  };

  return (
    <>
      <div id="content-page" class="content-page">
        <div class="container-fluid">
          {/* <div class="row">
            <div class="row">
              <div class="col-12">
                <div class="page-title-box d-sm-flex align-items-center justify-content-between mt-2 mb-3">
                  <h4 class="ml-3">Trailer </h4>
                </div>
              </div>
            </div> */}

          <div className="iq-card my-4">
            <div className="iq-card-header">
              <h4 class="card-title">Trailer</h4>
            </div>


            <div className="iq-card-body p-3">
              <form>
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
                              name: "Name is Required!",
                            });
                          } else {
                            return setError({
                              ...error,
                              name: "",
                            });
                          }
                        }}
                      />
                      {error.name && (
                        <div className="pl-1 text-left">
                          <Typography
                            variant="caption"
                            color="error"
                            style={{
                              fontFamily: "Circular-Loom",
                              color: "#ee2e47",
                            }}
                          >
                            {error.name}
                          </Typography>
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="row">
                    <div className="col-md-12 my-2 styleForTitle">
                      <label className="float-left">Type</label>
                      <select
                        type="text"
                        className="form-select form-control-line"
                        value={type}
                        onChange={(e) => {
                          setType(e.target.value);

                          if (e.target.value === "select Trails") {
                            return setError({
                              ...error,
                              type: "Trailer Type is Required!",
                            });
                          } else {
                            return setError({
                              ...error,
                              type: "",
                            });
                          }
                        }}
                      >
                        <option value="select Trails">Select Type</option>
                        <option value="trailer">Trailer</option>
                        <option value="teaser">Teaser </option>
                        <option value="clip">Clip </option>
                      </select>

                      {error.type && (
                        <div className="pl-1 text-left">
                          <Typography
                            variant="caption"
                            color="error"
                            style={{
                              fontFamily: "Circular-Loom",
                              color: "#ee2e47",
                            }}
                          >
                            {error.type}
                          </Typography>
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="row">
                    <div className="col-md-6 my-2 styleForTitle">
                      <label htmlFor="earning ">Movie</label>

                      <input
                        type="text"
                        placeholder="Name"
                        className="form-control form-control-line"
                        required
                        value={movieTitle}
                        readOnly
                      />
                      {error.movie && (
                        <div className="pl-1 text-left">
                          <Typography
                            variant="caption"
                            color="error"
                            style={{
                              fontFamily: "Circular-Loom",
                              color: "#ee2e47",
                            }}
                          >
                            {error.movie}
                          </Typography>
                        </div>
                      )}
                    </div>
                    <div className="col-md-6 my-2 styleForTitle">
                      <label
                      // className="movieForm"
                      // style={{ paddingTop: "1.5px" }}
                      >
                        Video Type
                      </label>
                      <div>
                        <select
                          id="contentType"
                          name="contentType"
                          class="form-select form-control-line"
                          required
                          value={videoType}
                          onChange={(e) => {
                            setVideoType(e.target.value);
                            if (e.target.value === "select") {
                              return setError({
                                ...error,
                                videoType: "Video Type is Required!",
                              });
                            } else {
                              return setError({
                                ...error,
                                videoType: "",
                              });
                            }
                          }}
                        >
                          <option value="select">Select Video Type</option>
                          <option value="0">Youtube Url </option>
                          <option value="1">File (MP4/MOV/MKV/WEBM)</option>
                        </select>
                        {error.videoType && (
                          <div className="pl-1 text-left">
                            <Typography
                              variant="caption"
                              color="error"
                              style={{
                                fontFamily: "Circular-Loom",
                                color: "#ee2e47",
                              }}
                            >
                              {error.videoType}
                            </Typography>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>

                  <div className="row">
                    <div className="col-md-6 my-2">
                      <label className="float-left styleForTitle">
                        Image
                      </label>
                      <input
                        type="file"
                        id="customFile"
                        className="form-control"
                        accept="image/png, image/jpeg ,image/jpg"
                        Required=""
                        onChange={imageLoad}
                      />
                      <p className='extention-show'>Accept only .png, .jpeg, .jpeg</p>
                      {image.length === 0 ? (
                        <div className="pl-1 text-left">
                          <Typography
                            variant="caption"
                            color="error"
                            style={{
                              fontFamily: "Circular-Loom",
                              color: "#ee2e47",
                            }}
                          >
                            {error.image}
                          </Typography>
                        </div>
                      ) : (
                        ""
                      )}

                      {imagePath && (
                        <>
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
                                "rgb(101 132 173 / 35%) 0px 0px 0px 1.2px;",
                              borderRadius: 10,
                              marginTop: 10,
                              float: "left",
                            }}
                          />

                          <div
                            className="img-container"
                            style={{
                              display: "inline",
                              position: "relative",
                              float: "left",
                            }}
                          ></div>
                        </>
                      )}
                    </div>
                    <div className="col-md-6 my-2 styleForTitle">
                      <label htmlFor="earning ">Video URL</label>
                      <div>
                        {videoType == 0 && (
                          <>
                            <input
                              type="text"
                              // id="link"
                              placeholder="Link"
                              class="form-control "
                              value={videoUrl}
                              onChange={(e) => {
                                setVideoUrl(e.target.value);
                                if (e.target.value) {
                                  return setError({
                                    ...error,
                                    videoUrl: "Link Is Reburied",
                                  });
                                } else {
                                  return setError({
                                    ...error,
                                    videoUrl: "",
                                  });
                                }
                              }}
                            />
                          </>
                        )}
                        {videoType == 1 && (
                          <>
                            <input
                              type="file"
                              id="customFile"
                              className="form-control"
                              accept="video/*"
                              required=""
                              onChange={videoLoad}
                            />
                            <p className='extention-show'>Accept only .mp4, .mov, .mkv, .webm</p>
                            {videoPath ? (
                              <>
                                <video
                                  height="100px"
                                  width="100px"
                                  controls
                                  alt="app"
                                  src={videoPath}
                                  style={{
                                    boxShadow:
                                      " rgba(105, 103, 103, 0) 0px 5px 15px 0px",
                                    border:
                                      "0.5px solid rgba(255, 255, 255, 0.2)",
                                    borderRadius: "10px",
                                    marginTop: "10px",
                                    float: "left",
                                  }}
                                />

                                <div
                                  class="img-container"
                                  style={{
                                    display: "inline",
                                    position: "relative",
                                    float: "left",
                                  }}
                                ></div>
                              </>
                            ) : (
                              <>
                                <div className="pl-1 text-left">
                                  <Typography
                                    variant="caption"
                                    color="error"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.video}
                                  </Typography>
                                </div>
                              </>
                            )}
                          </>
                        )}
                      </div>
                    </div>
                  </div>
                </div>


              </form>
            </div>
            <div className="iq-card-footer">
              <DialogActions>
                {dialogData ? (
                  <button
                    type="button"
                    className="btn btn-success btn-sm px-3 py-1"
                    onClick={insertSubmit}
                  >
                    Update
                  </button>
                ) : (
                  <button
                    type="button"
                    className="btn btn-success btn-sm px-3 py-1"
                    onClick={insertSubmit}
                  >
                    Insert
                  </button>
                )}
                <button
                  type="button"
                  className="btn btn-danger btn-sm px-3 py-1"
                  onClick={handleClose}
                >
                  Cancel
                </button>
              </DialogActions>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default connect(null, {
  insertTrailer,
  updateTrailer,
  getMovie,
})(SeriesTrailerForm);
