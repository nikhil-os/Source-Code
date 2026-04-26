import React, { useState, useEffect } from 'react';
import dayjs from 'dayjs';

//image
import Default from '../assets/images/noImage.png';

//react-router-dom
import { NavLink } from 'react-router-dom';

//mui
import MovieFilterIcon from '@mui/icons-material/MovieFilter';
import RecentActorsIcon from '@mui/icons-material/RecentActors';
import EditIcon from '@mui/icons-material/Edit';
import DynamicFeedIcon from '@mui/icons-material/DynamicFeed';
import TvIcon from '@mui/icons-material/Tv';
import Search from '../assets/images/search.png';

//Pagination
import TablePaginationActions from './Pagination';
import { TablePagination } from '@mui/material';

//Alert
import Swal from 'sweetalert2';

//react-redux
import { connect, useDispatch, useSelector } from 'react-redux';

import { setToast } from '../../util/Toast';
import { warning, alert } from '../../util/Alert';

import { getSeason, deleteSeason } from '../../store/Season/season.action';
import { OPEN_SEASON_DIALOG } from '../../store/Season/season.type';
import SeasonDialogue from '../Dialog/SeasonDialogue';
import placeholderImage from '../assets/images/defaultUserPicture.jpg';
import Pagination from '../../Pages/Pagination';
import { IconEdit, IconTrash } from '@tabler/icons-react';

const Season = (props) => {
  const { loader } = useSelector((state) => state.loader);

  const [data, setData] = useState([]);
  const [page, setPage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);


  const dialogData = sessionStorage.getItem('seriesTrailerId');
  const seriesTitle = sessionStorage.getItem('seriesTitle');

  const dispatch = useDispatch();

  const handleOpen = () => {

    dispatch({ type: OPEN_SEASON_DIALOG });
  };

  const updateDialogOpen = (data) => {

    dispatch({ type: OPEN_SEASON_DIALOG, payload: data });
  };
  //useEffect for Get Data
  useEffect(() => {
    dispatch(getSeason(dialogData));
  }, [dispatch]);

  const { season, toast, toastData, actionFor } = useSelector(
    (state) => state.season
  );
  const tmdbId = JSON.parse(sessionStorage.getItem('updateMovieData'));

  //Set Data after Getting
  useEffect(() => {
    setData(season);
  }, [season]);

  const openDeleteDialog = (id) => {
    const data = warning();
    data
      .then((result) => {
        if (result.isConfirmed) {


          props.deleteSeason(id);
          Swal.fire('Deleted!', 'Your file has been deleted.', 'success');
        }
      })
      .catch((err) => console.log(err));
  };

  const handleSearch = (e) => {
    const value = e.target.value.trim().toUpperCase();
    if (value) {
      const data = season.filter((data) => {
        return data?.name?.toUpperCase()?.indexOf(value) > -1;
      });
      setData(data);
    } else {
      return setData(season);
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
                to="/admin/web_series/series_form"
              >

                Edit
              </NavLink>

            </button>
            <button className="nav-item navCustom border-0">
              <NavLink
                className="nav-link"
                to="/admin/web_series/trailer"
              >
                Trailer
              </NavLink>

            </button>
            <button className="nav-item navCustom border-0">
              <NavLink
                className="nav-link"
                to="/admin/web_series/season"
              >
                Season
              </NavLink>
            </button>
            <button className="nav-item navCustom border-0">
              <NavLink
                className="nav-link"
                to="/admin/episode"
              >
                Episode
              </NavLink>
            </button>
            <button className="nav-item navCustom border-0">
              <NavLink
                className="nav-link"
                to="/admin/web_series/cast"
              >
                Cast
              </NavLink>
            </button>
          </div>
          <div className="iq-card mb-5">
            <div className="iq-card-header d-flex justify-content-between">
              <h4 className="card-title my-0">Seasons </h4>

              <div className="d-flex">
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
                  onClick={handleOpen}
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
                    <tr>
                      <th className="tableAlign">ID</th>
                      <th style={{ paddingLeft: '45px' }}>Image</th>
                      <th className="tableAlign">Name</th>
                      <th className="tableAlign">Season No.</th>
                      <th className="tableAlign">Total Episode</th>
                      <th className="tableAlign">Web Series</th>
                      <th className="tableAlign">Realese Date</th>
                      <th className="tableAlign">Created At</th>
                      <th className="tableAlign">Action</th>
                    </tr>
                  </thead>
                  <tbody style={{ borderColor: '#e9ebec' }}>
                    {data?.length > 0
                      ? data
                        .slice(
                          (page - 1) * rowsPerPage,
                          (page - 1) * rowsPerPage + rowsPerPage
                        )
                        .map((data, index) => {
                          return (
                            <>
                              <tr>
                                <td class="align-middle tableAlign">
                                  {(page - 1) * rowsPerPage + index + 1}
                                </td>
                                <td
                                  className="align-middle"
                                  style={{ paddingLeft: '38px' }}
                                >
                                  <img
                                    src={
                                      data?.image
                                        ? data?.image
                                        : placeholderImage
                                    }
                                    height="60px"
                                    width="60px"
                                    style={{
                                      boxShadow:
                                        '0 5px 15px 0 rgb(105 103 103 / 0%)',
                                      border:
                                        '0.5px solid rgb(88 106 110)',
                                      borderRadius: 10,
                                      float: 'left',
                                      objectFit: 'cover',
                                    }}
                                    alt=""
                                  />
                                </td>
                                <td class="align-middle tableAlign">
                                  {data?.name}
                                </td>
                                <td class="align-middle tableAlign">
                                  {data?.seasonNumber}
                                </td>
                                <td class="align-middle tableAlign">
                                  {data?.episodeCount}
                                </td>
                                <td class="align-middle tableAlign">
                                  {data?.movie?.title}
                                </td>
                                <td class="align-middle tableAlign">
                                  {data?.releaseDate}
                                </td>
                                <td class="align-middle tableAlign">
                                  {dayjs(data?.createdAt).format(
                                    'DD MMM YYYY'
                                  )}
                                </td>

                                <td class="align-middle tableAlign">
                                  <div className='d-flex justify-content-center '>
                                    <button
                                      type="button"
                                      className="btn custom-action-button mr-2 btn-sm"
                                      onClick={() => updateDialogOpen(data)}
                                    >
                                      <IconEdit className='text-secondary' />
                                    </button>
                                    <button
                                      type="button"
                                      className="btn custom-action-button mr-2 btn-sm"
                                      onClick={() =>
                                        openDeleteDialog(data?._id)
                                      }
                                    >
                                      <IconTrash className='text-secondary' />
                                    </button>

                                  </div>
                                </td>
                                {/* <td class="align-middle tableAlign">
                                        <button
                                          type="button"
                                          className="btn iq-bg-primary btn-sm"
                                          onClick={() =>
                                            openDeleteDialog(data?._id)
                                          }
                                        >
                                          <i
                                            class="ri-delete-bin-6-line"
                                            style={{ fontSize: '19px' }}
                                          ></i>
                                        </button>
                                      </td> */}
                              </tr>
                            </>
                          );
                        })
                      : loader === false &&
                      data?.length === 0 && (
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
                      { label: 'All', value: data?.length },
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

        <SeasonDialogue />
      </div>
    </>
  );
};

export default connect(null, { getSeason, deleteSeason })(Season);
