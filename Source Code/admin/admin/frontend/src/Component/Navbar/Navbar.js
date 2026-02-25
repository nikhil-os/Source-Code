import $ from "jquery";
import React, { useEffect, useState } from "react";
import { folderStructurePath, projectName } from "../../util/config";
import adminImage from "../assets/images/admin.png";
import logo from "../assets/images/movie.png";

//routing
import { NavLink, useHistory } from "react-router-dom";

//react-redux
import { connect, useSelector } from "react-redux";

//action
import { getProfile } from "../../store/Admin/admin.action";

//Alert
import { toast } from "react-toastify";
import Swal from "sweetalert2";
import noImage from "../assets/images/noImageUser.png";

//MUI
import {
  Dialog,
  DialogActions,
  DialogContent,
  Typography
} from "@mui/material";
import { setToast } from "../../util/Toast";


//axios//Alert
import axios from "axios";

//Redux - Action
import { IconBell, IconX } from "@tabler/icons-react";
import { useDispatch } from "react-redux";
import { UNSET_ADMIN } from "../../store/Admin/admin.type";
import { covertURl, uploadFile } from "../../util/AwsFunction";

const Navbar = (props) => {
  const dispatch = useDispatch();
  const history = useHistory();
  const { admin } = useSelector((state) => state.admin);

  //get admin
  const [data, setData] = useState([]);
  const [imageData, setImageData] = useState(null);
  const [imagePath, setImagePath] = useState(null);
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [type, setType] = useState("");
  const [showURL, setShowURL] = useState("");
  const [resURL, setResURL] = useState("");

  const [errors, setError] = useState({
    title: "",
    image: "",
    description: "",
    type: "",
  });
  useEffect(() => {
    if (admin?.image) {
      const fileNameWithExtension = admin?.image.split("/").pop();
      console.log("fileNameWithExtension", fileNameWithExtension);

      const fetchData = async () => {
        try {
          const { imageURL } = await covertURl(
            "adminImage/" + fileNameWithExtension
          );

          setShowURL(imageURL);
        } catch (error) {
          console.error(error);
        }
      };

      fetchData();
      const interval = setInterval(fetchData, 1000 * 60);
      return () => clearInterval(interval);
    }
  }, [admin]);



  const [open, setOpen] = React.useState(false);

  let folderStructure = folderStructurePath + "notificationImage";

  // const handleInputImage = async (e) => {
  //   setImageData(e.target.files[0]);
  //   const { resDataUrl, imageURL } = await uploadFile(
  //     e.target.files[0],
  //     folderStructure
  //   );
  //   setResURL(resDataUrl);
  //   setImagePath(imageURL);
  // };

  const handleInputImage = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    setImageData(file); // keep file for upload during submit
    setImagePath(URL.createObjectURL(file)); // for local preview only
  };

  // const handleSubmit = (e) => {
  //   if (!title || !description || !type) {
  //     const errors = {};

  //     if (!title) {
  //       errors.title = "Title can't be a blank!";
  //     }
  //     if (!description) {
  //       errors.description = "Description can't be a blank!";
  //     }

  //     if (!type) {
  //       errors.type = 'Please select type!';
  //     }

  //     return setError({ ...errors });
  //   }

  //   setError({ ...errors, image: '' });
  //   setOpen(false);

  //   let notificationData = {
  //     title,
  //     description,
  //     notificationType: type,
  //     image: resURL,
  //   };
  //   axios
  //     .post('notification/send', notificationData)
  //     .then((res) => {
  //       if (res.data.status === true) {
  //         setToast('Notification sent successfully!', 'insert');
  //         setOpen(false);

  //         setError({
  //           title: '',
  //           image: '',
  //           description: '',
  //           type: '',
  //         });
  //         setTitle('');
  //         setDescription('');
  //         setImageData(null);
  //         setImagePath(null);
  //       } else {
  //         toast.error('Something went wrong');
  //       }
  //     })
  //     .catch((error) => {
  //       console.log(error);
  //     });
  // };

  const handleSubmit = async (e) => {
    e.preventDefault();

    const errors = {};

    if (!title) errors.title = "Title can't be blank!";
    if (!description) errors.description = "Description can't be blank!";
    if (!type) errors.type = "Please select type!";

    if (Object.keys(errors).length > 0) {
      return setError(errors);
    }

    try {
      let uploadedURL = "";

      if (imageData) {
        // Upload image here
        const { resDataUrl, imageURL } = await uploadFile(
          imageData,
          folderStructure
        );
        uploadedURL = resDataUrl;
      }

      const notificationData = {
        title,
        description,
        notificationType: type,
        image: uploadedURL, // use uploaded URL
      };

      const res = await axios.post("notification/send", notificationData);
      if (res.data.status === true) {
        setToast("Notification sent successfully!", "insert");
        setOpen(false);

        // Reset form fields
        setTitle("");
        setDescription("");
        setImageData(null);
        setImagePath("");
        setResURL("");
        setError({ title: "", image: "", description: "", type: "" });
      } else {
        toast.error("Something went wrong");
      }
    } catch (error) {
      console.error(error);
      toast.error("Error while sending notification");
    }
  };

  useEffect(() => {
    dispatch(getProfile());
  }, []);

  useEffect(() => {
    setData(admin);
  }, [admin]);

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
    setError({
      title: "",
      image: "",
      description: "",
      type: "",
    });
    setTitle("");
    setDescription("");
    setImageData(null);
    setImagePath(null);
    $("#file").val("");
  };
  //sidebar toggle function
  const handleCollapse = () => {
    $("body").toggleClass("sidebar-main");
    $(".wrapper-menu").toggleClass("open");
  };

  const logout = () => {
    Swal.fire({
      title: "Are you sure?",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#d33",
      confirmButtonText: "Logout",
    })
      .then((result) => {
        if (result.isConfirmed) {
          dispatch({ type: UNSET_ADMIN });
          history.push("/login");
        }
      })
      .catch((err) => console.log(err));
  };

  // set default image

  // $(document).ready(function () {
  //   $("img").bind("error", function () {
  //     // Set the default image
  //     $(this).attr("src", adminImage);
  //   });
  // });

  return (
    <>
      <div
        className="iq-top-navbar"
      // style={{
      //   marginRight: "0px",
      // }}
      >
        <div className="mt-3">
          {/* <div className="iq-navbar-custom"> */}
          <div className="iq-sidebar-logo">
            <div className="top-logo">
              <a href="index.html" className="logo">
                {/* <div className="iq-light-logo">
                  <img src="images/logo.gif" className="img-fluid" alt />
                </div>*/}
                <div className="iq-dark-logo">
                  <img
                    alt=""
                    src={logo}
                    onError={(e) => {
                      e.target.onerror = null; // Prevents infinite loop
                      e.target.src = noImage; // Default image path
                    }}
                    className="img-fluid"
                    width={35}
                    height={41}
                  />
                </div>
                <span>{projectName}</span>
              </a>
            </div>
          </div>
          <nav
            className="navbar navbar-expand-lg navbar-light p-0 border"
            style={{
              borderRadius: "5px",
            }}
          >
            <div className="navbar-left"></div>
            <div
              className="iq-menu-bt align-self-center"
              style={{ marginLeft: "10px" }}
            >
              <div className="wrapper-menu">
                <div onClick={() => handleCollapse}>
                  <i className="ri-menu-3-line" />
                </div>
              </div>
            </div>

            <ul className="navbar-nav ml-auto navbar-list">
              <li className="nav-item">
                <a
                  className="search-toggle iq-waves-effect"
                  onClick={handleClickOpen}
                >
                  <div
                    style={{
                      marginTop: "4px",
                      cursor: "pointer",
                      color: "#6c757d",
                    }}
                  >
                    {/* <img
                      src={notificationIcon}
                      onError={(e) => {
                        e.target.onerror = null; // Prevents infinite loop
                        e.target.src = noImage; // Default image path
                      }}
                      width="35px"
                      height="35px"
                      alt=""
                    /> */}
                    <IconBell />
                  </div>
                </a>
              </li>
            </ul>
            <ul className="navbar-list">
              <li>
                <NavLink
                  to="/admin/profile/admin_info"
                  className="search-toggle iq-waves-effect d-flex align-items-center  rounded"
                >
                  <img
                    src={admin.image ? admin.image : noImage}
                    onError={(e) => {
                      e.target.onerror = null; // Prevents infinite loop
                      e.target.src = noImage; // Default image path
                    }}
                    className="img-fluid rounded"
                    alt="user"
                    style={{ objectFit: "cover" }}
                  />
                  <div className="caption">
                    <h6 className="line-height text-dark">{data.name}</h6>
                  </div>
                </NavLink>
                <div
                  className="iq-sub-dropdown iq-user-dropdown"
                  style={{ width: "210px" }}
                ></div>
              </li>
            </ul>
          </nav>
        </div>
      </div>
      {/* ------------ Notification Dialog ------------------ */}
      <Dialog
        open={open}
        aria-labelledby="responsive-dialog-title"
        onClose={handleClose}
        disableBackdropClick
        disableEscapeKeyDown
        fullWidth
        maxWidth="sm"
      >
        {/* <DialogTitle className="p-0" id="responsive-dialog-title">
          
          Notification 
        </DialogTitle> */}
        <div className="modal-header">
          <h2 class="modal-title m-0">Notification</h2>
          <button
            className="btn btn-sm custom-action-button"
            onClick={handleClose}
          >
            <IconX className="text-secondary" />
          </button>
        </div>

        {/* <Tooltip title="Close">
          <Cancel
            className="cancelButton"
            style={{
              position: 'absolute',
              top: '23px',
              right: '15px',
              color: '#fff',
            }}
            onClick={handleClose}
          />
        </Tooltip> */}

        <DialogContent>
          {/* <div  className="modal-body mt-0 px-1 pb-3"> */}
          <div className="d-flex flex-column text-center">
            <form className="">
              <div className="form-group ">
                <label className="float-left">Title</label>
                <input
                  type="text"
                  className="form-control"
                  placeholder="Title"
                  required
                  value={title}
                  onChange={(e) => {
                    setTitle(
                      e.target.value.charAt(0).toUpperCase() +
                      e.target.value.slice(1)
                    );
                    if (!e.target.value) {
                      return setError({
                        ...errors,
                        title: "Title can't be a blank!",
                      });
                    } else {
                      return setError({
                        ...errors,
                        title: "",
                      });
                    }
                  }}
                />
                {errors.title && (
                  <div className="pl-1 text-left error">
                    <Typography variant="caption">{errors.title}</Typography>
                  </div>
                )}
              </div>
              <div className="form-group ">
                <label className="float-left">Description</label>
                <input
                  type="text"
                  className="form-control"
                  placeholder="Description"
                  required
                  value={description}
                  onChange={(e) => {
                    setDescription(e.target.value);

                    if (!e.target.value) {
                      return setError({
                        ...errors,
                        description: "Description can't be a blank!",
                      });
                    } else {
                      return setError({
                        ...errors,
                        description: "",
                      });
                    }
                  }}
                />
                {errors.description && (
                  <div className="pl-1 text-left error">
                    <Typography variant="caption">
                      {errors.description}
                    </Typography>
                  </div>
                )}
              </div>

              <div className="form-group ">
                <label className="float-left">Notification Type</label>
                <select
                  name="type"
                  className="form-select form-control-line"
                  id="type"
                  value={type}
                  style={{ color: "red" }}
                  onChange={(e) => {
                    setType(e.target.value);

                    if (!e.target.value) {
                      return setError({
                        ...errors,
                        type: "Notification type is Required!",
                      });
                    } else {
                      return setError({
                        ...errors,
                        type: "",
                      });
                    }
                  }}
                >
                  <option>Select Type</option>
                  <option>General Notification</option>
                  <option>App Update</option>
                  {/* {categoryData.map((data) => {
                    return <option value={data._id}>{data.name}</option>;
                  })} */}
                </select>
                {errors.type && (
                  <div className="pl-1 text-left error">
                    <Typography variant="caption">{errors.type}</Typography>
                  </div>
                )}
              </div>

              <div className="form-group">
                <label className="float-left">Image (Optional)</label>
                <input
                  className="form-control"
                  type="file"
                  id="customFile"
                  required=""
                  accept="image/png, image/jpeg ,image/jpg"
                  onChange={handleInputImage}
                />
                {/* {errors.image && (
                  <div className="pl-1 text-left">
                    <Typography variant="caption" color="error">
                      {errors.image}
                    </Typography>
                  </div> 
                )} */}
                {/* {imagePath && (
                  <div className="row pl-3">
                    <img
                      src={imagePath}
                      onError={(e) => {
                        e.target.onerror = null; // Prevents infinite loop
                        e.target.src = noImage; // Default image path
                      }}
                      style={{
                        boxShadow: '0 5px 15px 0 rgb(105 103 103 / 0%)',
                        border: '2px solid rgb(105 103 103 / 0%)',
                        borderRadius: '10px !important',
                        marginTop: 10,
                        float: 'left',
                        objectFit: 'cover',
                        height: '70px',
                        width: '70px',
                      }}
                      alt=""
                    />
                  </div>
                )} */}
                {imagePath && (
                  <div className="row pl-3">
                    <img
                      src={imagePath}
                      onError={(e) => {
                        e.target.onerror = null;
                        e.target.src = noImage;
                      }}
                      style={{
                        boxShadow: "0 5px 15px 0 rgb(105 103 103 / 0%)",
                        border: "2px solid rgb(105 103 103 / 0%)",
                        borderRadius: "10px",
                        marginTop: 10,
                        float: "left",
                        objectFit: "cover",
                        height: "70px",
                        width: "70px",
                      }}
                      alt=""
                    />
                  </div>
                )}
              </div>
            </form>
          </div>
        </DialogContent>
        <DialogActions className="modal-footer">
          <button
            type="button"
            className="btn dark-icon btn-primary float-right m-0"
            onClick={handleSubmit}
          >
            <i className="ri-send-plane-fill mr-1 fs-6 mb-1"></i>
            Send
          </button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default connect(null, { getProfile })(Navbar);
