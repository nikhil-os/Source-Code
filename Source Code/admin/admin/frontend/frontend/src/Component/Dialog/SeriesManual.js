import React, { useRef } from "react";
import { NavLink, useHistory } from "react-router-dom";
import { DialogActions, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import MovieFilterIcon from "@mui/icons-material/MovieFilter";
import RecentActorsIcon from "@mui/icons-material/RecentActors";
import EditIcon from "@mui/icons-material/Edit";
import { getRegion } from "../../store/Region/region.action";
import Paper from "@mui/material/Paper";
import { getGenre } from "../../store/Genre/genre.action";
import card from "../assets/images/1.png";
import thumb from "../assets/images/5.png";
import { useState } from "react";
import UploadProgress from "../../Pages/UploadProgress";
import SunEditor from "suneditor-react";
import Multiselect from "multiselect-react-dropdown";
import { connect, useDispatch, useSelector } from "react-redux";
import { useEffect } from "react";
import { createManualSeries } from "../../store/TvSeries/tvSeries.action";
import noImage from "../assets/images/noImage.png";

//mui
import GetAppIcon from "@mui/icons-material/GetApp";
import AddIcon from "@mui/icons-material/Add";

//Alert

import { uploadFile } from "../../util/AwsFunction";
import { folderStructurePath } from "../../util/config";
import { CLOSE_LOADER, OPEN_LOADER } from "../../store/Loader/loader.type";
import { IconTrash, IconX } from "@tabler/icons-react";
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

const SeriesManual = (props) => {
  const ref = useRef();
  const imageRef = useRef();
  const classes = useStyles1();
  const editor = useRef(null);
  const [title, setTitle] = useState("");
  const [imagePath, setImagePath] = useState("");
  const [description, setDescription] = useState("");
  const [country, setCountry] = useState("");
  const [year, setYear] = useState("");
  const [type, setType] = useState("Premium");
  const [thumbnailPath, setThumbnailPath] = useState("");
  const [trailerVideoUrl, setTrailerVideoUrl] = useState("");
  const [trailerVideoPath, setTrailerVideoPath] = useState("");
  const [trailerImage, setTrailerImage] = useState([]);
  const [trailerImagePath, setTrailerImagePath] = useState("");
  const [updateType, setUpdateType] = useState("");
  const [convertUpdateType, setConvertUpdateType] = useState({
    image: "",
    thumbnail: "",
    link: "",
  });
  const [trailerVideoType, setTrailerVideoType] = useState("");
  const [trailerName, setTrailerName] = useState("");
  const [trailerType, setTrailerType] = useState("");
  const [trailerVideo, setTrailerVideo] = useState([]);
  const [data, setData] = useState([]);
  const [youtubeUrl, setYoutubeUrl] = useState("");
  const [embedUrl, setEmbedUrl] = useState("");
  const [thumbnail, setThumbnail] = useState("");
  const [genres, setGenres] = useState([]);
  const [image, setImage] = useState("");
  const [gerenData, setGerenData] = useState([]);
  const [selectThumbnail, setSelectThumbnail] = useState("");
  const [selectImage, setSelectImage] = useState("");
  const [selectFile, setSelectedFile] = useState("");
  const [showURL, setShowURL] = useState({
    thumbnailImageShowImage: "",
    seriesImageShowURL: "",
    movieVideoShowURl: "",
    trailerImageShowURL: "",
    trailerVideoShowURL: "",
  });
  const [resURL, setResURL] = useState({
    thumbnailImageResURL: "",
    seriesImageResURL: "",
    movieVideoResURL: "",
    trailerImageResURL: "",
    trailerVideoResURL: "",
  });

  const [error, setError] = useState({
    title: "",
    description: "",
    type: "",
    year: "",
    country: "",
    genres: [],

    trailerVideoUrl: "",
    trailerVideoType: "",
    trailerName: "",
    trailerType: "",
  });

  //get country list
  const [countries, setCountries] = useState([]);
  const { region } = useSelector((state) => state.region);
  const { seriesDetailsTmdb } = useSelector((state) => state.series);
  const { genre } = useSelector((state) => state.genre);
  const dispatch = useDispatch();


  useEffect(() => {
    dispatch(getRegion());
    dispatch(getGenre());
  }, [dispatch]);

  //Set Data after Getting
  useEffect(() => {
    setCountries(region);
  }, [region]);

  //get genre list
  const [genreData, setGenreData] = useState([]);

  //Set Data after Getting
  useEffect(() => {
    setGenreData(genre);
  }, [genre]);

  const dialogData = JSON.parse(sessionStorage.getItem("updateMovieData"));

  const history = useHistory();
  const handleClose = () => {
    sessionStorage.removeItem("updateMovieData");
    if (dialogData) {
      history.goBack();
    } else {
      history.replace("/admin/web_series");
    }
  };

  let folderStructureMovieImage = folderStructurePath + "seriesImage";

  const selectImageFile = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSelectImage(file);
      setShowURL({ ...showURL, seriesImageShowURL: URL.createObjectURL(file) });
    }
  };

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
    setShowURL({ ...showURL, seriesImageShowURL: imageURL });
  };

  let folderStructureThumbnail = folderStructurePath + "seriesThumbnail";

  const selectThumbnailFile = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSelectThumbnail(file);
      setShowURL({
        ...showURL,
        thumbnailImageShowImage: URL.createObjectURL(file),
      });
    }
  };

  // Thumbnail Load
  const thumbnailLoad = async (event) => {
    setThumbnail(selectThumbnail);
    setUpdateType(1);
    setConvertUpdateType({
      ...convertUpdateType,
      thumbnail: 1,
    });
    const { resDataUrl, imageURL } = await uploadFile(
      selectThumbnail,
      folderStructureThumbnail
    );

    setResURL({ ...resURL, thumbnailImageResURL: resDataUrl });
    setShowURL({ ...showURL, thumbnailImageShowImage: imageURL });
  };

  //Trailer Video Load
  let folderStructureTrailerVideo = folderStructurePath + "trailerVideo";
  // const trailerVideoLoad = async (event) => {
  //   setTrailerVideo(event.target.files[0]);
  //   setUpdateType(1);
  //   setConvertUpdateType({
  //     ...convertUpdateType,
  //     link: 1,
  //   });
  //   const { resDataUrl, imageURL } = await uploadFile(
  //     event.target.files[0],
  //     folderStructureTrailerVideo
  //   );

  //   setResURL({ ...resURL, trailerVideoResURL: resDataUrl });
  //   setShowURL({ ...showURL, trailerVideoShowURL: imageURL });
  // };

  const trailerVideoLoad = (event) => {
    const file = event.target.files[0];
    if (file) {
      setTrailerVideo(file); // ✅ File ko state me store karo

      setUpdateType(1); // ✅ Optional: agar aap version track kar rahe ho
      setConvertUpdateType((prev) => ({
        ...prev,
        link: 1,
      }));

      // ✅ Preview ke liye local URL create karo
      const previewURL = URL.createObjectURL(file);
      setShowURL((prev) => ({
        ...prev,
        trailerVideoShowURL: previewURL,
      }));
    }
  };

  let folderStructureTrailerImage = folderStructurePath + "trailerImage";

  // const handleFileChange = (e) => {
  //   const file = e.target.files[0];
  //   if (file) {
  //     setSelectedFile(file);
  //     setShowURL({ ...showURL, trailerImageShowURL: URL.createObjectURL(file) });
  //   }
  // };

  const handleFileChange = (e) => {
    const inputName = e.target.name; // e.g., 'trailerImageShowURL' or 'thumbnailImageShowImage'
    const file = e.target.files[0];

    if (file) {
      setShowURL((prev) => ({
        ...prev,
        [inputName]: URL.createObjectURL(file),
      }));

      if (inputName === "trailerImageShowURL") {
        setSelectedFile(file);
      } else if (inputName === "thumbnailImageShowImage") {
        setSelectThumbnail(file);
      } else if (inputName === "seriesImageShowURL") {
        setSelectImage(file);
      }
    }
  };

  //Trailer Image Load
  const trailerImageLoad = async (event) => {
    setTrailerImage(selectFile);

    const { resDataUrl, imageURL } = await uploadFile(
      selectFile,
      folderStructureTrailerImage
    );

    setResURL({ ...resURL, trailerImageResURL: resDataUrl });
    setShowURL({ ...showURL, trailerImageShowURL: imageURL });
  };

  // open dialogue
  useEffect(
    () => () => {
      setGenres([]);
      setCountry("");
      setTitle("");
      setTrailerName("");
      setTrailerType("");
      setDescription("");
      setYear("");
      setImage([]);
      setImagePath("");
      setTrailerImage([]);
      setTrailerImagePath("");
      setThumbnail("");
      setTrailerVideo([]);
      setTrailerVideoPath("");
      setType("");
      setYoutubeUrl("");
      setTrailerVideoType("");
      setTrailerVideoUrl("");
      setError({
        title: "",
        trailerName: "",
        trailerType: "",
        description: "",
        year: "",
        country: "",
        genres: "",
        image: "",
        trailerImage: "",
        thumbnail: "",
        type: "",
        runtime: "",
        trailerVideoType: "",
        videoType: "",
      });
    },
    [dialogData]
  );

  //   const handleAllUploads = async () => {
  //   let trailerRes = {}, thumbnailRes = {}, seriesImageRes = {};

  //   // Trailer Image Upload
  //   if (selectFile) {
  //     trailerRes = await uploadFile(selectFile, folderStructurePath + 'trailerImage');
  //     setResURL(prev => ({ ...prev, trailerImageResURL: trailerRes.resDataUrl }));
  //     setShowURL(prev => ({ ...prev, trailerImageShowURL: trailerRes.imageURL }));
  //     setTrailerImage(selectFile);
  //   }

  //   // Thumbnail Upload
  //   if (selectThumbnail) {
  //     thumbnailRes = await uploadFile(selectThumbnail, folderStructurePath + 'seriesThumbnail');
  //     setResURL(prev => ({ ...prev, thumbnailImageResURL: thumbnailRes.resDataUrl }));
  //     setShowURL(prev => ({ ...prev, thumbnailImageShowImage: thumbnailRes.imageURL }));
  //     setThumbnail(selectThumbnail);
  //     setUpdateType(1);
  //     setConvertUpdateType(prev => ({ ...prev, thumbnail: 1 }));
  //   }

  //   // Series Image Upload
  //   if (selectImage) {
  //     seriesImageRes = await uploadFile(selectImage, folderStructurePath + 'seriesImage');
  //     setResURL(prev => ({ ...prev, seriesImageResURL: seriesImageRes.resDataUrl }));
  //     setShowURL(prev => ({ ...prev, seriesImageShowURL: seriesImageRes.imageURL }));
  //     setImage(selectImage);
  //     setUpdateType(1);
  //     setConvertUpdateType(prev => ({ ...prev, image: 1 }));
  //   }

  //   return {
  //     trailerImageResURL: trailerRes.resDataUrl || '',
  //     thumbnailImageResURL: thumbnailRes.resDataUrl || '',
  //     seriesImageResURL: seriesImageRes.resDataUrl || '',
  //   };
  // };

  const handleAllUploads = async () => {
    let trailerRes = {},
      thumbnailRes = {},
      seriesImageRes = {},
      trailerVideoRes = {};

    // Trailer Image Upload
    if (selectFile) {
      trailerRes = await uploadFile(
        selectFile,
        folderStructurePath + "trailerImage"
      );
      setResURL((prev) => ({
        ...prev,
        trailerImageResURL: trailerRes.resDataUrl,
      }));
      setShowURL((prev) => ({
        ...prev,
        trailerImageShowURL: trailerRes.imageURL,
      }));
      setTrailerImage(selectFile);
    }

    // Thumbnail Upload
    if (selectThumbnail) {
      thumbnailRes = await uploadFile(
        selectThumbnail,
        folderStructurePath + "seriesThumbnail"
      );
      setResURL((prev) => ({
        ...prev,
        thumbnailImageResURL: thumbnailRes.resDataUrl,
      }));
      setShowURL((prev) => ({
        ...prev,
        thumbnailImageShowImage: thumbnailRes.imageURL,
      }));
      setThumbnail(selectThumbnail);
      setUpdateType(1);
      setConvertUpdateType((prev) => ({ ...prev, thumbnail: 1 }));
    }

    // Series Image Upload
    if (selectImage) {
      seriesImageRes = await uploadFile(
        selectImage,
        folderStructurePath + "seriesImage"
      );
      setResURL((prev) => ({
        ...prev,
        seriesImageResURL: seriesImageRes.resDataUrl,
      }));
      setShowURL((prev) => ({
        ...prev,
        seriesImageShowURL: seriesImageRes.imageURL,
      }));
      setImage(selectImage);
      setUpdateType(1);
      setConvertUpdateType((prev) => ({ ...prev, image: 1 }));
    }

    // ✅ Trailer Video Upload (only when type is 1 and file selected)
    if (trailerVideoType == 1 && trailerVideo) {
      trailerVideoRes = await uploadFile(
        trailerVideo,
        folderStructurePath + "trailerVideo"
      );
      setResURL((prev) => ({
        ...prev,
        trailerVideoResURL: trailerVideoRes.resDataUrl,
      }));
      setShowURL((prev) => ({
        ...prev,
        trailerVideoShowURL: trailerVideoRes.imageURL,
      }));
    }

    return {
      trailerImageResURL: trailerRes.resDataUrl || "",
      thumbnailImageResURL: thumbnailRes.resDataUrl || "",
      seriesImageResURL: seriesImageRes.resDataUrl || "",
      trailerVideoResURL: trailerVideoRes.resDataUrl || "", // ✅ return video URL
    };
  };

  // const handleSubmit = async () => {
  //   

  //   if (
  //     !title ||
  //     !description ||
  //     type === 'selectType' ||
  //     !type ||
  //     !year ||
  //     !country ||
  //     !genres ||
  //     !trailerVideoType ||
  //     !trailerName ||
  //     !trailerType ||
  //     (trailerVideoType == 0 && !trailerVideoUrl)
  //   ) {
  //     let error = {};
  //     if (!title) error.title = 'title is required';
  //     if (!description) error.description = 'description is required';
  //     if (type === 'selectType' || !type) error.type = 'type is required';
  //     if (!year) error.year = 'year is required';
  //     if (!country) error.country = 'region is required';
  //     if (trailerVideoType == 0 && !trailerVideoUrl)
  //       error.trailerVideoUrl = 'Trailer video url is required';
  //     if (!trailerVideoType)
  //       error.trailerVideoType = 'Trailer video type is required';
  //     if (image.length === 0) error.image = 'image is required';
  //     if (thumbnail.length === 0) error.thumbnail = 'Thumbnail is required';
  //     if (trailerImage.length === 0) error.trailerImage = 'Trailer image is required';
  //     if (!trailerName) error.trailerName = 'Trailer name is required';
  //     if (!trailerType) error.trailerType = 'Trailer type is required';
  //     if (genres.length === 0) error.genres = 'Genre Is Required';

  //     return setError({ ...error });
  //   } else {
  //     // ✅ Upload all images before submit
  //     const uploaded = await handleAllUploads();

  //     // ✅ Overwrite existing resURL with uploaded ones
  //     // resURL = {
  //     //   ...resURL,
  //     //   trailerImageResURL: uploaded.trailerImageResURL || resURL?.trailerImageResURL,
  //     //   thumbnailImageResURL: uploaded.thumbnailImageResURL || resURL?.thumbnailImageResURL,
  //     //   seriesImageResURL: uploaded.seriesImageResURL || resURL?.seriesImageResURL,
  //     // };

  //     // ✅ Form payload
  //     let objData = {
  //       title,
  //       description,
  //       year,
  //       type,
  //       region: country,
  //       genre: genres,
  //       trailerName,
  //       trailerVideoType,
  //       updateType,
  //       convertUpdateType,
  //       trailerType,
  //       image: uploaded.seriesImageResURL,
  //       thumbnail: uploaded.thumbnailImageResURL,
  //       trailerImage: uploaded.trailerImageResURL,
  //       trailerVideoUrl:
  //         trailerVideoType == 0 ? trailerVideoUrl : resURL?.trailerVideoResURL,
  //     };

  //     props.createManualSeries(objData);
  //     history.push('/admin/web_series');
  //   }
  // };

  // const handleSubmit = () => {
  //   
  //   if (
  //     !title ||
  //     !description ||
  //     type === 'selectType' ||
  //     !type ||
  //     !year ||
  //     !country ||
  //     !genres ||
  //     !trailerVideoType ||
  //     !trailerName ||
  //     !trailerType ||
  //     (trailerVideoType == 0 && !trailerVideoUrl)
  //   ) {
  //     let error = {};
  //     if (!title) error.title = 'title is required';
  //     if (!description) error.description = 'description is required';
  //     if (type === 'selectType' || !type) error.type = 'type is required';
  //     if (!year) error.year = 'year is required';
  //     if (!country) error.country = 'region is required';

  //     if (trailerVideoType == 0 && !trailerVideoUrl)
  //       error.trailerVideoUrl = 'Trailer video url is required';
  //     if (!trailerVideoType)
  //       error.trailerVideoType = 'Trailer video type is required';
  //     if (image.length === 0) error.image = 'image is required';
  //     if (thumbnail.length === 0) error.thumbnail = 'Thumbnail is required';
  //     if (trailerImage.length === 0)
  //       error.trailerImage = 'Trailer image is required';
  //     if (!trailerName) error.trailerName = 'Trailer name is required';
  //     if (!trailerType) error.trailerType = 'Trailer type is required';
  //     if (genres.length === 0) error.genres = 'Genre Is Required';
  //     return setError({ ...error });
  //   } else {
  //     let objData = {
  //       title,
  //       description,
  //       year,
  //       type,
  //       region: country,
  //       genre: genres,
  //       trailerName,
  //       trailerVideoType,
  //       updateType,
  //       convertUpdateType,
  //       trailerType,
  //       image: resURL?.seriesImageResURL,
  //       thumbnail: resURL?.thumbnailImageResURL,
  //       trailerImage: resURL?.trailerImageResURL,
  //       trailerVideoUrl:
  //         trailerVideoType == 0 ? trailerVideoUrl : resURL?.trailerVideoResURL,
  //     };
  //     props.createManualSeries(objData);
  //     history.push('/admin/web_series');
  //   }
  // };

  const handleSubmit = async () => {


    dispatch({ type: OPEN_LOADER });

    try {
      if (
        !title ||
        !description ||
        type === "selectType" ||
        !type ||
        !year ||
        !country ||
        !genres ||
        !trailerVideoType ||
        !trailerName ||
        !trailerType ||
        (trailerVideoType == 0 && !trailerVideoUrl)
      ) {
        let error = {};
        if (!title) error.title = "title is required";
        if (!description) error.description = "description is required";
        if (type === "selectType" || !type) error.type = "type is required";
        if (!year) error.year = "year is required";
        if (!country) error.country = "region is required";
        if (trailerVideoType == 0 && !trailerVideoUrl)
          error.trailerVideoUrl = "Trailer video url is required";
        if (!trailerVideoType)
          error.trailerVideoType = "Trailer video type is required";
        if (image.length === 0) error.image = "image is required";
        if (thumbnail.length === 0) error.thumbnail = "Thumbnail is required";
        if (trailerImage.length === 0)
          error.trailerImage = "Trailer image is required";
        if (!trailerName) error.trailerName = "Trailer name is required";
        if (!trailerType) error.trailerType = "Trailer type is required";
        if (genres.length === 0) error.genres = "Genre Is Required";

        return setError({ ...error });
        dispatch({ type: CLOSE_LOADER });
        return;
      }
      // ✅ Upload everything (including video) before submit
      const uploaded = await handleAllUploads();

      let objData = {
        title,
        description,
        year,
        type,
        region: country,
        genre: genres,
        trailerName,
        trailerVideoType,
        updateType,
        convertUpdateType,
        trailerType,
        image: uploaded.seriesImageResURL,
        thumbnail: uploaded.thumbnailImageResURL,
        trailerImage: uploaded.trailerImageResURL,
        trailerVideoUrl:
          trailerVideoType == 0 ? trailerVideoUrl : uploaded.trailerVideoResURL, // ✅ use uploaded video URL
      };

      props.createManualSeries(objData);
      history.push("/admin/web_series");
    } catch (error) {
      console.error("handleSubmit error", error);
    } finally {
      dispatch({ type: CLOSE_LOADER }); // 👈 Always close loader
    }
  };

  const handleClick = () => {
    ref.current.click();
  };
  const handleClickImage = () => {
    imageRef.current.click();
  };

  const genreId = seriesDetailsTmdb?.genre?.map((id) => {
    return id;
  });

  // useEffect(() => {
  //   setGenres(genreId);
  // }, [seriesDetailsTmdb]);

  //onselect function of selecting multiple values
  function onSelect(selectedList, selectedItem) {
    genres.push(selectedItem?._id);
  }

  //onRemove function for remove multiple values
  function onRemove(selectedList, removedItem) {
    setGenres(selectedList.map((data) => data._id));
  }

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
          )}
          <div className="iq-card mb-5">
            <div class="iq-card-header">
              <h4>Add Series</h4>
            </div>
            <div className="iq-card-body">
              <div className="row p-3">
                <div className="col-6 form-group">
                  <label className="float-left styleForTitle movieForm">
                    Title
                  </label>
                  {dialogData ? (
                    <>
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
                    </>
                  ) : (
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
                  )}
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
                  {dialogData ? (
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
                  ) : (
                    <input
                      type="date"
                      placeholder="YYYY-MM-DD"
                      className="form-control form-control-line"
                      Required
                      min="1950"
                      //   value={movieDetailsTmdb?.year}
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
                  )}

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
                <div className="col-md-6 form-group ">
                  <label htmlFor="earning" className="styleForTitle movieForm">
                    Region
                  </label>
                  <select
                    name="type"
                    className="form-select form-control-line minimal"
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
                      return <option value={data._id}>{data.name}</option>;
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
                  <label className="float-left movieForm">Free/Premium</label>
                  {dialogData ? (
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
                  ) : (
                    <select
                      name="type"
                      className="form-select form-control-line selector"
                      id="type"
                      value={type}
                      onChange={(e) => {
                        setType(e.target.value);

                        if (e.target.value === "selectType") {
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
                      <option value="selectType">Select Type</option>
                      <option value="Free">Free</option>
                      <option value="Premium">Premium</option>
                    </select>
                  )}

                  {error.type && (
                    <div className="pl-1 text-left">
                      <Typography
                        variant="caption"
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

                <div className="col-6 form-group">
                  <label className="styleForTitle movieForm">Genre</label>
                  {dialogData ? (
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
                  ) : (
                    <Multiselect
                      options={genre} // Options to display in the dropdown
                      selectedValues={seriesDetailsTmdb?.genre} // Preselected value to persist in dropdown
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
                  )}

                  {genres?.length === 0 && (
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
                  )}
                </div>

                <div class="col-12 form-group">
                  <label
                    htmlFor="description"
                    className="styleForTitle mt-3 movieForm"
                  >
                    Description
                  </label>
                  {dialogData ? (
                    <SunEditor
                      value={description}
                      setContents={description}
                      ref={editor}
                      height={346}
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
                  ) : (
                    <SunEditor
                      //   value={movieDetailsTmdb?.description}
                      //   setContents={movieDetailsTmdb?.description}
                      //   ref={editor}
                      height={346}
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
                  )}

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
                  <div>
                    <label className="mt-3 movieForm">Thumbnail</label>

                    <div className="d-flex justify-content-center align-item-center">
                      {thumbnailPath ? (
                        <>
                          <input
                            ref={ref}
                            type="file"
                            className="form-control"
                            id="customFile"
                            name="thumbnailImageShowImage"
                            accept="image/png, image/jpeg ,image/jpg"
                            Required=""
                            // onChange={thumbnailLoad}
                            style={{ display: "none" }}
                            enctype="multipart/form-data"
                            // onChange={selectThumbnailFile}
                            onChange={handleFileChange}
                          />
                          <img
                            onClick={handleClick}
                            alt="app"
                            src={showURL?.thumbnailImageShowImage}
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
                      ) : (
                        <>
                          {showURL?.thumbnailImageShowImage ? (
                            <>
                              <div className="d-flex flex-column">
                                <img
                                  alt=""
                                  onClick={handleClick}
                                  src={showURL?.thumbnailImageShowImage}
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
                                <button
                                  className="bg-danger btn-sm btn"
                                  style={{
                                    position: "relative",
                                    bottom: "257px",
                                    width: "30px",
                                    left: "225px",
                                  }}
                                  onClick={() => {
                                    setShowURL({
                                      ...showURL,
                                      thumbnailImageShowImage: "",
                                    });
                                    setSelectThumbnail("");
                                  }}
                                >
                                  <IconX size={"sm"} className="text-white" />
                                </button>
                              </div>
                            </>
                          ) : (
                            <div class="select_image">
                              <i
                                className="fas fa-plus"
                                style={{
                                  paddingTop: 56,
                                  fontSize: 165,
                                  fontWeight: 400,
                                  color: "#4d848f",
                                }}
                              />

                              <input
                                autocomplete="off"
                                style={{
                                  position: "absolute",
                                  top: 112,
                                  transform: "scale(3.5)",
                                  opacity: 0,
                                }}
                                type="file"
                                className="form-control"
                                id="customFile"
                                name="thumbnailImageShowImage"
                                accept="image/png, image/jpeg ,image/jpg"
                                Required=""
                                // onChange={thumbnailLoad}
                                enctype="multipart/form-data"
                                // onChange={selectThumbnailFile}
                                onChange={handleFileChange}
                              />
                            </div>
                          )}
                        </>
                      )}
                    </div>
                    <p className="extention-show">
                      Accept only .png, .jpeg and .jpg
                    </p>

                    {/* <div className="d-flex justify-content-end mt-3">
                            <button
                              type="button"
                              className="btn btn-success btn-sm px-3 py-1 mt-4 "
                              onClick={thumbnailLoad} // actual upload logic
                            >
                              Upload
                            </button>
                          </div> */}

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
                </div>

                <div class="pl-3 form-group">
                  <label className="mt-3 movieForm">Image</label>

                  <div className="d-flex justify-content-center align-item-center">
                    {imagePath ? (
                      <>
                        <input
                          ref={imageRef}
                          type="file"
                          className="form-control"
                          id="customFile"
                          name="seriesImageShowURL"
                          accept="image/png, image/jpeg ,image/jpg"
                          Required=""
                          // onChange={imageLoad}
                          style={{ display: "none" }}
                          enctype="multipart/form-data"
                          // onChange={selectImageFile}
                          onChange={handleFileChange}
                        />
                        <img
                          onClick={handleClickImage}
                          alt="app"
                          src={showURL?.seriesImageShowURL}
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
                    ) : (
                      <>
                        {showURL?.seriesImageShowURL ? (
                          <>
                            <div className="d-flex flex-column">

                              <img
                                alt=""
                                src={showURL?.seriesImageShowURL}
                                onError={(e) => {
                                  e.target.onerror = null; // Prevents infinite loop
                                  e.target.src = noImage; // Default image path
                                }}
                                onClick={handleClickImage}
                                style={{
                                  borderRadius: "5px",
                                  height: "250px",
                                  width: "250px",
                                }}
                              />
                              <button
                                className="bg-danger btn-sm btn"
                                style={{
                                  position: "relative",
                                  bottom: "257px",
                                  width: "30px",
                                  left: "225px",
                                }}
                                onClick={() => {
                                  setShowURL({ ...showURL, seriesImageShowURL: "" });
                                  setSelectedFile("")
                                }}
                              >

                                <IconX size={"sm"} className="text-white" />
                              </button>
                            </div>
                          </>
                        ) : (
                          <div class="select_image">
                            <i
                              className="fas fa-plus"
                              style={{
                                paddingTop: 56,
                                fontSize: 165,
                                fontWeight: 400,
                                color: "#4d848f",
                              }}
                            />

                            <input
                              autocomplete="off"
                              tabIndex="-1"
                              style={{
                                position: "absolute",
                                top: 112,
                                transform: "scale(3.5)",
                                opacity: 0,
                              }}
                              type="file"
                              className="form-control"
                              id="customFile"
                              name="seriesImageShowURL"
                              accept="image/png, image/jpeg ,image/jpg"
                              Required=""
                              // onChange={imageLoad}
                              // onChange={selectImageFile}
                              onChange={handleFileChange}
                            />
                          </div>
                        )}
                      </>
                    )}
                  </div>
                  <p className="extention-show">
                    Accept only .png, .jpeg and .jpg
                  </p>

                  {/* <div className="d-flex justify-content-end mt-3">
                            <button
                              type="button"
                              className="btn btn-success btn-sm px-3 py-1 mt-4 "
                              onClick={imageLoad} // actual upload logic
                            >
                              Upload
                            </button>
                          </div> */}

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
              <div className="">
                <h4 className="border-top border-bottom m-0 p-3">Trailer</h4>
                <div className="row p-3">
                  <div className="col-6">
                    <label className="float-left styleForTitle movieForm">
                      Trailer Type
                    </label>
                    <select
                      type="text"
                      placeholder="Trailer Name"
                      className="form-select form-control-line"
                      Required
                      value={trailerType}
                      onChange={(e) => {
                        setTrailerType(e.target.value);

                        if (!e.target.value) {
                          return setError({
                            ...error,
                            trailerType: "Trailer Type is Required!",
                          });
                        } else {
                          return setError({
                            ...error,
                            trailerType: "",
                          });
                        }
                      }}
                    >
                      <option value="select Trails">Select Trailer Type</option>
                      <option value="trailer">Trailer</option>
                      <option value="teaser">Teaser </option>
                      <option value="clip">Clip </option>
                    </select>
                    {error.trailerType && (
                      <div className="pl-1 text-left">
                        <Typography
                          variant="caption"
                          style={{
                            fontFamily: "Circular-Loom",
                            color: "#ee2e47",
                          }}
                        >
                          {error.trailerType}
                        </Typography>
                      </div>
                    )}
                  </div>

                  <div className="col-md-6 my-2">
                    <label className="float-left styleForTitle movieForm">
                      Trailer Name
                    </label>
                    <input
                      type="text"
                      placeholder="Trailer Name"
                      className="form-control form-control-line"
                      Required
                      value={trailerName}
                      onChange={(e) => {
                        setTrailerName(
                          e.target.value.charAt(0).toUpperCase() +
                          e.target.value.slice(1)
                        );
                        if (!e.target.value) {
                          return setError({
                            ...error,
                            trailerName: "Trailer Name is Required!",
                          });
                        } else {
                          return setError({
                            ...error,
                            trailerName: "",
                          });
                        }
                      }}
                    />
                    {error.trailerName && (
                      <div className="pl-1 text-left">
                        <Typography
                          variant="caption"
                          style={{
                            fontFamily: "Circular-Loom",
                            color: "#ee2e47",
                          }}
                        >
                          {error.trailerName}
                        </Typography>
                      </div>
                    )}
                  </div>

                  <div className="col-md-6 my-2">
                    <label className="float-left styleForTitle movieForm">
                      Trailer Video Type
                    </label>
                    <select
                      type="text"
                      placeholder="Trailer Name"
                      className="form-select form-control-line"
                      Required
                      value={trailerVideoType}
                      onChange={(e) => {
                        setTrailerVideoType(e.target.value);

                        if (!e.target.value) {
                          return setError({
                            ...error,
                            trailerVideoType: "Trailer Video Type is Required!",
                          });
                        } else {
                          return setError({
                            ...error,
                            trailerVideoType: "",
                          });
                        }
                      }}
                    >
                      <option value="select Trails">
                        Select Trailer Video Type
                      </option>
                      <option value="0">Youtube Url </option>
                      <option value="1">File (MP4/MOV/MKV/WEBM)</option>
                    </select>
                    {error.trailerVideoType && (
                      <div className="pl-1 text-left">
                        <Typography
                          variant="caption"
                          style={{
                            fontFamily: "Circular-Loom",
                            color: "#ee2e47",
                          }}
                        >
                          {error.trailerVideoType}
                        </Typography>
                      </div>
                    )}
                  </div>

                  <div className="col-md-6 my-2">
                    <label className="float-left styleForTitle movieForm">
                      Trailer Video Url
                    </label>
                    <div>
                      {trailerVideoType == 0 && (
                        <>
                          <input
                            type="text"
                            // id="link"
                            placeholder="Link"
                            class="form-control"
                            value={trailerVideoUrl}
                            onChange={(e) => {
                              setTrailerVideoUrl(e.target.value);
                              if (!e.target.value) {
                                return setError({
                                  ...error,
                                  trailerVideoUrl:
                                    "Trailer Video Url is Required!",
                                });
                              } else {
                                return setError({
                                  ...error,
                                  trailerVideoUrl: "",
                                });
                              }
                            }}
                          />
                          {error.trailerVideoUrl && (
                            <div className="pl-1 text-left">
                              <Typography
                                variant="caption"
                                style={{
                                  fontFamily: "Circular-Loom",
                                  color: "#ee2e47",
                                }}
                              >
                                {error.trailerVideoUrl}
                              </Typography>
                            </div>
                          )}
                        </>
                      )}
                      {trailerVideoType == 1 && (
                        <>
                          <input
                            type="file"
                            id="customFile"
                            className="form-control"
                            accept="video/*"
                            required=""
                            onChange={trailerVideoLoad}
                          />
                          <p className="extention-show">
                            Accept only .mp4, .mov, .mkv, .webm
                          </p>

                          {showURL?.trailerVideoShowURL && (
                            <>
                              <video
                                height="100px"
                                width="100px"
                                controls
                                alt="app"
                                src={showURL?.trailerVideoShowURL}
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
                          )}
                        </>
                      )}
                      {/* {error.trailerVideoUrl && (
                            <div className="pl-1 text-left">
                              <Typography
                                variant="caption"
                                style={{
                                  fontFamily: "Circular-Loom",
                                  color: "#ee2e47",
                                }}
                              >
                                {error.trailerVideoUrl}
                              </Typography>
                            </div>
                          )} */}
                    </div>
                  </div>
                  <div className="col-md-6 my-2">
                    <label className="float-left styleForTitle movieForm">
                      Trailer Image
                    </label>
                    <input
                      type="file"
                      id="customFile"
                      name="trailerImageShowURL"
                      placeholder="https://www.youtube.com"
                      className="form-control form-control-line"
                      onChange={handleFileChange}
                    />
                    <p className="extention-show">
                      Accept only .png, .jpeg and .jpg
                    </p>

                    {/* <div className="d-flex justify-content-end mt-3">
                            <button
                              type="button"
                              className="btn btn-success btn-sm px-3 py-1 mt-4 "
                              onClick={trailerImageLoad} // actual upload logic
                            >
                              Upload
                            </button>
                          </div> */}

                    {showURL?.trailerImageShowURL && (
                      <img
                        src={showURL?.trailerImageShowURL}
                        onError={(e) => {
                          e.target.onerror = null; // Prevents infinite loop
                          e.target.src = noImage; // Default image path
                        }}
                        height="100px"
                        width="100px"
                        alt="app"
                        style={{
                          boxShadow: " rgba(105, 103, 103, 0) 0px 5px 15px 0px",
                          border: "0.5px solid rgba(255, 255, 255, 0.2)",
                          borderRadius: "10px",
                          marginTop: "10px",
                          float: "left",
                        }}
                      />
                    )}

                    {error.trailerImage && (
                      <div className="pl-1 text-left">
                        <Typography
                          variant="caption"
                          style={{
                            fontFamily: "Circular-Loom",
                            color: "#ee2e47",
                          }}
                        >
                          {error.trailerImage}
                        </Typography>
                      </div>
                    )}
                  </div>
                </div>
              </div>

              <UploadProgress data={data} />
            </div>
            <div className="iq-card-footer">
              <DialogActions className="">
                {dialogData ? (
                  <button
                    type="button"
                    className="btn btn-success btn-sm px-3 py-1"
                    onClick={handleSubmit}
                  >
                    Update
                  </button>
                ) : (
                  <button
                    type="button"
                    className="btn btn-success btn-sm px-3 py-1"
                    onClick={handleSubmit}
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

export default connect(null, { getRegion, getGenre, createManualSeries })(
  SeriesManual
);
