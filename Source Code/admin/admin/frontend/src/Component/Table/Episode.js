import React, { useState, useEffect } from 'react';
import dayjs from 'dayjs';

//react-router-dom
import { NavLink, useHistory } from 'react-router-dom';

//css
import noImage from '../assets/images/noImage.png';
import $ from 'jquery';
//mui
import MovieFilterIcon from '@mui/icons-material/MovieFilter';
import RecentActorsIcon from '@mui/icons-material/RecentActors';
import EditIcon from '@mui/icons-material/Edit';
import DynamicFeedIcon from '@mui/icons-material/DynamicFeed';
import TvIcon from '@mui/icons-material/Tv';

//Alert
import Swal from 'sweetalert2';
import { setToast } from '../../util/Toast';
import { warning } from '../../util/Alert';

//react-redux
import { useSelector } from 'react-redux';
import { connect } from 'react-redux';
import { useDispatch } from 'react-redux';

//action
import {
  getEpisode,
  deleteEpisode,
  getMovieEpisode,
} from '../../store/Episode/episode.action';
import { getMovieCategory } from '../../store/Movie/movie.action';
import {
  OPEN_INSERT_DIALOG,
  CLOSE_EPISODE_TOAST,
} from '../../store/Episode/episode.type';
import { getSeason } from '../../store/Season/season.action';

//Pagination
import TablePaginationActions from './Pagination';
import { TablePagination } from '@mui/material';
//image
import placeholderImage from '../assets/images/defaultUserPicture.jpg';

import Pagination from '../../Pages/Pagination';
import { IconEdit, IconTrash } from '@tabler/icons-react';

const Episode = (props) => {
  const { loader } = useSelector((state) => state.loader);

  const history = useHistory();
  const dispatch = useDispatch();

  const [data, setData] = useState([]);
  const [page, setPage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [seasons, setSeasons] = useState('');
  // const [showURLs, setShowURLs] = useState([""]);

  const dialogData = sessionStorage.getItem('seriesTrailerId');
  const seriesTitle = sessionStorage.getItem('seriesTitle');
  const tmdbId = JSON.parse(sessionStorage.getItem('updateMovieData'));

  //get movie
  const [movieData, setMovieData] = useState([]);

  const { movie } = useSelector((state) => state.movie);

  useEffect(() => {
    setMovieData(movie);
  }, [movie]);

  useEffect(() => {
    dispatch(getMovieEpisode(dialogData, seasons ? seasons : 'AllSeasonGet'));
  }, [dispatch, dialogData, seasons]);

  //Get Episode
  const { episode, toast, toastData, actionFor } = useSelector(
    (state) => state.episode
  );

  useEffect(() => {
    setData(episode);
  }, [episode]);

  //get tv series season from season
  const [seasonData, setSeasonData] = useState([]);

  //useEffect for getmovie
  useEffect(() => {
    if (tmdbId) {
      dispatch(getSeason(tmdbId?._id));
    }
  }, []);

  //call the season
  const { season } = useSelector((state) => state.season);
  useEffect(() => {
    setSeasonData(season ? season : 'AllSeasonGet');
  }, [season]);

  const insertOpen = () => {

    sessionStorage.removeItem('updateEpisodeData');
    dispatch({ type: OPEN_INSERT_DIALOG });
    history.push('/admin/episode/episode_form');
  };

  //Update Dialog OPen
  const updateOpen = (data) => {

    dispatch({ type: OPEN_INSERT_DIALOG, payload: data });
    sessionStorage.setItem('updateEpisodeData', JSON.stringify(data));
    history.push('/admin/episode/episode_form');
  };

  const deleteOpen = (mongoId) => {
    const data = warning();
    data
      .then((result) => {
        if (result.isConfirmed) {

          props.deleteEpisode(mongoId);
          Swal.fire('Deleted!', 'Your file has been deleted.', 'success');
        }
      })
      .catch((err) => console.log(err));
  };
  //pagination
  const handleChangePage = (event, newPage) => {
    setPage(event);
  };
  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event, 10));
    setPage(1);
  };

  //for search
  const handleSearch = (e) => {
    const value = e.target.value.trim().toUpperCase();
    if (value) {
      const data = episode.filter((data) => {
        return (
          data?.movie?.title?.toUpperCase()?.indexOf(value) > -1 ||
          data?.name?.toUpperCase()?.indexOf(value) > -1
        );
      });
      setData(data);
    } else {
      return setData(episode);
    }
  };

  //toast
  useEffect(() => {
    if (toast) {
      setToast(toastData, actionFor);
      dispatch({ type: CLOSE_EPISODE_TOAST });
    }
  }, [toast, toastData, actionFor, dispatch]);

  $(document).ready(function () {
    $('img').bind('error', function () {
      // Set the default image
      $(this).attr('src', placeholderImage);
      // $(this).css({
      //   // Add CSS properties here
      //   width: "100px",
      //   height: "100px",
      //   border: "1px solid red",
      //   // Add more CSS properties as needed
      // });
    });
  });
  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          <div className="nav nav-pills mb-3">
            <button className="nav-item navCustom border-0">
              <NavLink className="nav-link" to="/admin/web_series/series_form">
                Edit
              </NavLink>
            </button>
            <button className="nav-item navCustom border-0">
              <NavLink className="nav-link" to="/admin/web_series/trailer">
                Trailer
              </NavLink>
            </button>
            <button className="nav-item navCustom border-0">
              <NavLink className="nav-link" to="/admin/web_series/season">
                Season
              </NavLink>
            </button>
            <button className="nav-item navCustom border-0">
              <NavLink className="nav-link" to="/admin/episode">
                Episode
              </NavLink>
            </button>
            <button className="nav-item navCustom border-0">
              <NavLink className="nav-link" to="/admin/web_series/cast">
                Cast
              </NavLink>
            </button>
          </div>

          {/* <div className="iq-card my-3">
                    
                      <label className="styleForTitle">Select Season</label>
                     
                    
                  </div> */}


          <div className="iq-card">
            <div className="iq-card-header d-flex justify-content-between  ">
              <h4 className="card-title my-0">Episode</h4>


              <div className="d-flex w-50 justify-content-end">
                <div className='w-25 mr-3'>
                  <select
                    name="session"
                    value={seasons}
                    className="form-select "
                    onChange={(e) => {
                      setSeasons(e.target.value);
                    }}
                  >
                    <option value="AllSeasonGet">
                      {!seasons ? "select season" : "All Season"}
                    </option>
                    {seasonData?.map((data, key) => {
                      return (
                        <option
                          value={data._id}
                          key={key}
                          selected={data._id}
                        >
                          Season{" " + data.seasonNumber}
                        </option>
                      );
                    })}
                  </select>
                </div>

                <div class="form-group mb-0 d-flex mr-3">
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
                  className="table table-striped table-borderless mb-0"
                  role="grid"
                  aria-describedby="user-list-page-info"
                >
                  <thead>
                    <tr className="text-center">
                      <th>ID</th>
                      <th>Image</th>
                      <th>Episode No.</th>
                      <th>Name</th>
                      <th>Web Series</th>
                      <th>Created Date</th>
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
                                      border: "0.5px solid rgb(88 106 110)",
                                      borderRadius: 10,

                                      objectFit: "cover",
                                    }}
                                    alt=""
                                  />
                                </td>
                                <td>{data?.episodeNumber}</td>
                                <td>
                                  {data?.name.length > 10
                                    ? data?.name?.slice(0, 10) + "..."
                                    : data?.name}
                                </td>
                                <td>{data?.title}</td>

                                <td>
                                  {dayjs(data?.createdAt).format(
                                    "DD MMM YYYY"
                                  )}
                                </td>
                                <td>
                                  <div className='d-flex justify-content-center'>
                                    <button
                                      type="button"
                                      className="btn custom-action-button mr-2"
                                      onClick={() => updateOpen(data)}
                                    >
                                      <IconEdit className='text-secondary' />
                                    </button>
                                    <button
                                      type="button"
                                      className="btn custom-action-button"
                                      onClick={() => deleteOpen(data._id)}
                                    >
                                      <IconTrash className='text-secondary' />
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
                                        class="ri-delete-bin-6-line"
                                        style={{ fontSize: "19px" }}
                                      ></i>
                                    </button>
                                  </td> */}
                              </tr>
                            </>
                          );
                        })
                      : loader === false &&
                      data?.length < 0 && (
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
            <div className='iq-card-footer'>
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
  getEpisode,
  getMovieCategory,
  // getMovie,
  deleteEpisode,
  getSeason,
  getMovieEpisode,
})(Episode);
