import react, { useEffect, useState } from "react";
import { connect, useDispatch, useSelector } from "react-redux";
import { useLocation } from "react-router-dom";
import $ from "jquery";
//action
import { viewDetails, getComment } from "../../store/TvSeries/tvSeries.action";

//image
import defaultUserPicture from "../assets/images/defaultUserPicture.jpg";
import userDefault from "../assets/images/singleUser.png";
import { useHistory } from "react-router-dom";

//html Parser
import parse from "html-react-parser";
import Slider from "react-slick";

//react player
import ReactPlayer from "react-player";

//react-skeleton
import Skeleton from "react-loading-skeleton";
import "react-loading-skeleton/dist/skeleton.css";
import { colors } from "../assets/js/SkeletonColor";

// antd
import { Popconfirm } from "antd";

//alert

import { OPEN_DIALOG } from "../../store/TvSeries/tvSeries.type";
import noImage from "../../Component/assets/images/noImage.png";
import { IconEdit, IconTrash } from "@tabler/icons-react";

const WebSeriesDetail = (props) => {
  const location = useLocation();
  const dispatch = useDispatch();

  const [data, setData] = useState([]);

  const [comments, setComments] = useState([]);

  const isLoading = useSelector((state) => state.loader.loader);

  const id = location.state;

  useEffect(() => {
    dispatch(viewDetails(id));
    dispatch(getComment(id));
  }, [dispatch]);

  const { movieDetails, comment } = useSelector((state) => state.series);


  useEffect(() => {
    setData(movieDetails ? movieDetails[0] : "");
    setComments(comment ? comment : "");
  }, [movieDetails, comment]);

  var settings = {
    dots: false,
    infinite: false,
    speed: 500,
    slidesToShow: 3,
    slidesToScroll: 1,
    responsive: [
      {
        breakpoint: 1440,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 1,
        },
      },
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 1,
        },
      },

      {
        breakpoint: 600,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 2,
          initialSlide: 1,
          arrows: true,
        },
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 1,
          arrows: true,
        },
      },
    ],
  };

  const settings2 = {
    dots: false,
    infinite: false,
    speed: 500,
    slidesToShow: 5,
    slidesToScroll: 5,
    arrows: true,
    responsive: [
      {
        breakpoint: 1440,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 2,
        },
      },
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 2,
        },
      },
      {
        breakpoint: 889,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 1,
        },
      },
      {
        breakpoint: 600,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 2,
          initialSlide: 2,
          arrows: true,
        },
      },

      {
        breakpoint: 480,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 1,
          arrows: true,
        },
      },
    ],
  };

  const handleDelete = (commentId) => {

    props.deleteComment(commentId);
  };
  //Cast Slider Setting
  const castSliderShimmer = {
    dots: false,
    infinite: false,
    speed: 500,
    slidesToShow: 4,
    slidesToScroll: 3,
    arrows: false,
    responsive: [
      {
        breakpoint: 1440,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 2,
        },
      },
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 2,
        },
      },
      {
        breakpoint: 600,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 2,
          initialSlide: 2,
        },
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 1,
        },
      },
    ],
  };

  //Episode Slider Setting

  const episodeSliderShimmer = {
    dots: false,
    infinite: false,
    speed: 500,
    slidesToShow: 3,
    slidesToScroll: 3,
    arrows: true,
    responsive: [
      {
        breakpoint: 1440,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 1,
        },
      },
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 1,
        },
      },
      {
        breakpoint: 889,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 1,
        },
      },
      {
        breakpoint: 679,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 1,
        },
      },
      {
        breakpoint: 600,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 1,
          initialSlide: 1,
        },
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 1,
        },
      },
    ],
  };

  const history = useHistory();

  //update button
  const updateOpen = (data) => {
    dispatch({ type: OPEN_DIALOG, payload: data });
    sessionStorage.setItem("updateMovieData", JSON.stringify(data));
    sessionStorage.setItem("tvSeriesId", data._id);
    history.push("/admin/web_series/series_form");
  };

  // set default image

  // $(document).ready(function () {
  //   $("img").bind("error", function () {
  //     // Set the default image
  //     $(this).attr("src", defaultUserPicture);
  //     // $(this).css({
  //     //   // Add CSS properties here
  //     //   width: "100px",
  //     //   height: "100px",
  //     //   border: "1px solid red",
  //     //   // Add more CSS properties as needed
  //     // });
  //   });
  // });
  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          {/* <div className="row d-flex align-items-center">
                <div className="col-10">
                  <div class="iq-header-title">
                    <h4 class="card-title mb-3">Web Series Details</h4>
                  </div>
                </div>
                <div className="col-2 px-4">
                  <button
                    type="button"
                    className="btn iq-bg-primary btn-sm float-right "
                    onClick={() => updateOpen(data)}
                  >
                    <i
                      className="ri-pencil-fill"
                      style={{ fontSize: '19px' }}
                    />
                  </button>
                </div>
              </div> */}
          <div className="iq-card mt-2 mb-5">
            <div className="iq-card-header d-flex justify-content-between align-items-center">
              <div class="iq-header-title">
                <h4 class="card-title">Series Details</h4>
              </div>
              <button
                type="button"
                className="btn custom-action-button btn-sm  "
                onClick={() => updateOpen(data)}
              >
                <IconEdit className="text-secondary" />
              </button>
            </div>
            <div className="iq-card-body profile-page p-3 ">
              <div className="profile-header">
                <div className="cover-container">
                  {/* <img
                    src={
                      movieDetails &&
                      movieDetails.length > 0 &&
                      movieDetails[0].image
                        ? movieDetails[0].image
                        : defaultUserPicture
                    }
                    onError={(e) => {
                      e.target.onerror = null; // Prevents infinite loop
                      e.target.src = noImage; // Default image path
                    }}
                    alt="profile-bg"
                    className="img-fluid posterImage"
                  /> */}

                  {data?.image ? (
                    <>
                      <div className="card text-bg-dark">
                        <img
                          src={movieDetails?.[0]?.image}
                          className="card-img img-fluid posterImage"
                          alt="..."
                          onError={(e) => {
                            e.target.onerror = null; // Prevents infinite loop
                            e.target.src = defaultUserPicture; // Default image path
                          }}
                        />
                        <div
                          className="card-img-overlay d-flex justify-content-end align-content-center flex-column pl-5 pb-5"
                          style={{
                            background:
                              "linear-gradient(360deg,rgba(0, 0, 0, 1) 0%, rgba(133, 177, 255, 0) 60%)",
                          }}
                        >
                          <h1 className="m-0 text-white">
                            {data?.title || "-"}
                          </h1>
                          <p
                            className="card-text text-white w-75 fs-5 mb-3 description"
                            style={{ fontSize: "large" }}
                          >
                            {parse(`${data?.description}`) || "-"}
                          </p>
                          <div className="d-flex mb-2 ">
                            <div className="text-white mr-3">
                              Type : {"  "}
                              <span className="badge badge-primary">
                                {data?.type || "-"}
                              </span>
                            </div>

                            <div className="text-white mr-3">
                              Region : {"  "}
                              <span className="badge badge-success">
                                {data?.region?.name || "-"}
                              </span>
                            </div>
                            <div className="text-white mr-3">
                              Genre : {"  "}
                              {data?.genre?.map((genreData) => {
                                return (
                                  <span className="badge badge-warning mr-1">
                                    {genreData.name || "-"}
                                  </span>
                                );
                              })}
                            </div>

                            <div className="text-white mr-3">
                              Year : {"  "}
                              <span className="badge badge-secondary">
                                {data?.year || "-"}
                              </span>
                            </div>
                          </div>
                          {/* <p className="card-text text-white">{data?.year}</p> */}
                        </div>
                      </div>
                    </>
                  ) : (
                    <>
                      <div
                        className="iq-card mb-4"
                        style={{
                          margin: " 5px",
                          borderRadius: "5px",
                        }}
                      >
                        <div
                          className="card-body"
                          style={{
                            padding: "0px",
                            borderRadius: "5px",
                          }}
                        >
                          <div
                            style={{
                              height: "550px",
                            }}
                          >
                            <Skeleton
                              style={{
                                height: "550px",
                                objectFit: "cover",
                                width: "100%",
                                borderRadius: "5px 5px 0 0",
                                lineHeight: "normal",
                              }}
                              className="card__pic"
                              containerClassName="avatar-skeleton"
                              baseColor={colors.baseColor}
                              highlightColor={colors.highlightColor}
                            />
                          </div>
                        </div>
                      </div>
                    </>
                  )}
                </div>
                <div className="profile-info ">
                  {/* <div className="row">
                    <div className="col-md-2 iq-item-product-left thumbnailPoster d-flex justify-content-start">
                      <img
                        src={
                          movieDetails && movieDetails[0]?.thumbnail
                            ? movieDetails[0]?.thumbnail
                            : movieDefault
                        }
                        onError={(e) => {
                          e.target.onerror = null; // Prevents infinite loop
                          e.target.src = noImage; // Default image path
                        }}
                        alt="profile-img"
                        className="img-fluid"
                        width="200"
                        style={{ borderRadius: "2px", objectFit: "cover" }}
                      />
                    </div>
                    <div className="col-md-10 iq-item-product-left mt-3">
                      <h3 className="m-0">{data?.title}</h3>

                      <div className="row movie-web-details-font">
                        <div className="col-12 col-md-3">
                          <form>
                            <table>
                              <tr style={{ backgroundColor: "transparent" }}>
                                <td
                                  className="py-2 mb-2 fw-bold"
                                  style={{ color: "#4989F7" }}
                                >
                                  Year
                                </td>
                                <td
                                  className="py-2 mb-2 "
                                  style={{ color: "#4989F7" }}
                                >
                                  &nbsp;:&nbsp;&nbsp;
                                </td>
                                <td className="text-black fw-bold">
                                  {data?.year}
                                </td>
                              </tr>

                              <tr style={{ backgroundColor: "transparent" }}>
                                <td
                                  className="py-2 mb-2 fw-bold"
                                  style={{ color: "#4989F7" }}
                                >
                                  Run time
                                </td>
                                <td
                                  className="py-2 mb-2 "
                                  style={{ color: "#4989F7" }}
                                >
                                  &nbsp;:&nbsp;&nbsp;
                                </td>
                                <td className="text-black fw-bold">
                                  {data?.runtime
                                    ? data?.runtime + "minutes"
                                    : "-"}
                                </td>
                              </tr>

                              <tr style={{ backgroundColor: "transparent" }}>
                                <td
                                  className="py-2 mb-2 fw-bold"
                                  style={{ color: "#4989F7" }}
                                >
                                  Type
                                </td>
                                <td
                                  className="py-2 mb-2 "
                                  style={{ color: "#4989F7" }}
                                >
                                  &nbsp;:&nbsp;&nbsp;
                                </td>
                                <td className="text-black fw-bold">
                                  {data?.type || "-"}
                                </td>
                              </tr>

                              <tr style={{ backgroundColor: "transparent" }}>
                                <td
                                  className="py-2 mb-2 fw-bold"
                                  style={{ color: "#4989F7" }}
                                >
                                  Region
                                </td>
                                <td
                                  className="py-2 mb-2 "
                                  style={{ color: "#4989F7" }}
                                >
                                  &nbsp;:&nbsp;&nbsp;
                                </td>
                                <td className="text-black fw-bold ">
                                  {data?.region?.name || "-"}
                                </td>
                              </tr>
                            </table>
                          </form>
                        </div>
                        <div className="col-12 col-md-9">
                          <from>
                            <table>
                              <tr style={{ backgroundColor: "transparent" }}>
                                <td
                                  className="py-2 mb-2 fw-bold"
                                  style={{ color: "#4989f7" }}
                                >
                                  Genre
                                </td>
                                <td
                                  className="py-2 mb-2"
                                  style={{ color: "#4989f7" }}
                                >
                                  &nbsp;:&nbsp;&nbsp;
                                </td>
                                <td className="text-black fw-bold">
                                  {data?.genre?.map((genreData) => {
                                    return genreData?.name + ",";
                                  })}
                                </td>
                              </tr>
                              <tr style={{ backgroundColor: "transparent" }}>
                                <td
                                  className="py-2 mb-2 align-top fw-bold"
                                  style={{ color: "#4989f7" }}
                                >
                                  Description
                                </td>
                                <td
                                  className="py-2 mb-2 align-top"
                                  style={{ color: "#4989f7" }}
                                >
                                  &nbsp;:&nbsp;&nbsp;
                                </td>
                                <td className="text-black fw-bold">
                                  {parse(`${data?.description}`)}
                                </td>
                              </tr>
                            </table>
                          </from>
                        </div>
                      </div>
                    </div>
                  </div> */}

                  <div className="col-sm-12 product-description-details mt-4 pl-0">
                    <h4 className="m-0">Thumbnail</h4>

                    <div>
                      <img src={data?.thumbnail} style={{ height: 350, width: 300, borderRadius: 5 }} alt="" className="border" onError={(e) => {
                        e.target.onerror = null; // Prevents infinite loop
                        e.target.src = noImage; // Default image path
                      }} />
                    </div>

                  </div>

                  {/* --------- episode ---------- */}

                  <div className="col-sm-12 product-description-details mt-4 p-0">
                    <h4 className="m-0">Episodes</h4>

                    <Slider {...episodeSliderShimmer}>
                      {data.episode?.length > 0 ? (
                        data.episode.map((trailerValue, index) => {
                          return (
                            <>
                              <div style={{ margin: "15px" }}>
                                <div
                                  className="iq-card"
                                  style={{
                                    borderRadius: "5px",
                                  }}
                                  key={index} // Ensure to add a unique key to each element
                                >
                                  <div
                                    className="iq-card-body"
                                    style={{
                                      padding: "0px",
                                      borderRadius: "5px",
                                    }}
                                  >
                                    <div>
                                      <div className="card__pic">
                                        <img
                                          src={trailerValue?.image}
                                          onError={(e) => {
                                            e.target.onerror = null; // Prevents infinite loop
                                            e.target.src = noImage; // Default image path
                                          }}
                                          alt=""
                                          width="100%"
                                          height="220px"
                                          style={{
                                            borderRadius: "5px 5px 0px 0px ",
                                            objectFit: "cover",
                                          }}
                                        />
                                      </div>
                                    </div>
                                    {/* <YouTube video={trailerValue?.key} autoplay /> */}

                                    <div className="p-3">
                                      <h6 className="m-0">
                                        {trailerValue?.name}
                                      </h6>
                                      <div className="mt-1 ">
                                        <span className="mr-1">
                                          Episode No :
                                        </span>
                                        <span>
                                          {trailerValue?.episodeNumber}
                                        </span>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                              </div>

                            </>
                          );
                        })
                      ) : (
                        <>
                          {/* <Skeleton
                          height={300}
                          width={500}
                          className="card__pic"
                          containerClassName="avatar-skeleton"
                          baseColor={colors.baseColor}
                          highlightColor={colors.highlightColor}
                        /> */}

                          {/* <p className="text-center">No Episodes found!!</p> */}
                        </>
                      )}
                    </Slider>

                    {
                      data.episode?.length > 0 ? "" : <p className="text-center">No Episodes found!!</p>
                    }

                  </div>


                  <div className="col-sm-12 product-description-details mt-4 pl-0">
                    <h4 className="m-0">Trailer</h4>
                    {
                      data?.trailer?.length > 0 ? (
                        <></>
                      ) : (
                        <>
                          {/* Loading UI */}
                          {isLoading ? (
                            <div
                              className="iq-card mb-4"
                              style={{
                                margin: " 5px",
                                borderRadius: "5px",
                              }}
                            >
                              <div
                                className="card-body"
                                style={{
                                  padding: "0px",
                                  borderRadius: "5px",
                                }}
                              >
                                <div
                                  style={{
                                    height: "250px",
                                  }}
                                >
                                  <Skeleton
                                    style={{
                                      height: "250px",
                                      objectFit: "cover",
                                      width: "100%",
                                      borderRadius: "5px 5px 0 0",
                                      lineHeight: "normal",
                                    }}
                                    className="card__pic"
                                    containerClassName="avatar-skeleton"
                                    baseColor={colors.baseColor}
                                    highlightColor={colors.highlightColor}
                                  />
                                </div>

                                <p
                                  className="mt-3 text-center mb-0"
                                  style={{
                                    color: "#fdfdfd",
                                    fontWeight: "600",
                                  }}
                                >
                                  <Skeleton
                                    style={{
                                      height: "20px",
                                      objectFit: "cover",
                                      width: "50%",
                                    }}
                                    className="card__pic"
                                    containerClassName="avatar-skeleton"
                                    baseColor={colors.baseColor}
                                    highlightColor={colors.highlightColor}
                                  />
                                </p>
                                <p
                                  className="text-center pt-2 pb-3 text-white text-capitalize"
                                  style={{ marginBottom: "13px" }}
                                >
                                  <Skeleton
                                    style={{
                                      height: "30px",
                                      objectFit: "cover",
                                      width: "60%",
                                    }}
                                    className="card__pic"
                                    containerClassName="avatar-skeleton"
                                    baseColor={colors.baseColor}
                                    highlightColor={colors.highlightColor}
                                  />
                                </p>
                              </div>
                            </div>
                          ) : (
                            <>
                              {/* No Data  */}
                              <p className="text-center">No Trailer Found!!</p>
                            </>
                          )}
                        </>
                      )
                    }
                    <Slider {...settings}>
                      {data?.trailer?.map((trailerValue, index) => {
                        return (
                          <>
                            <div
                              className="iq-card mb-4"
                              style={{
                                margin: " 5px",
                                borderRadius: "5px",
                              }}
                            >
                              <div
                                className="card-body"
                                style={{
                                  padding: "0px",
                                  borderRadius: "5px",
                                }}
                              >
                                <div
                                  style={{
                                    height: "250px",
                                  }}
                                >
                                  <ReactPlayer
                                    url={trailerValue.videoUrl}
                                    className="react-player img-fluid"
                                    playing={false}
                                    width="100%"
                                    height="100%"
                                    style={{
                                      objectFit: "cover",
                                      borderRadius: "5px",
                                    }}
                                  />
                                </div>

                                <p
                                  className="mt-3 text-center mb-0"
                                  style={{
                                    fontWeight: "600",
                                  }}
                                >
                                  {trailerValue?.type || "-"}
                                </p>
                                <p
                                  className="text-center pt-2 pb-4 text-capitalize"
                                  style={{ marginBottom: "13px" }}
                                >
                                  {trailerValue?.name?.length > 50
                                    ? trailerValue?.name.substr(0, 40) + "..."
                                    : trailerValue?.name}
                                </p>
                              </div>
                            </div>
                          </>
                        );
                      })}
                    </Slider>
                  </div>


                  {/* --------------cast------------- */}

                  <div className="mb-3">
                    {data?.role?.length > 0 ? (
                      <>
                        <h4 className="m-0 mt-2">Cast</h4>
                        <Slider {...settings2} className="roleSlider">
                          {data?.role?.map((roleData_, index) => {
                            return (
                              <>
                                <div style={{ margin: "15px" }}>
                                  <a
                                    className=""
                                    href={() => false}
                                    style={{
                                      borderRadius: "5px",
                                    }}
                                  >
                                    <div
                                      className="card__preview img-fluid iq-card"
                                      style={{
                                        borderRadius: "5px",
                                      }}
                                    >
                                      <img
                                        className="roleImage"
                                        src={
                                          data?.image
                                            ? data?.image
                                            : userDefault
                                        }
                                        onError={(e) => {
                                          e.target.onerror = null; // Prevents infinite loop
                                          e.target.src = noImage; // Default image path
                                        }}
                                        draggable={false}
                                        style={{
                                          width: "120px",
                                          height: "150px",
                                        }}
                                        alt="Cast"
                                      />
                                      <div className="card__body">
                                        <div className="row ml-0">
                                          <div className="col-12">
                                            <div className="d-flex align-items-center justify-content-center">
                                              <div className="text-start">
                                                <h6
                                                  className="mt-0 mb-3"
                                                  style={{
                                                    fontSize: "18px",
                                                  }}
                                                >
                                                  {roleData_.name}
                                                </h6>

                                                <span
                                                  className="badge badge-danger"
                                                  style={{
                                                    borderRadius: "5px",
                                                    // color: "#56939F",
                                                    // background: "#374b4b4f",
                                                  }}
                                                >
                                                  {roleData_.position}
                                                </span>
                                              </div>
                                            </div>
                                          </div>
                                        </div>
                                      </div>
                                    </div>
                                  </a>
                                </div>
                              </>
                            );
                          })}
                        </Slider>
                      </>
                    ) : (
                      <>
                        <h4 className="m-0">Cast</h4>
                        {/* <div className="d-flex" style={{ overflowX: "hidden" }}>
                          {[...Array(4)].map((item, i) => {
                            return (
                              <>
                                <div className="pr-2" key={i}>
                                  <div
                                    className="card"
                                    href={() => false}
                                    style={{
                                      width: "250px",
                                      borderRadius: "5px",
                                    }}
                                  >
                                    <div className="">
                                      <div className="">
                                        <Skeleton
                                          style={{
                                            height: "150px",
                                            objectFit: "cover",
                                            width: "100%",
                                            lineHeight: "normal",
                                          }}
                                          className="card__pic"
                                          containerClassName="avatar-skeleton"
                                          baseColor={colors.baseColor}
                                          highlightColor={colors.highlightColor}
                                        />
                                      </div>
                                    </div>
                                  </div>
                                </div>
                              </>
                            );
                          })}
                        </div> */}

                        <p className="text-center">No cast found!!</p>
                      </>
                    )}
                  </div>

                  {/*-------- comment ------- */}
                  <div>
                    <div className="post">
                      <div id="myGroup">
                        <div class="post-actions">
                          <h4 className="m-0">Comments</h4>
                        </div>
                        <div class="post-comments mt-3">
                          {comments?.length > 0 ? (
                            comments.map((cmt, index) => {
                              return (
                                <>
                                  <div class="post-comm post-padding d-flex justify-content-center border">
                                    <div className="d-flex w-100 align-items-center">
                                      <div className="commentImage pr-2">
                                        <img
                                          src={
                                            cmt?.userImage
                                              ? cmt?.userImage
                                              : userDefault
                                          }
                                          onError={(e) => {
                                            e.target.onerror = null; // Prevents infinite loop
                                            e.target.src = noImage; // Default image path
                                          }}
                                          className="rounded-circle img-fluid avatar-40"
                                          alt=""
                                          style={{
                                            objectFit: "cover",
                                            boxSizing: "border-box",
                                          }}
                                        // onClick={() =>
                                        //   handleUserInfo(comment.user)
                                        // }
                                        />
                                      </div>
                                      <div class="">
                                        <div
                                        // onClick={() =>
                                        //   handleUserInfo(
                                        //     comment.user
                                        //   )
                                        // }
                                        >
                                          {cmt.fullName}
                                        </div>
                                        <div className="">{cmt.comment}</div>
                                        <small class="comment-date float-right d-flex">
                                          <div className="commentTime">
                                            {cmt.time}{" "}
                                          </div>
                                        </small>
                                      </div>
                                    </div>
                                    <div class="comment-container w-100 d-flex justify-content-end">

                                      <Popconfirm
                                        title="Are you sure to delete this comment?"
                                        onConfirm={() =>
                                          handleDelete(cmt._id)
                                        }
                                        // onCancel={cancel}
                                        okText="Yes"
                                        cancelText="No"
                                        placement="top"
                                      >
                                        <div className="d-flex">

                                          <button className="custom-action-button btn btn-sm">
                                            <IconTrash className="text-danger" />
                                          </button>
                                        </div>
                                      </Popconfirm>


                                    </div>
                                  </div>
                                </>
                              );
                            })
                          ) : (
                            <p className="text-center">No Comment Yet!!</p>
                          )}
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

export default connect(null, { viewDetails, getComment })(WebSeriesDetail);
