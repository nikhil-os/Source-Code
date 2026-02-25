import React, { useState, useEffect } from "react";
import $ from "jquery";

//image
import placeholderImage from "../assets/images/defaultUserPicture.jpg";

//react-router-dom
import { NavLink, useHistory } from "react-router-dom";

//react-redux
import { useDispatch, useSelector } from "react-redux";
import { connect } from "react-redux";
import Search from "../assets/images/search.png";

//mui
import MovieFilterIcon from "@mui/icons-material/MovieFilter";
import RecentActorsIcon from "@mui/icons-material/RecentActors";
import EditIcon from "@mui/icons-material/Edit";

//Alert
import Swal from "sweetalert2";

//Alert
import { setToast } from "../../util/Toast";
import { warning } from "../../util/Alert";


//action
import {
  getTeamMember,
  deleteTeamMember,
} from "../../store/TeamMember/teamMember.action";
import { getMovie } from "../../store/Movie/movie.action";
import {
  OPEN_DIALOG,
  CLOSE_TEAM_MEMBER_TOAST,
} from "../../store/TeamMember/teamMember.type";

//Pagination
import TablePaginationActions from "./Pagination";
import { TablePagination } from "@mui/material";
import { baseURL } from "../../util/config";
import Pagination from "../../Pages/Pagination";
import { IconEdit, IconTrash } from "@tabler/icons-react";

const TeamMember = (props) => {
  const { loader } = useSelector((state) => state.loader);
  const { teamMember, toast, toastData, actionFor } = useSelector(
    (state) => state.teamMember
  );

  const history = useHistory();
  const dispatch = useDispatch();

  const [data, setData] = useState([]);
  const [page, setPage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);



  const dialogData = JSON.parse(sessionStorage.getItem("trailerId"));
  const movieTitle = sessionStorage.getItem("movieTitle");

  useEffect(() => {
    dispatch(getTeamMember(dialogData?._id));
    dispatch(getMovie());
  }, []);

  useEffect(() => {
    setData(teamMember);
  }, [teamMember]);

  const insertOpen = (data) => {

    sessionStorage.removeItem("updateTeamMemberData");
    history.push("/admin/cast/cast_form");
  };

  //Update Dialog OPen
  const updateOpen = (data) => {

    dispatch({ type: OPEN_DIALOG, payload: data });
    sessionStorage.setItem(
      "updateTeamMemberDataDialogue",
      JSON.stringify(data)
    );

    history.push("/admin/cast/cast_form");
  };

  //pagination
  const handleChangePage = (event, newPage) => {
    setPage(event);
  };
  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event, 10));
    setPage(1);
  };

  // delete sweetAlert
  const openDeleteDialog = (mongoId) => {
    const data = warning();
    data
      .then((result) => {
        if (result.isConfirmed) {

          props.deleteTeamMember(mongoId);
          Swal.fire("Deleted!", "Your file has been deleted.", "success");
        }
      })
      .catch((err) => console.log(err));
  };

  //for search
  const handleSearch = (e) => {
    const value = e.target.value.trim().toUpperCase();
    if (value) {
      const data = teamMember.filter((data) => {
        return (
          data?.name?.toUpperCase()?.indexOf(value) > -1 ||
          data?.position?.toUpperCase()?.indexOf(value) > -1 ||
          data?.movie?.title.toUpperCase()?.indexOf(value) > -1
        );
      });
      setData(data);
    } else {
      return setData(teamMember);
    }
  };

  //toast
  useEffect(() => {
    if (toast) {
      setToast(toastData, actionFor);
      dispatch({ type: CLOSE_TEAM_MEMBER_TOAST });
    }
  }, [toast, toastData, actionFor, dispatch]);

  $(document).ready(function () {
    $("img").bind("error", function () {
      // Set the default image
      $(this).attr("src", placeholderImage);
    });
  });

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
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

          <div className="iq-card mb-5">
            <div className="iq-card-header d-flex justify-content-between">
              <h4 className="card-title my-0">{movieTitle} : Cast </h4>
              <div className="d-flex">
                <div class="form-group mb-0 d-flex mr-3 ">
                  <input
                    type="search"
                    class="form-control"
                    id="input-search"
                    placeholder="Search"
                    aria-controls="user-list-table"
                    onChange={handleSearch}
                  />
                </div>
                <button
                  type="button"
                  class="btn dark-icon btn-primary"
                  data-bs-toggle="modal"
                  id="create-btn"
                  data-bs-target="#showModal"
                  onClick={insertOpen}
                >
                  <i class="ri-add-line align-bottom me-1 fs-6"></i> Add
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
                    <tr>
                      <th className="tableAlign">ID</th>
                      <th className="tableAlign">Profile Image</th>
                      <th className="tableAlign">Name</th>
                      <th className="tableAlign">Role</th>
                      <th className="tableAlign">Movie</th>
                      <th className="tableAlign">Action</th>
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
                              <tr className="text-center">
                                <td>{(page - 1) * rowsPerPage + index + 1}</td>
                                <td>
                                  <img
                                    src={
                                      data?.image
                                        ? data?.image
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
                                        "0 5px 15px 0 rgb(105 103 103 / 0%)",
                                      border:
                                        "0.5px solid rgba(255, 255, 255, 0.20)",
                                      borderRadius: 10,

                                      objectFit: "cover",
                                    }}
                                    alt=""
                                  />
                                </td>
                                <td>{data?.name}</td>
                                <td>{data?.position}</td>
                                <td>{data?.movie?.title}</td>

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
                                      onClick={() => openDeleteDialog(data._id)}
                                    >
                                      <IconTrash className="text-secondary" />
                                    </button>
                                  </div>
                                </td>
                                {/* <td>
                                    <button
                                      type="button"
                                      className="btn iq-bg-primary btn-sm"
                                      onClick={() => openDeleteDialog(data._id)}
                                    >
                                      <i
                                        class="ri-delete-bin-6-line"
                                        style={{ fontSize: "19px" }}
                                      ></i>
                                    </button>
                                  </td> */}
                              </tr>
                            </>
                          );
                        })
                      :
                      loader === false &&
                      data?.length === 0 && (
                        <tr>
                          <td colSpan="12" className="text-center">

                          </td>
                        </tr>

                      )
                    }
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
    </>
  );
};

export default connect(null, {
  getTeamMember,
  getMovie,
  deleteTeamMember,
})(TeamMember);
