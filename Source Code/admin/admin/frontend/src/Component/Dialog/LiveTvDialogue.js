import {
  Dialog,
  DialogActions,
  DialogContent,
  TablePagination,
} from "@mui/material";
import React from "react";
import { useEffect } from "react";
import { useState } from "react";
import { connect, useDispatch, useSelector } from "react-redux";
import { useHistory } from "react-router-dom";
import TablePaginationActions from "../../Pages/Pagination";
import $ from "jquery";
import image from "../../Component/assets/images/login.jpg";
import noImage from "../../Component/assets/images/noImage.png";
import {
  getCountry,
  getLiveTvData,
  createLiveChannel,
  getFlag,
} from "../../store/LiveTv/liveTv.action";

import Select from "react-select";
import Pagination from "../../Pages/Pagination";
import { IconEdit, IconPlus, IconX } from "@tabler/icons-react";
import { baseURL, folderStructurePath, secretKey } from "../../util/config";
const LiveTvDialogue = (props) => {
  const { loader } = useSelector((state) => state.loader);
  const dispatch = useDispatch();
  const { liveTv, country, flag } = useSelector((state) => state.liveTv);

  const [data, setData] = useState([]);
  const [country_, setCountry] = useState({
    value: "india",
    label: "india",
  });
  const [page, setPage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [countries, setCountries] = useState([]);
  const [open, setOpen] = useState(false);
  const [selectedData, setSelectedData] = useState();
  const [image, setImage] = useState();
  const [errors, setErrors] = useState();

  useEffect(() => {
    dispatch(getFlag());
    dispatch(getCountry());
    dispatch(getLiveTvData("india"));
  }, [dispatch]);

  useEffect(() => {
    dispatch(getLiveTvData(country_.value));
  }, [dispatch, country_]);

  useEffect(() => {
    setData(liveTv);
  }, [liveTv]);

  const options = country?.map((countryData) => {
    return {
      value: countryData.countryName,
      label: countryData.countryName,
    };
  });

  //pagination
  const handleChangePage = (event, newPage) => {
    setPage(event);
  };
  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event, 10));
    setPage(1);
  };

  const handleOpen = (data) => {
    setOpen(true);
    setSelectedData(data);
  };

  const handleClose = () => {
    setOpen(false);
    setSelectedData();
    setErrors("");
    setImage();
  };

  const handelCreateChannel = async () => {
    if (!image) return setErrors("Image is required");

    var channelLogo = "";

    let folderStructureContentImage = folderStructurePath + "channlelogo";
    const formData = new FormData();
    formData.append("folderStructure", folderStructureContentImage);
    formData.append("keyName", image.name);
    formData.append("content", image);
    const response = await fetch(baseURL + `file/upload-file`, {
      method: "POST",
      headers: {
        key: secretKey,
      },
      body: formData,
    });

    const responseData = await response.json();
    if (responseData?.url) {
      channelLogo = responseData?.url;
    }
    const countriesData = country_.value;
    var channelData = {
      channelId: selectedData.channelId,
      channelName: selectedData.channelName,
      streamURL: selectedData.streamURL,
      channelLogo: channelLogo,
      country: countriesData,
    };

    console.log("channelData-->", channelData);
    // return;
    props.createLiveChannel(channelData);
    history.push("/admin/live_tv");
  };

  const handelCreateChannelWithLogo = (data) => {
    const countriesData = country_.value;
    var channelData = {
      channelId: data.channelId,
      channelName: data.channelName,
      streamURL: data.streamURL,
      channelLogo: data.channelLogo,
      country: countriesData,
    };
    props.createLiveChannel(channelData);
    history.push("/admin/live_tv");
  };

  const handleSearch = (e) => {
    const value = e.target.value.trim().toUpperCase();
    if (value) {
      const data = liveTv.filter((data) => {
        return (
          data?.channelName?.toUpperCase()?.indexOf(value) > -1 ||
          data?.streamURL?.toUpperCase()?.indexOf(value) > -1 ||
          data?.country?.toUpperCase()?.indexOf(value) > -1
        );
      });
      setData(data);
    } else {
      setData(liveTv);
    }
  };

  // set default image
  $(document).ready(function () {
    $("img").bind("error", function () {
      // Set the default image
      $(this).attr("src", noImage);
    });
  });

  const history = useHistory();
  const handlePrevious = () => {
    history.goBack();
  };

  const handleInputImage = (e) => {
    const file = e.target.files[0];
    setImage(file);
  };

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          {/* <div class="iq-header-title row col-12 mb-3 pr-0">
            <div className="col-6 ">
              <div class="iq-header-title mt-4">
                <h4 class="card-title mb-0">Add Live TV </h4>
              </div>
            </div>
            <div className="col-6  d-flex justify-content-end px-0">
              <button
                type="button"
                className="btn iq-bg-primary btn-sm "
                onClick={() => handlePrevious()}
              >
              
                <i
                  class="fa-solid fa-angles-left  p-2"
                  style={{ fontSize: "19px", color: "#fdfdfd" }}
                />
              </button>
            </div>
          </div> */}
          <div className="iq-card mb-5 mt-2">
            <div className="iq-card-header d-flex justify-content-between">
              <div class="iq-header-title w-50">
                <div class="iq-header-title">
                  <h4 class="card-title mb-0">Add Live TV </h4>
                </div>
                {/* <div className="col-6  d-flex justify-content-end px-0">
                  <button
                    type="button"
                    className="btn iq-bg-primary btn-sm "
                    onClick={() => handlePrevious()}
                  >
                   
                    <i
                      class="fa-solid fa-angles-left  p-2"
                      style={{ fontSize: "19px", color: "#fdfdfd" }}
                    />
                  </button>
                </div> */}
              </div>
              <div className="row w-50">
                <div className="col-12 col-lg-6 p-0  d-flex justify-content-end">
                  <form class=" mr-3">
                    <div class="form-group mb-0">
                      <p className='' style={{margin : 0 , color : "#000" , fontWeight : 500 , fontSize : "small"}}>Search Here</p>
                      <input
                        id="input-search"
                        type="search"
                        class="form-control"
                        placeholder="Search"
                        aria-controls="user-list-table"
                        onChange={handleSearch}
                      />
                    </div>
                  </form>
                </div>
                <div className="col-12 col-lg-6 p-0 form-group">
                
                    <p className='' style={{margin : 0 , color : "#000" , fontWeight : 500 , fontSize : "small"}}>Select Country</p>
                  <Select
                    defaultValue={country_}
                    onChange={setCountry}
                    options={options}
                    // styles={colourStyles}
                    placeholder={`Select Country`}
                    className="text-black"
                  />
                </div>
              </div>
            </div>
            <div className="iq-card-body">
              <div className="table-responsive custom-table">
                {/* <div className="row justify-content-end">
                  <div className="col-sm-12 col-md-6">
                    <div
                      id="user_list_datatable_info"
                      className="dataTables_filter"
                    >
                      <form className="mr-3 position-relative">
                        <div className="form-group mb-0">
                              <input
                                type="search"
                                className="form-control"
                                id="exampleInputSearch"
                                placeholder="Search"
                                aria-controls="user-list-table"
                                onChange={handleSearch}
                              />
                            </div>
                      </form>
                    </div>
                  </div>
                </div> */}
                <table
                  id="user-list-table"
                  className="table table-striped table-borderless mb-0"
                  role="grid"
                  aria-describedby="user-list-page-info"
                >
                  <thead>
                    <tr className="text-center">
                      <th>ID</th>
                      {/* <th>Image</th> */}
                      <th>Title</th>
                      <th>Stream </th>
                      <th>Create Channel</th>
                    </tr>
                  </thead>
                  <tbody>
                    {data
                      ?.slice(
                        (page - 1) * rowsPerPage,
                        (page - 1) * rowsPerPage + rowsPerPage
                      )
                      .map((data, index) => {
                        return (
                          <>
                            <tr>
                              <td className="pr-3 tableAlign">
                                {(page - 1) * rowsPerPage + index + 1}
                              </td>
                              {/* <td className="pr-3">
                                <img
                                  className="img-fluid mx-auto"
                                  style={{
                                    boxShadow:
                                      " rgba(105, 103, 103, 0) 0px 5px 15px 0px",
                                    border:
                                      "0.5px solid rgba(255, 255, 255, 0.2)",
                                    borderRadius: 10,
                                    objectFit: "cover",
                                    display: "block",
                                    width: "100px",
                                    height: "100px",
                                  }}
                                  draggable="false"
                                  src={data?.channelLogo || ""}
                                  onError={(e) => {
                                    e.target.onerror = null; // Prevents infinite loop
                                    e.target.src = noImage; // Default image path
                                  }}
                                  alt="profile"
                                />
                              </td> */}
                              {/* <td class="align-middle">
                            {" "}
                            <img
                              // className="shadow p-1 mb-2 bg-white rounded "
                              src={data?.image}
                              style={{
                                borderRadius: 8,
                                objectFit: "cover",
                              }}
                              height="65px"
                              width="65px"
                              alt=""
                            />
                          </td> */}
                              <td className="pr-3 tableAlign">
                                {data?.channelName}
                                {/* {data?.title?.length > 10
                                      ? data?.title.slice(0, 10) + "...."
                                      : data?.title} */}
                              </td>
                              {/* {parse(
                                      `${
                                        data?.description?.length > 250
                                          ? data?.description.substr(0, 250) +
                                            "..."
                                          : data?.description
                                      }`
                                    )} */}
                              <td className="pr-3 tableAlign">
                                {/* <video
                                        // className="shadow bg-white rounded mt-2"
                                        src={data?.streamURL}
                                        height="120px"
                                        width="120px"
                                        type="video/mp4"
                                        controls
                                        style={{
                                          boxShadow:
                                            "0 5px 15px 0 rgb(105 103 103 / 0%)",
                                          border:
                                            "2px solid rgba(41, 42, 72, 1)",
                                          borderRadius: 10,
                                          display: "block",
                                          objectFit: "cover",
                                        }}
                                        className="mx-auto"
                                      /> */}
                                {data?.streamURL?.length > 25
                                  ? data?.streamURL.slice(0, 25) + "...."
                                  : data?.streamURL}
                              </td>

                              {/* <td>{data?.view}</td>

                                  <td>
                                    {dayjs(data?.createdAt).format(
                                      "DD MMM YYYY"
                                    )}
                                  </td> */}
                              <td className="pr-3 tableAlign">
                                <button
                                  className="btn custom-action-button btn-sm"
                                  onClick={()=>{
                                    if(data?.channelLogo){
                                       handelCreateChannelWithLogo(data)
                                    }else{
                                      handleOpen(data)
                                    }
                                  }}
                                >
                                  <IconPlus className="text-secondary" />
                                </button>
                              </td>
                            </tr>
                          </>
                        );
                      })}
                    {/* {loader === false && data?.length === 0 && (
                      <tr>
                        <td colSpan="12" className="text-center">
                          No data Found!!
                        </td>
                      </tr>
                    )} */}
                  </tbody>
                </table>
              </div>
            </div>
            <div className="iq-card-footer">
              <Pagination
                activePage={page}
                rowsPerPage={rowsPerPage}
                userTotal={data?.length}
                handleRowsPerPage={handleChangeRowsPerPage}
                handlePageChange={handleChangePage}
              />
            </div>
          </div>
        </div>
      </div>

      {/* Dialog */}
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
          <h2 class="modal-title m-0">Select Channel Logo</h2>
          <button
            className="btn btn-sm custom-action-button"
            onClick={handleClose}
          >
            <IconX className="text-secondary" />
          </button>
        </div>

        <DialogContent>
          <div className="d-flex flex-column">
            <form className="">
              <div className="form-group">
                <label className="float-left">Channel Name  </label>
                <input
                 className="form-control"
                  readOnly 
                  type="text"
                  value={selectedData?.channelName || "-"}
                />
              </div>
              <div className="form-group">
                <label className="float-left">Stream URL  </label>
                <input
                 className="form-control"
                  readOnly 
                  type="text"
                  value={selectedData?.streamURL || "-"}
                />
              </div>
              <div className="form-group">
                <label className="float-left">Channel ID  </label>
                <input
                 className="form-control"
                  readOnly 
                  type="text"
                  value={selectedData?.channelId || "-"}
                />
              </div>
              <div className="form-group">
                <label className="float-left">Select Channel Logo </label>
                <input
                  className="form-control"
                  type="file"
                  id="customFile"
                  required=""
                  accept="image/png, image/jpeg ,image/jpg"
                  onChange={handleInputImage}
                />
                <p className="extention-show">Accept only .png, .jpeg, .jpeg</p>

                {errors && (
                  <p className="extention-show text-start">{errors}</p>
                )}

                {image && (
                  <div className="row pl-3">
                    <img
                      src={URL.createObjectURL(image)}
                      onError={(e) => {
                        e.target.onerror = null;
                        e.target.src = noImage;
                      }}
                      width={100}
                      height={100}
                      style={{
                        borderRadius: "5px",
                        marginTop: 10,
                        float: "left",
                        objectFit: "cover",
                      }}
                      alt=""
                    />
                  </div>
                )}
              </div>
            </form>
          </div>
        </DialogContent>
        <DialogActions className="modal-footer">
          <button
            type="button"
            className="btn dark-icon btn-danger float-right mr-3 m-0"
            onClick={handleClose}
          >
            Close
          </button>
          <button
            type="button"
            className="btn dark-icon btn-primary float-right m-0"
            onClick={handelCreateChannel}
          >
            Submit
          </button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default connect(null, {
  getCountry,
  getLiveTvData,
  createLiveChannel,
  getFlag,
})(LiveTvDialogue);
