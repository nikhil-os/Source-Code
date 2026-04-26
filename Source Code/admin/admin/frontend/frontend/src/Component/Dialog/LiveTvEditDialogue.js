import {
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  Tooltip,
  Typography,
} from "@material-ui/core";
import React from "react";
import { useEffect } from "react";
import { useState } from "react";
import { connect, useDispatch, useSelector } from "react-redux";
import { CLOSE_LIVE_TV_DIALOGUE } from "../../store/LiveTv/liveTv.type";
import {
  getCountry,
  createManualLiveChannel,
  updateLiveTvChannel,
} from "../../store/LiveTv/liveTv.action";
//Alert


import Select from "react-select";
import { uploadFile } from "../../util/AwsFunction";
import { folderStructurePath } from "../../util/config";
import Cancel from "@mui/icons-material/Cancel";
import noImage from "../../Component/assets/images/noImage.png";
import { CLOSE_LOADER, OPEN_LOADER } from "../../store/Loader/loader.type";
import { IconX } from "@tabler/icons-react";

const LiveTvEditDialogue = (props) => {

  const {
    dialogue: open,
    dialogueData,
    country,
  } = useSelector((state) => state.liveTv);
  const dispatch = useDispatch();

  const [country_, setCountry] = useState({
    value: "",
    label: "",
  });
  const [channelName, setChannelName] = useState("");
  const [image, setImage] = useState("");
  const [imagePath, setImagePath] = useState("");
  const [streamURL, setStreamURL] = useState("");
  const [error, setError] = useState("");
  const [resURL, setResURL] = useState("");
  const [selectedOption, setSelectedOption] = useState(null);
  const [selectedFile, setSelectedFile] = useState("");

  useEffect(
    () => () => {
      setCountry("");
      setChannelName("");
      setImagePath("");
      setStreamURL("");
      setError({ channelName: "", image: "", country: "", setStreamURL: "" });
    },
    [open]
  );
  useEffect(() => {
    dispatch(getCountry());
  }, [dispatch]);

  useEffect(() => {
    if (dialogueData?.channelId == null) {
      setImagePath(dialogueData?.channelLogo);
      setStreamURL(dialogueData?.streamURL);
      setCountry(dialogueData?.country);
      setChannelName(dialogueData?.channelName);
      setCountry({
        value: dialogueData?.country,
        label: dialogueData?.country,
      });
    } else {
      setStreamURL(dialogueData?.streamURL);
      setCountry(dialogueData?.country);
      setChannelName(dialogueData?.channelName);
      setImagePath(dialogueData?.channelLogo);
      setCountry({
        value: dialogueData?.country,
        label: dialogueData?.country,
      });
    }
  }, [dialogueData]);

  const options = country?.map((countryData) => {
    return {
      value: countryData.countryName,
      label: countryData.countryName,
    };
  });

  const colourStyles = {
    option: (styles, { data, isDisabled, isFocused, isSelected }) => {
      return {
        ...styles,
        backgroundColor: isSelected ? "#0000001a" : "#fff",
        ":active": {
          ...styles[":active"],
          backgroundColor: !isDisabled
            ? isSelected
              ? "#0000001a"
              : "#fff"
            : undefined,
          height: "3px", // Set the height for active option
        },
        placeholder: (styles) => ({
          ...styles,
          color: "#111",
        }),
      };
    },
  };

  const handleClose = () => {
    dispatch({ type: CLOSE_LIVE_TV_DIALOGUE });
  };

  //  Image Load fffff

  let folderStructureMovieImage = folderStructurePath + "liveTvImage";

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSelectedFile(file);
      setImagePath(URL.createObjectURL(file));
    }
  };
  const imageLoad = async (event) => {
    setImage(selectedFile);
    const { resDataUrl, imageURL } = await uploadFile(
      selectedFile,
      folderStructureMovieImage
    );

    setResURL(resDataUrl);
    setImagePath(imageURL);
  };

  // const handleSubmit = async () => {
  //   if (selectedOption?.value) {
  //     setCountry(selectedOption?.value);
  //   }
  //   
  //   if (!channelName || !streamURL || !imagePath) {
  //     let error = {};
  //     if (country_ === 'SelectCountry' || !country_)
  //       error.country_ = 'Country Is Required !';
  //     if (!streamURL) error.streamURL = 'Stream URL Is Required !';
  //     if (!channelName) error.channelName = 'Channel Name Is Required !';
  //     if (!imagePath) error.image = 'Image is Required !';
  //     return setError({ ...error });

  //   } else {
  //     const countries = country_?.value;
  //     const objData = {
  //       channelLogo: resURL,
  //       country: countries,
  //       channelName,
  //       streamURL,
  //     };

  //     if (dialogueData) {
  //       if (resURL) {
  //         const objData = {
  //           channelLogo: resURL,
  //           country: countries,
  //           channelName,
  //           streamURL,
  //         };
  //         props.updateLiveTvChannel(dialogueData?._id, objData);
  //       } else {
  //         const objData = {
  //           country: countries,
  //           channelName,
  //           streamURL,
  //         };
  //         props.updateLiveTvChannel(dialogueData?._id, objData);
  //       }
  //     } else {
  //       const objData = {
  //         channelLogo: resURL,
  //         country: countries,
  //         channelName,
  //         streamURL,
  //       };
  //       props.createManualLiveChannel(objData);
  //     }
  //     handleClose();
  //   }
  // };

  const handleSubmit = async () => {
    dispatch({ type: OPEN_LOADER });
    if (selectedOption?.value) {
      setCountry(selectedOption?.value);
    }

    if (!channelName || !streamURL || !selectedFile) {
      let error = {};
      if (country_ === "SelectCountry" || !country_)
        error.country_ = "Country Is Required !";
      if (!streamURL) error.streamURL = "Stream URL Is Required !";
      if (!channelName) error.channelName = "Channel Name Is Required !";
      if (!selectedFile) error.image = "Image is Required !";
      dispatch({ type: CLOSE_LOADER }); // ❌ Close loader on validation fail
      return setError({ ...error });
    }

    try {
      // ✅ STEP 1: Upload image
      const { resDataUrl, imageURL } = await uploadFile(
        selectedFile,
        folderStructureMovieImage
      );

      // ✅ Update image state
      setImage(selectedFile);
      setImagePath(imageURL);
      setResURL(resDataUrl);

      // ✅ STEP 2: Continue with form submission
      const countries = country_?.value;
      const objData = {
        channelLogo: resDataUrl, // ✅ uploaded image URL
        country: countries,
        channelName,
        streamURL,
      };

      if (dialogueData) {
        await props.updateLiveTvChannel(dialogueData?._id, objData);
      } else {
        await props.createManualLiveChannel(objData);
      }

      handleClose();
    } catch (error) {
      console.error("Submission failed:", error);
      // Optional: set a global error state here
    } finally {
      dispatch({ type: CLOSE_LOADER }); // ✅ Always close loader
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
            {dialogueData ? "Update LiveTv" : "Create LiveTv"}
          </h2>
          <button
            className="btn btn-sm custom-action-button"
            onClick={handleClose}
          >
            <IconX className="text-secondary" />
          </button>
        </div>
        {/* </IconButton> */}
        <DialogContent style={{ padding: 0 }}>
          <div className="modal-body">
            <div className="d-flex flex-column">
              <form>
                <div className="">
                  <div className="row">
                    <div className="col-md-12 my-2">
                      <label className="float-left styleForTitle">
                        Channel Name
                      </label>
                      <input
                        type="text"
                        placeholder="Name"
                        // className="form-control form-control-line"
                        className="form-control"
                        required
                        value={channelName}
                        onChange={(e) => {
                          setChannelName(e.target.value);

                          if (!e.target.value) {
                            return setError({
                              ...error,
                              channelName: "Name is Required!",
                            });
                          } else {
                            return setError({
                              ...error,
                              channelName: "",
                            });
                          }
                        }}
                      />
                      {error.channelName && (
                        <div className="pl-1 text-left">
                          {error.channelName && (
                            <span className="error">{error.channelName}</span>
                          )}
                        </div>
                      )}
                    </div>
                  </div>
                  <div className="row">
                    <div className="col-md-12 my-2">
                      <label className="float-left styleForTitle">
                        Stream URl
                      </label>
                      <input
                        type="text"
                        placeholder="streamUrl"
                        // className="form-control form-control-line"
                        className="form-control"
                        required
                        value={streamURL}
                        onChange={(e) => {
                          setStreamURL(e.target.value);

                          if (!e.target.value) {
                            return setError({
                              ...error,
                              streamURL: "stream URL is Required!",
                            });
                          } else {
                            return setError({
                              ...error,
                              streamURL: "",
                            });
                          }
                        }}
                      />
                      {error.streamURL && (
                        <div className="pl-1 text-left">
                          {error.streamURL && (
                            <span className="error">{error.streamURL}</span>
                          )}
                        </div>
                      )}
                    </div>
                  </div>
                  <div className="row">
                    <div className="col-md-12 my-2">
                      <label className="float-left styleForTitle">
                        Country
                      </label>

                    </div>
                    <div className="col-md-12 mb-3">

                      <Select
                        className=""
                        value={country_}
                        placeholder="Select Country"
                        defaultValue={country}
                        onChange={setCountry}
                        options={options}
                        styles={colourStyles}
                      />
                      {error.country_ && (
                        <div className="pl-1 text-left">
                          {error.country_ && (
                            <span className="error">{error.country_}</span>
                          )}
                        </div>
                      )}
                    </div>
                  </div>

                  <div className="row">
                    <label className="float-left styleForTitle mb-0 ml-3">
                      Image
                    </label>
                    <div className="col-md-12 my-2">
                      <input
                        type="file"
                        id="customFile"
                        className="form-control"
                        accept="image/png, image/jpeg ,image/jpg"
                        required=""
                        onChange={handleFileChange}
                      />
                      <p className='extention-show'>Accept only .png, .jpeg and .jpg</p>

                      {/* <div className="d-flex justify-content-end">
                        <button
                          type="button"
                          className="btn btn-success btn-sm px-3 py-1 mt-4 "
                          onClick={imageLoad} // actual upload logic
                        >
                          Upload
                        </button>
                      </div> */}

                      {/* {imagePath && ( */}
                      {imagePath && (
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
                            // boxShadow: "0 0 0 1.2px #7f65ad80",
                            borderRadius: 10,
                            marginTop: "10px",
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
                      <div className="pl-1 text-left">
                        {error.image && (
                          <span className="error">{error.image}</span>
                        )}
                      </div>
                    </div>
                  </div>
                </div>
              </form>
            </div>
          </div>
        </DialogContent>

        <DialogActions className="modal-footer">
          <button
            type="button"
            className="btn btn-danger btn-sm px-3 py-1 "
            onClick={handleClose}
          >
            Cancel
          </button>
          {dialogueData ? (
            <button
              type="button"
              className="btn btn-success btn-sm px-3 py-1 mr-3 "
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
              Submit
            </button>
          )}
        </DialogActions>
      </Dialog>
    </>
  );
};

export default connect(null, {
  getCountry,
  updateLiveTvChannel,
  createManualLiveChannel,
})(LiveTvEditDialogue);
