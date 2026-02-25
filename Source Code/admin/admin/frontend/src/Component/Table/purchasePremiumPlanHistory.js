import { useEffect, useState } from "react";

//jquery
import $ from "jquery";

//dayjs
import dayjs from "dayjs";

//redux
import { connect, useSelector } from "react-redux";

//action
import { premiumPlanHistory } from "../../store/PremiumPlan/plan.action";

//routing

import PurchasePremiumPlan from "./History/PurchasePremiumPlan";

//MUI icon

// //Date Range Picker
// import { DateRangePicker } from "react-date-range";

//datepicker
import "bootstrap-daterangepicker/daterangepicker.css";
import DateRangePicker from "react-bootstrap-daterangepicker";

//Calendar Css
import "react-date-range/dist/styles.css"; // main style file
import "react-date-range/dist/theme/default.css"; // theme css file

//Pagination
import Pagination from "../../Pages/Pagination";



//useStyle

const PurchasePremiumPlanTable = (props) => {
   
  const [data, setData] = useState([]);
  const [activePage, setActivePage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);

  const [date, setDate] = useState([]);
  const [sDate, setsDate] = useState("ALL");
  const [eDate, seteDate] = useState("ALL");
  const { history, totalPlan } = useSelector((state) => state.premiumPlan);

  useEffect(() => {
    $("#card").click(() => {
      $("#datePicker").removeClass("show");
    });
  }, []);

  useEffect(() => {
    props.premiumPlanHistory(null, activePage, rowsPerPage, sDate, eDate); 
  }, [activePage, rowsPerPage, sDate, eDate]);

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
    $("#datePicker").removeClass("show");
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
    setsDate("ALL");
    seteDate("ALL");
    $("#datePicker").removeClass("show");
    props.premiumPlanHistory(null, activePage, rowsPerPage, sDate, eDate);
  };

  const collapsedDatePicker = () => {
    $("#datePicker").toggleClass("collapse");
  };

  //Apply button function for analytic
  const handleApply = (event, picker) => {
    const start = dayjs(picker.startDate).format("YYYY-MM-DD");
    const end = dayjs(picker.endDate).format("YYYY-MM-DD");
    setsDate(start);
    seteDate(end);
  };

  //Cancel button function for analytic
  const handleCancel = (event, picker) => {
    picker.element.val("");
    setsDate("");
    seteDate("");
    props.premiumPlanHistory(null, activePage, rowsPerPage, sDate, eDate);
  };

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          <div className="row">
            <div className="col-sm-12">
              

              <div className="iq-card mb-5 mt-2" id="card">
                <div className="iq-card-header">
                <div class="iq-header-title w-100">
                <h4 class="card-title">Purchase Plan History</h4>
              </div>
                  <div className="d-flex justify-content-end w-100">
                    <button
                      className="btn btn-primary mr-1"
                      onClick={getAllHistory}
                    >
                      All
                    </button>
                    <div>
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
                    </div>
                    {sDate === "" ||
                    eDate === "" ||
                    sDate === "ALL" ||
                    sDate === "ALL" ? (
                      ""
                    ) : (
                      <div className="align-items-center d-flex dateShow fs-5 ml-2">
                        <span className="mr-1">{sDate}</span>
                        <span className="mr-1">To</span>
                        <span>{eDate}</span>
                      </div>
                    )}
                    <div
                      id="datePicker2"
                      className="collapse mt-5 pt-3 pl-5 ml-5"
                      aria-expanded="false"
                    >
                      <div className="container table-responsive">
                        <div key={JSON.stringify(date)}>
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
                              class="daterange form-control float-left bg-primary text-white"
                              placeholder="Select Date"
                              style={{ width: 120, fontWeight: 700 }}
                            />
                          </DateRangePicker>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="iq-card-body">
                  <PurchasePremiumPlan data={data} activePage={activePage} rowsPerPage={rowsPerPage} />
                </div>
                <div className="iq-card-footer border-t-0">
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

export default connect(null, { premiumPlanHistory })(PurchasePremiumPlanTable);
