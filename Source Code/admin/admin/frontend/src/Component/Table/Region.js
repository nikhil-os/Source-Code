import { useEffect, useState } from "react";

//react-router-dom
import Pagination from "../../Pages/Pagination";

//Pagination

//Alert
import Swal from "sweetalert2";

//react-redux
import { connect, useDispatch, useSelector } from "react-redux";

//alert
// import dayjs from "dayjs";
import { warning } from "../../util/Alert";
import { setToast } from "../../util/Toast";

//action
import { deleteRegion, getRegion } from "../../store/Region/region.action";
import {
  CLOSE_REGION_TOAST,
  OPEN_REGION_DIALOG,
} from "../../store/Region/region.type";

//component
import { IconEdit } from "@tabler/icons-react";
import arraySort from "array-sort";
import RegionDialog from "../Dialog/RegionDialog";
import dayjs from "dayjs";

const Region = (props) => {
  const { loader } = useSelector((state) => state.loader);

  const [page, setPage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [data, setData] = useState([]);
  const [nameSort, setNameSort] = useState(true);



  const dispatch = useDispatch();

  //useEffect for Get Data
  useEffect(() => {
    dispatch(getRegion());
  }, [dispatch]);

  const { region, toast, toastData, actionFor } = useSelector(
    (state) => state.region
  );

  //Set Data after Getting
  useEffect(() => {
    setData(region);
  }, [region]);

  //Open Dialog
  const handleOpen = () => {
    dispatch({ type: OPEN_REGION_DIALOG });
  };

  //Update Dialog
  const updateDialogOpen = (data) => {
    dispatch({ type: OPEN_REGION_DIALOG, payload: data });
  };
  // delete sweetAlert
  const openDeleteDialog = (regionId) => { // eslint-disable-line no-unused-vars
    const data = warning();
    data
      .then((result) => {
        if (result.isConfirmed) {

          props.deleteRegion(regionId);
          Swal.fire("Deleted!", "Your file has been deleted.", "success");
        }
      })
      .catch((err) => console.log(err));
  };

  //toast
  useEffect(() => {
    if (toast) {
      setToast(toastData, actionFor);
      dispatch({ type: CLOSE_REGION_TOAST });
    }
  }, [toast, toastData, actionFor, dispatch]);

  //for search
  const handleSearch = (e) => {
    const value = e.target.value.trim().toUpperCase();
    if (value) {
      const data = region.filter((data) => {
        return data?.name?.toUpperCase()?.indexOf(value) > -1;
      });
      setData(data);
    } else {
      return setData(region);
    }
  };

  //pagination
  const handleChangePage = (event, newPage) => {
    // console.log("event->" , event , newPage);
    setPage(event);
  };
  const handleChangeRowsPerPage = (event) => {
    // console.log("event->" , event);
    setRowsPerPage(parseInt(event, 10));
    setPage(1);
  };

  const handlenameSort = () => {
    setNameSort(!nameSort);
    arraySort(data, "name", { reverse: nameSort });
  };

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid pl-3">
          <div className="row">
            <div className="col-sm-12">
              <div className="iq-card mb-5  mt-2">
                <div className="iq-card-header d-flex justify-content-between ">
                  <div class="iq-header-title">
                    <h4 class="card-title">Region</h4>
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
                          <th
                            onClick={handlenameSort}
                            style={{ cursor: "pointer" }}
                          >
                            Name {nameSort ? " ▼" : " ▲"}
                          </th>
                          {/* <th>Country Code</th> */}
                          <th>Created At</th>
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
                                      {(page - 1) * rowsPerPage + index + 1}
                                    </td>

                                    <td className="text-center">
                                      {data?.name || "-"}
                                    </td>
                                    {/* <td className="text-center">
                                        {data?.uniqueID ||  "-"}
                                      </td> */}
                                    <td className="text-center">
                                      {data?.createdAt ? dayjs(data.createdAt).format("DD/MM/YYYY") : "-"}

                                    </td>

                                    <td className="pr-3 tableAlign">
                                      <button
                                        type="button"
                                        className="btn custom-action-button btn-sm"
                                        onClick={() => updateDialogOpen(data)}
                                      >
                                        <IconEdit className="text-secondary" />
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
                      { label: "All", value: data.length },
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
          <RegionDialog />
        </div>
      </div>
    </>
  );
};

export default connect(null, { getRegion, deleteRegion })(Region);
