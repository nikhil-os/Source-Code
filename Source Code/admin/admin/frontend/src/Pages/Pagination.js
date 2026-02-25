import React from "react";

//pagination
import TablePagination from "react-js-pagination";
import { useSelector } from "react-redux";

const Pagination = (props) => {
  const handlePage = (page) => {
    props.handlePageChange(page);
  };
  const handleRowsPerPage = (value) => {
    props.handleRowsPerPage(value);
  }; 

  const isLoading = useSelector((state) => state.loader.loader);

  return (
    <>
      {props.userTotal ? (
        <div className="d-md-flex justify-content-between align-items-center">
          <div className="d-flex align-items-center">
            <span>Rows Per Page</span>
            <select
              class=" mx-2 mb-2 mb-md-0 mb-lg-0 dropdown  "
              style={{
                // borderColor: "#112935",
                // background: "#112935",
                color: "black",
                borderRadius: "5px",
              }}
              onChange={(e) => {
                handleRowsPerPage(e.target.value);
              }}
            >
              <option  value="5">
                5
              </option>
              <option  value="10" selected>
                10
              </option>
              <option  value="25">
                25
              </option>
              <option  value="50">
                50
              </option>
              <option  value="100">
                100
              </option>
              <option  value="200">
                200
              </option>
              <option  value="500">
                500
              </option>
              <option  value="1000">
                1000
              </option>
              <option  value="5000">
                5000
              </option>
            </select>
          </div>
          <div className="align-middle">
            <TablePagination
              activePage={props.activePage}
              itemsCountPerPage={props.rowsPerPage}
              totalItemsCount={props.userTotal}
              pageRangeDisplayed={2}
              onChange={(page) => handlePage(page)}
              itemClass="page-item"
              linkClass="align-middle page-link text-center"
              itemClassFirst="paginationClass"
              itemClassNext="paginationClass"
              itemClassLast="paginationClass"
              itemClassPrev="paginationClass"
              className={"m-0"}
            />
          </div>
        </div>
      ) : (
        <div className="d-flex justify-content-center">
        {
          isLoading ? <h6>Loading...</h6> : <h6>No Data Found</h6>
        }
          {/* <h6>No Data Found</h6>
          {isLoading ? "Loading" : ""} */}
        </div>
      )}
    </>
  );
};

export default Pagination;
