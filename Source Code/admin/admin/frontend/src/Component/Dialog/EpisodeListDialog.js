import {
  Box,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  Input,
  Modal,
  Tooltip,
} from "@mui/material";
import { useDispatch, useSelector } from "react-redux";
import { useEffect, useState } from "react";
import {
  insertEpisode,
  updateEpisode,
  uploadMultipleImage,
} from "../../store/EpisodeList/EpisodeList.action";
import {
  CLOSE_INSERT_DIALOG,
  CLOSE_SHORT_DIALOG,
} from "../../store/EpisodeList/EpisodeList.type";
import Cancel from "@mui/icons-material/Cancel";
import { projectName } from "../../util/config";
import { Toast } from "../../util/Toast_";
import noImage from "../../Component/assets/images/noImage.png";
import { CLOSE_LOADER, OPEN_LOADER } from "../../store/Loader/loader.type";
import { IconX } from "@tabler/icons-react";

const style = {
  position: "absolute",
  top: "50%",
  left: "50%",
  transform: "translate(-50%, -50%)",
  width: 600,
  backgroundColor: "background.paper",
  borderRadius: "13px",
  border: "1px solid #C9C9C9",
  boxShadow: "24px",
  padding: "19px",
};

const EpisodeListDialogue = ({ page, size }) => {
  const [videoPath, setVideoPath] = useState(null);

  const [videoUrlType, setVideoUrlType] = useState("1"); // 1 = Link, 2 = File
  const [videoDuration, setVideoDuration] = useState(null);
  const [previewImageUrl, setPreviewImageUrl] = useState(null);
  const [previewVideoUrl, setPreviewVideoUrl] = useState(null);
  const [thumbnailBlob, setThumbnailBlob] = useState(null);

  const [fileData, setFileData] = useState(null);

  const [name, setName] = useState("");
  const [error, setError] = useState({
    name: "",
    video: "",
    // image: "",
  });

  const { dialog: open, dialogData } = useSelector(
    (state) => state.episodeList
  );
  const dispatch = useDispatch();

  const handleClose = () => {
    dispatch({ type: CLOSE_SHORT_DIALOG });
    setPreviewImageUrl(null);
    setPreviewVideoUrl(null);
    setVideoDuration(null);
    setVideoPath(null);
  };

  useEffect(() => {
    setPreviewVideoUrl(dialogData?.videoUrl);
    setPreviewImageUrl(dialogData?.videoImage);
    setVideoPath(dialogData?.videoPath);
    setVideoDuration(dialogData?.duration);
    setVideoUrlType(dialogData?.videoUrlType);
  }, [dialogData]);

  const handleSubmit = async () => {
    dispatch({ type: OPEN_LOADER });
    try {
      const uploadResult = await handleVideoUpload();

      const payload = {
        videoUrlType,
        videoUrl: videoUrlType === 1 ? videoPath : uploadResult?.videoUrl,
        videoImage:
          videoUrlType === 1 ? previewImageUrl : uploadResult?.videoImage,
        duration: videoDuration,
      };

      if (!dialogData?._id) {
        payload.movieSeriesId = dialogData;
      } else {
        payload.shortVideoId = dialogData._id;
      }

      if (dialogData?._id) {
        await dispatch(updateEpisode(payload, dialogData._id));
      } else {
        const response = await dispatch(insertEpisode(payload)).unwrap();

        if (response?.status) {
          Toast("success", "Short video added successfully.");
        }
      }
    } catch (error) {
      console.error("Error submitting episode:", error);
    } finally {
      // ✅ Always close dialog, clear fields, and reset errors
      dispatch({ type: CLOSE_LOADER });
      handleClose();
      setError({ ...error });
    }
  };

  const handleVideo = async (event) => {
    const file = event.target.files?.[0];
    if (!file) {
      setError((prev) => ({ ...prev, video: "Please select a video!" }));
      return;
    }
    setFileData(file);
    try {
      const videoURL = URL.createObjectURL(file);
      setPreviewVideoUrl(videoURL);

      const video = document.createElement("video");
      video.preload = "metadata";
      video.src = videoURL;

      video.onloadedmetadata = () => {
        setVideoDuration(video.duration);
        video.currentTime = 1;
      };

      video.onseeked = async () => {
        const canvas = document.createElement("canvas");
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        const ctx = canvas.getContext("2d");
        if (ctx) {
          ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
          canvas.toBlob((blob) => {
            if (blob) {
              setThumbnailBlob(blob);
              setPreviewImageUrl(URL.createObjectURL(blob));
              setError((prev) => ({ ...prev, video: "" }));
            }
          }, "image/jpeg");
        }
      };

      video.onerror = () => {
        setError((prev) => ({
          ...prev,
          video: "Error loading video. Please try a different format.",
        }));
        URL.revokeObjectURL(videoURL);
      };
    } catch (error) {
      console.error("Error processing video file:", error);
      setError((prev) => ({
        ...prev,
        video: "Error processing video file. Please try again.",
      }));
    }
  };

  const handleVideoLinkChange = (e) => {
    const link = e.target.value.trim();
    setVideoPath(link);
    setPreviewVideoUrl(link);
    fetchVideoDuration(link);
    setPreviewImageUrl(null);
    setError((prev) => ({ ...prev, video: "" }));

    if (!link) {
      setVideoDuration(null);
      return;
    }

    const video = document.createElement("video");
    video.src = link;
    video.preload = "metadata";
    video.crossOrigin = "anonymous"; // Allow crossorigin attempt

    video.onloadedmetadata = () => {
      setVideoDuration(video.duration);
      try {
        video.currentTime = 1;
      } catch (error) {
        console.error("Seeking error", error);
      }
    };

    video.onseeked = () => {
      try {
        const canvas = document.createElement("canvas");
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        const ctx = canvas.getContext("2d");

        if (ctx) {
          ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
          canvas.toBlob((blob) => {
            if (blob) {
              setThumbnailBlob(blob);
              setPreviewImageUrl(URL.createObjectURL(blob));
            } else {
              console.warn("Thumbnail not generated. Likely due to CORS.");
            }
          }, "image/jpeg");
        }
      } catch (err) {
        console.error("Thumbnail generation failed", err);
      }
    };

    video.onerror = () => {
      console.error("Failed to load video metadata or CORS error");
      setError((prev) => ({
        ...prev,
        video: "Invalid video link or unable to fetch video metadata.",
      }));
      setVideoDuration(null);
      setPreviewVideoUrl(null);
      setPreviewImageUrl(null);
    };
  };

  const fetchVideoDuration = (link) => {
    const video = document.createElement("video");

    video.src = link;
    video.preload = "metadata";
    video.crossOrigin = "anonymous";

    // When metadata is loaded
    video.onloadedmetadata = () => {
      window.URL.revokeObjectURL(video.src);
      const durationInSeconds = video.duration;

      setVideoDuration(durationInSeconds);
    };

    video.onerror = () => {
      console.error("Failed to load video metadata.");
      setError((prevError) => ({
        ...prevError,
        video: "Invalid video link or unable to fetch video metadata.",
      }));
      setVideoDuration(null);
    };
  };

  const handleVideoUpload = async () => {
    if (!fileData && dialogData?.videoUrl && dialogData?.videoImage) {
      return {
        videoUrl: dialogData.videoUrl,
        videoImage: dialogData.videoImage,
      };
    }

    if (!fileData) {
      setError((prev) => ({
        ...prev,
        video: "Please select a valid video file!",
      }));
      return null;
    }

    try {
      const formData = new FormData();
      formData.append("folderStructure", `${projectName}/shortVideo`);
      formData.append("content", fileData);

      let thumbnailBlob = null;
      try {
        thumbnailBlob = await generateThumbnailBlob(fileData);
      } catch (thumbnailError) {
        console.error("Thumbnail generation failed:", thumbnailError);
        setError((prev) => ({
          ...prev,
          video: "Failed to generate thumbnail.",
        }));
        return null;
      }

      if (thumbnailBlob) {
        const thumbnailFileName = `${fileData.name.replace(
          /\.[^/.]+$/,
          ""
        )}.jpeg`;
        const thumbnailFile = new File([thumbnailBlob], thumbnailFileName, {
          type: "image/jpeg",
        });
        formData.append("content", thumbnailFile);
      }

      // Upload files
      const response = await dispatch(uploadMultipleImage(formData));

      if (response?.data?.status) {
        return {
          videoUrl: response?.data?.data?.videoUrl,
          videoImage: response?.data?.data?.videoImage,
        };
      } else {
        throw new Error("Upload failed: Invalid response from server.");
      }
    } catch (error) {
      console?.log("File upload failed:", error?.message);
      setError((prev) => ({
        ...prev,
        video: "Failed to upload video. Please try again.",
      }));
      return null;
    }
  };

  const generateThumbnailBlob = async (file) => {
    return new Promise((resolve) => {
      const video = document.createElement("video");
      video.preload = "metadata";

      video.onloadedmetadata = () => {
        video.currentTime = 1; // Set to capture the frame at 1 second
      };

      video.onseeked = async () => {
        const canvas = document.createElement("canvas");
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        const ctx = canvas.getContext("2d");
        ctx?.drawImage(video, 0, 0, canvas.width, canvas.height);

        // Convert the canvas to blob
        canvas.toBlob((blob) => {
          resolve(blob);
        }, "image/jpeg");
      };

      const objectURL = URL.createObjectURL(file);
      video.src = objectURL;

      return () => {
        URL.revokeObjectURL(objectURL);
      };
    });
  };

  return (
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
          {dialogData?._id ? "Update Movie Episode" : "Add Movie Episode"}
        </h2>
        <button
          className="btn btn-sm custom-action-button"
          onClick={handleClose}
        >
          <IconX className="text-secondary" />
        </button>
      </div>

      <DialogContent>
        <div className="d-flex flex-column">
          <form>
              <div className="form-group">
                <label className="">
                  Select Upload Type:
                </label>
                <div>
                  <label className="">
                    <input
                      type="radio"
                      name="videoType"
                      value="1"
                      checked={videoUrlType === 1}
                      onChange={() => {
                        setVideoUrlType(1);
                        setPreviewImageUrl(null);
                        setPreviewVideoUrl(null);
                        setVideoDuration(null);
                        setVideoPath(null);
                      }}
                    />{" "}
                    Link
                  </label>

                  <label className="ml-3">
                    <input
                      type="radio"
                      name="videoType"
                      value="2"
                      checked={videoUrlType === 2}
                      onChange={() => {
                        setVideoUrlType(2);
                        setPreviewImageUrl(null);
                        setPreviewVideoUrl(null);
                        setVideoPath(null);
                        setVideoDuration(null);
                      }}
                    />{" "}
                    File
                  </label>
                </div>
              </div>

              <div className="form-group">
                <label className="float-left ">
                  {videoUrlType === 1 ? " Video Link" : "Upload Video File"}
                </label>

                {videoUrlType === 1 ? (
                  <input
                    type="text"
                    placeholder="Enter video link"
                    className="form-control"
                    value={videoPath}
                    onChange={handleVideoLinkChange}
                  />
                ) : (
                  <>
                  <input
                    type="file"
                    accept="video/*"
                    className="form-control p-0"
                    onChange={handleVideo}
                  />
                  <p className='extention-show'>Accept only .mp4, .mov, .mkv, .webm</p>
                  </>
                )}

                {/* Show video preview */}
                <div className="row">
                  {videoUrlType === 1 && videoPath && (
                    <>
                      <div className="col-6 mt-2">
                        <video
                          src={videoPath}
                          height="150px"
                          width="200px"
                          style={{ borderRadius: 10 }}
                          controls
                        />
                      </div>

                      <div className="col-6">
                        {previewImageUrl && (
                          <div className="mt-2">
                            <img
                              src={previewImageUrl}
                              onError={(e) => {
                                e.target.onerror = null; // Prevents infinite loop
                                e.target.src = noImage; // Default image path
                              }}
                              width={120}
                              height={150}
                              alt="Thumbnail"
                            />
                          </div>
                        )}
                      </div>
                    </>
                  )}

                  {videoUrlType === 2 && (
                    <>
                      <div className="col-6">
                        {previewVideoUrl && (
                          <video
                            src={previewVideoUrl}
                            height="150px"
                            width="200px"
                            style={{
                              borderRadius: 10,
                              marginTop: "10px",
                              float: "left",
                            }}
                            controls
                          />
                        )}
                      </div>

                      <div className="col-6">
                        {previewImageUrl && (
                          <div className="mt-2">
                            <img
                              src={previewImageUrl}
                              onError={(e) => {
                                e.target.onerror = null; // Prevents infinite loop
                                e.target.src = noImage; // Default image path
                              }}
                              width={120}
                              height={150}
                              alt="Thumbnail"
                            />
                          </div>
                        )}
                      </div>
                    </>
                  )}
                </div>

                {/* Error Message */}
                {error.video && (
                  <div className="pl-1 text-left">
                    <span className="text-danger">{error.video}</span>
                  </div>
                )}
              </div>

              <div className=" form-group">
                <label className="float-left ">
                  Video Duration (Second)
                </label>
                <input
                  type="text"
                  placeholder="Video Duration"
                  className="form-control form-control-line text-capitalize"
                  readOnly
                  value={videoDuration?.toFixed(2)}
                />
              </div>
            
          </form>
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
        {dialogData?._id ? (
          <button
            type="button"
            className="btn btn-success btn-sm px-3 py-1 mr-3 mb-3"
            onClick={handleSubmit}
          >
            Update
          </button>
        ) : (
          <button
            type="button"
            className="btn btn-success btn-sm px-3 py-1 mr-3 mb-3"
            onClick={handleSubmit}
          >
            Insert
          </button>
        )}
      </DialogActions>
    </Dialog>
  );
};

export default EpisodeListDialogue;
