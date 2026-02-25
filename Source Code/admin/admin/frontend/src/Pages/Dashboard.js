import React, { useEffect, useState } from "react";

//routing
import { useHistory } from "react-router-dom";

//redux
import { useDispatch, useSelector } from "react-redux";
import { connect } from "react-redux";

//dayjs
import dayjs from "dayjs";

//action
import {
  getDashboard,
  getAnalytic,
  getCountryWiseUser,
  getMovieSeriesAnalytic,
} from "../store/dashboard/dashboard.action";
import { getTop10Movie, getTop10WebSeries } from "../store/Movie/movie.action";
import Chart from "react-apexcharts";

//datepicker
import DateRangePicker from "react-bootstrap-daterangepicker";

import "apexcharts/dist/apexcharts.css";

//type
import { MOVIE_DETAILS } from "../store/Movie/movie.type";
import { TV_SERIES_DETAILS } from "../store/TvSeries/tvSeries.type";

// icon
import user from "../Component/assets/images/dashUser.png";
import movieIcon from "../Component/assets/images/dashMovie.png";
import webSeriesIcon from "../Component/assets/images/dashWebSeries.png";
import revenueIcon from "../Component/assets/images/dashRevenue.png";
import { IconEditCircle, IconInfoCircle, IconUsers } from "@tabler/icons-react";

const Dashboard = (props) => {
  const dispatch = useDispatch();
  const history = useHistory();
  const [movies, setMovies] = useState([]);
  const [WebSeries, setWebSeries] = useState([]);

  let label = [];
  let dataUser = [];
  let movieLabel = [];
  let dataMovie = [];
  let data = ["no data found!!"];

  const [type, setType] = useState("User");
  const [chartType, setChartType] = useState("Movie");

  var date = new Date();
  var firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
  var lastDay = new Date();

  const startDate = dayjs(firstDay).format("YYYY-MM-DD");
  const endDate = dayjs(lastDay).format("YYYY-MM-DD");

  const [sDate, setSDate] = useState(startDate);
  const [eDate, setEDate] = useState(endDate);
  const [analyticData, setAnalyticData] = useState([]);
  const [analyticMovieData, setAnalyticMovieData] = useState([]);

  const { dashboard } = useSelector((state) => state.dashboard);
  const { analytic, movieAnalytic } = useSelector((state) => state.dashboard);

  //Get Data
  useEffect(() => {
    dispatch(getDashboard());
    dispatch(getAnalytic("User", sDate, eDate));
    dispatch(getMovieSeriesAnalytic("Movie", sDate, eDate));
    dispatch(getTop10Movie());
    dispatch(getTop10WebSeries());
    dispatch(getCountryWiseUser());
  }, [dispatch]);

  // user Revenue Data
  useEffect(() => {
    setAnalyticData(analytic);
  }, [analytic]);

  // movie series data
  useEffect(() => {
    setAnalyticMovieData(movieAnalytic);
  }, [movieAnalytic]);

  const { movie, web_Series } = useSelector((state) => state.movie);

  useEffect(() => {
    setMovies(movie);
  }, [movie]);

  useEffect(() => {
    setWebSeries(web_Series);
  }, [web_Series]);

  if (analyticData?.length > 0) {
    if (type === "User" || type === "Revenue") {
      if (type === "User") {
        analyticData.map((data_) => {
          const newDate = data_._id;

          var date;
          if (newDate._id) {
            date = newDate?._id.split("T");
          } else {
            date = newDate.split("T");
          }
          date?.length > 0 && label.push(date[0]);
          dataUser.push(data_.count);
        });
      } else {
        analyticData.map((data_) => {
          const newDate = data_?._id;
          const date = newDate?.split("T");
          date?.length > 0 && label.push(date[0]);
          dataUser.push(data_.dollar);
        });
      }
    }
  }

  if (analyticMovieData?.length > 0) {
    if (chartType === "Movie" || chartType === "WebSeries") {
      analyticMovieData.map((data_) => {
        const newDate = data_._id;
        const date = newDate.split("T");
        movieLabel.push(date[0]);
        dataMovie.push(data_.count);
      });
    }
  }

  const handleAnalytic = (type) => {
    setSDate(startDate);
    setEDate(endDate);
    setType(type);
    if (type === "User" || type === "Revenue") {
      dispatch(getAnalytic(type, startDate, endDate));
    } else if (chartType === "Movie" || chartType === "WebSeries") {
      dispatch(getMovieSeriesAnalytic(chartType, startDate, endDate));
    }
  };

  const handleAnalyticsChart = (chartType) => {
    setSDate(startDate);
    setEDate(endDate);
    setChartType(chartType);
    dispatch(getMovieSeriesAnalytic(chartType, startDate, endDate));
  };

  var state = {
    options: {
      chart: {
        width: "100%",
        height: 350,
        type: "area",
        stroke: {
          curve: "smooth",
          width: 3,
        },

        zoom: {
          type: "x",
          enabled: false,
          autoScaleYaxis: false,
        },
        toolbar: {
          autoSelected: "zoom",
        },
      },
      colors: ["rgb(45,60,58)"],
      xaxis: {
        categories: label,
      },
      stroke: {
        show: true, // Show line on the area chart
        curve: "smooth", // Set the curve for the line ('smooth' or 'straight')
        width: 2, // Adjust the line width
        colors: undefined, // You can set a specific color for the line
      },
    },
    series: [
      {
        name: "User",
        data: dataUser,
      },
    ],
  };

  var stateData = {
    options: {
      chart: {
        type: "area",
        width: "100%",
        height: 350,

        zoom: {
          type: "x",
          enabled: false,
          autoScaleYaxis: false,
        },
        toolbar: {
          autoSelected: "zoom",
        },
        fill: {
          type: "gradient",
          gradient: {
            shadeIntensity: 1,
            opacityFrom: 0.4,
            opacityTo: 0.9,
            stops: [0, 90, 100],
          },
        },
      },
      colors: ["rgb(45,60,58)"],
      xaxis: {
        categories: movieLabel,
      },
    },
    series: [
      {
        name: "Movie",
        data: dataMovie,
      },
    ],
  };

  const handleResize = () => {
    const width = this.chartRef.current.clientWidth;
    if (width < 600) {
      this.chart.updateOptions({
        chart: {
          height: 200,
          width: "100%",
        },
      });
    } else {
      this.chart.updateOptions({
        chart: {
          height: 400,
          width: "80%",
        },
      });
    }
  };

  const chartData = {
    labels: label,
    datasets: [
      {
        label: type,
        data: dataUser,
        fill: true,
        fillOpacity: 1,
        backgroundColor: "rgba(255,255,255, 0.01)",
        borderColor: "hsl(253deg 61% 55%)",
        lineTension: 0.5,
      },
    ],
  };

  var stateRevenue = {
    options: {
      chart: {
        type: "area",
        width: "100%",
        height: 350,

        zoom: {
          type: "x",
          enabled: false,
          autoScaleYaxis: false,
        },
        toolbar: {
          autoSelected: "zoom",
        },
        fill: {
          type: "gradient",
          gradient: {
            shadeIntensity: 1,
            opacityFrom: 0.4,
            opacityTo: 0.9,
            stops: [0, 90, 100],
          },
        },
      },
      colors: ["rgb(45,60,58)"],
      xaxis: {
        categories: label,
      },
    },
    series: [
      {
        name: "Revenue",
        data: dataUser,
      },
    ],
  };

  const defaultChartData = {
    labels: label,
    datasets: [
      {
        label: type,
        data: data,
        fill: true,
        fillOpacity: 1,
        backgroundColor: "rgba(255,255,255, 0.01)",
        borderColor: "hsl(253deg 61% 55%)",
        lineTension: 0.5,
      },
    ],
  };

  const analciteChartData = {
    labels: movieLabel,
    datasets: [
      {
        label: chartType,
        data: dataMovie,
        fill: true,
        fillOpacity: 1,
        backgroundColor: "rgba(255,255,255, 0.01)",
        borderColor: "hsl(253deg 61% 55%)",
        lineTension: 0.5,
      },
    ],
  };

  const defaultAnalciteChartData = {
    labels: movieLabel,
    datasets: [
      {
        label: chartType,
        data: data,
        fill: true,
        fillOpacity: 1,
        backgroundColor: "rgba(255,255,255, 0.01)",
        borderColor: "hsl(253deg 61% 55%)",
        lineTension: 0.5,
      },
    ],
  };

  //Apply button function for analytic
  const handleApply = (event, picker) => {
    if (type === "User" || type === "Revenue") {
      picker.element.val(
        picker.startDate.format("M/DD/YYYY") +
        " - " +
        picker.endDate.format("M/DD/YYYY")
      );
      const dayStart = dayjs(picker.startDate).format("M/DD/YYYY");
      const dayEnd = dayjs(picker.endDate).format("M/DD/YYYY");

      setSDate(dayStart);
      setEDate(dayEnd);

      dispatch(getAnalytic(type, dayStart, dayEnd));
    }
  };

  const handleApplyMovie = (event, picker) => {
    if (chartType === "Movie" || chartType === "WebSeries") {
      picker.element.val(
        picker.startDate.format("M/DD/YYYY") +
        " - " +
        picker.endDate.format("M/DD/YYYY")
      );
      const dayStart = dayjs(picker.startDate).format("M/DD/YYYY");
      const dayEnd = dayjs(picker.endDate).format("M/DD/YYYY");

      setSDate(dayStart);
      setEDate(dayEnd);

      dispatch(getMovieSeriesAnalytic(chartType, dayStart, dayEnd));
    }
  };

  //Cancel button function for analytic
  const handleCancel = (event, picker) => {
    picker.element.val("");
    dispatch(getAnalytic(type, startDate, endDate));
  };
  const handleMovieCancel = (event, picker) => {
    picker.element.val("");
    dispatch(getMovieSeriesAnalytic(chartType, startDate, endDate));
  };

  //Total Of All
  // const total =
  //   dashboard?.movie +
  //   dashboard?.user +
  //   dashboard?.revenue?.dollar +
  //   dashboard?.series;

  const total =
    (dashboard?.movie ?? 0) +
    (dashboard?.user ?? 0) +
    (dashboard?.revenue?.dollar ?? 0) +
    (dashboard?.series ?? 0);

  // Safe percentage calculation
  const safePercent = (value) => {
    return total > 0 ? ((value * 100) / total).toFixed(2) : 0;
  };

  //Percentage Of Every Table
  // const userPer = ((dashboard?.user * 100) / total).toFixed(2);
  // const moviePer = ((dashboard?.movie * 100) / total).toFixed(2);
  // const revenuePer = ((dashboard?.revenue?.dollar * 100) / total).toFixed(2);
  // const webSeriesPer = ((dashboard?.series * 100) / total).toFixed(2);
  // const userPer = (
  //   isNaN(total) ? 0 : ((dashboard?.user ?? 0) * 100) / total
  // ).toFixed(2);
  // const moviePer = (
  //   isNaN(total) ? 0 : ((dashboard?.movie ?? 0) * 100) / total
  // ).toFixed(2);
  // const revenuePer = (
  //   isNaN(total) ? 0 : ((dashboard?.revenue?.dollar ?? 0) * 100) / total
  // ).toFixed(2);
  // const webSeriesPer = (
  //   isNaN(total) ? 0 : ((dashboard?.series ?? 0) * 100) / total
  // ).toFixed(2);

  const userPer = safePercent(dashboard?.user ?? 0);
  const moviePer = safePercent(dashboard?.movie ?? 0);
  const revenuePer = safePercent(dashboard?.revenue?.dollar ?? 0);
  const webSeriesPer = safePercent(dashboard?.series ?? 0);

  //Width Set For Progress bar
  const userWidth = userPer + "%";
  const movieWidth = moviePer + "%";
  const revenueWidth = revenuePer + "%";
  const webSeriesWidth = webSeriesPer + "%";

  //Movie Details
  const MovieDetails = (data) => {
    dispatch({ type: MOVIE_DETAILS, payload: data });
    // sessionStorage.setItem("movieDetails", JSON.stringify(data));
    history.push({
      pathname: "/admin/movie/movie_details",
      state: data,
    });
  };

  //Movie Details
  const SeriesDetails = (data) => {
    dispatch({ type: TV_SERIES_DETAILS, payload: data });
    // sessionStorage.setItem("movieDetails", JSON.stringify(data));
    history.push({
      pathname: "/admin/web_series/webSeriesDetail",
      state: data,
    });
  };

  var stateSeries = {
    options: {
      chart: {
        type: "area",
        height: 280,

        zoom: {
          type: "x",
          enabled: false,
          autoScaleYaxis: false,
        },
        toolbar: {
          autoSelected: "zoom",
        },
        fill: {
          type: "gradient",
          gradient: {
            shadeIntensity: 1,
            opacityFrom: 0.4,
            opacityTo: 0.9,
            stops: [0, 90, 100],
          },
        },
      },
      colors: ["rgba(255,255,255, 0.06)"],
      xaxis: {
        categories: movieLabel,
      },
    },
    series: [
      {
        name: "Web Series",
        data: dataMovie,
      },
    ],
  };

  const CustomeCard = ({ link, title, count, icon }) => {
    return (
      <div
        className="col-xl-3 col-sm-6 col-12 cursor-pointer"
      // onClick={() => router.push(link)}
      >
        <div className="card">
          <div className="card-content cursor-pointer">
            <div className="card-body p-4">
              <div className="align-content-center d-flex justify-content-between media">
                <div className="media-body text-left">
                  <h3 className="warning">{count}</h3>
                  <span className="fw-medium">{title}</span>
                </div>
                <div className="align-self-center">{icon}</div>
              </div>
              <div className="progress mt-2 mb-0" style={{ height: 7 }}>
                <div
                  className="progress-bar"
                  role="progressbar"
                  style={{ width: "50%" }}
                  aria-valuenow={50}
                  aria-valuemin={0}
                  aria-valuemax={100}
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  };
  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          <div className="row">
            <div className="col-lg-12">
              <div class="iq-header-title">
                <h4 class="card-title m-0 mb-3">Dashboard</h4>
              </div>

              <div className="row d-flex dashCard mb-2 ml-1">
                <div className="col-12 col-sm-6 col-md-6 col-xl-3  col-lg-3 mb-2 pl-0 w-100">
                  <div className="iq-card-block iq-card-stretch iq-card-height dashboard-card iq-card w-100">
                    <div onClick={() => handleAnalytic("User")}>
                      <div className="d-flex justify-content-between align-items-center">
                        <div class="pt-2">
                          <div className="text-start dashCard-text-user">
                            <h4 className="text-capitalize my-0 dashCard-font-size">
                              Users
                            </h4>
                          </div>

                          <div className="value-box">
                            <h2
                              className="mb-0 ml-1"
                              style={{ marginTop: "11px" }}
                            >
                              <span className="counter">
                                {dashboard?.user ? dashboard?.user : 0}
                              </span>
                            </h2>
                            <p className="mb-0 line-height dashCard_font_color">
                              <i className="ri-arrow-up-line pb-1"></i>
                              {userPer ? userPer : 0}%
                            </p>
                          </div>
                        </div>
                        <div
                          class=" iq-card-icon dark-icon-light  d-flex justify-content-center align-items-center"
                          style={{
                            backgroundColor: "rgba(41, 131, 214, 1)",
                            borderRadius: "15px",
                          }}
                        >
                          <img src={user} class="dashboard-card-icon" alt="" />
                        </div>
                      </div>
                      <div className="iq-progress-bar">
                        <span
                          data-percent={{
                            width: userWidth,
                            height: "6px",
                          }}
                          style={{
                            transition: "width 2s ease 0s",
                            width: userWidth,
                            fontSize: "18px",
                            background: "rgba(41, 131, 214, 1)",
                          }}
                        ></span>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="col-12 col-sm-6 col-md-6 col-xl-3 col-lg-3 mb-2 pl-0 w-100">
                  <div className="iq-card-block iq-card-stretch iq-card-height dashboard-card iq-card w-100">
                    <div onClick={() => handleAnalyticsChart("Movie")}>
                      <div className="d-flex justify-content-between align-items-center">
                        <div class="pt-2">
                          <div className="text-start dashCard-text-movie">
                            <h4 className="text-capitalize my-0 dashCard-font-size">
                              Movies
                            </h4>
                          </div>

                          <div className="value-box">
                            <h2
                              className="mb-0 ml-1"
                              style={{ marginTop: "11px" }}
                            >
                              <span className="counter">
                                {dashboard?.movie ? dashboard?.movie : 0}
                              </span>
                            </h2>
                            <p className="mb-0 line-height dashCard_font_color">
                              <i className="ri-arrow-up-line pb-1"></i>
                              {moviePer ? moviePer : 0}%
                            </p>
                          </div>
                        </div>
                        <div
                          class=" iq-card-icon dark-icon-light  d-flex justify-content-center align-items-center"
                          style={{
                            backgroundColor: "#C33B3B",
                            borderRadius: "15px",
                          }}
                        >
                          <img src={movieIcon} width="50px" alt="" />
                        </div>
                      </div>
                      <div className="iq-progress-bar">
                        <span
                          data-percent={{
                            width: movieWidth,
                            height: "6px",
                          }}
                          style={{
                            transition: "width 2s ease 0s",
                            width: movieWidth,
                            backgroundColor: "#c33b3b",
                          }}
                        ></span>
                      </div>
                    </div>
                  </div>
                </div>

                <div className="col-12 col-sm-6 col-md-6 col-xl-3 col-lg-3 mb-3 pl-0 w-100">
                  <div className="iq-card-block iq-card-stretch iq-card-height dashboard-card iq-card w-100">
                    <div onClick={() => handleAnalyticsChart("WebSeries")}>
                      <div className="d-flex justify-content-between align-items-center">
                        <div class="pt-2">
                          <div className="text-start dashCard-text-webSeries">
                            <h4 className="text-capitalize my-0 dashCard-font-size">
                              Web Series
                            </h4>
                          </div>

                          <div className="value-box">
                            <h2
                              className="mb-0 ml-1"
                              style={{ marginTop: "11px" }}
                            >
                              <span className="counter">
                                {dashboard?.series ? dashboard?.series : 0}
                              </span>
                            </h2>
                            <p className="mb-0 line-height dashCard_font_color">
                              <i className="ri-arrow-up-line pb-1"></i>
                              {webSeriesPer ? webSeriesPer : 0}%
                            </p>
                          </div>
                        </div>
                        <div
                          class="iq-card-icon dark-icon-light  d-flex justify-content-center align-items-center"
                          style={{
                            backgroundColor: "#07A1B6",
                            borderRadius: "15px",
                          }}
                        >
                          <img
                            src={webSeriesIcon}
                            class="dashboard-card-icon"
                            alt=""
                          />
                        </div>
                      </div>
                      <div className="iq-progress-bar">
                        <span
                          data-percent={{
                            width: webSeriesWidth,
                            height: "6px",
                          }}
                          style={{
                            backgroundColor: "#07A1B6",
                            transition: "width 2s ease 0s",
                            width: webSeriesWidth,
                          }}
                        ></span>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="col-12 col-sm-6 col-md-6 col-xl-3  col-lg-3 mb-3 pl-0 w-100">
                  <div className="iq-card-block iq-card-stretch iq-card-height dashboard-card iq-card w-100">
                    <div onClick={() => handleAnalytic("Revenue")}>
                      <div className="d-flex justify-content-between align-items-center">
                        <div class="pt-2">
                          <div className="text-start dashCard-text-revenue">
                            <h4 className="text-capitalize my-0 dashCard-font-size">
                              Revenue
                            </h4>
                          </div>

                          <div className="value-box">
                            <h2
                              className="mb-0 ml-1"
                              style={{ marginTop: "11px" }}
                            >
                              <span className="counter">
                                {dashboard?.revenue?.dollar
                                  ? dashboard?.revenue?.dollar
                                  : 0}
                                $
                              </span>
                            </h2>
                            <p className="mb-0 line-height dashCard_font_color ">
                              <i className="ri-arrow-up-line pb-1"></i>
                              {revenuePer ? revenuePer : 0}%
                            </p>
                          </div>
                        </div>
                        <div
                          class="iq-card-icon dark-icon-light  d-flex justify-content-center align-items-center"
                          style={{
                            backgroundColor: "#0FB032",
                            borderRadius: "15px",
                          }}
                        >
                          <img
                            src={revenueIcon}
                            class="dashboard-card-icon"
                            alt=""
                          />
                        </div>
                      </div>
                      <div className="iq-progress-bar">
                        <span
                          data-percent={{
                            width: revenueWidth,
                            height: "6px",
                          }}
                          style={{
                            backgroundColor: "#0FB032",
                            transition: "width 2s ease 0s",
                            width: revenueWidth,
                          }}
                        ></span>
                      </div>
                    </div>
                  </div>
                </div>


              </div>

              <div className="row mb-2 ">
                <div className="col-lg-6 ">
                  <div class="col-md-12  pl-0 pr-0">
                    <h4 className="m-0 mb-3">{type}</h4>
                    {type === "User" ? (
                      dataUser.length > 0 ? (
                        <>
                          <div class="iq-card iq-card-block iq-card-stretch card_border ">
                            <div
                              class="iq-card-header d-flex justify-content-end"
                              style={{
                                paddingRight: "27px",
                                paddingTop: "23px",
                              }}
                            >
                              <div class="iq-card-header-toolbar d-flex align-items-center">
                                <DateRangePicker
                                  initialSettings={{
                                    autoUpdateInput: false,
                                    locale: {
                                      cancelLabel: "Clear",
                                    },
                                    maxDate: new Date(),
                                  }}
                                  onApply={handleApply}
                                  onCancel={handleCancel}
                                >
                                  <input
                                    readOnly
                                    type="text"
                                    class="form-control float-right"
                                    placeholder="Select Date"
                                    style={{
                                      fontWeight: 500,
                                    }}
                                  />
                                </DateRangePicker>
                              </div>
                            </div>
                            <div class="cartPadding">
                              {/* <Line
                                data={chartData}
                                options={{ responsive: true }}
                                width={1146}
                                height={450}
                                style={{
                                  display: "block",
                                  boxSizing: "border-box",
                                }}
                              /> */}
                              <Chart
                                options={state.options}
                                series={state.series}
                                type="area"
                                height={350}
                              />
                            </div>
                          </div>
                        </>
                      ) : (
                        <div class="iq-card iq-card-block iq-card-stretch card_border">
                          <div
                            class="iq-card-header d-flex justify-content-end"
                            style={{ paddingRight: "27px", paddingTop: "23px" }}
                          >
                            <div class="iq-card-header-toolbar d-flex align-items-center">
                              <DateRangePicker
                                initialSettings={{
                                  autoUpdateInput: false,
                                  locale: {
                                    cancelLabel: "Clear",
                                  },
                                  maxDate: new Date(),
                                }}
                                onApply={handleApply}
                                onCancel={handleCancel}
                              >
                                <input
                                  readOnly
                                  type="text"
                                  class="form-control float-right"
                                  placeholder="Select Date"
                                  style={{
                                    fontWeight: 500,
                                  }}
                                />
                              </DateRangePicker>
                            </div>
                          </div>
                          <div class="cartPadding">
                            {/* <Line
                              data={defaultChartData}
                              options={{ responsive: true }}
                              width={1146}
                              height={450}
                              style={{
                                display: "block",
                                boxSizing: "border-box",
                              }}
                            /> */}
                            <Chart
                              options={state.options}
                              series={state.series}
                              type="line"
                              height={350}
                            />
                          </div>
                        </div>
                      )
                    ) : type === "Revenue" ? (
                      dataUser.length > 0 ? (
                        <>
                          <div class="iq-card iq-card-block iq-card-stretch card_border">
                            <div
                              class="iq-card-header d-flex justify-content-end"
                              style={{
                                paddingRight: "27px",
                                paddingTop: "23px",
                              }}
                            >
                              <div class="iq-card-header-toolbar d-flex align-items-center">
                                <DateRangePicker
                                  initialSettings={{
                                    autoUpdateInput: false,
                                    locale: {
                                      cancelLabel: "Clear",
                                    },
                                    maxDate: new Date(),
                                  }}
                                  onApply={handleApply}
                                  onCancel={handleCancel}
                                >
                                  <input
                                    readOnly
                                    type="text"
                                    class="form-control float-right"
                                    placeholder="Select Date"
                                    style={{
                                      fontWeight: 500,
                                    }}
                                  />
                                </DateRangePicker>
                              </div>
                            </div>
                            <div class="cartPadding">
                              <div className="d-flex justify-content-end"></div>

                              <Chart
                                options={stateRevenue.options}
                                series={stateRevenue.series}
                                type="area"
                                height={350}
                              />
                            </div>
                          </div>
                        </>
                      ) : (
                        <>
                          <div class="iq-card iq-card-block iq-card-stretch card_border">
                            <div
                              class="iq-card-header d-flex justify-content-end"
                              style={{
                                paddingRight: "27px",
                                paddingTop: "23px",
                              }}
                            >
                              <div class="iq-card-header-toolbar d-flex align-items-center">
                                <DateRangePicker
                                  initialSettings={{
                                    autoUpdateInput: false,
                                    locale: {
                                      cancelLabel: "Clear",
                                    },
                                    maxDate: new Date(),
                                  }}
                                  onApply={handleApply}
                                  onCancel={handleCancel}
                                >
                                  <input
                                    readOnly
                                    type="text"
                                    class="form-control float-right"
                                    placeholder="Select Date"
                                    style={{
                                      fontWeight: 500,
                                    }}
                                  />
                                </DateRangePicker>
                              </div>
                            </div>
                            <div class="iq-card-body">
                              <div className="d-flex justify-content-end"></div>

                              <Chart
                                options={stateRevenue.options}
                                series={stateRevenue.series}
                                type="area"
                                height={350}
                              />
                            </div>
                          </div>
                        </>
                      )
                    ) : (
                      <>
                        <div class="iq-card iq-card-block iq-card-stretch card_border">
                          <div
                            class="iq-card-header d-flex justify-content-end"
                            style={{ paddingRight: "27px", paddingTop: "23px" }}
                          >
                            <div class="iq-card-header-toolbar d-flex align-items-center">
                              <DateRangePicker
                                initialSettings={{
                                  autoUpdateInput: false,
                                  locale: {
                                    cancelLabel: "Clear",
                                  },
                                  maxDate: new Date(),
                                }}
                                onApply={handleApply}
                                onCancel={handleCancel}
                              >
                                <input
                                  readOnly
                                  type="text"
                                  class="form-control float-right"
                                  placeholder="Select Date"
                                  style={{
                                    fontWeight: 500,
                                  }}
                                />
                              </DateRangePicker>
                            </div>
                          </div>
                          <div class="cartPadding">
                            <div className="d-flex justify-content-end"></div>

                            <Chart
                              options={stateRevenue.options}
                              series={stateRevenue.series}
                              type="area"
                              height={350}
                            />
                          </div>
                        </div>
                      </>
                    )}
                  </div>
                </div>
                <div className="col-lg-6">
                  <div class="col-md-12  pl-0 pr-0">
                    <h4 className="m-0 mb-3">{chartType}</h4>
                    {chartType === "Movie" ? (
                      dataMovie.length > 0 ? (
                        <>
                          <div class="iq-card iq-card-block iq-card-stretch card_border mr-3">
                            <div
                              class="iq-card-header d-flex justify-content-end"
                              style={{
                                paddingRight: "27px",
                                paddingTop: "23px",
                              }}
                            >
                              <div class="iq-card-header-toolbar d-flex align-items-center">
                                <DateRangePicker
                                  initialSettings={{
                                    autoUpdateInput: false,
                                    locale: {
                                      cancelLabel: "Clear",
                                    },
                                    maxDate: new Date(),
                                  }}
                                  onApply={handleApplyMovie}
                                  onCancel={handleMovieCancel}
                                >
                                  <input
                                    readOnly
                                    type="text"
                                    class="form-control float-right"
                                    placeholder="Select Date"
                                    style={{
                                      fontWeight: 500,
                                    }}
                                  />
                                </DateRangePicker>
                              </div>
                            </div>
                            <div class="cartPadding">
                              <div className="d-flex justify-content-end"></div>

                              <Chart
                                options={stateData.options}
                                series={stateData.series}
                                type="area"
                                height={350}
                              />
                            </div>
                          </div>
                        </>
                      ) : (
                        <>
                          <div class="iq-card iq-card-block iq-card-stretch card_border mx-1">
                            <div
                              class="iq-card-header d-flex justify-content-end"
                              style={{
                                paddingRight: "27px",
                                paddingTop: "23px",
                              }}
                            >
                              <div class="iq-card-header-toolbar d-flex align-items-center">
                                <DateRangePicker
                                  initialSettings={{
                                    autoUpdateInput: false,
                                    locale: {
                                      cancelLabel: "Clear",
                                    },
                                    maxDate: new Date(),
                                  }}
                                  onApply={handleApplyMovie}
                                  onCancel={handleMovieCancel}
                                >
                                  <input
                                    readOnly
                                    type="text"
                                    class="form-control float-right"
                                    placeholder="Select Date"
                                    style={{
                                      fontWeight: 500,
                                    }}
                                  />
                                </DateRangePicker>
                              </div>
                            </div>
                            <div class="cartPadding">
                              <div className="d-flex justify-content-end"></div>

                              <Chart
                                options={stateData.options}
                                series={stateData.series}
                                type="area"
                                height={350}
                              />
                            </div>
                          </div>
                        </>
                      )
                    ) : chartType === "WebSeries" ? (
                      dataMovie.length > 0 ? (
                        <>
                          <div class="iq-card iq-card-block iq-card-stretch card_border mr-3">
                            <div
                              class="iq-card-header d-flex justify-content-end"
                              style={{
                                paddingRight: "27px",
                                paddingTop: "23px",
                              }}
                            >
                              <div class="iq-card-header-toolbar d-flex align-items-center">
                                <DateRangePicker
                                  initialSettings={{
                                    autoUpdateInput: false,
                                    locale: {
                                      cancelLabel: "Clear",
                                    },
                                    maxDate: new Date(),
                                  }}
                                  onApply={handleApplyMovie}
                                  onCancel={handleMovieCancel}
                                >
                                  <input
                                    readOnly
                                    type="text"
                                    class="form-control float-right"
                                    placeholder="Select Date"
                                    style={{
                                      fontWeight: 500,
                                    }}
                                  />
                                </DateRangePicker>
                              </div>
                            </div>
                            <div class="cartPadding">
                              <div className="d-flex justify-content-end"></div>

                              <div id="chart">
                                <Chart
                                  options={stateSeries.options}
                                  series={stateSeries.series}
                                  type="area"
                                  height={350}
                                />
                              </div>
                            </div>
                          </div>
                        </>
                      ) : (
                        <>
                          <div class="iq-card iq-card-block iq-card-stretch card_border mx-1">
                            <div
                              class="iq-card-header d-flex justify-content-end"
                              style={{
                                paddingRight: "27px",
                                paddingTop: "23px",
                              }}
                            >
                              <div class="iq-card-header-toolbar d-flex align-items-center">
                                <DateRangePicker
                                  initialSettings={{
                                    autoUpdateInput: false,
                                    locale: {
                                      cancelLabel: "Clear",
                                    },
                                    maxDate: new Date(),
                                  }}
                                  onApply={handleApplyMovie}
                                  onCancel={handleMovieCancel}
                                >
                                  <input
                                    readOnly
                                    type="text"
                                    class="form-control float-right"
                                    placeholder="Select Date"
                                    style={{
                                      fontWeight: 500,
                                    }}
                                  />
                                </DateRangePicker>
                              </div>
                            </div>
                            <div style={{ padding: "4px 17px 0 17px" }}>
                              <div className="d-flex justify-content-end"></div>

                              <Chart
                                options={stateSeries.options}
                                series={stateSeries.series}
                                type="area"
                                height={350}
                              />
                            </div>
                          </div>
                        </>
                      )
                    ) : (
                      <>
                        <div class="iq-card iq-card-block iq-card-stretch card_border mx-1">
                          <div
                            class="iq-card-header d-flex justify-content-end"
                            style={{ paddingRight: "27px", paddingTop: "23px" }}
                          >
                            <div class="iq-card-header-toolbar d-flex align-items-center">
                              <DateRangePicker
                                initialSettings={{
                                  autoUpdateInput: false,
                                  locale: {
                                    cancelLabel: "Clear",
                                  },
                                  maxDate: new Date(),
                                }}
                                onApply={handleApplyMovie}
                                onCancel={handleMovieCancel}
                              >
                                <input
                                  type="text"
                                  readonly
                                  class="form-control float-right"
                                  placeholder="Select Date"
                                  style={{
                                    fontWeight: 500,
                                  }}
                                />
                              </DateRangePicker>
                            </div>
                          </div>
                          <div style={{ padding: "4px 17px 0 17px" }}>
                            <div className="d-flex justify-content-end"></div>

                            <Chart
                              options={stateSeries.options}
                              series={stateSeries.series}
                              type="area"
                              height={350}
                            />
                          </div>
                        </div>
                      </>
                    )}
                  </div>
                </div>
              </div>
              <div className="row mb-5 ">
                <div className="col-lg-6">
                  <div className="">
                    <div className="iq-card iq-card-block iq-card-stretch  iq-card-height overflow-hidden mt-3">
                      <div className="iq-card-header">
                        <h4 className="card-title">Most viewed movie</h4>
                      </div>
                      <div class="iq-card-body p-0">
                        <div class="table-responsive">
                          <table class="table mb-0 table-borderless">
                            <thead className="dashboard-table border-bottom">
                              <tr className="text-center">
                                <th>ID</th>
                                <th scope="col" className="">
                                  Name
                                </th>
                                <th scope="col">Type</th>

                                <th scope="col">View</th>
                                <th scope="col">Detail</th>
                              </tr>
                            </thead>
                            <tbody>
                              {movies ? (
                                movies.map((data, index) => {
                                  return (
                                    <React.Fragment key={index}>
                                      <tr className="border-bottom">
                                        <td className="text-center">
                                          {index + 1}
                                        </td>

                                        <td className="text-start">
                                          {data?.title?.length > 17
                                            ? data?.title.slice(0, 17) + "...."
                                            : data?.title}
                                        </td>
                                        <td className="pr-3 tableAlign text-center">
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

                                        <td className="text-center">
                                          {data?.view}
                                        </td>

                                        <td className="text-center">
                                          <button
                                            type="button"
                                            className="btn custom-action-button btn-sm"
                                            onClick={() =>
                                              MovieDetails(data._id)
                                            }
                                          >
                                            <IconInfoCircle className="text-secondary" />
                                          </button>
                                        </td>
                                      </tr>
                                    </React.Fragment>
                                  );
                                })
                              ) : (
                                ""
                              )}
                            </tbody>
                          </table>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="col-lg-6 ">
                  <div className="">
                    <div class="iq-card iq-card-block iq-card-stretch  iq-card-height overflow-hidden mt-3">
                      <div className="iq-card-header">
                        <h4 className="card-title">Most Viewed Web Series</h4>
                      </div>
                      <div class="iq-card-body p-0">
                        <div class="table-responsive">
                          <table class="table mb-0 table-borderless ">
                            <thead className="dashboard-table border-bottom">
                              <tr className="text-center">
                                <th>ID</th>
                                <th scope="col">Name</th>
                                <th scope="col">Type</th>
                                <th scope="col">View</th>
                                <th scope="col">Detail</th>
                              </tr>
                            </thead>
                            <tbody>
                              {WebSeries ? (
                                WebSeries.map((data, index) => {
                                  return (
                                    <React.Fragment key={index}>
                                      <tr className="border-bottom">
                                        <td className="text-center">
                                          {index + 1}
                                        </td>

                                        <td className="text-start">
                                          {data?.title?.length > 17
                                            ? data?.title.slice(0, 17) + "...."
                                            : data?.title}
                                        </td>
                                        <td className="pr-3 tableAlign text-center">
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

                                        <td className="text-center">
                                          {data?.view}
                                        </td>

                                        <td className="text-center">
                                          <button
                                            type="button"
                                            className="btn custom-action-button btn-sm"
                                            onClick={() =>
                                              SeriesDetails(data?._id)
                                            }
                                          >
                                            <IconInfoCircle className="text-secondary" />
                                          </button>
                                        </td>
                                      </tr>
                                    </React.Fragment>
                                  );
                                })
                              ) : (
                                ""
                              )}
                            </tbody>
                          </table>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default connect(null, {
  getDashboard,
  getAnalytic,
  getTop10Movie,
  getTop10WebSeries,
  getCountryWiseUser,
  getMovieSeriesAnalytic,
})(Dashboard);
