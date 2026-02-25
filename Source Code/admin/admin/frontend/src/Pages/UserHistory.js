import { useEffect, useState } from "react";

//react-redux
import { connect, useSelector } from "react-redux";

//component
import PurchasePremiumPlan from "../Component/Table/History/PurchasePremiumPlan";

//action
import { premiumPlanHistory } from "../store/PremiumPlan/plan.action";

//jquery
import $ from "jquery";

//dayjs
import dayjs from "dayjs";

//MUI icon

//Date Range Picker
import "bootstrap-daterangepicker/daterangepicker.css";
import DateRangePicker from "react-bootstrap-daterangepicker";
//Calendar Css
import "react-date-range/dist/styles.css"; // main style file
import "react-date-range/dist/theme/default.css"; // theme css file

//Pagination
import Pagination from "../Pages/Pagination";

const UserHistory = (props) => {
  const [data, setData] = useState([]);
  const [activePage, setActivePage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [date, setDate] = useState([]);
  const [sDate, setsDate] = useState("ALL");
  const [eDate, seteDate] = useState("ALL");

  const user = JSON.parse(sessionStorage.getItem("user"));

  const { history, totalPlan } = useSelector((state) => state.premiumPlan);

  useEffect(() => {
    $("#card").click(() => {
      $("#datePicker2").removeClass("show");
    });
  }, []);

  // useEffect(() => {
  //   if(sDate && eDate){

  //     props.premiumPlanHistory(user._id, activePage, rowsPerPage, "ALL", "ALL");
  //   }
  // }, [rowsPerPage, activePage]);

  useEffect(() => {
    props.premiumPlanHistory(user._id, activePage, rowsPerPage, sDate, eDate);
  }, [activePage, rowsPerPage]);

  useEffect(() => {
    setData(history);
  }, [history]);

  useEffect(() => {
    if (date.length === 0) {
      setDate([
        {
          startDate: new Date(),
          endDate: new Date(),
          key: "selection",
        },
      ]);
    }
    $("#datePicker2").removeClass("show");
    setData(history);
  }, [date, history]);

  const handlePageChange = (pageNumber) => {
    setActivePage(pageNumber);
  };

  const handleRowsPerPage = (value) => {
    setActivePage(1);
    setRowsPerPage(value);
  };

  const getAllHistory = () => {
    setActivePage(1);
    setStartDate("");
    setEndDate("");
    $("#datePicker2").removeClass("show");
    // props.vipPlanHistory(null, activePage, rowsPerPage, startDate, endDate);
    props.premiumPlanHistory(user._id, activePage, rowsPerPage, "ALL", "ALL");
  };

  const collapsedDatePicker = () => {
    $("#datePicker2").toggleClass("collapse");
  };

  //Apply button function for analytic
  const handleApply = (event, picker) => {
    const start = dayjs(picker.startDate).format("YYYY-MM-DD");
    const end = dayjs(picker.endDate).format("YYYY-MM-DD");
    setStartDate(start);
    setEndDate(end);

    props.premiumPlanHistory(user._id, activePage, rowsPerPage, start, end);
  };

  //Cancel button function for analytic
  const handleCancel = (event, picker) => {
    picker.element.val("");
    setStartDate("");
    setEndDate("");
    props.premiumPlanHistory(user._id, activePage, rowsPerPage, "ALL", "ALL");
  };
  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          <div className="row">
            <div className="col-sm-12">
              <div className="iq-card mb-5 mt-2" id="card">
                <div className="iq-card-header d-flex justify-content-between ">
                  <div class="iq-header-title w-100">
                    <h4 class="card-title">{user?.fullName}'s History</h4>
                  </div>
                  <div className="row w-100">
                    <div className="col-xs-12 col-sm-12 float-left">
                      <div className="text-left align-sm-left d-md-flex d-lg-flex justify-content-end">
                        <button
                          className="btn btn-primary mr-1"
                          onClick={getAllHistory}
                        >
                          All
                        </button>
                        {/* <button
                          className="collapsed btn btn-primary"
                          value="check"
                          data-toggle="collapse"
                          data-target="#datePicker2"
                          onClick={collapsedDatePicker}
                        >
                          Analytics
                          <ExpandMoreIcon />
                        </button> */}
                        {/* <p style={{ paddingLeft: 10 }} className="my-2 ">
                          {sDate !== "ALL" && sDate + " to " + eDate}
                        </p> */}
                        
                          <DateRangePicker
                            initialSettings={{
                              autoUpdateInput: false,
                              locale: {
                                cancelLabel: "Clear",
                              },
                              maxDate: new Date(),

                              buttonClasses: ["btn btn-dark"],
                            }}
                            onApply={handleApply}
                            onCancel={handleCancel}
                          >
                            <input
                              readOnly
                              type="text"
                              class="btn dark-icon btn-primary"
                              value="Analytics"
                              style={{
                                width: 120,
                              }}
                            />
                          </DateRangePicker>
                        
                        {startDate === "" || endDate === "" ? (
                          ""
                        ) : (
                          <div className="align-items-center d-flex dateShow fs-5 ml-2 ">
                            <span className="mr-1">{startDate}</span>
                            <span className="mr-1">To</span>
                            <span>{endDate}</span>
                          </div>
                        )}
                      </div>
                    </div>
                  
                  </div>
                </div>

                <div className="iq-card-body">
                  <PurchasePremiumPlan data={data} />
                </div>
                <div className="iq-card-footer">
                  <Pagination
                    activePage={activePage}
                    rowsPerPage={rowsPerPage}
                    userTotal={totalPlan}
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

export default connect(null, { premiumPlanHistory })(UserHistory);
