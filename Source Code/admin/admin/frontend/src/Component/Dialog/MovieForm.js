import React, { useState, useRef, useEffect } from "react";
import $ from "jquery";

//react-router-dom
import { useHistory, NavLink } from "react-router-dom";

//material-ui
import { DialogActions, Typography } from "@mui/material";
import { makeStyles } from "@mui/styles";
import MovieFilterIcon from "@mui/icons-material/MovieFilter";
import RecentActorsIcon from "@mui/icons-material/RecentActors";
import EditIcon from "@mui/icons-material/Edit";
import GetAppIcon from "@mui/icons-material/GetApp";
import AddIcon from "@mui/icons-material/Add";
import male from "../assets/images/defaultUserPicture.jpg";
import noImage from "../assets/images/noImage.png";
import Paper from "@mui/material/Paper";
import card from "../assets/images/1.png";
import thumb from "../assets/images/5.png";

//editor
import SunEditor from "suneditor-react";
import "suneditor/dist/css/suneditor.min.css";

//Multi Select Dropdown
import Multiselect from "multiselect-react-dropdown";

//react-redux
import { connect, useDispatch } from "react-redux";
import { useSelector } from "react-redux";

//all actions

import {
  updateMovie,
  loadMovieData,
  createManual,
} from "../../store/Movie/movie.action";
import { getGenre } from "../../store/Genre/genre.action";
import { getRegion } from "../../store/Region/region.action";
import { getTeamMember } from "../../store/TeamMember/teamMember.action";
import UploadProgressManual from "../../Pages/UploadProgressManual";
import { setUploadFileManual } from "../../store/Movie/movie.action";
//Alert

import { covertURl, uploadFile } from "../../util/AwsFunction";
import axios from "axios";
import { folderStructurePath, baseURL, secretKey } from "../../util/config";
import { setToast } from "../../util/Toast";
import { Toast } from "../../util/Toast_";
import {
  EMPTY_TMDB_MOVIES_DIALOGUE,
  FILE_UPLOAD_SUCCESS,
} from "../../store/Movie/movie.type";
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

const MovieDialog = (props) => {
  const { genre } = useSelector((state) => state.genre);
  const { region } = useSelector((state) => state.region);
  const { movieDetailsTmdb } = useSelector((state) => state.movie);

  //call teamMember and set teamMember
  const { teamMember } = useSelector((state) => state.teamMember);

  const dialogData = JSON.parse(sessionStorage.getItem("updateMovieData"));

  const editor = useRef(null);
  const dispatch = useDispatch();

  const [country, setCountry] = useState("");
  const [title, setTitle] = useState("");
  const [trailerName, setTrailerName] = useState("");
  const [trailerType, setTrailerType] = useState("");
  const [description, setDescription] = useState("");
  const [trailerUrl, setTrailerUrl] = useState("");
  const [convertUpdateType, setConvertUpdateType] = useState({
    image: "",
    thumbnail: "",
    link: "",
  });
  const [year, setYear] = useState("");
  const [genres, setGenres] = useState([]);
  const [image, setImage] = useState([]);
  const [imagePath, setImagePath] = useState("");
  const [trailerImage, setTrailerImage] = useState([]);
  const [trailerImagePath, setTrailerImagePath] = useState("");
  const [thumbnail, setThumbnail] = useState([]);
  const [thumbnailPath, setThumbnailPath] = useState("");
  const [video, setVideo] = useState([]);
  const [videoPath, setVideoPath] = useState("");
  const [trailerVideo, setTrailerVideo] = useState([]);
  const [trailerVideoPath, setTrailerVideoPath] = useState("");
  const [movieId, setMovieId] = useState("");
  const [type, setType] = useState("Premium");
  const [runtime, setRuntime] = useState("");
  const [videoType, setVideoType] = useState("0");
  const [trailerVideoType, setTrailerVideoType] = useState(0);
  const [youtubeUrl, setYoutubeUrl] = useState("");
  const [m3u8Url, setM3u8Url] = useState("");
  const [movUrl, setMovUrl] = useState("");
  const [mp4Url, setMp4Url] = useState("");
  const [mkvUrl, setMkvUrl] = useState("");
  const [webmUrl, setWebmUrl] = useState("");
  const [embedUrl, setEmbedUrl] = useState("");
  const [countries, setCountries] = useState([]);
  const [uploadProgress, setUploadProgress] = useState(0);
  const [loading, setLoading] = useState(false);
  const [updateType, setUpdateType] = useState();
  const [selectedFile, setSelectedFile] = useState("");
  const [selectThumbail, setSelectThumbail] = useState("");
  const [selectMovieImage, setSelectMovieImage] = useState("");

  const [videoPreview, setVideoPreview] = useState(null); // for preview
  const [selectedVideoFile, setSelectedVideoFile] = useState(null); // for upload at submit

  const [trailerVideoPreview, setTrailerVideoPreview] = useState(null);
  const [selectedTrailerVideoFile, setSelectedTrailerVideoFile] =
    useState(null);

  const [showLink, setShowLink] = useState("");
  //get genre list
  const [genreData, setGenreData] = useState([]);
  //get category list
  const [categoryData, setCategoryData] = useState([]);
  const [trailerVideoUrl, setTrailerVideoUrl] = useState("");
  sessionStorage.setItem("trillerId", movieId);
  const [data, setData] = useState({
    title: "",
    trailerName: "",
    trailerType: "",
    description: "",
    year: "",
    categories: "",
    genres: [],
    thumbnail: [],
    image: [],
    trailerImage: [],
    type: "",
    country: "",
    runtime: "",
    videoType: "",
    trailerVideoType: "",
    youtubeUrl: "",
    m3u8Url: "",
    movUrl: "",
    mp4Url: "",
    mkvUrl: "",
    webmUrl: "",
    embedUrl: "",
    trailerVideoUrl: "",
    trailerVideo: [],
  });

  // Rental controls
  const [isRentable, setIsRentable] = useState(false);
  const [rentalCurrency, setRentalCurrency] = useState("INR");
  const [rentalOptions, setRentalOptions] = useState([
    { duration: 3, durationLabel: "3 Hours", price: "" },
    { duration: 6, durationLabel: "6 Hours", price: "" },
    { duration: 12, durationLabel: "12 Hours", price: "" },
    { duration: 24, durationLabel: "24 Hours", price: "" },
    { duration: 48, durationLabel: "2 Days", price: "" },
    { duration: 168, durationLabel: "7 Days", price: "" },
    { duration: 360, durationLabel: "15 Days", price: "" },
    { duration: 504, durationLabel: "21 Days", price: "" },
    { duration: 720, durationLabel: "30 Days", price: "" },
  ]);
  const rentalSectionRef = useRef(null);

  const [error, setError] = useState({
    title: "",
    trailerType: "",
    trailerName: "",
    description: "",
    year: "",
    genres: [],
    thumbnail: [],
    image: [],
    trailerImage: [],
    type: "",

    country: "",
    runtime: "",
    trailerVideoType: "",
    videoType: "",
    youtubeUrl: "",
    m3u8Url: "",
    movUrl: "",
    mp4Url: "",
    mkvUrl: "",
    webmUrl: "",
    embedUrl: "",
    trailerVideoUrl: "",
    trailerVideo: "",
  });

  //useEffect for Get Data
  useEffect(() => {
    dispatch(getGenre());
    dispatch(getRegion());
  }, [dispatch]);

  //Set Data after Getting
  useEffect(() => {
    setGenreData(genre);
  }, [genre]);

  // set data in dialog
  useEffect(() => {
    if (dialogData) {
      const genreId = dialogData?.genre?.map((value) => {
        return value._id;
      });
      setTitle(dialogData.title);
      setConvertUpdateType({
        image: dialogData?.convertUpdateType?.image,
        thumbnail: dialogData?.convertUpdateType?.thumbnail,
        link: dialogData?.convertUpdateType?.link,
      });
      setTrailerName(dialogData.trailerName);
      setTrailerType(dialogData.trailerType);
      setDescription(dialogData.description);
      setYear(dialogData.year);
      setCountry(dialogData.region._id);
      setImagePath(dialogData.image);
      setThumbnailPath(dialogData.thumbnail);
      setMovieId(dialogData._id);
      setVideoPath(dialogData.link);
      setType(dialogData.type);

      setRuntime(dialogData.runtime);
      setUpdateType(dialogData?.updateType);
      setTrailerVideoType(dialogData.trailerVideoType);
      if (dialogData.trailerVideoType == 0) {
        setTrailerVideoUrl(dialogData.trailerVideoUrl);
      } else if (dialogData.trailerVideoType == 1) {
        setTrailerVideoPath(dialogData.trailerVideoUrl);
        setTrailerVideo(dialogData.trailerVideoUrl);
      }
      setVideoType(dialogData.videoType);
      if (dialogData.videoType == 0) {
        setYoutubeUrl(dialogData.link);
      } else if (dialogData.videoType == 1) {
        setM3u8Url(dialogData.link);
      } else if (dialogData.videoType == 2) {
        setMovUrl(dialogData.link);
      } else if (dialogData.videoType == 3) {
        setMp4Url(dialogData.link);
      } else if (dialogData.videoType == 4) {
        setMkvUrl(dialogData.link);
      } else if (dialogData.videoType == 5) {
        setWebmUrl(dialogData.link);
      } else if (dialogData.videoType == 6) {
        setEmbedUrl(dialogData.link);
      } else if (dialogData.videoType == 7) {
        setVideoPath(dialogData.link);
        setVideo(dialogData.link);
      }

      // Rental state from existing movie
      setIsRentable(Boolean(dialogData.isRentable));
      setRentalCurrency(dialogData.rentalCurrency || "USD");
      if (
        Array.isArray(dialogData.rentalOptions) &&
        dialogData.rentalOptions.length > 0
      ) {
        setRentalOptions(dialogData.rentalOptions);
      }
    } else {
      setTitle("");
      setTrailerName("");
      setTrailerType("");
      setDescription("");
      setYear("");
      setCountry("");
      setImagePath("");
      setThumbnailPath("");
      setMovieId("");
      setVideoPath("");
      setType("");
      setRuntime("");
      setTrailerVideoType("");
      setTrailerVideoUrl("");
      setTrailerVideoPath("");
      setTrailerVideo("");
      setVideoType("");
      setYoutubeUrl("");
      setM3u8Url("");
      setMovUrl("");
      setMp4Url("");
      setMkvUrl("");
      setWebmUrl("");
      setEmbedUrl("");
      setVideoPath("");
      setVideo("");
    }

    return () => {
      console.log("executed movie form return block");
      dispatch({ type: EMPTY_TMDB_MOVIES_DIALOGUE });
    };
  }, [dialogData]);

  // Focus rental section when coming from Purchase button
  useEffect(() => {
    const focusRental = sessionStorage.getItem("rentalFocus");
    if (focusRental === "true") {
      setTimeout(() => {
        rentalSectionRef.current?.scrollIntoView({
          behavior: "smooth",
          block: "start",
        });
        sessionStorage.removeItem("rentalFocus");
      }, 300);
    }
  }, []);

  const ref = useRef();
  const imageRef = useRef();
  const videoRef = useRef();
  const classes = useStyles1();
  const history = useHistory();

  const handlePaste = (e) => {
    const bufferText = (e?.originalEvent || e).clipboardData.getData(
      "text/plain",
    );
    e.preventDefault();
    document.execCommand("insertText", false, bufferText);
  };
  const [editorOptions, setEditorOptions] = useState({
    // Other SunEditor options you may want to set
    // For the complete list of options, check the documentation.
    buttonList: [
      ["undo", "redo"],
      ["font", "fontSize", "formatBlock"],
      ["bold", "underline", "italic", "strike", "subscript", "superscript"],
      ["removeFormat"],
      ["outdent", "indent"],
      ["align", "horizontalRule", "list", "table"],
      ["link", "image", "video"],
      ["fullScreen", "showBlocks", "codeView"],
      ["preview", "print"],
      ["save"],
    ],
    // Add the custom onPaste handler to the options
    onPaste: handlePaste,
  });

  useEffect(() => {
    setCountries(region);
  }, [region]);

  //get Teammember list
  const [teamMemberData, setTeamMemberData] = useState([]);
  const [showURL, setShowURL] = useState({
    thumbnailImageShowImage: "",
    movieImageShowURL: "",
    movieVideoShowURl: "",
    trailerImageShowURL: "",
    trailerVideoShowURL: "",
  });
  const [resURL, setResURL] = useState({
    thumbnailImageResURL: "",
    movieImageResURL: "",
    movieVideoResURL: "",
    trailerImageResURL: "",
    trailerVideoResURL: "",
  });

  useEffect(() => {
    setTeamMemberData(teamMember);
  }, [teamMember]);

  let folderStructureMovieImage = folderStructurePath + "movieImage";
  // const handleImageChange = (e) => {
  //   const file = e.target.files[0];

  //   if (file) {
  //     setSelectMovieImage(file);
  //     setShowURL({ ...showURL, movieImageShowURL: URL.createObjectURL(file) });
  //   }
  // }

  //  Image Load
  const imageLoad = async (event) => {
    setUpdateType(1);
    setConvertUpdateType({
      ...convertUpdateType,
      image: 1,
    });
    setImage(selectMovieImage);
    const { resDataUrl, imageURL } = await uploadFile(
      selectMovieImage,
      folderStructureMovieImage,
    );

    setResURL({ ...resURL, movieImageResURL: resDataUrl });
    setShowURL({ ...showURL, movieImageShowURL: imageURL });
  };

  let folderStructureThumbnail = folderStructurePath + "movieThumbnail";

  // const handlethumbailChange = (e) => {
  //   const file = e.target.files[0];

  //   if (file) {
  //     setSelectThumbail(file);
  //     setShowURL({ ...showURL, thumbnailImageShowImage: URL.createObjectURL(file) });
  //   }
  // }
  // Thumbnail Load
  const thumbnailLoad = async (event) => {
    setUpdateType(1);
    setConvertUpdateType({
      ...convertUpdateType,
      thumbnail: 1,
    });
    setThumbnail(selectThumbail);
    const { resDataUrl, imageURL } = await uploadFile(
      selectThumbail,
      folderStructureThumbnail,
    );

    setResURL({ ...resURL, thumbnailImageResURL: resDataUrl });
    setShowURL({ ...showURL, thumbnailImageShowImage: imageURL });
  };

  let folderStructureMovieVideo = folderStructurePath + "movieVideo";

  const videoLoad = async (event) => {
    setUpdateType(1);
    setConvertUpdateType({
      ...convertUpdateType,
      link: 1,
    });
    setVideo(event.target.files[0]);
    setVideo(event.target.files[0]);
    const videoElement = document.createElement("video");
    videoElement.src = URL.createObjectURL(event.target.files[0]);
    videoElement.addEventListener("loadedmetadata", () => {
      const durationInSeconds = videoElement.duration;
      const durationInMilliseconds = durationInSeconds * 1000;
      setRuntime(parseInt(durationInMilliseconds));
    });

    const formData = new FormData();
    formData.append("folderStructure", folderStructureMovieVideo);
    formData.append("keyName", event.target.files[0]?.name);
    formData.append("content", event.target.files[0]);
    const uploadUrl = baseURL + `file/upload-file`;

    const xhr = new XMLHttpRequest();
    xhr.open("POST", uploadUrl, true);
    // Set up event listener for tracking progress
    xhr.upload.onprogress = (event) => {
      const progress = (event.loaded / event.total) * 100;
      setUploadProgress(progress);
      setLoading(true);

      if (progress === 100) {
        xhr.onload = async () => {
          if (xhr.status === 200) {
            try {
              const responseData = JSON?.parse(xhr.responseText);

              setResURL({ ...resURL, movieVideoResURL: responseData?.url });

              if (responseData?.status) {
                setLoading(false);

                Toast("success", "successfully Video Upload");

                const fileNameWithExtension = responseData?.url
                  .split("/")
                  .pop();
                const fetchData = async () => {
                  try {
                    const { imageURL } = await covertURl(
                      "movieVideo/" + fileNameWithExtension,
                    );

                    setShowURL({ ...showURL, movieVideoShowURl: imageURL });
                  } catch (error) {
                    console.error(error);
                  }
                };

                fetchData();
                const interval = setInterval(fetchData, 1000 * 60);
                return () => clearInterval(interval);
              }
            } catch (error) {
              console.error("Error parsing response data:", error);
            }
          } else {
            console.error("HTTP error! Status:", xhr?.status);
          }
        };
      }
    };
    xhr.onerror = () => {
      console.error("Error during upload");
    };
    xhr.setRequestHeader("key", secretKey);
    xhr.send(formData);
  };

  //Trailer Video Load
  let folderStructureTrailerVideo = folderStructurePath + "trailerVideo";
  const trailerVideoLoad = async (event) => {
    const formData = new FormData();
    formData.append("folderStructure", folderStructureTrailerVideo);
    formData.append("keyName", event.target.files[0]?.name);
    formData.append("content", event.target.files[0]);
    const uploadUrl = baseURL + `file/upload-file`;

    const xhr = new XMLHttpRequest();
    xhr.open("POST", uploadUrl, true);
    // Set up event listener for tracking progress
    xhr.upload.onprogress = (event) => {
      const progress = (event.loaded / event.total) * 100;
      setUploadProgress(progress);
      setLoading(true);

      if (progress === 100) {
        xhr.onload = async () => {
          if (xhr.status === 200) {
            try {
              const responseData = JSON?.parse(xhr.responseText);

              setResURL({ ...resURL, trailerVideoResURL: responseData?.url });

              if (responseData?.status) {
                setLoading(false);

                Toast("success", "successfully Video Upload");

                const fileNameWithExtension = responseData?.url
                  .split("/")
                  .pop();
                const fetchData = async () => {
                  try {
                    const { imageURL } = await covertURl(
                      "trailerVideo/" + fileNameWithExtension,
                    );

                    setShowURL({ ...showURL, trailerVideoShowURL: imageURL });
                  } catch (error) {
                    console.error(error);
                  }
                };

                fetchData();
                const interval = setInterval(fetchData, 1000 * 60);
                return () => clearInterval(interval);
              }
            } catch (error) {
              console.error("Error parsing response data:", error);
            }
          } else {
            console.error("HTTP error! Status:", xhr?.status);
          }
        };
      }
    };

    xhr.onerror = () => {
      console.error("Error during upload");
    };

    xhr.setRequestHeader("key", secretKey);

    xhr.send(formData);
  };

  let folderStructureTrailerImage = folderStructurePath + "trailerImage";

  // const handleFileChange = (e) => {
  //  const  {name} = e.target.value
  //   console.log("name",name);

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
        setSelectThumbail(file);
      } else if (inputName === "movieImageShowURL") {
        setSelectMovieImage(file);
      }
    }
  };

  //Trailer Image Load
  const trailerImageLoad = async (event) => {
    setTrailerImage(selectedFile);

    const { resDataUrl, imageURL } = await uploadFile(
      selectedFile,
      folderStructureTrailerImage,
    );

    setResURL({ ...resURL, trailerImageResURL: resDataUrl });
    setShowURL({ ...showURL, trailerImageShowURL: imageURL });
  };

  //Remove Demo
  const removeDemo = () => {
    setVideo([]);
    setVideoPath("");
  };

  const videoChange = (event) => {
    if (document.getElementById("demoVideo").checked) {
      setShowLink("");
    } else {
      setShowLink(event.target.value);
    }
  };

  const handleAllUploads = async () => {
    let trailerRes = {},
      thumbnailRes = {},
      movieRes = {};

    if (selectedFile) {
      trailerRes = await uploadFile(selectedFile, folderStructureTrailerImage);
      setResURL((prev) => ({
        ...prev,
        trailerImageResURL: trailerRes.resDataUrl,
      }));
      setShowURL((prev) => ({
        ...prev,
        trailerImageShowURL: trailerRes.imageURL,
      }));
      setTrailerImage(selectedFile);
    }

    if (selectThumbail) {
      thumbnailRes = await uploadFile(selectThumbail, folderStructureThumbnail);
      setResURL((prev) => ({
        ...prev,
        thumbnailImageResURL: thumbnailRes.resDataUrl,
      }));
      setShowURL((prev) => ({
        ...prev,
        thumbnailImageShowImage: thumbnailRes.imageURL,
      }));
      setThumbnail(selectThumbail);
      setUpdateType(1);
      setConvertUpdateType((prev) => ({ ...prev, thumbnail: 1 }));
    }

    if (selectMovieImage) {
      movieRes = await uploadFile(selectMovieImage, folderStructureMovieImage);
      setResURL((prev) => ({ ...prev, movieImageResURL: movieRes.resDataUrl }));
      setShowURL((prev) => ({ ...prev, movieImageShowURL: movieRes.imageURL }));
      setImage(selectMovieImage);
      setUpdateType(1);
      setConvertUpdateType((prev) => ({ ...prev, image: 1 }));
    }

    return {
      trailerImageResURL: trailerRes.resDataUrl || "",
      thumbnailImageResURL: thumbnailRes.resDataUrl || "",
      movieImageResURL: movieRes.resDataUrl || "",
    };
  };

  const handleMainVideoSelect = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    setSelectedVideoFile(file);
    setVideoPreview(URL.createObjectURL(file));

    const videoElement = document.createElement("video");
    videoElement.src = URL.createObjectURL(file);
    videoElement.onloadedmetadata = () => {
      const duration = videoElement.duration * 1000;
      setRuntime(parseInt(duration));
    };
  };

  // Trailer video select
  const handleTrailerVideoSelect = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    setSelectedTrailerVideoFile(file);
    setTrailerVideoPreview(URL.createObjectURL(file));
  };

  const uploadUsingXHR = (formData) => {
    return new Promise((resolve, reject) => {
      const xhr = new XMLHttpRequest();
      xhr.open("POST", `${baseURL}file/upload-file`, true);
      xhr.setRequestHeader("key", secretKey);

      xhr.onload = () => {
        if (xhr.status === 200) {
          const response = JSON.parse(xhr.responseText);
          if (response.status) {
            resolve(response.url);
          } else {
            reject("Upload failed");
          }
        } else {
          reject("HTTP error");
        }
      };

      xhr.onerror = () => reject("Network error");
      xhr.send(formData);
    });
  };

  // Rental option editor helpers
  const handleRentalOptionChange = (index, key, value) => {
    setRentalOptions((prev) =>
      prev.map((opt, i) => (i === index ? { ...opt, [key]: value } : opt)),
    );
  };

  // //insert function
  const handleSubmit = async () => {
    dispatch({ type: OPEN_LOADER }); // ✅ Start loader

    try {
      if (
        !title ||
        !trailerName ||
        !trailerType ||
        !description ||
        !year ||
        !country ||
        !image ||
        !trailerImage ||
        !thumbnail ||
        !runtime ||
        !type ||
        !trailerVideoType ||
        (!videoType && videoType == 0) ||
        (trailerVideoType == 0 && !trailerVideoUrl)
      ) {
        const error = {};
        if (!image || !imagePath) error.image = "Image is Required!";
        if (!trailerImage) error.trailerImage = "Trailer Image is Required!";
        if (!title) error.title = "Title is Required !";
        if (!trailerName) error.trailerName = "Trailer Name is Required !";
        if (!trailerType) error.trailerType = "Trailer Type is Required !";
        if (!description) error.description = "Description is Required !";
        if (!year) error.year = "Year is Required !";
        if (genres.length === 0) error.genres = "Genre is Required !";
        if (!country) error.country = "Region is Required !";
        if (!runtime) error.runtime = "Runtime is Required !";
        if (runtime > 200)
          error.runtime = "Runtime is must be under 200 minutes !";
        if (!thumbnail || !thumbnailPath)
          error.thumbnail = "Thumbnail is Required !";
        if (!type) error.type = "Type is required !";

        if (!videoType) error.videoType = "Video Type is required !";
        if (!trailerVideoType)
          error.trailerVideoType = "Trailer Video Type is required !";
        if (trailerVideoType == 0) {
          if (!trailerVideoUrl) {
            error.trailerVideoUrl = "Trailer Youtube URL is Required !";
          }
        } else if (trailerVideoType == 1) {
          if (trailerVideo.length == 0) {
            error.trailerVideo = "Trailer Video is Required !";
          }
        }
        if (!video || !videoPath) error.video = "Video is Required !";
        if (!trailerVideo) error.trailerVideo = "Trailer Video is Required !";

        if (!videoType || !youtubeUrl) {
          error.youtubeUrl = "Youtube URL is Required !";
        }

        return setError({ ...error });
      } else {
        // if (videoType == 7) {
        // props.setUploadFileManual(video);
        setData({
          title,
          trailerName,
          trailerType,
          description,
          year,
          genres,
          thumbnail,
          image,
          trailerImage,
          type,
          runtime,
          videoType,
          trailerVideoType,
          youtubeUrl,
          m3u8Url,
          movUrl,
          convertUpdateType,
          mp4Url,
          mkvUrl,
          webmUrl,
          embedUrl,
          trailerVideoUrl,
          country,
          trailerVideo,
        });
        // } else {

        const uploadedImages = await handleAllUploads();

        let uploadedVideoURL = "";
        if (videoType == 7 && selectedVideoFile) {
          const formData = new FormData();
          formData.append("folderStructure", folderStructureMovieVideo);
          formData.append("keyName", selectedVideoFile.name);
          formData.append("content", selectedVideoFile);

          try {
            uploadedVideoURL = await uploadUsingXHR(formData);
          } catch (err) {
            console.error(err);
            Toast("error", "Video upload failed!");
            return;
          }
        }

        // ✅ Upload trailer video if trailerVideoType == 1
        let uploadedTrailerVideoURL = "";
        if (trailerVideoType == 1 && selectedTrailerVideoFile) {
          const formData = new FormData();
          formData.append("folderStructure", folderStructureTrailerVideo);
          formData.append("keyName", selectedTrailerVideoFile.name);
          formData.append("content", selectedTrailerVideoFile);

          try {
            uploadedTrailerVideoURL = await uploadUsingXHR(formData);
          } catch (err) {
            console.error(err);
            Toast("error", "Trailer Video upload failed!");
            return;
          }
        }

        // let objData = {
        //   title,
        //   description,
        //   year,
        //   type,
        //   region: country,
        //   // image: resURL?.movieImageResURL,
        //   image: uploadedImages.movieImageResURL,
        //   trailerType,
        //   trailerVideoType,
        //   runtime,
        //   // thumbnail: resURL?.thumbnailImageResURL,
        //   thumbnail: uploadedImages.thumbnailImageResURL,
        //   trailerName,
        //   videoType,
        //   convertUpdateType,
        //   updateType: updateType,
        //   // trailerImage: resURL?.trailerImageResURL,
        //   trailerImage: uploadedImages.trailerImageResURL,
        //   genre: genres,
        //   link:
        //     videoType == 0
        //       ? youtubeUrl
        //       : videoType == 1
        //         ? m3u8Url
        //         : videoType == 2
        //           ? movUrl
        //           : videoType == 3
        //             ? mp4Url
        //             : videoType == 4
        //               ? mkvUrl
        //               : videoType == 5
        //                 ? webmUrl
        //                 : videoType == 6
        //                   ? embedUrl
        //                   : resURL?.movieVideoResURL,
        //   trailerVideoType,
        //   trailerVideoUrl:
        //     trailerVideoType == 0 ? trailerVideoUrl : resURL?.trailerVideoResURL,
        // };

        let objData = {
          title,
          description,
          year,
          type,
          region: country,
          image: uploadedImages.movieImageResURL,
          trailerType,
          trailerVideoType,
          runtime,
          thumbnail: uploadedImages.thumbnailImageResURL,
          trailerName,
          videoType,
          convertUpdateType,
          updateType: updateType,
          trailerImage: uploadedImages.trailerImageResURL,
          genre: genres,
          link:
            videoType == 0
              ? youtubeUrl
              : videoType == 1
                ? m3u8Url
                : videoType == 2
                  ? movUrl
                  : videoType == 3
                    ? mp4Url
                    : videoType == 4
                      ? mkvUrl
                      : videoType == 5
                        ? webmUrl
                        : videoType == 6
                          ? embedUrl
                          : uploadedVideoURL,
          trailerVideoUrl:
            trailerVideoType == 0 ? trailerVideoUrl : uploadedTrailerVideoURL,
          // rental fields
          isRentable,
          rentalCurrency,
          rentalOptions,
        };

        // if (uploadProgress == 100) {
        //   dispatch({ type: FILE_UPLOAD_SUCCESS, payload: objData });
        // }

        props.createManual(objData);
      }

      setTimeout(() => {
        history.push("/admin/movie");
      }, 3000);
      // }
    } catch (error) {
      console.error("Submit Error:", error);
      Toast("error", "Submission Failed!");
    } finally {
      dispatch({ type: CLOSE_LOADER }); // ✅ Stop loader
    }
  };

  const genreId = movieDetailsTmdb?.genre?.map((id) => {
    return id;
  });

  //onselect function of selecting multiple values
  function onSelect(selectedList, selectedItem) {
    genres?.push(selectedItem?._id);
  }

  //onRemove function for remove multiple values
  function onRemove(selectedList, removedItem) {
    setGenres(selectedList.map((data) => data._id));
  }

  // set default image

  $(document).ready(function () {
    $("img").bind("error", function () {
      // Set the default image
      $(this).attr("src", male);
    });
  });

  //Close Dialog
  const handleClose = () => {
    sessionStorage.removeItem("updateMovieData");

    if (dialogData) {
      history.goBack();
    } else {
      history.push("/admin/movie");
    }
  };

  const handleClick = (e) => {
    ref.current.click();
  };

  const handleClickImage = (e) => {
    imageRef.current.click();
  };

  const handleClickVideo = (e) => {
    videoRef.current.click();
  };

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          {dialogData ? (
            <div className="nav nav-pills mb-3">
              <button className="nav-item navCustom border-0">
                <NavLink className="nav-link" to="/admin/movie/movie_form">
                  Edit
                </NavLink>
              </button>
              <button className="nav-item navCustom border-0">
                <NavLink className="nav-link" to="/admin/movie/trailer">
                  Trailer
                </NavLink>
              </button>
              <button className="nav-item navCustom border-0">
                <NavLink className="nav-link" to="/admin/movie/cast">
                  Cast
                </NavLink>
              </button>
            </div>
          ) : (
            <div className="nav nav-pills mb-3">
              <button className="nav-item navCustom border-0">
                <NavLink className="nav-link" to="/admin/movie/movie_form">
                  IMDB
                </NavLink>
              </button>
              <button className="nav-item navCustom border-0">
                <NavLink className="nav-link" to="/admin/movie/movie_manual">
                  Manual
                </NavLink>
              </button>
            </div>
          )}

          <div className="iq-card mb-5">
            <div class="iq-card-header">
              <h4>Movie</h4>
            </div>
            <div className="iq-card-body">
              <div className="">
                <div className="p-3">
                  <div className="row p-0">
                    {/* New */}
                    <div class="col-6 form-group">
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
                            name="title"
                            value={title}
                            onChange={(e) => {
                              setTitle(
                                e.target.value.charAt(0).toUpperCase() +
                                  e.target.value.slice(1),
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
                          name="title"
                          placeholder="Title"
                          className="form-control form-control-line"
                          Required
                          value={title}
                          onChange={(e) => {
                            setTitle(
                              e.target.value.charAt(0).toUpperCase() +
                                e.target.value.slice(1),
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

                      <input
                        type="date"
                        placeholder="YYYY-MM-DD"
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
                      <label className="float-left">Runtime (minutes)</label>
                      <input
                        type="number"
                        placeholder="Runtime"
                        className="form-control form-control-line"
                        requiredfru
                        value={runtime}
                        onChange={(e) => {
                          setRuntime(e.target.value);

                          if (!e.target.value) {
                            return setError({
                              ...error,
                              runtime: "Runtime is Required!",
                            });
                          } else {
                            return setError({
                              ...error,
                              runtime: "",
                            });
                          }
                        }}
                      />
                      {error.runtime && (
                        <div className="pl-1 text-left">
                          <Typography
                            variant="caption"
                            color="error"
                            style={{
                              fontFamily: "Circular-Loom",
                              color: "#ee2e47",
                            }}
                          >
                            {error.runtime}
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

                          if (e.target.value === "select type") {
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
                        <option value="select type">Select Type</option>
                        <option value="Free">Free</option>
                        <option value="Premium">Premium</option>
                        {/* <option>Default</option> */}
                      </select>

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

                    <div class="col-6 form-group">
                      <label className="movieForm">Video Type</label>
                      <div>
                        <select
                          id="contentType"
                          name="contentType"
                          class="form-select form-control-line"
                          required
                          value={videoType}
                          onChange={(e) => {
                            setVideoType(e.target.value);
                            if (e.target.value === "select videoType") {
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
                          <option value="select videoType">
                            {" "}
                            Select Video Type
                          </option>
                          <option value={0}>Youtube Url </option>
                          <option value={1}>m3u8 Url </option>
                          <option value={2}>MOV Url </option>
                          <option value={3}>MP4 Url</option>
                          <option value={4}>MKV Url</option>
                          <option value={5}>WEBM Url</option>
                          <option value={6}>Embed source</option>
                          <option value={7}>File (MP4/MOV/MKV/WEBM)</option>
                        </select>
                        {!videoType ? (
                          <div className="pl-1 text-left">
                            <Typography
                              variant="caption"
                              style={{
                                fontFamily: "Circular-Loom",
                                color: "#ee2e47",
                              }}
                            >
                              {error.videoType}
                            </Typography>
                          </div>
                        ) : (
                          ""
                        )}
                      </div>
                    </div>

                    <div className="col-6 form-group ">
                      <label
                        htmlFor="earning"
                        className="styleForTitle movieForm"
                      >
                        Region
                      </label>
                      <select
                        name="type"
                        className="form-select form-control-line minimal"
                        id="type"
                        value={country}
                        onChange={(e) => {
                          setCountry(e.target.value);

                          if (e.target.value === "Select Region") {
                            return setError({
                              ...error,
                              country: "Movie Country is Required!",
                            });
                          } else {
                            return setError({
                              ...error,
                              country: "",
                            });
                          }
                        }}
                      >
                        <option value="Select Region">Select Region</option>
                        {countries.map((data, key) => {
                          return (
                            <>
                              <option value={data._id} key={key}>
                                {data.name}
                              </option>
                            </>
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

                    {/* Rental Settings */}
                    <div
                      className="col-12 form-group mt-3"
                      ref={rentalSectionRef}
                    >
                      <h5 className="border-top pt-3">Rental Settings</h5>
                      <div className="form-check form-switch mb-2">
                        <input
                          className="form-check-input"
                          type="checkbox"
                          id="isRentableSwitch"
                          checked={isRentable}
                          onChange={(e) => setIsRentable(e.target.checked)}
                        />
                        <label
                          className="form-check-label"
                          htmlFor="isRentableSwitch"
                        >
                          Enable Rental
                        </label>
                      </div>

                      {isRentable && (
                        <div className="row">
                          <div className="col-6 form-group">
                            <label className="movieForm">Rental Currency</label>
                            <select
                              className="form-select form-control-line"
                              value={rentalCurrency}
                              onChange={(e) =>
                                setRentalCurrency(e.target.value)
                              }
                            >
                              <option value="USD">USD</option>
                              <option value="INR">INR</option>
                              <option value="EUR">EUR</option>
                            </select>
                          </div>
                          <div className="col-12">
                            <label className="movieForm d-block">
                              Rental Options
                            </label>
                            <div className="table-responsive">
                              <table className="table table-sm">
                                <thead>
                                  <tr>
                                    <th>Label</th>
                                    <th>Duration (hours)</th>
                                    <th>Price ({rentalCurrency})</th>
                                  </tr>
                                </thead>
                                <tbody>
                                  {rentalOptions.map((opt, idx) => (
                                    <tr key={idx}>
                                      <td>
                                        <input
                                          type="text"
                                          className="form-control form-control-line"
                                          value={opt.durationLabel}
                                          onChange={(e) =>
                                            handleRentalOptionChange(
                                              idx,
                                              "durationLabel",
                                              e.target.value,
                                            )
                                          }
                                        />
                                      </td>
                                      <td>
                                        <input
                                          type="number"
                                          min="1"
                                          className="form-control form-control-line"
                                          value={opt.duration}
                                          onChange={(e) =>
                                            handleRentalOptionChange(
                                              idx,
                                              "duration",
                                              Number(e.target.value),
                                            )
                                          }
                                        />
                                      </td>
                                      <td>
                                        <input
                                          type="number"
                                          step="0.01"
                                          min="0"
                                          className="form-control form-control-line"
                                          value={opt.price}
                                          onChange={(e) =>
                                            handleRentalOptionChange(
                                              idx,
                                              "price",
                                              Number(e.target.value),
                                            )
                                          }
                                        />
                                      </td>
                                    </tr>
                                  ))}
                                </tbody>
                              </table>
                            </div>
                          </div>
                        </div>
                      )}
                    </div>

                    <div class="col-6 form-group">
                      <label className="movieForm">Video URL</label>
                      {dialogData ? (
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
                                      youtubeUrl: "Youtube url is Required!",
                                    });
                                  } else {
                                    return setError({
                                      ...error,
                                      youtubeUrl: "",
                                    });
                                  }
                                }}
                              />
                              {!youtubeUrl && (
                                <div className="pl-1 text-left">
                                  <Typography
                                    variant="caption"
                                    color="error"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.youtubeUrl}
                                  </Typography>
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
                                      m3u8Url: "m3u8 url is Required!",
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
                                  <Typography
                                    variant="caption"
                                    color="error"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.m3u8Url}
                                  </Typography>
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
                                      movUrl: "mov url is Required!",
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
                                  <Typography
                                    variant="caption"
                                    color="error"
                                    youtubeUrl
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.movUrl}
                                  </Typography>
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
                                      mp4Url: "mp4 url is Required!",
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
                                  <Typography
                                    variant="caption"
                                    color="error"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.mp4Url}
                                  </Typography>
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
                                      mkvUrl: "mkv url is Required!",
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
                                    color="error"
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
                                      webmUrl: "webm url is Required!",
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
                                    color="error"
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
                          {videoType == 6 && (
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
                                      embedUrl: "embed url is Required!",
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
                                    color="error"
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
                          {/* {videoType == 7 && (
                                <>
                                  <input
                                    type="file"
                                    id="customFile"
                                    className="form-control"
                                    accept="video/*"
                                    required=""
                                    onChange={videoLoad}
                                  />
                                  <>
                                    <video
                                      height="100px"
                                      width="100px"
                                      controls
                                      alt="app"
                                      src={showURL?.movieVideoShowURl}
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

                                    <div
                                      class="img-container"
                                      style={{
                                        display: 'inline',
                                        position: 'relative',
                                        float: 'left',
                                      }}
                                    ></div>
                                  </>
                                </>
                              )} */}
                          {videoType == 7 && (
                            <>
                              <input
                                type="file"
                                className="form-control"
                                id="customFile"
                                name="trailerImageShowURL"
                                accept="video/*"
                                onChange={handleMainVideoSelect}
                              />
                              <p className="extention-show">
                                Accept only .mp4, .mov, .mkv, .webm
                              </p>
                              {videoPreview && (
                                <video
                                  height="100px"
                                  width="100px"
                                  controls
                                  src={videoPreview}
                                  style={{
                                    marginTop: 10,
                                    borderRadius: "10px",
                                  }}
                                />
                              )}
                            </>
                          )}
                        </div>
                      ) : (
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
                                      youtubeUrl: "Youtube url is Required!",
                                    });
                                  } else {
                                    return setError({
                                      ...error,
                                      youtubeUrl: "",
                                    });
                                  }
                                }}
                              />
                              {!youtubeUrl && (
                                <div className="pl-1 text-left">
                                  <Typography
                                    variant="caption"
                                    color="error"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.youtubeUrl}
                                  </Typography>
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
                                      m3u8Url: "m3u8 url is Required!",
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
                                  <Typography
                                    variant="caption"
                                    color="error"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.m3u8Url}
                                  </Typography>
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
                                      movUrl: "mov url is Required!",
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
                                  <Typography
                                    variant="caption"
                                    color="error"
                                    youtubeUrl
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.movUrl}
                                  </Typography>
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
                                      mp4Url: "mp4 url is Required!",
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
                                  <Typography
                                    variant="caption"
                                    color="error"
                                    style={{
                                      fontFamily: "Circular-Loom",
                                      color: "#ee2e47",
                                    }}
                                  >
                                    {error.mp4Url}
                                  </Typography>
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
                                      mkvUrl: "mkv url is Required!",
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
                                    color="error"
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
                                      webmUrl: "webm url is Required!",
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
                                    color="error"
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
                          {videoType == 6 && (
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
                                      embedUrl: "embed url is Required!",
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
                                    color="error"
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
                          {/* {videoType == 7 && (
                                <>
                                  <input
                                    type="file"
                                    id="customFile"
                                    className="form-control"
                                    accept="video/*"
                                    required=""
                                    onChange={videoLoad}
                                  />

                                  <>
                                    <video
                                      height="100px"
                                      width="100px"
                                      controls
                                      alt="app"
                                      src={showURL?.movieVideoShowURl}
                                      style={{
                                        boxShadow:
                                          'rgb(101 146 173 / 34%) 0px 0px 0px 1.2px',
                                        borderRadius: 10,
                                        marginTop: 10,
                                        float: 'left',
                                      }}
                                    />
                                    {loading && <div className="loader" />}

                                    <div
                                      class="img-container"
                                      style={{
                                        display: 'inline',
                                        position: 'relative',
                                        float: 'left',
                                      }}
                                    ></div>
                                  </>
                                </>
                              )} */}
                          {videoType == 7 && (
                            <>
                              <input
                                type="file"
                                className="form-control"
                                accept="video/*"
                                id="customFile"
                                name="trailerImageShowURL"
                                onChange={handleMainVideoSelect}
                              />
                              <p className="extention-show">
                                Accept only .mp4, .mov, .mkv, .webm
                              </p>
                              {videoPreview && (
                                <video
                                  height="100px"
                                  width="100px"
                                  controls
                                  src={videoPreview}
                                  style={{
                                    marginTop: 10,
                                    borderRadius: "10px",
                                  }}
                                />
                              )}
                            </>
                          )}
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
                          selectedValues={movieDetailsTmdb?.genre} // Preselected value to persist in dropdown
                          onSelect={onSelect} // Function will trigger on select event
                          onRemove={onRemove} // Function will trigger on remove event
                          displayValue="name" // Property name to display in the dropdown options
                          id="css_custom"
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
                        className="styleForTitle mt-3 movieForm"
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
                        setOptions={editorOptions}
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
                      <div>
                        <label className=" movieForm">Thumbnail </label>

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
                                // onChange={handlethumbailChange}
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
                                      className=" bg-danger btn-sm btn"
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
                                        setSelectThumbail("");
                                      }}
                                    >
                                      <IconX
                                        size={"sm"}
                                        className="text-white"
                                      />
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
                                      top: 65,
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
                                    // onChange={handlethumbailChange}
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
                      <label className=" movieForm">Image</label>

                      <div className="d-flex justify-content-center align-item-center">
                        {imagePath ? (
                          <>
                            <input
                              ref={imageRef}
                              type="file"
                              className="form-control"
                              id="customFile"
                              name="movieImageShowURL"
                              accept="image/png, image/jpeg ,image/jpg"
                              Required=""
                              // onChange={imageLoad}
                              style={{ display: "none" }}
                              enctype="multipart/form-data"
                              // onChange={handleImageChange}
                              onChange={handleFileChange}
                            />
                            <img
                              onClick={handleClickImage}
                              alt="app"
                              src={showURL?.movieImageShowURL}
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
                            {showURL?.movieImageShowURL ? (
                              <>
                                <div className="d-flex flex-column">
                                  <img
                                    alt=""
                                    src={showURL?.movieImageShowURL}
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
                                    style={{
                                      position: "relative",
                                      bottom: "257px",
                                      width: "30px",
                                      left: "225px",
                                    }}
                                    className=" bg-danger btn-sm btn"
                                    onClick={() => {
                                      setShowURL({
                                        ...showURL,
                                        movieImageShowURL: "",
                                      });
                                      setSelectedFile("");
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
                                  name="movieImageShowURL"
                                  accept="image/png, image/jpeg ,image/jpg"
                                  Required=""
                                  // onChange={imageLoad}
                                  // onChange={handleImageChange}
                                  onChange={handleFileChange}
                                />
                              </div>
                            )}
                          </>
                        )}

                        {/* ===== imagePath here ======= */}
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

                    {/* Hello World */}
                  </div>
                </div>
                <div
                  className="col-md-6 iq-item-product-right"
                  style={{
                    borderLeft: "0.5px solid rgba(255, 255, 255, 0.3)",
                  }}
                ></div>
              </div>

              <div className="col-lg-12 p-0">
                <h4 className="border-top border-bottom p-3 m-0">Trailer</h4>
                <form className="p-2">
                  <div className="form-group">
                    <div className="row">
                      <div className="col-6 my-2">
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

                            if (e.target.value === "select Trailer Type") {
                              return setError({
                                ...error,
                                trailerType: "Trailer Name is Required!",
                              });
                            } else {
                              return setError({
                                ...error,
                                trailerType: "",
                              });
                            }
                          }}
                        >
                          <option value="select Trailer Type">
                            Select Trailer Type
                          </option>
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
                      <div className="col-md-6 my-2 ">
                        <label className="float-left styleForTitle">
                          Trailer Name
                        </label>
                        <input
                          type="text"
                          placeholder="Name"
                          className="form-control form-control-line"
                          required
                          value={trailerName}
                          onChange={(e) => {
                            setTrailerName(e.target.value);

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
                              color="error"
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
                      <div className="col-md-6">
                        <label className="movieForm">Trailer Video Type</label>
                        <div>
                          <select
                            id="contentType"
                            name="contentType"
                            class="form-select form-control-line"
                            required
                            value={trailerVideoType}
                            onChange={(e) => {
                              setTrailerVideoType(e.target.value);
                              if (
                                e.target.value === "select trailerVideoType"
                              ) {
                                return setError({
                                  ...error,
                                  trailerVideoType: "Video Type is Required!",
                                });
                              } else {
                                return setError({
                                  ...error,
                                  trailerVideoType: "",
                                });
                              }
                            }}
                          >
                            <option value="select trailerVideoType">
                              Select Trailer Video Type
                            </option>
                            <option value={0}>Youtube Url </option>
                            <option value={1}>File (MP4/MOV/MKV/WEBM)</option>
                          </select>
                          {error.trailerVideoType && (
                            <div className="pl-1 text-left">
                              <Typography
                                variant="caption"
                                color="error"
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
                      </div>
                      <div className="col-md-6 my-2 styleForTitle">
                        <label htmlFor="earning ">Trailer Video URL</label>

                        {trailerVideoType == 0 && (
                          <>
                            <input
                              type="text"
                              placeholder="Link"
                              class="form-control "
                              value={trailerVideoUrl}
                              onChange={(e) => {
                                setTrailerVideoUrl(e.target.value);
                                if (!e.target.value) {
                                  return setError({
                                    ...error,
                                    trailerVideoUrl:
                                      "Trailer Video URL is Required!",
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
                                  color="error"
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
                              className="form-control"
                              accept="video/*"
                              id="customFile"
                              name="trailerImageShowURL"
                              onChange={handleTrailerVideoSelect}
                            />
                            <p className="extention-show">
                              Accept only .mp4, .mov, .mkv, .webm
                            </p>
                            {trailerVideoPreview && (
                              <video
                                height="100px"
                                width="100px"
                                controls
                                src={trailerVideoPreview}
                                style={{
                                  marginTop: 10,
                                  borderRadius: "10px",
                                }}
                              />
                            )}
                          </>
                        )}
                      </div>
                    </div>

                    <div className="row ">
                      <div className="col-md-6 my-2 styleForTitle">
                        {/* <label className="float-left styleForTitle">
                                  Image
                                </label>
                                <input
                                  type="file"
                                  id="customFile"
                                  className="form-control"
                                  accept="image/png, image/jpeg ,image/jpg"
                                  Required=""
                                  onChange={trailerImageLoad}
                                /> */}

                        <label className="float-left styleForTitle">
                          Image
                        </label>

                        <input
                          type="file"
                          id="customFile"
                          name="trailerImageShowURL"
                          className="form-control"
                          accept="image/png, image/jpeg, image/jpg"
                          onChange={handleFileChange} // just stores file
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

                        {trailerImage.length === 0 && (
                          <div className="pl-1 text-left">
                            <Typography
                              variant="caption"
                              color="error"
                              style={{
                                fontFamily: "Circular-Loom",
                                color: "#ee2e47",
                              }}
                            >
                              {error.trailerImage}
                            </Typography>
                          </div>
                        )}

                        <>
                          {showURL?.trailerImageShowURL && (
                            <img
                              height="100px"
                              width="100px"
                              alt="app"
                              src={showURL?.trailerImageShowURL}
                              onError={(e) => {
                                e.target.onerror = null; // Prevents infinite loop
                                e.target.src = noImage; // Default image path
                              }}
                              style={{
                                boxShadow:
                                  "rgb(101 146 173 / 34%) 0px 0px 0px 1.2px",
                                borderRadius: 10,
                                marginTop: 10,
                                float: "left",
                              }}
                            />
                          )}

                          <div
                            className="img-container"
                            style={{
                              display: "inline",
                              position: "relative",
                              float: "left",
                            }}
                          ></div>
                        </>
                        {/* )} */}
                      </div>
                    </div>
                    <div className="row "></div>
                  </div>
                </form>
              </div>

              {/* <UploadProgress data={data} movieId={movieId} /> */}
              <UploadProgressManual data={data} />
            </div>
            <div className="iq-card-footer">
              <DialogActions>
                {dialogData ? (
                  <button
                    type="button"
                    className="btn btn-success btn-sm px-3 py-1 "
                    onClick={handleSubmit}
                  >
                    Update
                  </button>
                ) : (
                  <button
                    type="button"
                    className="btn btn-success btn-sm px-3 py-1 "
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

export default connect(null, {
  setUploadFileManual,
  getGenre,
  getRegion,
  getTeamMember,
  updateMovie,
  loadMovieData,
  createManual,
})(MovieDialog);
