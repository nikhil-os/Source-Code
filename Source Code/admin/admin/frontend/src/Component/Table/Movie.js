import React, { useEffect, useState } from "react";

import noImage from "../assets/images/moviePlaceHolder.png";

//react-router-dom
import { useHistory } from "react-router-dom";

//react-redux
import $ from "jquery";
import { connect, useDispatch, useSelector } from "react-redux";
import {
  deleteMovie,
  getMovie,
  newRelease,
} from "../../store/Movie/movie.action";
import { MOVIE_DETAILS } from "../../store/Movie/movie.type";

//mui
import Switch from "@mui/material/Switch";

//Alert
import { warning } from "../../util/Alert";

//html Parser

import { makeStyles } from "@mui/styles";
import arraySort from "array-sort";
import Pagination from "../../Pages/Pagination";
import { OPEN_SHORT_DIALOG } from "../../store/EpisodeList/EpisodeList.type";
import { Toast } from "../../util/Toast_";
import EpisodeListDialogue from "../Dialog/EpisodeListDialog";
import RentalDialog from "../Dialog/RentalDialog";
import addEpisode from "../assets/images/addEpisode.svg";
import episdoe from "../assets/images/episode.svg";
import Search from "../assets/images/search.png";
import {
  IconEdit,
  IconInfoCircle,
  IconPhotoVideo,
  IconTrash,
  IconVideoPlus,
  IconShoppingCart,
} from "@tabler/icons-react";
import { useDebounce } from "../../hooks/useDebounce";
import LazyImage from "../common/ImageFallback";

//useStyle
const useStyles1 = makeStyles((theme) => ({
  root: {
    flexShrink: 0,
    marginLeft: theme?.spacing && theme?.spacing(2.5),
    background: "#221f3a",
    color: "#fff",
  },
}));

const Movie = (props) => {
  const { loader } = useSelector((state) => state.loader);

  //Define History
  const history = useHistory();
  const dispatch = useDispatch();

  const [data, setData] = useState([]);
  const [activePage, setActivePage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  // const [showURLs, setShowURLs] = useState([]);
  const [titleSort, setTitleSort] = useState(true);
  const [countrySort, setCountrySort] = useState(true);
  const [search, setSearch] = useState("");
  const debounceValue = useDebounce(search, 500);

  // Rental Dialog state
  const [showRentalDialog, setShowRentalDialog] = useState(false);
  const [selectedMovieForRental, setSelectedMovieForRental] = useState(null);

  const { movie, isTost, toastData, actionFor, totalMovie } = useSelector(
    (state) => state.movie,
  );

  useEffect(() => {
    dispatch(getMovie(activePage, rowsPerPage, search));
  }, [dispatch, activePage, rowsPerPage, debounceValue]);

  useEffect(() => {
    setData(movie);
  }, [movie]);

  const updateOpen = (data) => {
    sessionStorage.setItem("trailerId", data?._id);
    sessionStorage.setItem("updateMovieData1", JSON.stringify(data));
    history.push({ pathname: "/admin/movie/movie_form", state: data });
  };

  const openPurchase = (movieData) => {
    // Open the Rental Dialog
    setSelectedMovieForRental(movieData);
    setShowRentalDialog(true);
  };

  const handleRentalDialogClose = () => {
    setShowRentalDialog(false);
    setSelectedMovieForRental(null);
  };

  const handleRentalSave = (updatedMovie) => {
    // Update the movie in the local data state
    setData((prevData) =>
      prevData.map((m) =>
        m._id === updatedMovie._id ? { ...m, ...updatedMovie } : m,
      ),
    );
  };

  const handlePageChange = (pageNumber) => {
    setActivePage(pageNumber);
  };

  const handleRowsPerPage = (value) => {
    setActivePage(1);
    setRowsPerPage(value);
  };

  const insertOpen = () => {
    sessionStorage.removeItem("updateMovieData");
    history.push("/admin/movie/movie_form");
  };

  const MovieDetails = (data) => {
    dispatch({ type: MOVIE_DETAILS, payload: data });
    history.push({
      pathname: "/admin/movie/movie_details",
      state: data,
    });
  };

  const handleNewRelease = (movieId) => {
    props.newRelease(movieId);
  };

  const handleSearch = (e) => {
    setSearch(e);
  };

  useEffect(() => {
    sessionStorage.removeItem("updateMovieData1");
  }, []);

  const deleteOpen = (movieId) => {
    const data = warning();
    data
      .then((result) => {
        if (result.isConfirmed) {
          props.deleteMovie(movieId);
          Toast("success", "Movie deleted successfully.");
        }
      })
      .catch((err) => console.log(err));
  };
  const handleTitleSort = () => {
    setTitleSort(!titleSort);
    arraySort(data, "title", { reverse: titleSort });
  };
  const handleCountrySort = () => {
    setCountrySort(!countrySort);
    arraySort(data, "region.name", { reverse: countrySort });
  };
  $(document).ready(function () {
    $("img").bind("error", function () {
      // Set the default image
      $(this).attr("src", noImage);
    });
  });

  const handleRedirect = (data) => {
    history.push({
      pathname: "/admin/movie/movide_episode",
      state: data,
    });
  };

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid pl-3">
          <div className="row">
            <div className="col-sm-12">
              {/* <div class="iq-header-title mt-4 ml-2">
                <h4 class="card-title">Movie</h4>
              </div> */}
              <div className="iq-card mb-5 mt-2">
                <div className="iq-card-header d-flex justify-content-between">
                  <div class="iq-header-title w-100">
                    <h4 class="card-title">Movie</h4>
                  </div>
                  <div className="d-flex gap-2 w-100 justify-content-end">
                    <div class="form-group mb-0 d-flex mr-3">
                      <input
                        type="search"
                        class="form-control"
                        id="input-search"
                        placeholder="Search"
                        aria-controls="user-list-table"
                        onChange={(e) => handleSearch(e.target.value)}
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
                      className="table table-striped table-borderless mb-0"
                      role="grid"
                      aria-describedby="user-list-page-info"
                    >
                      <thead class="text-nowrap">
                        <tr>
                          <th className="tableAlign">ID</th>
                          <th className="tableAlign">Image</th>
                          <th
                            className="tableAlign"
                            onClick={handleTitleSort}
                            style={{ cursor: "pointer" }}
                          >
                            Title {titleSort ? " ▼" : " ▲"}
                          </th>
                          <th
                            className="tableAlign"
                            onClick={handleCountrySort}
                            style={{ cursor: "pointer" }}
                          >
                            Region {countrySort ? " ▼" : " ▲"}
                          </th>
                          <th className="tableAlign">Type</th>
                          <th className="tableAlign">New Release</th>
                          <th className="tableAlign">Add Shorts</th>
                          <th className="tableAlign">Shorts</th>
                          <th className="tableAlign">Purchase</th>
                          {/* <th className="tableAlign">View Details</th>
                          <th className="tableAlign">Edit</th> */}
                          <th className="tableAlign">Action</th>
                        </tr>
                      </thead>
                      <tbody>
                        {data?.length > 0
                          ? data.map((data, index) => {
                              return (
                                <React.Fragment key={index}>
                                  <tr>
                                    <td className="pr-3 tableAlign">
                                      {(activePage - 1) * rowsPerPage +
                                        index +
                                        1}
                                    </td>
                                    <td className="d-flex justify-content-center mx-auto pr-3">
                                      <LazyImage
                                        imageSrc={data?.thumbnail}
                                        noImage={noImage}
                                      />
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
                                          data?.thumbnail
                                            ? data?.thumbnail
                                            : noImage
                                        }
                                        onError={(e) => {
                                          e.target.onerror = null; 
                                          e.target.src = noImage; 
                                        }}
                                        alt=""
                                      /> */}
                                    </td>

                                    <td className="text-start text-capitalize text-center">
                                      {data?.title}
                                    </td>
                                    <td className="description-text text-center">
                                      {data?.region?.name}
                                    </td>

                                    <td className="pr-3 tableAlign">
                                      {data?.type === "Premium" ? (
                                        <div class="badge badge-pill badge-danger">
                                          {data?.type}
                                        </div>
                                      ) : (
                                        <div class="badge badge-pill badge-info">
                                          {data?.type}
                                        </div>
                                      )}
                                    </td>

                                    <td className="pr-3 tableAlign">
                                      <Switch
                                        checked={data?.isNewRelease}
                                        onChange={(e) =>
                                          handleNewRelease(data?._id)
                                        }
                                        color="primary"
                                        name="checkedB"
                                        inputProps={{
                                          "aria-label": "primary checkbox",
                                        }}
                                      />
                                    </td>

                                    <td className="text-center">
                                      {/* <img
                                        alt=""
                                        src={addEpisode}
                                        height={25}
                                        width={25}
                                        style={{ cursor: "pointer" }}
                                        onClick={() => {
                                          // 

                                          dispatch({
                                            type: OPEN_SHORT_DIALOG,
                                            payload: data?._id,
                                          });
                                        }}
                                      /> */}
                                      <button
                                        className="btn custom-action-button"
                                        onClick={() => {
                                          //

                                          dispatch({
                                            type: OPEN_SHORT_DIALOG,
                                            payload: data?._id,
                                          });
                                        }}
                                      >
                                        <IconVideoPlus className="text-secondary" />
                                      </button>
                                    </td>

                                    <td className="text-center">
                                      {/* <img
                                        alt=""
                                        src={episdoe}
                                        height={25}
                                        width={25}
                                        style={{ cursor: "pointer" }}
                                        onClick={() => handleRedirect(data)}
                                      /> */}
                                      <button
                                        className="btn custom-action-button"
                                        onClick={() => handleRedirect(data)}
                                      >
                                        <IconPhotoVideo className="text-secondary" />
                                      </button>
                                    </td>

                                    {/* Purchase (Rental Settings) */}
                                    <td className="text-center">
                                      <button
                                        className="btn custom-action-button"
                                        onClick={() => openPurchase(data)}
                                        title="Purchase Settings"
                                      >
                                        <IconShoppingCart className="text-secondary" />
                                      </button>
                                    </td>

                                    <td className="pr-3 tableAlign">
                                      <div className="d-flex justify-content-center">
                                        <button
                                          type="button"
                                          className="btn custom-action-button mr-2"
                                          onClick={() => MovieDetails(data._id)}
                                        >
                                          <IconInfoCircle className="text-secondary" />
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
                                          className="btn custom-action-button"
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
                                        onClick={() => updateOpen(data)}
                                      >
                                        <i
                                          className="ri-pencil-fill"
                                          style={{ fontSize: "19px" }}
                                        />
                                      </button>
                                    </td> */}
                                    {/* <td className="pr-3 tableAlign">
                                      <button
                                        type="button"
                                        className="btn iq-bg-primary btn-sm"
                                        onClick={() => deleteOpen(data._id)}
                                      >
                                        <i
                                          class="ri-delete-bin-6-line"
                                          style={{ fontSize: "19px" }}
                                        ></i>
                                      </button>
                                    </td> */}
                                  </tr>
                                </React.Fragment>
                              );
                            })
                          : loader === false && data?.length < 0 && ""}
                      </tbody>
                    </table>
                  </div>
                </div>
                <div className="iq-card-footer">
                  <Pagination
                    activePage={activePage}
                    rowsPerPage={rowsPerPage}
                    userTotal={totalMovie}
                    handleRowsPerPage={handleRowsPerPage}
                    handlePageChange={handlePageChange}
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <EpisodeListDialogue />

      {/* Rental Dialog */}
      <RentalDialog
        show={showRentalDialog}
        onHide={handleRentalDialogClose}
        movie={selectedMovieForRental}
        onSave={handleRentalSave}
      />
    </>
  );
};

export default connect(null, {
  getMovie,
  deleteMovie,
  newRelease,
})(Movie);
