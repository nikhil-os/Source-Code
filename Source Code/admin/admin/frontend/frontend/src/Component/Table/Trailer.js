import React, { useState, useEffect } from "react";
import dayjs from "dayjs";
import $ from "jquery";

//react-router-dom
import { NavLink, useHistory } from "react-router-dom";

//mui
import MovieFilterIcon from "@mui/icons-material/MovieFilter";
import RecentActorsIcon from "@mui/icons-material/RecentActors";
import EditIcon from "@mui/icons-material/Edit";
import Search from "../assets/images/search.png";

//Alert
import Swal from "sweetalert2";
import { setToast } from "../../util/Toast";
import { warning, alert } from "../../util/Alert";


//react-redux
import { useSelector } from "react-redux";
import { connect } from "react-redux";
import { useDispatch } from "react-redux";

//action
import { getMovie } from "../../store/Movie/movie.action";
import { getSeries } from "../../store/TvSeries/tvSeries.action";
import { MOVIE_DETAILS } from "../../store/Movie/movie.type";
import { getTrailer, deleteTrailer } from "../../store/Trailer/trailer.action";
//image
import placeholderImage from "../assets/images/defaultUserPicture.jpg";
import {
  OPEN_TRAILER_DIALOG,
  CLOSE_TRAILER_TOAST,
} from "../../store/Trailer/trailer.type";

//Pagination
import TablePaginationActions from "./Pagination";
import { TablePagination } from "@mui/material";
import Pagination from "../../Pages/Pagination";
import { IconEdit, IconTrash } from "@tabler/icons-react";

const Trailer = (props) => {
  const { loader } = useSelector((state) => state.loader);

  const dispatch = useDispatch();

  const history = useHistory();

  const [data, setData] = useState([]);
  const [page, setPage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  // const [showURLs, setShowURLs] = useState([]);



  const dialogData = JSON.parse(sessionStorage.getItem("trailerId"));
  const movieTitle = sessionStorage.getItem("movieTitle");

  //useEffect for Trailer
  useEffect(() => {
    dispatch(getTrailer(dialogData._id));
  }, [dispatch]);

  //Get Trailer
  const { trailer, toast, toastData, actionFor } = useSelector(
    (state) => state.trailer
  );
  console.log("trailer", trailer);

  useEffect(() => {
    setData(trailer);
  }, [trailer]);

  //Insert Dialog OPen
  const insertOpen = (data) => {

    sessionStorage.removeItem("updateTrailerData");
    history.push("/admin/trailer/trailer_form");
  };

  //Update Dialog OPen
  const updateOpen = (data) => {

    dispatch({ type: OPEN_TRAILER_DIALOG, payload: data });
    sessionStorage.setItem("updateTrailerData", JSON.stringify(data));

    history.push({ pathname: "/admin/trailer/trailer_form", state: data });
  };

  const deleteOpen = (mongoId) => {
    const data = warning();
    data
      .then((result) => {
        if (result.isConfirmed) {

          props.deleteTrailer(mongoId);
          Swal.fire("Deleted!", "Your file has been deleted.", "success");
        }
      })
      .catch((err) => console.log(err));
  };

  //toast
  useEffect(() => {
    if (toast) {
      setToast(toastData, actionFor);
      dispatch({ type: CLOSE_TRAILER_TOAST });
    }
  }, [toast, toastData, actionFor, dispatch]);

  //for search
  const handleSearch = (e) => {
    const value = e.target.value.trim().toUpperCase();
    if (value) {
      const data = trailer.filter((data) => {
        return (
          data?.name?.toUpperCase()?.indexOf(value) > -1 ||
          data?.movieTitle?.toUpperCase()?.indexOf(value) > -1
        );
      });
      setData(data);
    } else {
      return setData(trailer);
    }
  };

  //pagination
  const handleChangePage = (event, newPage) => {
    setPage(event);
  };
  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event, 10));
    setPage(1);
  };

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">


          <div className="nav nav-pills mb-3" >
            <button className="nav-item navCustom border-0">
              <NavLink
                className="nav-link"
                to="/admin/movie/movie_form"
              >

                Edit
              </NavLink>

            </button>
            <button className="nav-item navCustom border-0">
              <NavLink
                className="nav-link active"
                to="/admin/movie/trailer"
              >
                Trailer
              </NavLink>

            </button>
            <button className="nav-item navCustom border-0">
              <NavLink
                className="nav-link"
                to="/admin/movie/cast"
              >
                Cast
              </NavLink>
            </button>
          </div>


          <div className="iq-card mb-5">
            <div className="iq-card-header d-flex justify-content-between">
              <h4 className="card-title my-0">{movieTitle} : Trailer </h4>
              <div className="d-flex">
                <div className="form-group mb-0 mr-3">
                  <input
                    type="search"
                    className="form-control"
                    id="input-search"
                    placeholder="Search"
                    aria-controls="user-list-table"
                    onChange={handleSearch}
                  />
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
            </div>
            <div className="iq-card-body">
              <div className="table-responsive custom-table">
                <table
                  id="user-list-table"
                  className="table table-striped table-borderless m-0"
                  role="grid"
                  aria-describedby="user-list-page-info"
                >
                  <thead>
                    <tr className="text-center">
                      <th>ID</th>
                      <th>Image</th>
                      <th>Movie </th>
                      <th>Type</th>
                      <th>Created Date</th>
                      {/* <th>Edit</th> */}
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {data?.length > 0
                      ? data
                        .slice(
                          (page - 1) * rowsPerPage,
                          (page - 1) * rowsPerPage + rowsPerPage
                        )
                        .map((data, index) => {
                          return (
                            <>
                              <tr className="text-center ">
                                <td>{(page - 1) * rowsPerPage + index + 1}</td>
                                <td>
                                  <img
                                    src={
                                      data?.trailerImage
                                        ? data?.trailerImage
                                        : placeholderImage
                                    }
                                    onError={(e) => {
                                      e.target.onerror = null; // Prevents infinite loop
                                      e.target.src = placeholderImage; // Default image path
                                    }}
                                    height="60px"
                                    width="60px"
                                    style={{
                                      boxShadow:
                                        " rgba(105, 103, 103, 0) 0px 5px 15px 0px",
                                      border:
                                        " 0.5px solid rgb(88, 106, 110)",
                                      borderRadius: "10px",

                                      objectFit: "cover",
                                    }}
                                    alt=""
                                  />
                                </td>
                                <td className="text-capitalize">
                                  {data?.movieTitle}
                                </td>
                                <td>{data?.type}</td>
                                <td>
                                  {dayjs(data?.createdAt).format(
                                    "DD MMM YYYY"
                                  )}
                                </td>
                                <td>
                                  <div className="d-flex justify-content-center">
                                    <button
                                      type="button"
                                      className="btn custom-action-button btn-sm mr-2"
                                      onClick={() => updateOpen(data)}
                                    >
                                      <IconEdit className="text-secondary" />
                                    </button>
                                    <button
                                      type="button"
                                      className="btn custom-action-button btn-sm"
                                      onClick={() => deleteOpen(data._id)}
                                    >
                                      <IconTrash className="text-secondary" />
                                    </button>
                                  </div>
                                </td>
                                {/* <td>
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
                            </>
                          );
                        })
                      : loader === false &&
                      data.length === 0 && (
                        ""
                      )}
                  </tbody>
                </table>
              </div>

              {/* <TablePagination
                rowsPerPageOptions={[
                  5,
                  10,
                  25,
                  50,
                  100,
                  { label: "All", value: data?.length },
                ]}
                component="div"
                count={data?.length}
                page={page}
                onPageChange={handleChangePage}
                rowsPerPage={rowsPerPage}
                onRowsPerPageChange={handleChangeRowsPerPage}
                ActionsComponent={TablePaginationActions}
              /> */}
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
    </>
  );
};

export default connect(null, {
  getTrailer,
  deleteTrailer,
  getMovie,
  getSeries,
  // getCourseLecture,
})(Trailer);
