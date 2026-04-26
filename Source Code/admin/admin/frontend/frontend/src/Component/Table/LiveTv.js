import React, { useEffect, useState } from "react";
//Pagination
import { connect, useDispatch, useSelector } from "react-redux";
import {
  deleteLiveChannel,
  getAdminCreateLiveTv,
} from "../../store/LiveTv/liveTv.action";
import logo from "../assets/images/logo.png";

//Alert
import Swal from "sweetalert2";


import $ from "jquery";
import { useHistory } from "react-router-dom";
import noImage from "../../Component/assets/images/noImage.png";
import { OPEN_LIVE_TV_DIALOGUE } from "../../store/LiveTv/liveTv.type";
import LiveTvEditDialogue from "../Dialog/LiveTvEditDialogue";

import { IconEdit, IconTrash } from "@tabler/icons-react";
import Skeleton from "react-loading-skeleton";
import "react-loading-skeleton/dist/skeleton.css";
import { getSetting, handleSwitch } from "../../store/Setting/setting.action";
import { warning } from "../../util/Alert";
import { CLOSE_GENRE_TOAST } from "../../store/Genre/genre.type";
import { Switch, Dialog, DialogContent, IconButton } from "@mui/material";
import { X } from "lucide-react";
import ReactPlayer from "react-player";

const LiveTv = (props) => {
  const { loader } = useSelector((state) => state.loader);
  const { adminCreateLiveTv } = useSelector((state) => state.liveTv);
  const { setting } = useSelector((state) => state.setting);
  const dispatch = useDispatch();

  const [data, setData] = useState([]);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [countries, setCountries] = useState("");
  const [isIptvAPI, setIsIptvAPI] = useState(false);
  const [isHovered, setIsHovered] = useState(null);

  // 🎬 state for player
  const [selectedChannel, setSelectedChannel] = useState(null);



  useEffect(() => {
    setIsIptvAPI(setting.isIptvAPI ? setting?.isIptvAPI : "");
    dispatch(getSetting());
    dispatch(getAdminCreateLiveTv());
  }, [dispatch]);

  useEffect(() => {
    setIsIptvAPI(setting.isIptvAPI ? setting.isIptvAPI : "");
  }, [setting]);

  useEffect(() => {
    setData(adminCreateLiveTv);
  }, [adminCreateLiveTv]);

  const insertManualLiveTv = (data) => {
    dispatch({ type: OPEN_LIVE_TV_DIALOGUE });
  };

  const history = useHistory();
  const insertOpen = () => {
    history.push("live_tv/createLiveTv");
  };

  const handleMouseOver = (videoId) => {
    setIsHovered(videoId);
  };

  const handleMouseOut = () => {
    setIsHovered(null);
  };

  const deleteOpen = (id) => {
    const data = warning();
    data
      .then((result) => {
        if (result.isConfirmed) {

          props.deleteLiveChannel(id);
          Swal.fire("Deleted!", "Your file has been deleted.", "success");
        }
      })
      .catch((err) => console.log(err));
  };

  // set default image
  $(document).ready(function () {
    $("img").bind("error", function () {
      $(this).attr("src", noImage);
    });
  });

  const handleSwitch_ = (type, value) => {

    props.handleSwitch(setting?._id ? setting?._id : "", type, value);
  };

  const handelEditManual = (data) => {
    dispatch({ type: OPEN_LIVE_TV_DIALOGUE, payload: data });
  };

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          <div className="align-items-center d-flex justify-content-end">
            <h4 className="card-title mr-3">Show In App</h4>
            <label class="switch mb-0">
              <Switch
                onChange={() => handleSwitch_("IptvAPI", isIptvAPI)}
                checked={isIptvAPI}
                color="primary"
                name="checkedB"
                inputProps={{
                  "aria-label": "primary checkbox",
                }}
              />
            </label>
          </div>
          <div className="iq-card mt-2">
            <div class="iq-card-header d-flex justify-content-between">
              <div className="iq-header-title w-50">
                <h4 class="card-title ml-0">Live TV</h4>
              </div>
              <div class="d-flex justify-content-end w-50">
                <button
                  type="button"
                  class="btn dark-icon btn-primary "
                  style={{ marginRight: "10px" }}
                  data-bs-toggle="modal"
                  id="create-btn"
                  data-bs-target="#showModal"
                  onClick={insertOpen}
                >
                  <i class="ri-add-line align-bottom me-1 fs-6"></i> Fetch
                </button>
                <button
                  type="button"
                  class="btn dark-icon btn-primary "
                  data-bs-toggle="modal"
                  id="create-btn"
                  data-bs-target="#showModal"
                  onClick={insertManualLiveTv}
                >
                  <i class="ri-add-line align-bottom me-1 fs-6"></i> Add
                </button>
              </div>
            </div>
          </div>
          <div class="row p-0 mb-5">
            {data?.length > 0 ? (
              <>
                {data?.map((data, index) => {
                  return (
                    <React.Fragment key={index}>
                      <div class="col-3 mt-4">
                        <div
                          class="iq-card shadow-none border-2 pointer-cursor"
                          onClick={() => setSelectedChannel(data)} // 👈 open player
                          style={{ cursor: "pointer" }}
                        >
                          <div
                            className="align-items-center border-bottom d-flex justify-content-center"
                            style={{
                              height: "250px",
                            }}
                          >
                            <img
                              src={data?.channelLogo || ""}
                              alt={data?.channelName}
                              onError={(e) => {
                                e.target.onerror = null;
                                e.target.src = logo;
                              }}
                              style={{
                                maxHeight: "250px",
                                maxWidth: "250px",
                                padding: "25px",
                              }}
                            />
                          </div>

                          <div
                            class="iq-card-body rowspan-2"
                            style={{ padding: "1px" }}
                          >
                            <div className="row ">
                              <div className="col">
                                <h5 className="m-2"> {data?.channelName}</h5>

                                {/* <p
                                  className=" m-2 mt-3"
                                  style={{ fontSize: "15px" }}
                                >
                                  {data?.streamURL?.length > 30
                                    ? data?.streamURL.slice(0, 30) + "...."
                                    : data?.streamURL}
                                </p> */}
                                <p className="m-2 mt-2 "> <span className="fw-bold">Region:</span>{" "}
                                  {data?.country
                                    ? data.country.charAt(0).toUpperCase() +
                                    data.country.slice(1)
                                    : ""}
                                </p>
                              </div>
                            </div>
                          </div>
                          <div className="iq-card-footer">
                            <div className=" d-flex justify-content-end">
                              <button
                                type="button"
                                class="btn custom-action-button mr-2"
                                onClick={(e) => {
                                  e.stopPropagation();
                                  handelEditManual(data);
                                }}
                              >
                                <IconEdit className="text-secondary" />
                              </button>
                              <button
                                type="button"
                                class="btn custom-action-button "
                                onClick={(e) => {
                                  e.stopPropagation();
                                  deleteOpen(data?._id);
                                }}
                              >
                                <IconTrash className="text-danger" />
                              </button>
                            </div>
                          </div>
                        </div>
                      </div>
                    </React.Fragment>
                  );
                })}
              </>
            ) : (

              // [...Array(9)].map((x, i) => {
              //   return (
              //     <React.Fragment key={i}>
              //       <div class="col-3">
              //         <div class="iq-card shadow-none border-2 pointer-cursor">
              //           <div
              //             style={{
              //               boxShadow: "0 5px 15px 0 rgb(105 103 103 / 0%)",
              //               overflow: "hidden",
              //               display: "block",
              //               width: "calc(100% - 0px)",
              //             }}
              //           >
              //             <Skeleton
              //               width="calc(100% - 0px)"
              //               height="292px"
              //               highlightColor="#f5f5f5"
              //               baseColor="#dfdfdf"
              //               className="rounded-0"
              //               style={{ lineHeight: "normal" }}
              //             />
              //           </div>
              //           <div
              //             class="iq-card-body rowspan-2"
              //             style={{ padding: "1px" }}
              //           >
              //             <div className="row ">
              //               <div className="col">
              //                 <Skeleton
              //                   className="m-2 mt-3"
              //                   height={20}
              //                   width={120}
              //                   highlightColor="#f5f5f5"
              //                   baseColor="#dfdfdf"
              //                 />
              //                 <Skeleton
              //                   className="m-2"
              //                   style={{ fontSize: "17px" }}
              //                   highlightColor="#f5f5f5"
              //                   baseColor="#dfdfdf"
              //                   height={15}
              //                   width={250}
              //                 />
              //                 <Skeleton
              //                   className="m-2 mt-2"
              //                   highlightColor="#f5f5f5"
              //                   baseColor="#dfdfdf"
              //                   height={15}
              //                   width={50}
              //                   style={{ fontSize: "15px", color: "#fff" }}
              //                 />
              //               </div>
              //             </div>
              //             <hr
              //               className="mb-0"
              //               style={{
              //                 borderTop: "1px solid #ae9fbe63",
              //               }}
              //             />
              //             <div className="row d-flex justify-content-end p-3">
              //               <Skeleton
              //                 highlightColor="#f5f5f5"
              //                 baseColor="#dfdfdf"
              //                 className="  mr-2"
              //                 width={40}
              //                 height={40}
              //               />
              //               <Skeleton
              //                 highlightColor="#f5f5f5"
              //                 baseColor="#dfdfdf"
              //                 className=" badge badge-lg  m-1 d-inline-block"
              //                 width={40}
              //                 height={40}
              //               />
              //             </div>
              //           </div>
              //         </div>
              //       </div>
              //     </React.Fragment>
              //   );
              // })
              <h6 className='col-12 text-center py-2'>No Data Found.</h6>
            )}
          </div>
        </div>
      </div>

      {/* 🎬 Player Dialog */}
      <Dialog
        open={!!selectedChannel}
        onClose={() => setSelectedChannel(null)}
        maxWidth="sm"
        fullWidth
      >
        <DialogContent className="relative bg-black p-0">
          <div className="d-flex justify-content-between">
            {/* Channel name on top-left */}
            {selectedChannel?.channelName && (
              <div className="absolute top-2 left-2 z-10 text-black py-1 rounded-lg text-md font-extrabold">
                {selectedChannel.channelName}
              </div>
            )}

            {/* Close button on top-right */}
            <IconButton
              onClick={() => setSelectedChannel(null)}
              className="absolute top-2 right-2 z-10 text-black mb-2"
            >
              <X color='black' />
            </IconButton>
          </div>


          {/* Player */}
          {selectedChannel && (
            <ReactPlayer
              url={selectedChannel?.streamURL1 || selectedChannel?.streamURL}
              playing={true}
              controls={true}
              width="100%"
            />
          )}

        </DialogContent>
      </Dialog>

      <LiveTvEditDialogue />
    </>
  );
};

export default connect(null, {
  getAdminCreateLiveTv,
  deleteLiveChannel,
  handleSwitch,
  getSetting,
})(LiveTv);
