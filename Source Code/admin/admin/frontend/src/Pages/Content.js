import React, { useEffect, useState } from "react";

import noImage from "../Component/assets/images/moviePlaceHolder.png";

//react-router-dom

//react-redux
import $ from "jquery";
import { connect, useDispatch, useSelector } from "react-redux";
import {
  MOVIE_DETAILS
} from "../store/Movie/movie.type";

//mui

//Alert
import { warning } from "../util/Alert";

//html Parser

import { IconEdit, IconTrash } from "@tabler/icons-react";
import { useHistory } from "react-router-dom";
import { deleteContent, getContent } from "../store/Content/content.action";
import { CLOSE_CONTENT_TOAST } from "../store/Content/content.type";
import { setToast } from "../util/Toast";
import LazyImage from "../Component/common/ImageFallback";

const Content = (props) => {
  const { loader } = useSelector((state) => state.loader);

  //Define History
  const navigate = useHistory();
  const dispatch = useDispatch();

  const [data, setData] = useState([]);
  // const [showURLs, setShowURLs] = useState([]);



  const { content, toast, toastData, actionFor } = useSelector(
    (state) => state.content
  );
  console.log("content: ", content);

  useEffect(() => {
    dispatch(getContent());
  }, [dispatch]);

  useEffect(() => {
    if (content?.length > 0) {
      setData(content);
    }
  }, [content]);

  useEffect(() => {
    if (toast) {
      setToast(toastData, actionFor);
      dispatch({ type: CLOSE_CONTENT_TOAST });
    }
  }, [toast, toastData, actionFor, dispatch]);

  const updateOpen = (data) => {
    sessionStorage.setItem("updateContent", JSON.stringify(data));
    navigate.push({ pathname: "/admin/content/content_form", state: data });
  };

  const insertOpen = () => {
    sessionStorage.removeItem("updateContent");
    navigate.push("/admin/content/content_form");
  };

  const MovieDetails = (data) => {
    dispatch({ type: MOVIE_DETAILS, payload: data });
    navigate.push({
      pathname: "/admin/movie/movie_details",
      state: data,
    });
  };

  const handleNewRelease = (movieId) => {

    props.newRelease(movieId);
  };

  useEffect(() => {
    sessionStorage.removeItem("updateMovieData1");
  }, []);

  const deleteOpen = (movieId) => {
    const data = warning();
    data
      .then((result) => {
        if (result.isConfirmed) {

          props.deleteContent(movieId);
          setToast("Content deleted successfully.", "success");
        }
      })
      .catch((err) => console.log(err));
  };
  $(document).ready(function () {
    $("img").bind("error", function () {
      // Set the default image
      $(this).attr("src", noImage);
    });
  });

  const handleRedirect = (data) => {
    navigate.push({
      pathname: "/admin/content/movide_episode",
      state: data,
    });
  };

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid pl-3">
          <div className="row">
            <div className="col-sm-12">
              <div className="iq-card mb-5 mt-2">
                <div className="iq-card-header d-flex justify-content-between">
                  <div className="iq-header-title">
                    <h4 className="card-title">Content</h4>
                  </div>
                  <button
                    type="button"
                    className="btn dark-icon btn-primary"
                    data-bs-toggle="modal"
                    id="create-btn"
                    data-bs-target="#showModal"
                    onClick={insertOpen}
                  >
                    <i className="ri-add-line align-bottom me-1 fs-6"></i> Add
                  </button>
                </div>
                <div className="iq-card-body">
                  <div className="table-responsive custom-table ">
                    <table
                      id="user-list-table"
                      className="table table-striped table-borderless mb-0"
                      role="grid"
                      aria-describedby="user-list-page-info"
                    >
                      <thead className="text-nowrap">
                        <tr>
                          <th className="tableAlign">No.</th>
                          <th className="tableAlign text-start">Icon</th>
                          <th
                            className="tableAlign"
                            style={{ cursor: "pointer" }}
                          >
                            Name
                          </th>
                          <th
                            className="tableAlign"
                            style={{ cursor: "pointer" }}
                          >
                            Title
                          </th>
                          <th className="tableAlign">Action</th>
                          {/* <th className="tableAlign">Delete</th> */}
                        </tr>
                      </thead>
                      <tbody>
                        {data?.length > 0
                          ? data.map((data, index) => {
                            return (
                              <React.Fragment key={index}>
                                <tr>
                                  <td className="pr-3 tableAlign">
                                    {index + 1}
                                  </td>
                                  <td className="pr-3 tableAlign d-flex justify-content-center">
                                    {/* <img
                                        className="img-fluid"
                                        style={{
                                          height: "100px",
                                          width: "100px",
                                          margin: "0 auto",
                                          boxShadow:
                                            "0 5px 15px 0 rgb(105 103 103 / 0%)",
                                          border:
                                            "0.5px solid rgba(255, 255, 255, 0.20)",
                                          borderRadius: 10,
                                          objectFit: "cover",
                                        }}
                                        src={data?.icon ? data?.icon : noImage}
                                        onError={(e) => {
                                          e.target.onerror = null; // Prevents infinite loop
                                          e.target.src = noImage; // Default image path
                                        }}
                                        alt=""
                                      /> */}

                                    <LazyImage imageSrc={data?.icon} noImage={noImage} />
                                  </td>

                                  <td className="text-start text-capitalize text-center">
                                    {data?.name}
                                  </td>
                                  <td className="description-text text-center">
                                    {data?.title}
                                  </td>
                                  <td className="pr-3 tableAlign">
                                    <div className="d-flex justify-content-center">

                                      <button
                                        type="button"
                                        className=" btn custom-action-button mr-2"
                                        onClick={() => updateOpen(data)}
                                      >
                                        <IconEdit className="text-secondary" />
                                      </button>
                                      <button
                                        type="button"
                                        className=" btn custom-action-button mr-2"
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
                                          className="ri-delete-bin-6-line"
                                          style={{ fontSize: "19px" }}
                                        ></i>
                                      </button>
                                    </td> */}
                                </tr>
                              </React.Fragment>
                            );
                          })
                          : loader === false &&

                          <tr>
                            <td colSpan="8" className="text-center py-2">
                              <h6>No Data Found</h6>
                            </td>
                          </tr>
                        }
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default connect(null, {
  getContent,
  deleteContent,
})(Content);
