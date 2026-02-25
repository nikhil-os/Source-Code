import React, { useState, useRef, useEffect } from "react";
import UploadProgressTv from "../../Pages/UploadProgressTv";

//react-router-dom
import { useHistory, NavLink } from "react-router-dom";

//material-ui
import { DialogActions, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";

import Paper from "@mui/material/Paper";

import card from "../assets/images/defaultUserPicture.jpg";
import thumb from "../assets/images/5.png";

import { EMPTY_TMDB_SERIES_DIALOGUE } from "../../store/TvSeries/tvSeries.type";
//editor
import SunEditor from "suneditor-react";
import "suneditor/dist/css/suneditor.min.css";

import { ImdbSeriesCreate } from "../../store/TvSeries/tvSeries.action";

//Multi Select Dropdown
import Multiselect from "multiselect-react-dropdown";
import MovieFilterIcon from "@mui/icons-material/MovieFilter";
import RecentActorsIcon from "@mui/icons-material/RecentActors";
import EditIcon from "@mui/icons-material/Edit";
import GetAppIcon from "@mui/icons-material/GetApp";
import AddIcon from "@mui/icons-material/Add";
import DynamicFeedIcon from "@mui/icons-material/DynamicFeed";
import TvIcon from "@mui/icons-material/Tv";

//react-redux
import { connect } from "react-redux";
import { useSelector, useDispatch } from "react-redux";

import {
  // updateSeries,
  loadSeriesData,
  // createSeries,
  setUploadTvFile,
  updateTvSeries,
} from "../../store/TvSeries/tvSeries.action";

import { getGenre } from "../../store/Genre/genre.action";
import { getRegion } from "../../store/Region/region.action";
import { getTeamMember } from "../../store/TeamMember/teamMember.action";

//Alert


//jquery
import $ from "jquery";
import noImage from "../../Component/assets/images/noImage.png";
import { uploadFile } from "../../util/AwsFunction";
import { folderStructurePath } from "../../util/config";
import { Toast } from "../../util/Toast_";
import { CLOSE_LOADER, OPEN_LOADER } from "../../store/Loader/loader.type";
import axios from "axios";
import { debounce } from "lodash";
import AsyncSelect from "react-select/async";

const useStyles1 = makeStyles((theme) => ({
  root: {
    maxWidth: 345,
    display: "flex",
    flexWrap: "wrap",
    "& > *": {
      margin: theme?.spacing && theme?.spacing(1),
      marginBottom: "22px",
    },
  },
}));

const SeriesForm = (props) => {
  const ref = useRef();
  const imageRef = useRef();
  const videoRef = useRef();
  const classes = useStyles1();
  const dispatch = useDispatch();

  const history = useHistory();

  const dialogData = JSON.parse(sessionStorage.getItem("updateMovieData"));

  const editor = useRef(null);
  const [tmdbId, setTmdbId] = useState("");
  const [tmdbTitle, setTmdbTitle] = useState("");
  const [genres, setGenres] = useState([]);
  const [country, setCountry] = useState("");
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [trailerUrl, setTrailerUrl] = useState("");
  const [year, setYear] = useState("");
  const [image, setImage] = useState([]);
  const [imagePath, setImagePath] = useState("");
  const [thumbnail, setThumbnail] = useState([]);
  const [thumbnailPath, setThumbnailPath] = useState("");
  const [video, setVideo] = useState([]);
  const [videoPath, setVideoPath] = useState("");
  const [seriesId, setSeriesId] = useState("");
  const [updateType, setUpdateType] = useState("");
  const [selectThumbail, setSelectThumbail] = useState("");
  const [selectImage, setSelectImage] = useState("");
  const [convertUpdateType, setConvertUpdateType] = useState({
    image: "",
    thumbnail: "",
    link: "",
  });

  const [selectedValue, setSelectedValue] = useState("");
  const [type, setType] = useState("Premium");
  const [update, setUpdate] = useState("");

  const { seriesDetailsTmdb, showData } = useSelector((state) => state.series);
  console.log("seriesDetailsTmdb", seriesDetailsTmdb);

  sessionStorage.setItem("seriesTrailerId", seriesId);
  sessionStorage.setItem("seriesTitle", title);


  const [data, setData] = useState({
    title: "",
    description: "",
    year: "",
    genres: [],
    thumbnail: [],
    image: [],
    type: "",
    country: "",
    tmdbMovieId: "",
  });

  const [error, setError] = useState({
    title: "",
    description: "",
    year: "",
    country: "",
    genres: "",
    image: "",
    thumbnail: "",
    type: "",
  });

  const [resURL, setResURL] = useState({
    thumbnailImageResURL: "",
    seriesImageResURL: "",
    movieVideoResURL: "",
    trailerImageResURL: "",
    trailerVideoResURL: "",
  });

  useEffect(() => {
    setTitle(seriesDetailsTmdb?.title);
    setYear(seriesDetailsTmdb?.year);
    setImagePath(seriesDetailsTmdb?.image);
    setDescription(seriesDetailsTmdb?.description);
    setTrailerUrl(seriesDetailsTmdb?.trailerUrl);
    setThumbnailPath(seriesDetailsTmdb?.thumbnail);
  }, [seriesDetailsTmdb]);

  const genreId = seriesDetailsTmdb?.genre?.map((id) => {
    return id;
  });

  useEffect(() => {
    return () => {
      console.log("executed movie dialog return block");
      dispatch({ type: EMPTY_TMDB_SERIES_DIALOGUE });
    };
  }, []);

  // set data in dialog
  useEffect(() => {
    if (dialogData) {
      const genreId_ = dialogData?.genre?.map((value) => {
        return value;
      });
      setUpdateType(dialogData?.updateType);
      setConvertUpdateType({
        image: dialogData?.convertUpdateType?.image
          ? dialogData?.convertUpdateType?.image
          : "",
        thumbnail: dialogData?.convertUpdateType?.thumbnail
          ? dialogData?.convertUpdateType?.thumbnail
          : "",
        link: dialogData?.convertUpdateType?.link
          ? dialogData?.convertUpdateType?.link
          : "",
      });
      setTitle(dialogData.title);
      setDescription(dialogData.description);
      setYear(dialogData.year);
      setCountry(dialogData.region?._id);
      setGenres(genreId !== undefined ? genreId : genreId_);
      setImagePath(dialogData.image);
      setThumbnailPath(dialogData.thumbnail);
      // setMovieId(dialogData._id);
      setSeriesId(dialogData._id);
      setType(dialogData.type);
    }
  }, []);

  useEffect(() => {
    if (seriesDetailsTmdb) {
      seriesDetailsTmdb?.region?.map((data) => {
        return setCountry(data?._id);
      });
      setSelectedValue(seriesDetailsTmdb.genre);
    }
  }, [seriesDetailsTmdb]);

  useEffect(() => {
    setGenres(genreId);
  }, [seriesDetailsTmdb]);

  //useEffect for Get Data
  useEffect(() => {
    dispatch(getGenre());
    dispatch(getRegion());
  }, [dispatch]);

  useEffect(() => {
    if (dialogData) {
      dispatch(getTeamMember(dialogData?._id));
    }
  }, []);

  // set default image
  $(document).ready(function () {
    $("img").bind("error", function () {
      // Set the default image
      $(this).attr("src", noImage);
    });
  });

  const tmdbMovieDetail = async () => {
    await props.loadSeriesData(tmdbId, tmdbTitle);
  };

  //get genre list
  const [genreData, setGenreData] = useState([]);
  const { genre } = useSelector((state) => state.genre);

  //Set Data after Getting
  useEffect(() => {
    setGenreData(genre);
  }, [genre]);

  //get country list
  const [countries, setCountries] = useState([]);

  const { region } = useSelector((state) => state.region);

  //Set Data after Getting
  useEffect(() => {
    setCountries(region);
  }, [region]);

  //get Teammember list
  const [teamMemberData, setTeamMemberData] = useState([]);

  //call teamMember and set teamMember
  const { teamMember } = useSelector((state) => state.teamMember);

  useEffect(() => {
    setTeamMemberData(teamMember);
  }, [teamMember]);

  const handleFileChange = (e) => {
    const inputName = e.target.name; // name="thumbnailImageResURL" or "seriesImageResURL"
    const file = e.target.files[0];

    console.log("inputName", inputName);
    console.log("file", file);

    if (file) {
      const fileURL = URL.createObjectURL(file);

      if (inputName === "thumbnailImageResURL") {
        setSelectThumbail(file); // Store file for upload
        setThumbnailPath(fileURL); // Preview in UI
      } else if (inputName === "seriesImageResURL") {
        setSelectImage(file); // Store file for upload
        setImagePath(fileURL); // Preview in UI
      }
    }
  };

  let folderStructureMovieImage = folderStructurePath + "seriesImage";

  //  Image Load
  const imageLoad = async (event) => {
    setUpdateType(1);
    setConvertUpdateType({
      ...convertUpdateType,
      image: 1,
    });
    setImage(selectImage);
    const { resDataUrl, imageURL } = await uploadFile(
      selectImage,
      folderStructureMovieImage
    );

    setResURL({ ...resURL, seriesImageResURL: resDataUrl });
    setImagePath(imageURL);
  };

  let folderStructureThumbnail = folderStructurePath + "seriesThumbnail";
  // Thumbnail Load
  const thumbnailLoad = async (event) => {
    setThumbnail(selectThumbail);
    setUpdateType(1);
    setConvertUpdateType({
      ...convertUpdateType,
      thumbnail: 1,
    });
    const { resDataUrl, imageURL } = await uploadFile(
      selectThumbail,
      folderStructureThumbnail
    );
    setResURL({ ...resURL, thumbnailImageResURL: resDataUrl });
    setThumbnailPath(imageURL);
  };

  // Image & Thumbnail Upload Function
  const handleSeriesImageAndThumbnailUpload = async () => {
    let movieImageRes = {};
    let thumbnailRes = {};

    if (selectImage) {
      const folderStructureMovieImage = folderStructurePath + "seriesImage";
      movieImageRes = await uploadFile(selectImage, folderStructureMovieImage);
      setImage(selectImage);
      setUpdateType(1);
      setConvertUpdateType((prev) => ({ ...prev, image: 1 }));
      setResURL((prev) => ({
        ...prev,
        seriesImageResURL: movieImageRes.resDataUrl,
      }));
      setImagePath(movieImageRes.imageURL);
    }

    if (selectThumbail) {
      const folderStructureThumbnail = folderStructurePath + "seriesThumbnail";
      thumbnailRes = await uploadFile(selectThumbail, folderStructureThumbnail);
      setThumbnail(selectThumbail);
      setUpdateType(1);
      setConvertUpdateType((prev) => ({ ...prev, thumbnail: 1 }));
      setResURL((prev) => ({
        ...prev,
        thumbnailImageResURL: thumbnailRes.resDataUrl,
      }));
      setThumbnailPath(thumbnailRes.imageURL);
    }

    return {
      seriesImageResURL: movieImageRes.resDataUrl || "",
      thumbnailImageResURL: thumbnailRes.resDataUrl || "",
    };
  };

  const handleSubmit = async () => {


    dispatch({ type: OPEN_LOADER });

    try {
      if (dialogData) {
        if (!title || !year || !description || !country) {
          const error = {};
          if (genre.length === 0) error.genre = "Genre is Required!";
          if (!title) error.title = "Title is Required!";
          if (!year) error.year = "Year is Required!";
          if (!country) error.country = "Title is Required!";
          if (!description) error.description = "Title is Required!";
          if (image.length === 0) error.image = "Image is Required!";
          if (thumbnail.length === 0) error.thumbnail = "Image is Required!";
          dispatch({ type: CLOSE_LOADER }); // ❌ Stop loader if validation fails
          return setError({ ...error });
        } else {
          const uploaded = await handleSeriesImageAndThumbnailUpload();

          if (uploaded) {
            let objData = {
              title,
              year,
              genre: genres,
              description,
              type,
              updateType: updateType,
              convertUpdateType: convertUpdateType,
              region: country,
              // thumbnail: resURL?.thumbnailImageResURL,
              thumbnail: uploaded.thumbnailImageResURL,
              // image: resURL?.seriesImageResURL,
              image: uploaded.seriesImageResURL,
            };
            await props.updateTvSeries(dialogData?._id, objData);

            setUpdate("update");
          } else {
            let objData = {
              title,
              updateType,
              convertUpdateType,
              year,
              genre: genres,
              description,
              type,
              region: country,
            };
            await props.updateTvSeries(dialogData?._id, objData);

            setUpdate("update");
          }
          setTimeout(() => {
            if (seriesDetailsTmdb) {
              dispatch({ type: EMPTY_TMDB_SERIES_DIALOGUE });
            }
            // history.goBack();
            history.push({ pathname: "/admin/web_series" });
          }, 3000);
        }
      } else {

        let objData = {
          tmdbId: seriesDetailsTmdb?.TmdbMovieId,
          title,
          year,
          genre: genres,
          description,
          type,
          region: country,
          thumbnail: thumbnailPath,
          image: imagePath,
        };

        await props.ImdbSeriesCreate(objData);
        setTimeout(() => {
          if (seriesDetailsTmdb) {
            dispatch({ type: EMPTY_TMDB_SERIES_DIALOGUE });
          }
          history.push({ pathname: "/admin/web_series" });
        }, 3000);
      }
    } catch (error) {
      console.error("Submit Error:", error);
      dispatch({ type: CLOSE_LOADER }); // ✅ Always close loader
      sessionStorage.removeItem("updateMovieData");
    }
  };

  const [selectedGenres, setSelectedGenres] = useState([]);
  // ...

  //onselect function of selecting multiple values
  function onSelect(selectedList, selectedItem) {
    const updatedGenres = [...selectedGenres, selectedItem._id];
    setSelectedGenres(updatedGenres);

    genres?.push(selectedItem?._id);
  }

  //onRemove function for remove multiple values
  function onRemove(selectedList, removedItem) {
    setGenres(selectedList.map((data) => data._id));
  }

  //Close Dialog
  const handleClose = () => {
    sessionStorage.removeItem("updateMovieData");
    history.goBack();
    dispatch({ type: EMPTY_TMDB_SERIES_DIALOGUE });
  };

  const handleClick = (e) => {
    ref.current.click();
  };

  const handleClickImage = (e) => {
    imageRef.current.click();
  };

  const fetchOptions = async (inputValue) => {
    if (!inputValue) return []; // no input, return empty list

    try {
      const res = await axios.get(`/movie/getSearchMovie`, {
        params: {
          title: inputValue,
          type: "WEBSERIES"
        }
      });
      if (res.data.data.length) {
        return res.data.data.map((item) => ({
          label: item.name,
          value: item.id,
        }));
      } else {
        return []
      }
    } catch (err) {
      console.error(err);
      return [];
    }
  };

  const loadOptions = debounce((inputValue, callback) => {
    fetchOptions(inputValue).then(callback);
  }, 500); // 500ms delay

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          {dialogData ? (
            <div className="nav nav-pills mb-3">
              <button className="nav-item navCustom border-0">
                <NavLink
                  className="nav-link"
                  to="/admin/web_series/series_form"
                >
                  Edit
                </NavLink>
              </button>
              <button className="nav-item navCustom border-0">
                <NavLink className="nav-link" to="/admin/web_series/trailer">
                  Trailer
                </NavLink>
              </button>
              <button className="nav-item navCustom border-0">
                <NavLink className="nav-link" to="/admin/web_series/season">
                  Season
                </NavLink>
              </button>
              <button className="nav-item navCustom border-0">
                <NavLink className="nav-link" to="/admin/episode">
                  Episode
                </NavLink>
              </button>
              <button className="nav-item navCustom border-0">
                <NavLink className="nav-link" to="/admin/web_series/cast">
                  Cast
                </NavLink>
              </button>
            </div>
          ) : (
            <>
              <div className="nav nav-pills mb-3">
                <button className="nav-item navCustom border-0">
                  <NavLink
                    className="nav-link"
                    to="/admin/web_series/series_form"
                  >
                    IMDB
                  </NavLink>
                </button>
                <button className="nav-item navCustom border-0">
                  <NavLink
                    className="nav-link"
                    to="/admin/web_series/series_manual"
                  >
                    Manual
                  </NavLink>
                </button>
              </div>
            </>
          )}

          {dialogData ? (
            ""
          ) : (
            <>
              <div className="iq-card mb-3">
                <div class="iq-card-header">
                  <div className="card-title">Import Contents From IMDB</div>
                </div>

                <div class="iq-card-body d-flex  mt-3">
                  <div class="col-lg-5">
                    <input
                      class="form-control"
                      id="imdb_id"
                      type="text"
                      placeholder="Enter IMDB ID. Ex:tt0120338"
                      value={tmdbId}
                      onChange={(e) => {
                        setTmdbId(e.target.value);
                      }}
                    />
                  </div>
                  <p className="align-items-center col-lg-1 d-flex fw-bold justify-content-center mb-0 text-center">
                    OR
                  </p>
                  <div class="col-lg-5 ">
                    {/* <input
                      class="form-control"
                      id="imdb_id"
                      type="text"
                      placeholder="Enter Movie Title"
                      value={tmdbTitle}
                      onChange={(e) => {
                        setTmdbTitle(e.target.value);
                      }}
                      
                    /> */}

                    <AsyncSelect
                      classNamePrefix={"select"}
                      cacheOptions
                      loadOptions={loadOptions}
                      defaultOptions
                      onChange={(newValue) => {
                        console.log("newValue-->", newValue);
                        setTmdbTitle(newValue.label);
                      }}
                    />
                  </div>
                  <div className="col-lg-1">
                    <div>
                      <button
                        type="submit"
                        onClick={tmdbMovieDetail}
                        id="import_btn"
                        className="btn btn-primary btn-sm px-3 py-2 ml-3"
                      >
                        {" "}
                        Fetch{" "}
                      </button>
                    </div>
                  </div>
                </div>
                <div class="row justify-content-center">
                  <div class="col-lg-5">
                    <h6>
                      <p>
                        Find the IMDB ID from
                        <a
                          href="https://www.themoviedb.org/movie/"
                          target="_blank"
                        >
                          TheMovieDB.org
                        </a>{" "}
                        or{" "}
                        <a href="https://www.imdb.com/" target="_blank">
                          Imdb.com
                        </a>{" "}
                      </p>
                    </h6>
                  </div>
                </div>
              </div>
            </>
          )}

          {dialogData || showData ? (
            <>
              <div className="iq-card mb-5">
                <div className="iq-card-header d-flex justify-content-between">
                  <h4 className="card-title my-0">
                    {dialogData?.title || "Insert Series"}
                  </h4>
                </div>
                <div className="iq-card-body">
                  {showData ? (
                    <>
                      <div className=" ">
                        <div className="p-3">
                          <div className="row p-0">
                            <div class="col-6 form-group">
                              <label className="float-left styleForTitle movieForm">
                                Title
                              </label>

                              <input
                                type="text"
                                placeholder="Title"
                                className="form-control form-control-line"
                                Required
                                value={title}
                                onChange={(e) => {
                                  setTitle(
                                    e.target.value.charAt(0).toUpperCase() +
                                    e.target.value.slice(1)
                                  );
                                  if (!e.target.value) {
                                    return setError({
                                      ...error,
                                      title: "Title is Required!",
                                    });
                                  } else {
                                    return setError({
                                      ...error,
                                      title: "",
                                    });
                                  }
                                }}
                              />

                              {error.title && (
                                <div className="pl-1 text-left">
                                  <Typography
                                    variant="caption"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.title}
                                  </Typography>
                                </div>
                              )}
                            </div>
                            <div className="col-6 form-group">
                              <label className="float-left styleForTitle movieForm">
                                Release Year
                              </label>

                              <input
                                type="string"
                                placeholder="YYYY-MM-DD"
                                className="form-control form-control-line"
                                Required
                                min="1950"
                                value={seriesDetailsTmdb?.year}
                                onChange={(e) => {
                                  setYear(e.target.value);

                                  if (!e.target.value) {
                                    return setError({
                                      ...error,
                                      year: "Year is Required!",
                                    });
                                  } else {
                                    return setError({
                                      ...error,
                                      year: "",
                                    });
                                  }
                                }}
                              />

                              {error.year && (
                                <div className="pl-1 text-left">
                                  <Typography
                                    variant="caption"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.year}
                                  </Typography>
                                </div>
                              )}
                            </div>
                            <div className="col-6 form-group">
                              <label className="float-left styleForTitle movieForm">
                                Region
                              </label>

                              <>
                                <select
                                  name="type"
                                  className="form-select form-control-line"
                                  id="type"
                                  value={country}
                                  onChange={(e) => {
                                    setCountry(e.target.value);
                                    if (!e.target.value) {
                                      return setError({
                                        ...error,
                                        country: "Country is Required!",
                                      });
                                    } else {
                                      return setError({
                                        ...error,
                                        country: "",
                                      });
                                    }
                                  }}
                                >
                                  <option>Select Region</option>
                                  {countries.map((data) => {
                                    return (
                                      <option value={data._id}>
                                        {data.name}
                                      </option>
                                    );
                                  })}
                                </select>
                              </>

                              {error.country && (
                                <div className="pl-1 text-left">
                                  <Typography
                                    variant="caption"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.country}
                                  </Typography>
                                </div>
                              )}
                            </div>
                            <div className="col-6 form-group">
                              <label className="float-left movieForm">
                                Free/Premium
                              </label>
                              <select
                                name="type"
                                className="form-select form-control-line selector"
                                id="type"
                                value={type}
                                onChange={(e) => {
                                  setType(e.target.value);

                                  if (!e.target.value) {
                                    return setError({
                                      ...error,
                                      type: "Type is Required!",
                                    });
                                  } else {
                                    return setError({
                                      ...error,
                                      type: "",
                                    });
                                  }
                                }}
                              >
                                <option>Select Type</option>
                                <option value={"Free"}>Free</option>
                                <option value={"Premium"}>Premium</option>
                                {/* <option value={"Default"}>Default</option> */}
                              </select>
                            </div>
                            <div className="col-6 form-group">
                              <label className="styleForTitle movieForm">
                                Genre
                              </label>

                              <Multiselect
                                options={genre} // Options to display in the dropdown
                                selectedValues={selectedGenres} // Preselected value to persist in dropdown
                                displayValue="name" // Property name to display in the dropdown options
                                id="css_custom"
                                placeholder="Select Genre"
                                style={{
                                  chips: {
                                    // background: "rgba(145, 111, 203, 0.69)",
                                  },
                                  multiselectContainer: {
                                    color: "rgba(174, 159, 199, 1)",
                                  },
                                  searchBox: {
                                    border: "none",
                                    "border-bottom": "1px solid blue",
                                    "border-radius": "0px",
                                  },
                                }}
                              />

                              {genres?.length === 0 ? (
                                <div className="pl-1 text-left">
                                  <Typography
                                    variant="caption"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.genres}
                                  </Typography>
                                </div>
                              ) : (
                                ""
                              )}
                            </div>
                            <div className="col-6 form-group">
                              <label className="float-left movieForm">
                                Trailer URL(YouTube Only)
                              </label>
                              {dialogData ? (
                                <input
                                  type="text"
                                  placeholder="https://www.youtube.com"
                                  className="form-control form-control-line"
                                  Required
                                  value={trailerUrl}
                                  onChange={(e) => {
                                    setTrailerUrl(e.target.value);

                                    if (!e.target.value) {
                                      return setError({
                                        ...error,
                                        trailerUrl: "Trailer is Required!",
                                      });
                                    } else {
                                      return setError({
                                        ...error,
                                        trailerUrl: "",
                                      });
                                    }
                                  }}
                                />
                              ) : (
                                <input
                                  type="text"
                                  placeholder="https://www.youtube.com"
                                  className="form-control form-control-line"
                                  Required
                                  value={seriesDetailsTmdb?.trailerUrl}
                                  onChange={(e) => {
                                    setTrailerUrl(e.target.value);

                                    if (!e.target.value) {
                                      return setError({
                                        ...error,
                                        trailerUrl: "Trailer is Required!",
                                      });
                                    } else {
                                      return setError({
                                        ...error,
                                        trailerUrl: "",
                                      });
                                    }
                                  }}
                                />
                              )}

                              {error.trailer && (
                                <div className="pl-1 text-left">
                                  <Typography
                                    variant="caption"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.trailer}
                                  </Typography>
                                </div>
                              )}
                            </div>

                            <div className="col-12 form-group">
                              <label
                                htmlFor="description"
                                className="styleForTitle mt-3 movieForm"
                              >
                                Description
                              </label>

                              <SunEditor
                                value={seriesDetailsTmdb?.description}
                                setContents={seriesDetailsTmdb?.description}
                                ref={editor}
                                height={318}
                                onChange={(e) => {
                                  setDescription(e);

                                  if (!e) {
                                    return setError({
                                      ...error,
                                      description: "Description is Required !",
                                    });
                                  } else {
                                    return setError({
                                      ...error,
                                      description: "",
                                    });
                                  }
                                }}
                                placeholder="Description"
                                setOptions={{
                                  buttonList: [
                                    ["undo", "redo"],
                                    ["font", "fontSize", "formatBlock"],

                                    ["fontColor", "hiliteColor", "textStyle"],
                                    ["removeFormat"],
                                    [
                                      "bold",
                                      "underline",
                                      "italic",
                                      "subscript",
                                      "superscript",
                                    ],

                                    ["align", "list", "lineHeight"],
                                    ["link"],
                                    ["fullScreen"],
                                  ],
                                }}
                              />

                              {error.description && (
                                <div className="pl-1 text-left">
                                  <Typography
                                    variant="caption"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.description}
                                  </Typography>
                                </div>
                              )}
                            </div>

                            <div className="pl-3 form-group">
                              {" "}
                              <label className="mt-3 movieForm">
                                Thumbnail
                              </label>
                              <div className="d-flex justify-content-center align-item-center">
                                <>
                                  <img
                                    alt="app"
                                    src={
                                      seriesDetailsTmdb.thumbnail
                                        ? seriesDetailsTmdb.thumbnail
                                        : thumb
                                    }
                                    onError={(e) => {
                                      e.target.onerror = null; // Prevents infinite loop
                                      e.target.src = noImage; // Default image path
                                    }}
                                    style={{
                                      borderRadius: "5px",
                                      height: "250px",
                                      width: "250px",
                                    }}
                                  />
                                </>
                              </div>
                              {!thumbnailPath ? (
                                <div className="pl-1 text-left">
                                  <Typography
                                    variant="caption"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.thumbnail}
                                  </Typography>
                                </div>
                              ) : (
                                ""
                              )}
                            </div>

                            <div className="pl-3 form-group">
                              <label className="mt-3 movieForm">Image</label>
                              <div className="d-flex justify-content-center align-item-center">
                                <>
                                  {imagePath ? (
                                    <>
                                      {/* <div>
                                        <input
                                          ref={imageRef}
                                          type="file"
                                          className="form-control"
                                          id="customFile"
                                          accept="image/png, image/jpeg ,image/jpg"
                                          Required=""
                                          onChange={imageLoad}
                                          style={{ display: "none" }}
                                          enctype="multipart/form-data"
                                        />
                                      </div> */}
                                      <img
                                        onClick={handleClickImage}
                                        className="img-fluid"
                                        alt="app"
                                        src={imagePath}
                                        onError={(e) => {
                                          e.target.onerror = null; // Prevents infinite loop
                                          e.target.src = noImage; // Default image path
                                        }}
                                        style={{

                                          borderRadius: "5px",
                                          height: "250px",
                                          width: "250px",
                                        }}
                                      />

                                      {/* <p className='extention-show'>Accept only .png, .jpeg, .jpeg dd</p> */}

                                      <div
                                        className="img-container"
                                        style={{
                                          display: "inline",
                                          position: "relative",
                                          float: "left",
                                        }}
                                      ></div>
                                    </>
                                  ) : (
                                    <div className={classes.root}>
                                      <Paper elevation={5}>
                                        <div>
                                          <button
                                            onClick={handleClickImage}
                                            className="upload-button btn"
                                            style={{
                                              // backgroundColor: "#7a788b94 !important",
                                              position: "absolute",
                                              color: "#7a6699",
                                              top: "397px",
                                              right: "302px",
                                            }}
                                          >
                                            <i
                                              class="ri-add-box-fill"
                                              style={{ fontSize: "30px" }}
                                            ></i>
                                          </button>

                                          <input
                                            ref={imageRef}
                                            type="file"
                                            className="form-control"
                                            id="customFile"
                                            accept="image/png, image/jpeg ,image/jpg"
                                            Required=""
                                            onChange={imageLoad}
                                            style={{ display: "none" }}
                                            enctype="multipart/form-data"
                                          />
                                        </div>
                                        <img
                                          src={card}
                                          alt=""
                                          onError={(e) => {
                                            e.target.onerror = null; // Prevents infinite loop
                                            e.target.src = noImage; // Default image path
                                          }}
                                          style={{
                                            height: "100px",
                                            width: "200px",
                                            objectFit: "cover",
                                          }}
                                        />
                                      </Paper>
                                    </div>
                                  )}
                                </>
                              </div>

                              {!imagePath ? (
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
                            </div>
                            {/* -------- */}
                          </div>
                        </div>
                        <div className="col-md-6 iq-item-product-right">
                          <div className="product-additional-details"></div>
                        </div>
                      </div>
                      {/* <DialogActions className="mb-3  mr-2">
                        <button
                          type="button"
                          className="btn btn-success btn-sm px-3 py-1 mt-4"
                          onClick={handleSubmit}
                        >
                          Insert
                        </button>

                        <button
                          type="button"
                          className="btn btn-danger btn-sm px-3 py-1 mt-4"
                          onClick={handleClose}
                        >
                          Cancel
                        </button>
                      </DialogActions> */}
                      <UploadProgressTv
                        data={data}
                        seriesId={seriesId}
                        update={update}
                      />
                    </>
                  ) : (
                    dialogData && (
                      <>
                        {/* DIALOGDATA */}
                        <div className="">
                          <div className="p-3">
                            <div className="row p-0">
                              <div class="col-6 form-group">
                                <label className="float-left styleForTitle movieForm">
                                  Title
                                </label>

                                <input
                                  type="text"
                                  placeholder="Title"
                                  className="form-control form-control-line"
                                  Required
                                  value={title}
                                  onChange={(e) => {
                                    setTitle(
                                      e.target.value.charAt(0).toUpperCase() +
                                      e.target.value.slice(1)
                                    );
                                    if (!e.target.value) {
                                      return setError({
                                        ...error,
                                        title: "Title is Required!",
                                      });
                                    } else {
                                      return setError({
                                        ...error,
                                        title: "",
                                      });
                                    }
                                  }}
                                />

                                {error.title && (
                                  <div className="pl-1 text-left">
                                    <Typography
                                      variant="caption"
                                      style={{
                                        fontFamily: "Circular-Loom",
                                        color: "#ee2e47",
                                      }}
                                    >
                                      {error.title}
                                    </Typography>
                                  </div>
                                )}
                              </div>

                              <div className="col-6 form-group">
                                <label className="float-left styleForTitle movieForm">
                                  Release Year
                                </label>

                                <input
                                  type="date"
                                  placeholder="YYYY"
                                  className="form-control form-control-line"
                                  Required
                                  min="1950"
                                  value={year}
                                  onChange={(e) => {
                                    setYear(e.target.value);

                                    if (!e.target.value) {
                                      return setError({
                                        ...error,
                                        year: "Year is Required!",
                                      });
                                    } else {
                                      return setError({
                                        ...error,
                                        year: "",
                                      });
                                    }
                                  }}
                                />

                                {error.year && (
                                  <div className="pl-1 text-left">
                                    <Typography
                                      variant="caption"
                                      style={{
                                        fontFamily: "Circular-Loom",
                                        color: "#ee2e47",
                                      }}
                                    >
                                      {error.year}
                                    </Typography>
                                  </div>
                                )}
                              </div>

                              <div className="col-6 form-group">
                                <label className="float-left styleForTitle movieForm">
                                  Region
                                </label>

                                <select
                                  name="type"
                                  className="form-select form-control-line"
                                  id="type"
                                  value={country}
                                  onChange={(e) => {
                                    setCountry(e.target.value);

                                    if (!e.target.value) {
                                      return setError({
                                        ...error,
                                        country: "Country is Required!",
                                      });
                                    } else {
                                      return setError({
                                        ...error,
                                        country: "",
                                      });
                                    }
                                  }}
                                >
                                  <option>Select Region</option>
                                  {countries.map((data) => {
                                    return (
                                      <option value={data._id}>
                                        {data.name}
                                      </option>
                                    );
                                  })}
                                </select>

                                {error.country && (
                                  <div className="pl-1 text-left">
                                    <Typography
                                      variant="caption"
                                      style={{
                                        fontFamily: "Circular-Loom",
                                        color: "#ee2e47",
                                      }}
                                    >
                                      {error.country}
                                    </Typography>
                                  </div>
                                )}
                              </div>

                              <div className="col-6 form-group">
                                <label className="float-left movieForm">
                                  Free/Premium
                                </label>
                                <select
                                  name="type"
                                  className="form-select form-control-line selector"
                                  id="type"
                                  value={type}
                                  onChange={(e) => {
                                    setType(e.target.value);

                                    if (!e.target.value) {
                                      return setError({
                                        ...error,
                                        type: "Type is Required!",
                                      });
                                    } else {
                                      return setError({
                                        ...error,
                                        type: "",
                                      });
                                    }
                                  }}
                                >
                                  <option>Select Type</option>
                                  <option value={"Free"}>Free</option>
                                  <option value={"Premium"}>Premium</option>
                                  {/* <option value={"Default"}>Default</option> */}
                                </select>
                              </div>

                              <div className="col-6 form-group">
                                <label className="styleForTitle movieForm">
                                  Genre
                                </label>

                                <Multiselect
                                  options={genre} // Options to display in the dropdown
                                  selectedValues={dialogData?.genre} // Preselected value to persist in dropdown
                                  onSelect={onSelect} // Function will trigger on select event
                                  onRemove={onRemove} // Function will trigger on remove event
                                  displayValue="name" // Property name to display in the dropdown options
                                  id="css_custom"
                                  placeholder="Select Genre"
                                  style={{
                                    chips: {
                                      // background: "rgba(145, 111, 203, 0.69)",
                                    },
                                    multiselectContainer: {
                                      color: "rgba(174, 159, 199, 1)",
                                    },
                                    searchBox: {
                                      border: "none",
                                      "border-bottom": "1px solid blue",
                                      "border-radius": "0px",
                                    },
                                  }}
                                />

                                {genres?.length === 0 ? (
                                  <div className="pl-1 text-left">
                                    <Typography
                                      variant="caption"
                                      style={{
                                        fontFamily: "Circular-Loom",
                                        color: "#ee2e47",
                                      }}
                                    >
                                      {error.genres}
                                    </Typography>
                                  </div>
                                ) : (
                                  ""
                                )}
                              </div>

                              <div class="col-12 form-group">
                                <label
                                  htmlFor="description"
                                  className="styleForTitle  movieForm"
                                >
                                  Description
                                </label>

                                <SunEditor
                                  value={description}
                                  setContents={description}
                                  ref={editor}
                                  height={318}
                                  onChange={(e) => {
                                    setDescription(e);

                                    if (!e) {
                                      return setError({
                                        ...error,
                                        description:
                                          "Description is Required !",
                                      });
                                    } else {
                                      return setError({
                                        ...error,
                                        description: "",
                                      });
                                    }
                                  }}
                                  placeholder="Description"
                                  setOptions={{
                                    callBackSave: (contents) => {
                                      editor.current.editor.core._editable.classList.add(
                                        "custom-editor-class"
                                      );
                                    },
                                    buttonList: [
                                      ["undo", "redo"],
                                      ["font", "fontSize", "formatBlock"],

                                      ["fontColor", "hiliteColor", "textStyle"],
                                      ["removeFormat"],
                                      [
                                        "bold",
                                        "underline",
                                        "italic",
                                        "subscript",
                                        "superscript",
                                      ],

                                      ["align", "list", "lineHeight"],
                                      ["link"],
                                      ["fullScreen"],
                                    ],
                                  }}
                                />

                                {error.description && (
                                  <div className="pl-1 text-left">
                                    <Typography
                                      variant="caption"
                                      style={{
                                        fontFamily: "Circular-Loom",
                                        color: "#ee2e47",
                                      }}
                                    >
                                      {error.description}
                                    </Typography>
                                  </div>
                                )}
                              </div>

                              <div className=" form-group pl-3">
                                <label className="mt-3 movieForm">
                                  Thumbnail
                                </label>
                                <div className="d-flex justify-content-center align-item-center pointer-cursor">
                                  {dialogData ? (
                                    <>
                                      {thumbnailPath ? (
                                        <>
                                          <div>
                                            <input
                                              ref={ref}
                                              type="file"
                                              className="form-control"
                                              id="customFile"
                                              name="thumbnailImageResURL"
                                              accept="image/png, image/jpeg ,image/jpg"
                                              Required=""
                                              // onChange={thumbnailLoad}
                                              onChange={handleFileChange}
                                              style={{ display: "none" }}
                                              enctype="multipart/form-data"
                                            />
                                            <img
                                              onClick={handleClick}
                                              alt="app"
                                              src={thumbnailPath}
                                              onError={(e) => {
                                                e.target.onerror = null; // Prevents infinite loop
                                                e.target.src = noImage; // Default image path
                                              }}
                                              style={{
                                                borderRadius: "5px",
                                                height: "250px",
                                                width: "250px",
                                                objectFit: "cover",
                                              }}
                                            />
                                            <p className='extention-show'>Accept only .png, .jpeg, .jpeg</p>
                                          </div>

                                          <div
                                            className="img-container"
                                            style={{
                                              display: "inline",
                                              position: "relative",
                                              float: "left",
                                            }}
                                          ></div>
                                        </>
                                      ) : (
                                        <div className={classes.root}>
                                          <Paper elevation={5}>
                                            <div>
                                              <button
                                                onClick={handleClick}
                                                className="upload-button btn"
                                                style={{
                                                  backgroundColor:
                                                    "#7a6699 !important",
                                                  color: "#7a6699",
                                                  position: "absolute",
                                                  top: "50px",
                                                  right: "305px",
                                                }}
                                              >
                                                <i
                                                  class="ri-add-box-fill"
                                                  style={{ fontSize: "30px" }}
                                                ></i>
                                              </button>

                                              <input
                                                ref={ref}
                                                type="file"
                                                className="form-control"
                                                id="customFile"
                                                name="thumbnailImageResURL"
                                                accept="image/png, image/jpeg ,image/jpg"
                                                Required=""
                                                onChange={thumbnailLoad}
                                                style={{ display: "none" }}
                                                enctype="multipart/form-data"
                                              />
                                            </div>

                                            <img
                                              src={thumb}
                                              onError={(e) => {
                                                e.target.onerror = null; // Prevents infinite loop
                                                e.target.src = noImage; // Default image path
                                              }}
                                              height="250"
                                              width="170"
                                              style={{ zIndex: "-1" }}
                                              alt=""
                                            />
                                          </Paper>
                                        </div>
                                      )}
                                    </>
                                  ) : (
                                    <>
                                      <img
                                        alt="app"
                                        src={
                                          seriesDetailsTmdb.thumbnail
                                            ? seriesDetailsTmdb.thumbnail
                                            : thumb
                                        }
                                        onError={(e) => {
                                          e.target.onerror = null; // Prevents infinite loop
                                          e.target.src = noImage; // Default image path
                                        }}
                                        style={{
                                          borderRadius: "0.25rem",
                                          marginTop: 10,
                                          marginBottom: 30,
                                          height: "240px",
                                          width: "170px",
                                          // maxWidth: "150px",
                                          // height: "auto",
                                        }}
                                      />
                                    </>
                                  )}
                                </div>

                                {!thumbnailPath ? (
                                  <div className="pl-1 text-left">
                                    <Typography
                                      variant="caption"
                                      style={{
                                        fontFamily: "Circular-Loom",
                                        color: "#ee2e47",
                                      }}
                                    >
                                      {error.thumbnail}
                                    </Typography>
                                  </div>
                                ) : (
                                  ""
                                )}
                              </div>

                              <div class="form-group pl-3">
                                <label className="mt-3 movieForm">Image</label>
                                <div className="d-flex justify-content-center align-item-center pointer-cursor">
                                  <>
                                    {imagePath ? (
                                      <>
                                        <div>
                                          <input
                                            ref={imageRef}
                                            type="file"
                                            className="form-control"
                                            id="customFile"
                                            name="seriesImageResURL"
                                            accept="image/png, image/jpeg ,image/jpg"
                                            Required=""
                                            // onChange={imageLoad}
                                            onChange={handleFileChange}
                                            style={{ display: "none" }}
                                            enctype="multipart/form-data"
                                          />
                                        </div>
                                        <div>

                                          <img
                                            onClick={handleClickImage}
                                            className="img-fluid"
                                            alt="app"
                                            src={imagePath}
                                            onError={(e) => {
                                              e.target.onerror = null; // Prevents infinite loop
                                              e.target.src = noImage; // Default image path
                                            }}
                                            style={{
                                              borderRadius: "5px",
                                              maxWidth: "250px",
                                              height: "250px",
                                              objectFit: "cover",
                                            }}
                                          />
                                          <p className='extention-show'>Accept only .png, .jpeg, .jpeg</p>
                                        </div>

                                        <div
                                          className="img-container"
                                          style={{
                                            display: "inline",
                                            position: "relative",
                                            float: "left",
                                          }}
                                        ></div>
                                      </>
                                    ) : (
                                      <div className={classes.root}>
                                        <Paper elevation={5}>
                                          <div>
                                            <button
                                              onClick={handleClickImage}
                                              className="upload-button btn"
                                              style={{
                                                // backgroundColor: "#7a788b94 !important",
                                                position: "absolute",
                                                color: "#7a6699",
                                                top: "397px",
                                                right: "302px",
                                              }}
                                            >
                                              <i
                                                class="ri-add-box-fill"
                                                style={{ fontSize: "30px" }}
                                              ></i>
                                            </button>

                                            <input
                                              ref={imageRef}
                                              type="file"
                                              className="form-control"
                                              id="customFile"
                                              name="seriesImageResURL"
                                              accept="image/png, image/jpeg ,image/jpg"
                                              Required=""
                                              onChange={imageLoad}
                                              style={{ display: "none" }}
                                              enctype="multipart/form-data"
                                            />
                                          </div>
                                          <img
                                            alt=""
                                            src={card}
                                            onError={(e) => {
                                              e.target.onerror = null; // Prevents infinite loop
                                              e.target.src = noImage; // Default image path
                                            }}
                                            style={{
                                              height: "100px",
                                              width: "200px ",
                                              objectFit: "cover",
                                            }}
                                          />
                                        </Paper>
                                      </div>
                                    )}
                                  </>
                                </div>

                                {!imagePath ? (
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
                              </div>
                            </div>
                          </div>
                          <div
                            className="col-md-6 iq-item-product-right"
                            style={{
                              borderLeft:
                                "0.5px solid rgba(255, 255, 255, 0.3)",
                            }}
                          >
                            <div className="product-additional-details"></div>
                          </div>
                        </div>

                        <UploadProgressTv
                          data={data}
                          seriesId={seriesId}
                          update={update}
                        />
                      </>
                    )
                  )}
                </div>
                <div className="iq-card-footer">
                  <DialogActions className="">
                    <button
                      type="button"
                      className="btn btn-success btn-sm px-3 py-1 "
                      onClick={handleSubmit}
                    >
                      {showData ? "Submit" : "Update"}
                    </button>
                    <button
                      type="button"
                      className="btn btn-danger btn-sm px-3 py-1 "
                      onClick={handleClose}
                    >
                      Cancel
                    </button>
                  </DialogActions>
                </div>
              </div>
            </>
          ) : (
            " "
          )}
        </div>
      </div>
    </>
  );
};

export default connect(null, {
  setUploadTvFile,
  getGenre,
  getRegion,
  getTeamMember,
  loadSeriesData,
  updateTvSeries,
  ImdbSeriesCreate,
})(SeriesForm);
