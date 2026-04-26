import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  Tooltip,
  Typography,
} from "@mui/material";
import React, { useEffect, useState } from "react";
import { connect, useDispatch, useSelector } from "react-redux";
import { CLOSE_SEASON_DIALOG } from "../../store/Season/season.type";
import {
  updateSeason,
  CreateSeason,
  getSeason,
} from "../../store/Season/season.action";
import { getMovieCategory } from "../../store/Movie/movie.action";
import placeholderImage from "../assets/images/defaultUserPicture.jpg";
//Alert

import { uploadFile } from "../../util/AwsFunction";
import { folderStructurePath } from "../../util/config";
import noImage from "../../Component/assets/images/noImage.png";
import { CLOSE_LOADER, OPEN_LOADER } from "../../store/Loader/loader.type";
import { IconX } from "@tabler/icons-react";

const SeasonDialogue = (props) => {
  const {
    dialog: open,
    dialogData,
    season,
  } = useSelector((state) => state.season);

  const tmdbId = JSON.parse(sessionStorage.getItem("updateMovieData"));

  const [name, setName] = useState("");
  const [seasonNumber, setSeasonNumber] = useState("");
  const [image, setImage] = useState([]);
  const [imagePath, setImagePath] = useState("");
  const [episodeCount, setEpisodeCount] = useState("");
  const [releaseDate, setReleaseDate] = useState("");
  const [updateType, setUpdateType] = useState("");
  const [convertUpdateType, setConvertUpdateType] = useState({
    image: "",
    link: "",
  });
  const [movie, setMovie] = useState("");
  const [resUrl, setResUrl] = useState("");

  const [error, setError] = useState("");
  const dispatch = useDispatch();
  const handleClose = () => {
    dispatch({ type: CLOSE_SEASON_DIALOG });
  };

  //useEffect for getmovie
  useEffect(() => {
    dispatch(getMovieCategory());
  }, [dispatch]);

  useEffect(
    () => () => {
      setName("");
      setEpisodeCount("");
      setReleaseDate("");
      setImage("");
      setImagePath("");
      setSeasonNumber("");
      setMovie("");
      setError({
        releaseDate: "",
        episodeCount: "",
        seasonNumber: "",
        movie: "",
        image: "",
      });
    },
    [open]
  );
  useEffect(() => {
    setImagePath(
      dialogData?.image === "https://www.themoviedb.org/t/p/originalnull"
        ? placeholderImage
        : dialogData?.image
    );

    setName(dialogData?.name);
    setName(dialogData?.name);
    setEpisodeCount(dialogData?.episodeCount);
    setReleaseDate(dialogData?.releaseDate);
    setSeasonNumber(dialogData?.seasonNumber);
    setMovie(dialogData?.movie?._id);
    setConvertUpdateType({
      image: dialogData?.convertUpdateType?.image
        ? dialogData?.convertUpdateType?.image
        : "",
      link: dialogData?.convertUpdateType?.link
        ? dialogData?.convertUpdateType?.link
        : "",
    });
  }, [dialogData]);

  //  Image Load fffff

  let folderStructureMovieImage = folderStructurePath + "seasonImage";
  // const imageLoad = async (event) => {
  //   setUpdateType(1);
  //   setConvertUpdateType({
  //     ...convertUpdateType,
  //     image: 1,
  //   });
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
      setImage(file); // 🔐 File store karein
      setImagePath(URL.createObjectURL(file)); // 👁 Preview ke liye local URL
      setUpdateType(1);
      setConvertUpdateType((prev) => ({
        ...prev,
        image: 1,
      }));
    }
  };

  //  const submitUpdate = () => {
  //     
  //     if (
  //       !releaseDate ||
  //       !episodeCount ||
  //       episodeCount < 0 ||
  //       !seasonNumber ||
  //       seasonNumber < 0 ||
  //       !name ||
  //       movie === 'selectSeries'
  //     ) {
  //       const error = {};
  //       if (!name) error.name = 'Name IS Required !';
  //       if (!releaseDate) error.releaseDate = 'Release Date Is Required !';
  //       if (!episodeCount) error.episodeCount = 'episodeCount Is Required !';
  //       if (episodeCount < 0) error.episodeCount = 'Episode Count Is Invalid  !';
  //       if (!seasonNumber) error.seasonNumber = 'season Number Is Required !';
  //       if (seasonNumber < 0) error.seasonNumber = 'season Number  Is Invalid  !';
  //       if (image.length === 0) error.image = 'Image Is Required !';

  //       error.movie = 'Series Is Required !';
  //       return setError({ ...error });
  //     } else {
  //       if (dialogData) {
  //         if (resUrl) {
  //           let objData = {
  //             name,
  //             seasonNumber,
  //             episodeCount,
  //             releaseDate,
  //             updateType,
  //             convertUpdateType,
  //             movieId: tmdbId?._id,
  //             image: resUrl,
  //           };
  //           props.updateSeason(objData, dialogData._id);
  //         } else {
  //           let objData = {
  //             name,
  //             seasonNumber,
  //             episodeCount,
  //             updateType,
  //             convertUpdateType,
  //             releaseDate,
  //             movieId: tmdbId?._id,
  //           };
  //           props.updateSeason(objData, dialogData._id);
  //         }
  //       } else {
  //         let objData = {
  //           name,
  //           seasonNumber,
  //           episodeCount,
  //           releaseDate,
  //           movieId: tmdbId?._id,
  //           image: resUrl,
  //         };
  //         props.CreateSeason(objData);
  //       }

  //       handleClose();
  //     }
  //   };

  // const submitUpdate = async () => {
  //   

  //   if (
  //     !releaseDate ||
  //     !episodeCount ||
  //     episodeCount < 0 ||
  //     !seasonNumber ||
  //     seasonNumber < 0 ||
  //     !name
  //   ) {
  //     const error = {};
  //     if (!name) error.name = 'Name is Required!';
  //     if (!releaseDate) error.releaseDate = 'Release Date is Required!';
  //     if (!episodeCount) error.episodeCount = 'Episode Count is Required!';
  //     if (episodeCount < 0) error.episodeCount = 'Episode Count is Invalid!';
  //     if (!seasonNumber) error.seasonNumber = 'Season Number is Required!';
  //     if (seasonNumber < 0) error.seasonNumber = 'Season Number is Invalid!';
  //     // if (!image && !imagePath) error.image = 'Image is Required!';
  //     if (!image && (!imagePath || imagePath === placeholderImage)) {
  //       error.image = 'Image is Required!';
  //     }
  //     setError({ ...error });
  //     return;
  //   }

  //   let uploadedImageUrl = resUrl;

  //   // ✅ Only upload if new image is selected
  //   if (image) {
  //     const { resDataUrl } = await uploadFile(image, folderStructurePath + 'seasonImage');
  //     uploadedImageUrl = resDataUrl;
  //   }

  //   const objData = {
  //     name,
  //     seasonNumber,
  //     episodeCount,
  //     releaseDate,
  //     updateType,
  //     convertUpdateType,
  //     movieId: tmdbId?._id,
  //     image: uploadedImageUrl,
  //   };

  //   if (dialogData) {
  //     props.updateSeason(objData, dialogData._id);
  //   } else {
  //     props.CreateSeason(objData);
  //   }

  //   handleClose();
  // };
  const submitUpdate = async () => {


    const error = {};

    if (!name) error.name = "Name is Required!";
    if (!releaseDate) error.releaseDate = "Release Date is Required!";
    if (!episodeCount) error.episodeCount = "Episode Count is Required!";
    if (episodeCount < 0) error.episodeCount = "Episode Count is Invalid!";
    if (!seasonNumber) error.seasonNumber = "Season Number is Required!";
    if (seasonNumber < 0) error.seasonNumber = "Season Number is Invalid!";
    if (!image && (!imagePath || imagePath === placeholderImage)) {
      error.image = "Image is Required!";
    }

    // ⛔️ If any validation error, stop here
    if (Object.keys(error).length > 0) {
      setError(error);
      return;
    }

    dispatch({ type: OPEN_LOADER }); // ✅ Loader Start

    try {
      let uploadedImageUrl = resUrl;

      if (image) {
        const { resDataUrl } = await uploadFile(
          image,
          folderStructurePath + "seasonImage"
        );
        uploadedImageUrl = resDataUrl;
      }

      const objData = {
        name,
        seasonNumber,
        episodeCount,
        releaseDate,
        updateType,
        convertUpdateType,
        movieId: tmdbId?._id,
        image: uploadedImageUrl,
      };

      if (dialogData) {
        await props.updateSeason(objData, dialogData._id);
      } else {
        await props.CreateSeason(objData);
      }

      handleClose();
    } catch (err) {
      console.error("Submit Error:", err);
      // Optional: Show error toast or alert here
    } finally {
      dispatch({ type: CLOSE_LOADER }); // ✅ Loader Stop (always)
    }
  };

  return (
    <>
      <Dialog
        open={open}
        aria-labelledby="responsive-dialog-title"
        onClose={handleClose}
        disableBackdropClick
        disableEscapeKeyDown
        fullWidth
        maxWidth="sm"
      >
        <div className="modal-header">
          <h2 class="modal-title m-0">
            {dialogData ? <h5>Edit Season</h5> : <h5>Add Season</h5>}
          </h2>
          <button
            className="btn btn-sm custom-action-button"
            onClick={handleClose}
          >
            <IconX className="text-secondary" />
          </button>
        </div>

        {/* </IconButton> */}
        <DialogContent>
          <div className="modal-body pt-1 px-1 pb-3">
            <div className="d-flex flex-column">
              <form>
                <div className="form-group">
                  <div className="row">
                    <div className="col-md-12 my-2">
                      <label className="float-left styleForTitle">Name</label>
                      <input
                        type="text"
                        placeholder="Name"
                        // className="form-control form-control-line"
                        className="form-control"
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
                              name: "name is Required!",
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
                          {error.name && (
                            <span className="error">{error.name}</span>
                          )}
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="row">
                    <div className="col-md-12 my-2">
                      <label className="float-left styleForTitle">
                        Season Number
                      </label>
                      <input
                        type="number"
                        min="0"
                        placeholder="02"
                        // className="form-control form-control-line"
                        className="form-control"
                        required
                        value={seasonNumber}
                        onChange={(e) => {
                          setSeasonNumber(e.target.value);

                          if (!e.target.value) {
                            return setError({
                              ...error,
                              seasonNumber: "season Number is Required!",
                            });
                          } else {
                            return setError({
                              ...error,
                              seasonNumber: "",
                            });
                          }
                        }}
                      />
                      {error.seasonNumber && (
                        <div className="pl-1 text-left">
                          {error.seasonNumber && (
                            <span className="error">{error.seasonNumber}</span>
                          )}
                        </div>
                      )}
                    </div>
                  </div>
                  <div className="row">
                    <div className="col-md-12 my-2">
                      <label className="float-left styleForTitle">
                        Episode Count
                      </label>
                      <input
                        type="number"
                        min="0"
                        placeholder="10"
                        // className="form-control form-control-line"
                        className="form-control"
                        required
                        value={episodeCount}
                        onChange={(e) => {
                          setEpisodeCount(e.target.value);

                          if (!e.target.value) {
                            return setError({
                              ...error,
                              episodeCount: "EpisodeCount is Required!",
                            });
                          } else {
                            return setError({
                              ...error,
                              episodeCount: "",
                            });
                          }
                        }}
                      />
                      {error.episodeCount && (
                        <div className="pl-1 text-left">
                          {error.episodeCount && (
                            <span className="error">{error.episodeCount}</span>
                          )}
                        </div>
                      )}
                    </div>
                  </div>
                  <div className="row">
                    <div className="col-md-12 my-2">
                      <label className="float-left styleForTitle">
                        Release Date
                      </label>
                      <input
                        type="date"
                        placeholder="YYYY-MM-DD"
                        // className="form-control form-control-line"
                        className="form-control"
                        required
                        value={releaseDate}
                        onChange={(e) => {
                          setReleaseDate(e.target.value);

                          if (!e.target.value) {
                            return setError({
                              ...error,
                              releaseDate: "Release Date is Required!",
                            });
                          } else {
                            return setError({
                              ...error,
                              releaseDate: "",
                            });
                          }
                        }}
                      />
                      {error.releaseDate && (
                        <div className="pl-1 text-left">
                          {error.releaseDate && (
                            <span className="error">{error.releaseDate}</span>
                          )}
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="row">
                    <div className="col-md-12 my-2">
                      {/* <label htmlFor="earning ">Web Series</label> */}
                      {/* <select
                        name="session"
                        value={movie}
                        className="form-control"
                        onChange={(e) => {
                          setMovie(e.target.value);
                          if (
                            !e.target.value ||
                            e.target.value === "selectSeries"
                          ) {
                            return setError({
                              ...error,
                              movie: "Series is Required!",
                            });
                          } else {
                            return setError({
                              ...error,
                              movie: "",
                            });
                          }
                        }}
                      >
                        <option>--Select Series--</option>

                        <option value={tvSeriesId}>{movieTitle}</option>
                      </select> */}{" "}
                      {/* <input
                        type="text"
                        placeholder="Name"
                        className="form-control form-control-line"
                        value={movieTitle}
                        readOnly
                        disabled
                      /> */}
                      {/* {error.movie && (
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
                      )} */}
                    </div>
                  </div>
                  <div className="row">
                    <div className="col-md-12 my-2">
                      <label className="float-left styleForTitle">Image</label>
                      <input
                        type="file"
                        id="customFile"
                        className="form-control pt-0 pl-0 pb-0"
                        accept="image/png, image/jpeg ,image/jpg"
                        required=""
                        onChange={imageLoad}
                      // style={{
                      //   paddingTop: "0px !important",
                      //   paddingBottom: "0px !important",
                      //   paddingLeft: "0px !important",
                      // }}
                      />
                      <p className='extention-show'>Accept only .png, .jpeg, .jpeg</p>
                      {image.length === 0 ? (
                        <div className="pl-1 text-left">
                          {error.image && (
                            <div className="pl-1 text-left">
                              <span className="error">{error.image}</span>
                            </div>
                          )}
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
                                " rgba(105, 103, 103, 0) 0px 5px 15px 0px",
                              border: "0.5px solid rgba(255, 255, 255, 0.2)",
                              borderRadius: "10px",
                              marginTop: "10px",
                              float: "left",
                              objectFit: "cover",
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
                  </div>
                </div>
              </form>
            </div>
          </div>
        </DialogContent>
        <div>
          <hr className=" dia_border w-100 mt-0"></hr>
        </div>
        <DialogActions>
          <button
            type="button"
            className="btn btn-danger btn-sm px-3 py-1 mb-3"
            onClick={handleClose}
          >
            Cancel
          </button>
          {dialogData ? (
            <button
              type="button"
              className="btn btn-success btn-sm px-3 py-1 mr-3 mb-3"
              onClick={submitUpdate}
            >
              Update
            </button>
          ) : (
            <button
              type="button"
              className="btn btn-success btn-sm px-3 py-1 mr-3 mb-3"
              onClick={submitUpdate}
            >
              Insert
            </button>
          )}
        </DialogActions>
      </Dialog>
    </>
  );
};
export default connect(null, { CreateSeason, updateSeason, getMovieCategory })(
  SeasonDialogue
);
