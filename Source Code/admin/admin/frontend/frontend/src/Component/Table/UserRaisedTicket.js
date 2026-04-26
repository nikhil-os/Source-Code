import $ from 'jquery';
import { useEffect, useState } from 'react';
import { connect, useDispatch, useSelector } from 'react-redux';
import Pagination from '../../Pages/Pagination';
import {
  action,
  getRaisedTicket,
} from '../../store/UserRestrictedTicket/restricted.action';
import noImage from '../assets/images/noImage.png';
import profile from '../assets/images/singleUser.png';
import { IconCircleCheck } from '@tabler/icons-react';

const UserRaisedTicket = (props) => {
  const { ticketByUser, totalTickets } = useSelector(
    (state) => state.ticketByUser
  );
  const dispatch = useDispatch();

  const { loader } = useSelector((state) => state.loader);


  const [data, setData] = useState([]);
  // const [showURLs, setShowURLs] = useState([]);
  const [activePage, setActivePage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [type, setType] = useState('Pending');

  useEffect(() => {
    dispatch(getRaisedTicket(activePage, rowsPerPage, type));
  }, [dispatch, activePage, rowsPerPage, type]);

  useEffect(() => {
    setData(ticketByUser);
  }, [ticketByUser]);

  //pagination
  const handlePageChange = (pageNumber) => {
    setActivePage(pageNumber);
  };

  const handleRowsPerPage = (value) => {
    setActivePage(1);
    setRowsPerPage(value);
  };
  const handleSolved = (id) => {


    props.action(id);
  };

  // set default image

  $(document).ready(function () {
    $('img').bind('error', function () {
      // Set the default image
      $(this).attr('src', profile);
    });
  });

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid pl-3">
          <div className="row">
            <div className="col-sm-12">
              <div className="iq-card mb-5 mt-2">
                <div className="iq-card-header d-flex justify-content-between">
                  <div class="iq-header-title">
                    <h4 class="card-title">Raised Ticket</h4>
                  </div>
                  <div className="text-center sm ">
                    <div className="d-flex">
                      <button
                        type="button"
                        class={`btn ${type === "Pending" ? "activeBtn" : "noneBtn"
                          }`}
                        style={{ marginRight: "10px", cursor: "pointer" }}
                        data-bs-toggle="modal"
                        id="create-btn"
                        data-bs-target="#showModal"
                        onClick={() => setType("Pending")}
                      >
                        Pending
                      </button>
                      <button
                        type="button"
                        class={`btn ${type === "Solved" ? "activeBtn" : "noneBtn"
                          }`}
                        style={{ cursor: "pointer" }}
                        data-bs-toggle="modal"
                        id="create-btn"
                        data-bs-target="#showModal"
                        onClick={() => setType("Solved")}
                      >
                        Solved
                      </button>
                    </div>
                  </div>
                </div>
                <div className="iq-card-body">
                  <div className="table-responsive custom-table">
                    {type === "Pending" && (
                      <table
                        id="user-list-table"
                        className="table table-striped table-borderless mb-0"
                        role="grid"
                        aria-describedby="user-list-page-info"
                      >
                        <thead class="text-nowrap">
                          <tr>
                            <th className="text-center">No</th>
                            <th className="d-flex justify-content-center align-items-center">
                              User Image
                            </th>
                            <th className="text-center"> Name</th>
                            <th className="text-center"> Contact</th>
                            <th className="text-center"> Description</th>

                            <th className="text-center">Status</th>
                            <th className="text-center">isSolved</th>
                          </tr>
                        </thead>
                        <tbody>
                          {data?.length > 0
                            ? data.map((data, index) => {
                              return (
                                <>
                                  <tr>
                                    <td class="text-center">{(activePage - 1) * rowsPerPage + index + 1}</td>
                                    <td className="text-center">
                                      <img
                                        className="rounded-circle img-fluid avatar-40"
                                        src={data?.userId?.image}
                                        onError={(e) => {
                                          e.target.onerror = null; // Prevents infinite loop
                                          e.target.src = noImage; // Default image path
                                        }}
                                        alt=""
                                        style={{ objectFit: "cover" }}
                                      />
                                    </td>

                                    <td className="text-center text-capitalize">
                                      {data?.userId?.fullName}
                                    </td>
                                    <td className="text-center text-capitalize">
                                      {data?.contactNumber
                                        ? data?.contactNumber
                                        : "-"}
                                    </td>
                                    <td className="text-center text-capitalize">
                                      {data?.description
                                        ? data?.description
                                        : "-"}
                                    </td>
                                    <td className="text-center text-capitalize">
                                      {data?.status}
                                    </td>

                                    <td className="text-center">
                                      <button
                                        type="button"
                                        className="btn custom-action-button btn-sm py-1"
                                        onClick={() =>
                                          handleSolved(data?._id)
                                        }
                                      >
                                        <IconCircleCheck className="text-secondary" />
                                      </button>
                                    </td>
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
                    )}
                    {type === "Solved" && (
                      <table
                        id="user-list-table"
                        className="table table-striped table-borderless mb-0"
                        role="grid"
                        aria-describedby="user-list-page-info"
                      >
                        <thead class="text-nowrap">
                          <tr>
                            <th className="text-center">No</th>
                            <th className="d-flex justify-content-center align-items-center">
                              Image
                            </th>
                            <th className="text-center"> Name</th>
                            <th className="text-center"> Contact</th>
                            <th className="text-center"> Description</th>

                            <th className="text-center">Status</th>
                          </tr>
                        </thead>
                        <tbody>
                          {data?.length > 0
                            ? data.map((data, index) => {
                              return (
                                <>
                                  <tr>
                                    <td class="text-center">{index + 1}</td>
                                    <td className="text-center">
                                      <img
                                        className="rounded-circle img-fluid avatar-40"
                                        src={data?.userId?.image}
                                        onError={(e) => {
                                          e.target.onerror = null; // Prevents infinite loop
                                          e.target.src = noImage; // Default image path
                                        }}
                                        alt=""
                                        style={{ objectFit: "cover" }}
                                      />
                                    </td>

                                    <td className="text-center text-capitalize">
                                      {data?.userId?.fullName}
                                    </td>
                                    <td className="text-center text-capitalize">
                                      {data?.contactNumber
                                        ? data?.contactNumber
                                        : "-"}
                                    </td>
                                    <td className="text-center text-capitalize">
                                      {data?.description
                                        ? data?.description
                                        : "-"}
                                    </td>
                                    <td className="text-center text-capitalize">
                                      {data?.status}
                                    </td>
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
                    )}
                  </div>
                </div>
                <div className="iq-card-footer">
                  <Pagination
                    activePage={activePage}
                    rowsPerPage={rowsPerPage}
                    userTotal={totalTickets}
                    handleRowsPerPage={handleRowsPerPage}
                    handlePageChange={handlePageChange}
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default connect(null, { getRaisedTicket, action })(UserRaisedTicket);
