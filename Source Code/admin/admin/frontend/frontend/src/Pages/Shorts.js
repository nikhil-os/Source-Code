import { connect, useDispatch, useSelector } from "react-redux";
import Pagination from "../Pages/Pagination";
import React, { useEffect, useState } from "react";
import {
  deleteEpisode,
  getShortVideo,
} from "../store/EpisodeList/EpisodeList.action";
import { useLocation } from "react-router-dom";
import noImage from "../../src/Component/assets/images/noImage.png";
import { warning } from "../util/Alert";
import { Toast } from "../util/Toast_";
import {
  OPEN_INSERT_DIALOG,
  OPEN_SHORT_DIALOG,
} from "../store/EpisodeList/EpisodeList.type";
import EpisodeListDialogue from "../Component/Dialog/EpisodeListDialog";
import { getShorts } from "../store/EpisodeList/EpisodeList.action";
import { IconEdit, IconEye, IconTrash, IconX } from "@tabler/icons-react";
import { Dialog, DialogActions, DialogContent } from "@mui/material";
import LazyImage from "../Component/common/ImageFallback";

const Shorts = () => {
  const { loader } = useSelector((state) => state.loader);


  const [open, setOpen] = useState(false);
  const [videoUrl, setVideoUrl] = useState("");

  const handleClose = () => {
    setOpen(false);
    setVideoUrl("");
  };
  const handleOpen = (url) => {
    setOpen(true);
    setVideoUrl(url);
  };

  const [activePage, setActivePage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const { episode, total } = useSelector((state) => state.episodeList);

  const location = useLocation();

  const { movieDetails, comment } = useSelector((state) => state.movie);

  const dispatch = useDispatch();

  useEffect(() => {
    const payload = {
      start: activePage,
      limit: rowsPerPage,
    };
    dispatch(getShortVideo(payload));
  }, []);

  const handlePageChange = (pageNumber) => {
    setActivePage(pageNumber);
  };

  const handleRowsPerPage = (value) => {
    setActivePage(1);
    setRowsPerPage(value);
  };

  const deleteOpen = (movieId) => {
    const data = warning();
    data
      .then((result) => {
        if (result.isConfirmed) {
          // 
          dispatch(deleteEpisode(movieId));
          Toast("success", "Short Video deleted successfully.");
        }
      })
      .catch((err) => console.log(err));
  };

  const updateOpen = (data) => {
    dispatch({ type: OPEN_SHORT_DIALOG, payload: data });
  };

  return (
    <>
      <EpisodeListDialogue />
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          <div className="iq-card mb-5 mt-2">
            <div className="iq-card-header">
              <div class="iq-header-title w-100">
                <h4 class="card-title">Shorts</h4>
              </div>
            </div>
            <div className="iq-card-body">
              <div className="table-responsive custom-table">
                <table
                  id="user-list-table"
                  className="table table-striped table-borderless mb-0"
                  role="grid"
                  aria-describedby="user-list-page-info"
                >
                  <thead class="text-nowrap">
                    <tr>
                      <th className="tableAlign">ID</th>
                      {/* <th className="tableAlign">Video</th> */}
                      <th className="tableAlign">Image</th>
                      <th className="tableAlign">Movie Name</th>
                      <th className="tableAlign">Description</th>
                      <th className="tableAlign">Share Count</th>
                      <th className="tableAlign">Total Likes</th>
                      <th className="tableAlign">Duration (Second)</th>

                      {/* <th className="tableAlign">Edit</th>
                    <th className="tableAlign">Delete</th> */}
                      <th className="tableAlign">Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {episode?.length > 0
                      ? episode.map((data, index) => {
                        return (
                          <React.Fragment key={index}>
                            <tr>
                              <td className="pr-3 tableAlign">
                                {(activePage - 1) * rowsPerPage + index + 1}
                              </td>
                              {/* <td className="text-center">
                                  <video
                                    controls
                                    src={data?.videoUrl}
                                    height={100}
                                    width={100}
                                  />
                                </td> */}

                              <td className="pr-3 text-center">
                                {/* <img
                                    className="img-fluid"
                                    style={{
                                      height: "100px",
                                      width: "80px",
                                      boxShadow:
                                        "0 5px 15px 0 rgb(105 103 103 / 0%)",
                                      border:
                                        "0.5px solid rgba(255, 255, 255, 0.20)",
                                      borderRadius: 10,
                                      objectFit: "cover",
                                    }}
                                    src={
                                      data?.videoImage
                                        ? data?.videoImage
                                        : noImage
                                    }
                                    onError={(e) => {
                                      e.target.onerror = null; // Prevents infinite loop
                                      e.target.src = noImage; // Default image path
                                    }}
                                    alt=""
                                  /> */}
                                <LazyImage imageSrc={data?.videoImage} noImage={noImage} />
                              </td>

                              <td className="text-start text-capitalize text-center">
                                {data?.movieSeriesTitle ||
                                  data?.movieSeries?.title}
                              </td>

                              <DescriptionCell
                                text={
                                  data?.movieSeriesDes ||
                                  data?.movieSeries?.description
                                }
                              />


                              <td className="text-start text-capitalize text-center">
                                {data?.shareCount || 0}
                              </td>
                              <td className="description-text text-center">
                                {data?.totalLikes || 0}
                              </td>
                              <td className="description-text text-center">
                                {data?.duration || 0}
                              </td>
                              <td className="pr-3 tableAlign">
                                <div className="d-flex justify-content-center">
                                  <button
                                    type="button"
                                    className="btn custom-action-button mr-2"
                                    onClick={() => handleOpen(data?.videoUrl)}
                                  >
                                    <IconEye className="text-secondary" />
                                  </button>
                                  <button
                                    type="button"
                                    className="btn custom-action-button mr-2"
                                    onClick={() => updateOpen(data)}
                                  >
                                    <IconEdit className="text-secondary" />
                                  </button>
                                  <button
                                    type="button"
                                    className="btn custom-action-button mr-2"
                                    onClick={() => deleteOpen(data._id)}
                                  >
                                    <IconTrash className="text-secondary" />
                                  </button>
                                </div>
                              </td>
                              {/* <td className="pr-3 tableAlign">
                              <button
                                type="button"
                                className="btn iq-bg-primary btn-sm"
                                onClick={() => deleteOpen(data._id)}
                              >
                                <i
                                  class="ri-delete-bin-6-line"
                                  style={{ fontSize: '19px' }}
                                ></i>
                              </button>
                            </td> */}
                            </tr>
                          </React.Fragment>
                        );
                      })
                      : <tr>
                        <td colSpan="8" className="text-center py-2">
                          <h6>No Data Found</h6>
                        </td>
                      </tr>}
                  </tbody>
                </table>
              </div>
            </div>
            <div className="iq-card-footer">
              {episode?.length > 0 && (
                <Pagination
                  activePage={activePage}
                  rowsPerPage={rowsPerPage}
                  userTotal={total}
                  handleRowsPerPage={handleRowsPerPage}
                  handlePageChange={handlePageChange}
                />
              )}
            </div>
          </div>
        </div>
      </div>

      {/* ------------ Video Dialog ------------------ */}
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
          <h2 class="modal-title m-0">Shorts Video</h2>
          <button
            className="btn btn-sm custom-action-button"
            onClick={handleClose}
          >
            <IconX className="text-secondary" />
          </button>
        </div>

        <DialogContent>
          <div>
            <video controls src={videoUrl} style={{ height: 500, width: "100%" }} />
          </div>
        </DialogContent>
        <DialogActions className="modal-footer">
          <button
            type="button"
            className="btn dark-icon btn-primary float-right m-0"
            onClick={handleClose}
          >
            Close
          </button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default connect(null, {})(Shorts);

const DescriptionCell = ({ text }) => {
  const [expanded, setExpanded] = useState(false);
  const maxLength = 30; // characters before truncation

  const toggleExpanded = () => setExpanded(!expanded);

  if (!text) return <td className="text-center">-</td>;

  const shouldTruncate = text.length > maxLength;
  const displayText =
    expanded || !shouldTruncate ? text : `${text.slice(0, maxLength)}...`;

  return (
    <td
      className="text-start text-capitalize text-center"
      style={{ p: "mb-0" }}
    >
      {/* {displayText} */}
      <span
        dangerouslySetInnerHTML={{ __html: displayText }}
        className="mb-0"
      />
      {shouldTruncate && (
        <span
          onClick={toggleExpanded}
          style={{ color: "#007BFF", cursor: "pointer", marginLeft: "6px" }}
        >
          {expanded ? "Read less" : "Read more"}
        </span>
      )}
    </td>
  );
};
