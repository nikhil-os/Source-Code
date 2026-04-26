import $ from "jquery";
import React, { useEffect, useState } from "react";

import defaultUserPicture from "../assets/images/defaultUserPicture.jpg";
//image
import moviePlaceHolder from "../assets/images/movieDefault.png";
import placeholderImage from "../assets/images/singleUser.png";

// antd
import { Popconfirm } from "antd";

//mui

//react-router-dom
import { useLocation } from "react-router-dom";

// slick-carousel

import "slick-carousel/slick/slick-theme.css";
import "slick-carousel/slick/slick.css";

//react-redux
import { connect, useDispatch, useSelector } from "react-redux";

//action
import {
  deleteComment,
  getComment,
  viewDetails,
} from "../../store/Movie/movie.action";

//html Parser
import parse from "html-react-parser";
import Slider from "react-slick";

import { useHistory } from "react-router-dom";

//react player
import ReactPlayer from "react-player";

//react-skeleton
import Skeleton from "react-loading-skeleton";
import "react-loading-skeleton/dist/skeleton.css";
import noImage from "../../Component/assets/images/noImage.png";
import { colors } from "../assets/js/SkeletonColor";

//alert

import { IconEdit, IconTrash } from "@tabler/icons-react";

const MovieDetails = (props) => {
  const location = useLocation();
  const dispatch = useDispatch();

  const [data, setData] = useState([]);
  const [comments, setComments] = useState([]);
  const [season, setSeason] = useState("");

  const [index, setIndex] = useState(0);

  const isLoading = useSelector((state) => state.loader.loader);
  // const [showURLs, setShowURLs] = useState([]);
  // const [showURLsRole, setShowURLsRole] = useState([]);

  const id = location.state;

  const history = useHistory();

  useEffect(() => {
    dispatch(viewDetails(id));
    dispatch(getComment(id));
  }, [dispatch]);

  const { movieDetails, comment } = useSelector((state) => state.movie);


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

  //update button
  const updateOpen = (data) => {
    sessionStorage.setItem("trailerId", data?._id);
    sessionStorage.setItem("updateMovieData1", JSON.stringify(data));
    history.push({ pathname: "/admin/movie/movie_form", state: data });
  };

  const videoData = data?.trailer || [];
  const videoTop = videoData[0];

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          <div className="iq-card mt-2 mb-5 ">
            <div className="iq-card-header d-flex justify-content-between align-items-center">
              <div class="iq-header-title">
                <h4 class="card-title">Movie Details</h4>
              </div>
              <button
                type="button"
                className="btn custom-action-button btn-sm  "
                onClick={() => updateOpen(data)}
              >
                <IconEdit className="text-secondary" />
              </button>
            </div>
            <div
              className="iq-card-body profile-page p-3 "
              style={{ padding: "0px !important" }}
            >
              <div className="profile-header">
                <div className="cover-container">
                  {/* <img
                    src={
                      movieDetails?.[0]?.image
                        ? movieDetails?.[0]?.image
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
                          onError={(e) => {
                            e.target.onerror = null; // Prevents infinite loop
                            e.target.src = defaultUserPicture; // Default image path
                          }}
                          className="card-img img-fluid posterImage"
                          alt="..."
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
                              Runtime : {"  "}
                              <span className="badge badge-info">
                                {data?.runtime} min
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
                <div
                  className="profile-info "
                  style={{ paddingBottom: "0px !important" }}
                >
                  {/* thumbnail */}
                  <div className="col-sm-12 product-description-details mt-5 pl-0">
                    <h4 className="m-0">Thumbnail</h4>
                    <div>
                      <img src={data?.thumbnail} style={{ height: 350, width: 300, borderRadius: 5 }} alt="" className="border" />
                    </div>

                  </div>
                  {/* Trailer */}
                  <div className="col-sm-12 product-description-details mt-5 pl-0">
                    <h4 className="m-0">Trailer</h4>

                    {data?.trailer?.length > 0 ? (
                      <>
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
                                        className="react-player img-fluid rounded"
                                        playing={false}
                                        width="100%"
                                        height="100%"
                                        style={{
                                          objectFit: "cover",
                                          borderRadius: "5px",
                                        }}
                                      />
                                    </div>
                                    {/* <YouTube video={trailerValue?.key} autoplay /> */}
                                    {/* <video
                                  src={trailerValue?.videoUrl}
                                  type="video/mp4"
                                  controls
                                  style={{
                                    width: "98%",
                                    paddingBottom: "50px !important",
                                    // height: "430px",
                                    // width: "730px",
                                    // minHeight: "430px !important",
                                    // minWidth: "730px !important",
                                  }}
                                /> */}
                                    <p
                                      className="mt-3 text-center mb-0 "
                                      style={{
                                        fontWeight: "600",
                                      }}
                                    >
                                      {trailerValue?.type}
                                    </p>
                                    <p
                                      className="text-center pt-2 pb-4 text-capitalize"
                                      style={{ marginBottom: "13px" }}
                                    >
                                      {trailerValue?.name?.length > 50
                                        ? trailerValue?.name.substr(0, 40) +
                                        "..."
                                        : trailerValue?.name}
                                    </p>
                                  </div>
                                </div>
                              </>
                            );
                          })}
                        </Slider>
                      </>
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
                    )}
                  </div>

                  {/* Cast */}
                  <div className="mb-2">
                    {data?.role?.length > 0 ? (
                      <>
                        <h4 className="m-0">Cast</h4>

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
                                      className="card__preview img-fluid iq-card border"
                                      style={{
                                        borderRadius: "5px",
                                      }}
                                    >
                                      <img
                                        className="roleImage"
                                        src={
                                          roleData_?.image
                                            ? roleData_?.image
                                            : placeholderImage
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
                                                  className="m-0 my-2"
                                                  style={{
                                                    fontSize: "16px",
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
                        {/* Loading UI */}
                        <h4 className="m-0">Cast</h4>

                        {isLoading ? (
                          <>
                            <div
                              className="d-flex"
                              style={{ overflowX: "hidden" }}
                            >
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
                                              highlightColor={
                                                colors.highlightColor
                                              }
                                            />
                                          </div>
                                        </div>
                                      </div>
                                    </div>
                                  </>
                                );
                              })}
                            </div>
                          </>
                        ) : (
                          <>
                            <p className="text-center">No Cast Found!!</p>
                          </>
                        )}
                      </>
                    )}
                  </div>

                  <div className="">
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
                                              : placeholderImage
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
                                        onConfirm={() => handleDelete(cmt._id)}
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

export default connect(null, {
  viewDetails,
  getComment,
  deleteComment,
})(MovieDetails);
