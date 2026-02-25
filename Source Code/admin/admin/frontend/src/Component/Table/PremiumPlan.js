import React, { useState, useEffect } from 'react';

//react-router-dom
import { Link } from 'react-router-dom';

//react-redux
import { useDispatch, useSelector } from 'react-redux';
import { connect } from 'react-redux';
import Search from '../assets/images/search.png';

//action
import {
  getPremiumPlan,
  deletePremiumPlan,
} from '../../store/PremiumPlan/plan.action';
import {
  OPEN_PREMIUM_PLAN_DIALOG,
  CLOSE_PREMIUM_PLAN_TOAST,
} from '../../store/PremiumPlan/plan.type';

//Pagination
import TablePaginationActions from './Pagination';
import { TablePagination } from '@mui/material';

//swal
import Swal from 'sweetalert2';

//alert
import { setToast } from '../../util/Toast';
import { warning, alert } from '../../util/Alert';

//dialog
import PremiumPlanDialog from '../Dialog/PremiumPlanDialog';
import Pagination from '../../Pages/Pagination';
import { IconEdit, IconTrash } from '@tabler/icons-react';

const PremiumPlan = (props) => {
  const { loader } = useSelector((state) => state.loader);

  const dispatch = useDispatch();
  const [data, setData] = useState([]);
  const [page, setPage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);



  //get Premium Plan

  useEffect(() => {
    dispatch(getPremiumPlan());
  }, [dispatch]);

  const { premiumPlan, toast, toastData, actionFor } = useSelector(
    (state) => state.premiumPlan
  );

  useEffect(() => {
    setData(premiumPlan);
  }, [premiumPlan]);

  //Open Dialog
  const handleOpen = () => {
    dispatch({ type: OPEN_PREMIUM_PLAN_DIALOG });
  };

  //pagination
  const handleChangePage = (event, newPage) => {
    setPage(event);
  };
  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event, 10));
    setPage(1);
  };

  //Update Dialog
  const updateDialogOpen = (data) => {
    dispatch({ type: OPEN_PREMIUM_PLAN_DIALOG, payload: data });
  };

  // delete sweetAlert
  const openDeleteDialog = (premiumPlanId) => {
    const data = warning();
    data
      .then((result) => {
        if (result.isConfirmed) {

          props.deletePremiumPlan(premiumPlanId);
          Swal.fire('Deleted!', 'Your file has been deleted.', 'success');
        }
      })
      .catch((err) => console.log(err));
  };

  const handleSearch = (e) => {
    const value = e.target.value.toUpperCase()
      ? e.target.value.trim().toUpperCase()
      : e.target.value.trim();

    if (value) {
      const data = premiumPlan.filter((data) => {
        return (
          data?.tag?.toUpperCase()?.indexOf(value) > -1 ||
          data?.dollar?.toString()?.indexOf(value) > -1
        );
      });
      setData(data);
    } else {
      return setData(premiumPlan);
    }
  };

  //toast
  useEffect(() => {
    if (toast) {
      setToast(toastData, actionFor);
      dispatch({ type: CLOSE_PREMIUM_PLAN_TOAST });
    }
  }, [toast, toastData, actionFor, dispatch]);

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          <div className="row">
            <div className="col-sm-12">

              <div className="iq-card mb-5 mt-2">
                <div className="iq-card-header d-flex justify-content-between">
                  <div class="iq-header-title">
                    <h4 class="card-title">Premium Plan</h4>
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
                      <thead>
                        <tr className="text-center">
                          <th>ID</th>
                          <th className='text-left'>Benefit</th>
                          <th>Validity</th>
                          <th>Amount($)</th>
                          <th>Tag</th>

                          <th>Action</th>
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
                            .sort(
                              (a, b) =>
                                a.validity.validityType -
                                b.validity.validityType
                            )
                            .map((data, index) => {
                              return (
                                <>
                                  <tr className="text-center">
                                    <td>{(page - 1) * rowsPerPage + index + 1}</td>
                                    <td className="text-left">
                                      {data?.planBenefit?.map(
                                        (item, index) => {
                                          return (
                                            <>
                                              <p key={index} className="mb-0">
                                                <span
                                                  style={{ color: '#FF2929' }}
                                                >
                                                  ✔{' '}
                                                </span>
                                                {item}
                                              </p>
                                            </>
                                          );
                                        }
                                      )}
                                    </td>
                                    <td>
                                      {data.validity} &nbsp;
                                      {data.validityType}
                                    </td>
                                    <td>{data.dollar}</td>
                                    <td>
                                      {data.tag ? data.tag : '-'}
                                      <span style={{ color: '#06C270' }}>
                                        {' '}
                                        OFF
                                      </span>
                                    </td>


                                    <td>
                                      <div className='d-flex justify-content-center'>
                                        <button
                                          type="button"
                                          className="btn custom-action-button btn-sm mr-2"
                                          onClick={() => updateDialogOpen(data)}
                                        >
                                          <IconEdit className='text-secondary' />
                                        </button>
                                        <button
                                          type="button"
                                          className="btn custom-action-button btn-sm"
                                          onClick={() =>
                                            openDeleteDialog(data._id)
                                          }
                                        >
                                          <IconTrash className='text-secondary' />
                                        </button>
                                      </div>
                                    </td>
                                    {/* <td>
                                        <button
                                          type="button"
                                          className="btn iq-bg-primary btn-sm"
                                          onClick={() =>
                                            openDeleteDialog(data._id)
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
        </div>
      </div>
      <PremiumPlanDialog />
    </>
  );
};

export default connect(null, { getPremiumPlan, deletePremiumPlan })(
  PremiumPlan
);
