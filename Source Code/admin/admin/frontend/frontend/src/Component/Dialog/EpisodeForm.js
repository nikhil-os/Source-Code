import React, { useState, useEffect } from "react";

//react-router-dom
import { Link, useHistory } from "react-router-dom";

// material-ui
import { DialogActions, Typography } from "@mui/material";

//react-redux
import { useDispatch, useSelector } from "react-redux";
import { connect } from "react-redux";

//action
import { getMovieCategory } from "../../store/Movie/movie.action";
import { getSeason } from "../../store/Season/season.action";
import {
  insertEpisode,
  updateEpisode,
} from "../../store/Episode/episode.action";

//component
import EpisodeUploadProgress from "../../Pages/EpisodeUploadProgress";
import { setUploadFile } from "../../store/Episode/episode.action";

//Alert

import { uploadFile } from "../../util/AwsFunction";
import { folderStructurePath, baseURL, secretKey } from "../../util/config";
import { Toast } from "../../util/Toast_";
import VideoLoader from "../../util/VideoLoader";
import noImage from "../../Component/assets/images/noImage.png";
import { CLOSE_LOADER, OPEN_LOADER } from "../../store/Loader/loader.type";

const EpisodeForm = (props) => {
  const history = useHistory();
  const dispatch = useDispatch();

  //Get Data from Local Storage
  const dialogData = JSON.parse(sessionStorage.getItem("updateEpisodeData"));

  const dialogData_ = JSON.parse(sessionStorage.getItem("updateMovieData"));


  const [name, setName] = useState("");
  const [desc, setDesc] = useState("");
  const [episodeNumber, setEpisodeNumber] = useState("");
  const [video, setVideo] = useState([]);
  const [videoPath, setVideoPath] = useState("");
  const [image, setImage] = useState([]);
  const [imagePath, setImagePath] = useState("");
  const [movies, setMovies] = useState("");
  const [seasonNumber, setSeasonNumber] = useState(1);
  const [mongoId, setMongoId] = useState("");
  const [videoType, setVideoType] = useState(0);
  const [youtubeUrl, setYoutubeUrl] = useState("");
  const [m3u8Url, setM3u8Url] = useState("");
  const [movUrl, setMovUrl] = useState("");
  const [mp4Url, setMp4Url] = useState("");
  const [updateType, setUpdateType] = useState("");
  const [convertUpdateType, setConvertUpdateType] = useState({
    image: "",
    videoUrl: "",
  });
  const [mkvUrl, setMkvUrl] = useState("");
  const [webmUrl, setWebmUrl] = useState("");
  const [embedUrl, setEmbedUrl] = useState("");
  const [update, setUpdate] = useState("");
  const [uploadProgress, setUploadProgress] = useState(0);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState({
    episodeNumber: "",
    name: "",
    desc: "",
    seasonNumber: "",
    // video: "",
    movies: "",
    image: "",
    videoType: "",
    youtubeUrl: "",
    m3u8Url: "",
    movUrl: "",
    mp4Url: "",
    mkvUrl: "",
    webmUrl: "",
    embedUrl: "",
  });
  const [data, setData] = useState({
    episodeNumber: "",
    name: "",
    desc: "",
    seasonNumber: "",
    movies: "",
    image: "",
    videoType: "",
    youtubeUrl: "",
    m3u8Url: "",
    movUrl: "",
    mp4Url: "",
    mkvUrl: "",
    webmUrl: "",
    embedUrl: "",
    video: "",
  });

  const [resURL, setResURL] = useState({
    episodeImageResURL: "",
    episodeVideoResURL: "",
  });

  const movieTitle = sessionStorage.getItem("seriesTitle");
  const tvSeriesId = sessionStorage.getItem("tvSeriesId");

  //get movie data from movie
  const [movieData, setMovieData] = useState([]);

  //useEffect for getmovie
  useEffect(() => {
    dispatch(getMovieCategory());
  }, [dispatch]);

  //call the movie
  const { movie } = useSelector((state) => state.movie);

  useEffect(() => {
    setMovieData(movie);
  }, [movie]);

  //get tv series season from season
  const [seasonData, setSeasonData] = useState([]);

  //useEffect for getmovie
  useEffect(() => {
    dispatch(getSeason(dialogData_?._id));
  }, [dispatch]);

  //call the season
  const { season } = useSelector((state) => state.season);

  useEffect(() => {
    setSeasonData(season);
  }, [season]);

  //Empty Data After Insertion
  useEffect(() => {
    setName("");
    setDesc("");
    setEpisodeNumber("");
    setSeasonNumber("");
    setVideo([]);
    setVideoPath("");
    setMovies("");
    setImagePath("");
    setVideoType("");
    setError({
      name: "",
      desc: "",
      episodeNumber: "",
      seasonNumber: "",
      movies: "",
      video: "",
      // videoPath: "",
      image: "",
      videoType: "",
    });
  }, []);

  //Set Value For Update
  useEffect(() => {
    if (dialogData) {
      setEpisodeNumber(dialogData.episodeNumber);
      setName(dialogData.name);
      setDesc(dialogData.description);
      setSeasonNumber(dialogData.season);
      setMongoId(dialogData._id);
      setMovies(dialogData.movieId);
      setVideoPath(dialogData.videoUrl);
      setImagePath(dialogData.image);
      setUpdateType(dialogData?.updateType);
      setConvertUpdateType({
        image: dialogData?.convertUpdateType?.image
          ? dialogData?.convertUpdateType?.image
          : "",
        videoUrl: dialogData?.convertUpdateType?.videoUrl
          ? dialogData?.convertUpdateType?.videoUrl
          : "",
      });
      setVideoType(dialogData.videoType);
      if (dialogData.videoType == 0) {
        setYoutubeUrl(dialogData.videoUrl);
      } else if (dialogData.videoType == 1) {
        setM3u8Url(dialogData.videoUrl);
      } else if (dialogData.videoType == 2) {
        setMp4Url(dialogData.videoUrl);
      } else if (dialogData.videoType == 3) {
        setMkvUrl(dialogData.videoUrl);
      } else if (dialogData.videoType == 4) {
        setWebmUrl(dialogData.videoUrl);
      } else if (dialogData.videoType == 5) {
        setEmbedUrl(dialogData.videoUrl);
      } else if (dialogData.videoType == 7) {
        setMovUrl(dialogData.videoUrl);
      }
    }
  }, []);

  let folderStructureMovieVideo = folderStructurePath + "episodeVideo";


  //Insert Data

  const imageLoad = (event) => {
    const file = event.target.files[0];
    if (file) {
      setImage(file); // Store image file
      setImagePath(URL.createObjectURL(file)); // Show preview
      setUpdateType(1);

      setConvertUpdateType((prev) => ({
        ...prev,
        image: 1,
      }));
    }
  };

  const videoLoad = (event) => {
    const file = event.target.files[0];
    if (file) {
      setVideo(file); // Store file
      setVideoPath(URL.createObjectURL(file)); // Show preview

      setUpdateType(1);
      setConvertUpdateType((prev) => ({
        ...prev,
        videoUrl: 1,
      }));
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    dispatch({ type: OPEN_LOADER }); // ✅ Loader ON at the beginning


    if (!name || !episodeNumber || !imagePath) {
      const error = {};
      if (!name) error.name = "Name is Required !";
      if (!desc) error.desc = "Description is Required !";
      if (!episodeNumber) error.episodeNumber = "Episode Number is Required !";
      // if (!movies) error.movies = "Movie is Required !";
      if (image.length === 0 || !imagePath) error.image = "Image is Require !";
      if (!seasonNumber) error.seasonNumber = "Season is Required !";
      if (!videoType) error.videoType = "Video Type is required !";

      if (videoType == 0) {
        if (!youtubeUrl) error.youtubeUrl = "You tube Url is required !";
      } else if (videoType == 1) {
        if (!m3u8Url) error.m3u8Url = "m3u8 Url is required !";
      } else if (videoType == 2) {
        if (!movUrl) error.movUrl = "Mov Url is required !";
      } else if (videoType == 3) {
        if (!mp4Url) error.mp4Url = "mp4 Url is required !";
      } else if (videoType == 4) {
        if (!mkvUrl) error.mkvUrl = "mkv Url is required !";
      } else if (videoType == 5) {
        if (!webmUrl) error.webmUrl = "webm Url is required !";
      } else if (videoType == 6) {
        if (!embedUrl) error.embedUrl = "embed Url is required !";
      } else if (videoType == 7) {
        if (video.length === 0) error.video = "Video is Required !";
      }

      setError({ ...error });
      dispatch({ type: CLOSE_LOADER }); // ❌ stop loader if validation fails
      return;
    }

    try {
      if (!convertUpdateType || typeof convertUpdateType !== "object") {
        setConvertUpdateType({ image: "", videoUrl: "" });
      }

      let url =
        videoType == 0
          ? youtubeUrl
          : videoType == 1
            ? m3u8Url
            : videoType == 2
              ? mp4Url
              : videoType == 3
                ? mkvUrl
                : videoType == 4
                  ? webmUrl
                  : videoType == 5
                    ? embedUrl
                    : videoType == 7 && movUrl;

      isValidURL(url);

      let uploadedImageURL = imagePath;

      if (image && typeof image !== "string") {
        const { resDataUrl } = await uploadFile(
          image,
          folderStructurePath + "episodeImage"
        );
        uploadedImageURL = resDataUrl;
      }

      let uploadedVideoURL = resURL?.episodeVideoResURL;

      if (videoType == 6 && video && typeof video !== "string") {
        const formData = new FormData();
        formData.append(
          "folderStructure",
          folderStructurePath + "episodeVideo"
        );
        formData.append("keyName", video.name);
        formData.append("content", video);

        const response = await fetch(baseURL + `file/upload-file`, {
          method: "POST",
          headers: {
            key: secretKey,
          },
          body: formData,
        });

        const responseData = await response.json();

        if (responseData?.url) {
          uploadedVideoURL = responseData?.url;
        }
      }

      const objData = {
        movieId: tvSeriesId,
        name,
        description: desc,
        episodeNumber: Number(episodeNumber),
        season: seasonNumber,
        videoType,
        updateType,
        convertUpdateType,
        // image: imagePath,
        image: uploadedImageURL,

        videoUrl:
          videoType == 0
            ? youtubeUrl
            : videoType == 1
              ? m3u8Url
              : videoType == 2
                ? mp4Url
                : videoType == 3
                  ? mkvUrl
                  : videoType == 4
                    ? webmUrl
                    : videoType == 5
                      ? embedUrl
                      : // videoType == 6
                      //   ? resURL?.episodeVideoResURL
                      videoType == 6
                        ? uploadedVideoURL
                        : movUrl,
      };

      props.insertEpisode(objData);

      setTimeout(() => {
        history.push({
          pathname: "/admin/episode",
          state: data,
        });
      }, 3000);
    } catch (err) {
      console.error("Submit Error:", err);
      dispatch({ type: CLOSE_LOADER }); // ❌ Also close loader on any error
    }
  };

  const isValidURL = (url) => {
    const urlRegex = /^(ftp|http|https):\/\/[^ "]+$/;
    return urlRegex.test(url);
  };

  //Update Function
  const updateSubmit = async () => {

    if (
      !name ||
      !desc ||
      !seasonNumber ||
      !movies ||
      !imagePath ||
      !episodeNumber ||
      episodeNumber < 0
    ) {
      const error = {};

      if (!name) error.name = "Name is Required !";
      if (!desc) error.desc = "Description is Required !";
      if (!episodeNumber) error.episodeNumber = "Episode Number is Required !";
      if (episodeNumber < 0) error.episodeNumber = "Episode Number Invalid !";
      if (!seasonNumber) error.seasonNumber = "Season is Required !";
      if (!movies) error.movies = "Movie is Required !";
      if (!imagePath) error.image = "Image is Require !";
      if (videoType == 7) {
        if (video.length === 0) error.video = "Video is Required !";
      }

      return setError({ ...error });
    }

    let uploadedImageURL = imagePath;

    // ✅ If image file is selected (not already uploaded), upload it now
    if (image && typeof image !== "string") {
      const { resDataUrl } = await uploadFile(
        image,
        folderStructurePath + "episodeImage"
      );
      uploadedImageURL = resDataUrl;
    }

    let uploadedVideoURL = resURL?.episodeVideoResURL;

    if (videoType == 6 && video && typeof video !== "string") {
      const formData = new FormData();
      formData.append("folderStructure", folderStructurePath + "episodeVideo");
      formData.append("keyName", video.name);
      formData.append("content", video);

      const response = await fetch(baseURL + `file/upload-file`, {
        method: "POST",
        headers: {
          key: secretKey,
        },
        body: formData,
      });

      const responseData = await response.json();

      if (responseData?.url) {
        uploadedVideoURL = responseData?.url;
      }
    }

    const objData = {
      movieId: tvSeriesId,
      name,
      description: desc,
      episodeNumber: Number(episodeNumber),
      updateType,
      convertUpdateType: convertUpdateType || {},
      season: seasonNumber,
      videoType,
      // image: resURL?.episodeImageResURL,
      image: uploadedImageURL,
      videoUrl:
        videoType == 0
          ? youtubeUrl
          : videoType == 1
            ? m3u8Url
            : videoType == 2
              ? mp4Url
              : videoType == 3
                ? mkvUrl
                : videoType == 4
                  ? webmUrl
                  : videoType == 5
                    ? embedUrl
                    : // videoType == 6
                    //   ? resURL?.episodeVideoResURL
                    videoType == 6
                      ? uploadedVideoURL
                      : movUrl,
    };

    props.updateEpisode(objData, mongoId);
    sessionStorage.removeItem("updateEpisodeData");
    history.push("/admin/episode");
  };

  // Close Dialog
  const handleClose = () => {
    sessionStorage.removeItem("updateEpisodeData");
    history.replace("/admin/episode");
  };

  let folderStructureMovieImage = folderStructurePath + "episodeImage";
  //  Image Load
  // const imageLoad = async (event) => {
  //   setImage(event.target.files[0]);
  //   setUpdateType(1);
  //   setConvertUpdateType({
  //     ...convertUpdateType,
  //     image: 1,
  //   });
  //   const { resDataUrl, imageURL } = await uploadFile(
  //     event.target.files[0],
  //     folderStructureMovieImage
  //   );

  //   setResURL({ ...resURL, episodeImageResURL: resDataUrl });

  //   setImagePath(imageURL);
  // };

  return (
    <>
      <div id="content-page" class="content-page">
        <div class="container-fluid">
          {/* <div class="row">
              <div class="col-12">
                <div class="page-title-box d-sm-flex align-items-center justify-content-between mt-2 mb-3">
                  <h4 class="ml-3">Episode</h4>
                </div>
              </div>
            </div> */}

          <div className="iq-card mt-4">
            <div className="iq-card-header">
              <h4 class="card-title">Episode</h4>
            </div>
            <div className=" iq-card-body p-3">
              <form>
                <div className="form-group">
                  <div className="row">
                    <div className="col-md-6 my-2 ">
                      <label className="float-left styleForTitle">
                        Episode No.
                      </label>
                      <input
                        type="number"
                        min="1"
                        placeholder="1"
                        className="form-control form-control-line"
                        required
                        value={episodeNumber}
                        onChange={(e) => {
                          setEpisodeNumber(e.target.value);

                          if (!e.target.value) {
                            return setError({
                              ...error,
                              episodeNumber: "Episode Number is Required!",
                            });
                          } else {
                            return setError({
                              ...error,
                              episodeNumber: "",
                            });
                          }
                        }}
                      />
                      {error.episodeNumber && (
                        <div className="pl-1 text-left">
                          <Typography
                            variant="caption"
                            style={{
                              fontFamily: "Circular-Loom",
                              color: "#ee2e47",
                            }}
                          >
                            {error.episodeNumber}
                          </Typography>
                        </div>
                      )}
                    </div>
                    <div className="col-md-6 my-2 ">
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
                          {error.name && (
                            <span className="error">{error.name}</span>
                          )}
                        </div>
                      )}
                    </div>
                    <div className="col-md-12 my-2 ">
                      <label className="float-left styleForTitle">
                        Description
                      </label>
                      <textarea
                        type="text"
                        placeholder="Description"
                        className="form-control h-auto  form-control-line"
                        required
                        value={desc}
                        onChange={(e) => {
                          setDesc(
                            e.target.value.charAt(0).toUpperCase() +
                            e.target.value.slice(1)
                          );
                          if (!e.target.value) {
                            return setError({
                              ...error,
                              desc: "Description is Required!",
                            });
                          } else {
                            return setError({
                              ...error,
                              desc: "",
                            });
                          }
                        }}
                      />
                      {error.desc && (
                        <div className="pl-1 text-left">
                          {error.desc && (
                            <span className="error">{error.desc}</span>
                          )}
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="row">
                    {/* <div className="col-md-6 my-2 styleForTitle">
                              <label htmlFor="earning ">Web Series</label>

                              <input
                                type="text"
                                placeholder="Name"
                                className="form-control form-control-line"
                                value={movieTitle}
                              />
                              {error.movies && (
                                <div className="pl-1 text-left">
                                  {error.movies && (
                                    <span className="error">
                                      {error.movies}
                                    </span>
                                  )}
                                </div>
                              )}
                            </div> */}
                    <div className="col-md-6 my-2 styleForTitle">
                      <label htmlFor="earning ">Season</label>
                      <select
                        name="session"
                        value={seasonNumber}
                        className="form-select "
                        onChange={(e) => {
                          setSeasonNumber(e.target.value);

                          if (!e.target.value) {
                            return setError({
                              ...error,
                              seasonNumber: "Season is Required!",
                            });
                          } else {
                            return setError({
                              ...error,
                              seasonNumber: "",
                            });
                          }
                        }}
                      >
                        <option>Select Season</option>
                        {seasonData.map((data, key) => {
                          return (
                            <>
                              <option value={data?._id}>
                                {data?.seasonNumber}
                              </option>
                            </>
                          );
                        })}
                      </select>
                      {error.seasonNumber && (
                        <div className="pl-1 text-left">
                          {error.seasonNumber && (
                            <span className="error">
                              {error.seasonNumber}
                            </span>
                          )}
                        </div>
                      )}
                    </div>
                    <div className="col-md-6 my-2 styleForTitle">
                      <label htmlFor="earning ">Video Type</label>
                      <select
                        id="contentType"
                        name="contentType"
                        class="form-select form-control-line"
                        required
                        value={videoType}
                        onChange={(e) => {
                          setVideoType(parseInt(e.target.value));
                          if (!e.target.value) {
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
                        <option>Select Video Type</option>
                        <option value="0">Youtube Url </option>
                        <option value="1">m3u8 Url </option>
                        <option value="2">MP4 Url</option>
                        <option value="3">MKV Url</option>
                        <option value="4">WEBM Url</option>
                        <option value="5">Embed source</option>
                        <option value="6">
                          File (MP4/MOV/MKV/WEBM)
                          <option value="7">MOV Url </option>
                        </option>
                      </select>
                      {error.videoType && (
                        <div className="pl-1 text-left">
                          {error.videoType && (
                            <span className="error">{error.videoType}</span>
                          )}
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="row">
                    <div className="col-md-6 my-2 styleForTitle">
                      <label htmlFor="earning ">Video URL</label>
                      <div>
                        {videoType == 0 && (
                          <>
                            <input
                              type="text"
                              id="link"
                              placeholder="Link"
                              class="form-control "
                              value={youtubeUrl}
                              onChange={(e) => {
                                setYoutubeUrl(e.target.value);
                                if (!e.target.value) {
                                  return setError({
                                    ...error,
                                    youtubeUrl: "You tube URL is Required!",
                                  });
                                } else {
                                  return setError({
                                    ...error,
                                    youtubeUrl: "",
                                  });
                                }
                              }}
                            />
                            {error.youtubeUrl && (
                              <div className="pl-1 text-left">
                                {error.youtubeUrl && (
                                  <span className="error">
                                    {error.youtubeUrl}
                                  </span>
                                )}
                              </div>
                            )}
                          </>
                        )}
                        {videoType == 1 && (
                          <>
                            <input
                              type="text"
                              id="link"
                              placeholder="Link"
                              class="form-control "
                              value={m3u8Url}
                              onChange={(e) => {
                                setM3u8Url(e.target.value);
                                if (!e.target.value) {
                                  return setError({
                                    ...error,
                                    m3u8Url: "m3u8 URL is Required!",
                                  });
                                } else {
                                  return setError({
                                    ...error,
                                    m3u8Url: "",
                                  });
                                }
                              }}
                            />
                            {error.m3u8Url && (
                              <div className="pl-1 text-left">
                                {error.m2u8Url && (
                                  <span className="error">
                                    {error.m2u8Url}
                                  </span>
                                )}
                              </div>
                            )}
                          </>
                        )}
                        {videoType == 2 && (
                          <>
                            <input
                              type="text"
                              id="link"
                              placeholder="Link"
                              class="form-control "
                              value={movUrl}
                              onChange={(e) => {
                                setMovUrl(e.target.value);
                                if (!e.target.value) {
                                  return setError({
                                    ...error,
                                    movUrl: "mov URL is Required!",
                                  });
                                } else {
                                  return setError({
                                    ...error,
                                    movUrl: "",
                                  });
                                }
                              }}
                            />
                            {error.movUrl && (
                              <div className="pl-1 text-left">
                                {error.movUrl && (
                                  <span className="error">
                                    {error.movUrl}
                                  </span>
                                )}
                              </div>
                            )}
                          </>
                        )}
                        {videoType == 3 && (
                          <>
                            <input
                              type="text"
                              id="link"
                              placeholder="Link"
                              class="form-control "
                              value={mp4Url}
                              onChange={(e) => {
                                setMp4Url(e.target.value);
                                if (!e.target.value) {
                                  return setError({
                                    ...error,
                                    mp4Url: "mp4 URL is Required!",
                                  });
                                } else {
                                  return setError({
                                    ...error,
                                    mp4Url: "",
                                  });
                                }
                              }}
                            />
                            {error.mp4Url && (
                              <div className="pl-1 text-left">
                                {error.mp4Url && (
                                  <span className="error">
                                    {error.mp4Url}
                                  </span>
                                )}
                              </div>
                            )}
                          </>
                        )}
                        {videoType == 4 && (
                          <>
                            <input
                              type="text"
                              id="link"
                              placeholder="Link"
                              class="form-control "
                              value={mkvUrl}
                              onChange={(e) => {
                                setMkvUrl(e.target.value);
                                if (!e.target.value) {
                                  return setError({
                                    ...error,
                                    mkvUrl: "mkv URL is Required!",
                                  });
                                } else {
                                  return setError({
                                    ...error,
                                    mkvUrl: "",
                                  });
                                }
                              }}
                            />
                            {error.mkvUrl && (
                              <div className="pl-1 text-left">
                                <Typography
                                  variant="caption"
                                  style={{
                                    fontFamily: "Circular-Loom",
                                    color: "#ee2e47",
                                  }}
                                >
                                  {error.mkvUrl}
                                </Typography>
                              </div>
                            )}
                          </>
                        )}
                        {videoType == 5 && (
                          <>
                            <input
                              type="text"
                              id="link"
                              placeholder="Link"
                              class="form-control "
                              value={webmUrl}
                              onChange={(e) => {
                                setWebmUrl(e.target.value);
                                if (!e.target.value) {
                                  return setError({
                                    ...error,
                                    webmUrl: "webm URL is Required!",
                                  });
                                } else {
                                  return setError({
                                    ...error,
                                    webmUrl: "",
                                  });
                                }
                              }}
                            />
                            {error.webmUrl && (
                              <div className="pl-1 text-left">
                                <Typography
                                  variant="caption"
                                  style={{
                                    fontFamily: "Circular-Loom",
                                    color: "#ee2e47",
                                  }}
                                >
                                  {error.webmUrl}
                                </Typography>
                              </div>
                            )}
                          </>
                        )}
                        {videoType == 7 && (
                          <>
                            <input
                              type="text"
                              id="link"
                              placeholder="Link"
                              class="form-control "
                              value={embedUrl}
                              onChange={(e) => {
                                setEmbedUrl(e.target.value);
                                if (!e.target.value) {
                                  return setError({
                                    ...error,
                                    embedUrl: "embed URL is Required!",
                                  });
                                } else {
                                  return setError({
                                    ...error,
                                    embedUrl: "",
                                  });
                                }
                              }}
                            />
                            {error.embedUrl && (
                              <div className="pl-1 text-left">
                                <Typography
                                  variant="caption"
                                  style={{
                                    fontFamily: "Circular-Loom",
                                    color: "#ee2e47",
                                  }}
                                >
                                  {error.embedUrl}
                                </Typography>
                              </div>
                            )}
                          </>
                        )}
                        {videoType == 6 && (
                          <>
                            <input
                              type="file"
                              id="customFile"
                              // id="dVideo"
                              className="form-control"
                              accept="video/*"
                              required=""
                              onChange={videoLoad}
                            />
                            <p className='extention-show'>Accept only .mp4, .mov, .mkv, .webm</p>
                            {loading ? (
                              <div style={{ marginTop: "30px" }}>
                                {" "}
                                <VideoLoader />
                              </div>
                            ) : (
                              videoPath && (
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
                              )
                            )}
                            {error.video && (
                              <div className="pl-1 text-left">
                                <Typography
                                  variant="caption"
                                  style={{
                                    fontFamily: "Circular-Loom",
                                    color: "#ee2e47",
                                  }}
                                >
                                  {error.video}
                                </Typography>
                              </div>
                            )}
                          </>
                        )}
                      </div>
                    </div>
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
                      <p className='extention-show'>Accept only .png, .jpeg and .jpg</p>
                      {image.length === 0 ? (
                        <div className="pl-1 text-left">
                          <Typography
                            variant="caption"
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
                                " rgba(105, 103, 103, 0) 0px 5px 15px 0px",
                              border:
                                "0.5px solid rgba(255, 255, 255, 0.2)",
                              borderRadius: "10px",
                              marginTop: "10px",
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
                  </div>

                  <div className="row"></div>
                </div>


                <EpisodeUploadProgress
                  data={data}
                  mongoId={mongoId}
                  update={update}
                />
              </form>


            </div>
            <div className="iq-card-footer">
              <DialogActions>
                {dialogData ? (
                  <button
                    type="button"
                    className="btn btn-success btn-sm px-3 py-1"
                    onClick={updateSubmit}
                    disabled={loading === true ? true : false}
                  >
                    Update
                  </button>
                ) : (
                  <button
                    type="button"
                    className="btn btn-success btn-sm px-3 py-1"
                    onClick={handleSubmit}
                    disabled={loading === true ? true : false}
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
  setUploadFile,
  insertEpisode,
  updateEpisode,
  getSeason,
  // getMovie,
  getMovieCategory,
})(EpisodeForm);
