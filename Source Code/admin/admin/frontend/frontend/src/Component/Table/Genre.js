import React, { useState, useEffect } from 'react';

//Alert
import Swal from 'sweetalert2';

//mui
import InboxIcon from '@mui/icons-material/Inbox';

//react-redux
import { connect, useDispatch, useSelector } from 'react-redux';

//alert

import { setToast } from '../../util/Toast';
import { warning, alert } from '../../util/Alert';



//action
import {
  CLOSE_GENRE_TOAST,
  OPEN_GENRE_DIALOG,
} from '../../store/Genre/genre.type';
import { getGenre, deleteGenre } from '../../store/Genre/genre.action';

import noImg from '../../Component/assets/images/noImage.png';
import logo from '../assets/images/movie.png';

//component
import GenreDialog from '../Dialog/GenreDialog';
import Search from '../assets/images/search.png';
import arraySort from 'array-sort';
import Pagination from '../../Pages/Pagination';
import { IconEdit, IconTrash } from '@tabler/icons-react';

const Genre = (props) => {
  const { loader } = useSelector((state) => state.loader);

  const [data, setData] = useState([]);
  const [page, setPage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [nameSort, setNameSort] = useState(true);

  const dispatch = useDispatch();



  //useEffect for Get Data
  useEffect(() => {
    dispatch(getGenre());
  }, [dispatch]);

  const { genre, toast, toastData, actionFor } = useSelector(
    (state) => state.genre
  );

  //Set Data after Getting
  useEffect(() => {
    setData(genre);
  }, [genre]);

  //Open Dialog
  const handleOpen = () => {
    dispatch({ type: OPEN_GENRE_DIALOG });
  };

  //Update Dialog
  const updateDialogOpen = (data) => {
    dispatch({ type: OPEN_GENRE_DIALOG, payload: data });
  };
  // delete sweetAlert
  const openDeleteDialog = (genreId) => {
    const data = warning();
    data
      .then((result) => {
        if (result.isConfirmed) {

          props.deleteGenre(genreId);
          Swal.fire('Deleted!', 'Your file has been deleted.', 'success');
        }
      })
      .catch((err) => console.log(err));
  };

  //toast
  useEffect(() => {
    if (toast) {
      setToast(toastData, actionFor);
      dispatch({ type: CLOSE_GENRE_TOAST });
    }
  }, [toast, toastData, actionFor, dispatch]);

  //for search
  const handleSearch = (e) => {
    const value = e.target.value.trim().toUpperCase();
    if (value) {
      const data = genre.filter((data) => {
        return data?.name?.toUpperCase()?.indexOf(value) > -1;
      });
      setData(data);
    } else {
      return setData(genre);
    }
  };

  const handlenameSort = () => {
    setNameSort(!nameSort);

    arraySort(data, 'name', { reverse: nameSort });
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
        <div className="container-fluid pl-3">
          <div className="row">
            <div className="col-sm-12">
              <div className="iq-card mb-5 mt-2">
                <div className="iq-card-header d-flex justify-content-between">
                  <div class="iq-header-title">
                    <h4 class="card-title">Genre</h4>
                  </div>
                  <div className="d-flex">
                    <form class="mr-3">
                      <div class="form-group mb-0 d-flex">
                        <input
                          type="search"
                          class="form-control"
                          id="input-search"
                          placeholder="Search"
                          aria-controls="user-list-table"
                          onChange={handleSearch}
                        />
                      </div>
                    </form>
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
                      <thead class="text-nowrap">
                        <tr className="text-center">
                          <th>ID</th>
                          <th>Image</th>
                          <th
                            onClick={handlenameSort}
                            style={{ cursor: 'pointer' }}
                          >
                            Name {nameSort ? ' ▼' : ' ▲'}
                          </th>
                          <th>Edit</th>
                          {/* <th>Delete</th> */}
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
                                  <tr>
                                    <td className="pr-3 tableAlign">
                                      {index + 1}
                                    </td>
                                    <td className="text-center">
                                      <img
                                        className="rounded-circle img-fluid avatar-40"
                                        src={
                                          data?.image ? data?.image : noImg
                                        }
                                        onError={(e) => {
                                          e.target.onerror = null; // Prevents infinite loop
                                          e.target.src = noImg; // Default image path
                                        }}
                                        alt=""
                                        style={{ objectFit: 'cover' }}
                                      />
                                    </td>

                                    <td className="pr-3  text-center">
                                      {data?.name?.length && data?.name}
                                    </td>

                                    <td className="pr-3 tableAlign">
                                      <button
                                        type="button"
                                        className="btn custom-action-button btn-sm"
                                        onClick={() => updateDialogOpen(data)}
                                      >
                                        <IconEdit className='text-secondary' />
                                      </button>
                                    </td>
                                    {/* <td className="pr-3 tableAlign">
                                        <button
                                          type="button"
                                          className="btn iq-bg-primary btn-sm"
                                          onClick={() =>
                                            openDeleteDialog(data._id)
                                          }
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
          <GenreDialog />
        </div>
      </div>
    </>
  );
};

export default connect(null, { getGenre, deleteGenre })(Genre);
