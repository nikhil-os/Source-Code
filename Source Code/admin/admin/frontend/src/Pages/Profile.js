//React
import { useEffect, useRef, useState } from "react";

//react-router-dom
import { useHistory } from "react-router-dom";

//react-redux
import { connect, useDispatch, useSelector } from "react-redux";

//profile image
import $ from "jquery";

//types
import {
  CLOSE_ADMIN_TOAST,
  OPEN_ADMIN_TOAST,
  UNSET_ADMIN,
} from "../store/Admin/admin.type";

//action
import {
  getProfile,
  updateImage,
  updateProfile,
} from "../store/Admin/admin.action";

//axios
import axios from "axios";

//toast
import { setToast } from "../util/Toast";

//mui
import { makeStyles } from "@mui/styles";

import { folderStructurePath } from "../util/config";

//Toast

import male from "../../src/Component/assets/images/admin.png";

import { uploadFile } from "../util/AwsFunction";

const useStyles = makeStyles(() => ({
  avatar: {
    height: 140,
    width: 140,
    border: "3px solid #fff",
  },
}));

const Profile = (props) => {
  const classes = useStyles();

  //define dispatch and history
  const dispatch = useDispatch();
  const history = useHistory();

  //Define States
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [data, setData] = useState([]);
  console.log("data", data);

  const [imagePath, setImagePath] = useState("");
  const [imageLoaded, setImageLoaded] = useState(false);
  const [oldPassword, setOldPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [loading, setLoading] = useState(true);
  const [selectedFile, setSelectedFile] = useState(null);
  const [previewURL, setPreviewURL] = useState(null);
  console.log("selectedFile", selectedFile);

  const fileInputRef = useRef(null);

  const [errors, setErrors] = useState({
    oldPassword: "",
    newPassword: "",
    confirmPassword: "",
  });

  //confirm password error
  const [error, setError] = useState("");

  useEffect(() => {
    dispatch(getProfile());
  }, []);

  const { admin, toast, toastData, actionFor } = useSelector(
    (state) => state.admin
  );
  console.log("admin", admin);



  // Helper to robustly extract image path from admin object
  function getProfileImage(admin) {
    if (!admin) return "";
    if (admin.image) return admin.image;
    if (admin.admin && admin.admin.image) return admin.admin.image;
    return "";
  }

  useEffect(() => {
    setData(admin);
    setLoading(false);
    // Robustly extract image path
    const img = getProfileImage(admin);
    if (img) {
      setImagePath(img);
      setImageLoaded(false);
    } else {
      setImagePath("");
      setImageLoaded(true); // No image, so stop loader
    }
  }, [admin]);

  useEffect(() => {
    setEmail(data?.email);
    setName(data?.name || data?.admin?.admin?.name);
  }, [data]);

  const updateNameAndEmail = () => {
    if (!name || !email) {
      const errors = {};
      //for name validation
      if (!name) errors.name = "Name is Require!";
      //for email validation
      if (!email) errors.email = "Email is Require!";

      return setErrors({ ...errors });
    }

    const content = {
      name: name,
      email: email,
    };
    props.updateProfile(content);
  };

  //toast
  useEffect(() => {
    if (toast) {
      setToast(toastData, actionFor);
      dispatch({ type: CLOSE_ADMIN_TOAST });
    }
  }, [toast, toastData, actionFor]);

  const [fileUrl, setFileUrl] = useState("");

  const changePassword = () => {
    if (!oldPassword || !newPassword || !confirmPassword) {
      const errors = {};

      if (!oldPassword) errors.oldPassword = "Old Password is Required!";
      if (!newPassword) errors.newPassword = "New Password is Required!";
      if (!confirmPassword)
        errors.confirmPassword = "Confirm Password is Required!";

      return setErrors({ ...errors });
    } else {


      setError("");
      if (confirmPassword !== newPassword) {
        return setError("Password & Confirm Password do not match ❌");
      }

      axios
        .put("admin/updatePassword", {
          oldPass: oldPassword,
          newPass: newPassword,
          confirmPass: confirmPassword,
        })
        .then((res) => {
          if (res.data.status) {
            setOldPassword("");
            setNewPassword("");
            setConfirmPassword("");
            dispatch({
              type: OPEN_ADMIN_TOAST,
              payload: {
                data: "Change Admin Password Successful ✔",
                for: "insert",
              },
            });
            setTimeout(() => {
              dispatch({ type: UNSET_ADMIN });
              history.push("/");
            }, 3000);
          } else {
            dispatch({
              type: OPEN_ADMIN_TOAST,
              payload: {
                data: "Oops ! Old Password doesn't match",
                for: "error",
              },
            });
          }
        })
        .catch((error) => {
          console.log(error);
        });
    }
  };

  let folderStructure = folderStructurePath + "adminImage";

  // const imageLoad = async (event) => {
  //   setImage(event.target.files[0]);
  //   const { resDataUrl, imageURL } = await uploadFile(
  //     event.target.files[0],
  //     folderStructure
  //   );
  //   setResURL(resDataUrl);
  // };

  // const handleChangeImage = () => {
  //   
  //   if (!resURL) {
  //     Toast("info", "Please select image");
  //   } else {
  //     const imageURL = { image: resURL };
  //     props.updateImage(imageURL);
  //   }
  // };

  // const handleImageUpload = async (e) => {
  //   

  //   const file = e.target.files[0];
  //   console.log("file--profile", file);

  //   if (!file) return;

  //   // const folderStructure = 'userImage'; // or as per your setup

  //   const { resDataUrl, imageURL } = await uploadFile(file, folderStructure);
  //   console.log(
  //     "resDataUrl--profile",
  //     resDataUrl,
  //     "imageURL--profile",
  //     imageURL
  //   );

  //   // ✅ BACKEND KO YEH DENA HAI
  //   if (resDataUrl) {
  //     props.updateImage({ image: resDataUrl }); // ✅ CORRECT
  //   }

  //   // ✅ FRONTEND KE LIYE YEH
  //   if (imageURL) {
  //     setImagePath(imageURL); // show in <img src=... />
  //   }
  // };

  // const handleFileSelect = (e) => {
  //   const file = e.target.files[0];
  //   if (file) {
  //     setSelectedFile(file);
  //     const previewURL = URL.createObjectURL(file);
  //     setImagePath(previewURL);
  //     setImageLoaded(false);
  //   }
  // };
  const handleFileSelect = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSelectedFile(file);
      const preview = URL.createObjectURL(file);
      setPreviewURL(preview); // ✅ store preview separately
      setImagePath(preview); // ✅ show immediately
      setImageLoaded(false);
    }
  };

  // const handleChangeImage = async () => {
  //   
  //   if (!selectedFile) return setToast("Please select an image first");

  //   setLoading(true);

  //   try {
  //     const { resDataUrl, imageURL } = await uploadFile(
  //       selectedFile,
  //       folderStructure
  //     );

  //     if (resDataUrl) {
  //       dispatch(updateImage({ image: resDataUrl })); // Backend update
  //     }
  //     if (imageURL) {
  //       setImagePath(imageURL);
  //       setImageLoaded(false);
  //     }

  //     // Reset
  //     setSelectedFile(null);
  //     fileInputRef.current.value = "";
  //   } catch (err) {
  //     console.error("Image upload failed:", err);
  //   } finally {
  //     setLoading(false);
  //   }
  // };

  // set default image

  const handleChangeImage = async () => {

    if (!selectedFile) return setToast("Please select an image first");

    setLoading(true);
    try {
      const { resDataUrl, imageURL } = await uploadFile(
        selectedFile,
        folderStructure
      );

      if (resDataUrl) {
        dispatch(updateImage({ image: resDataUrl })); // send to backend
      }

      if (imageURL) {
        const img = new Image();
        img.onload = () => {
          setImagePath(imageURL); // ✅ overwrite after confirmed load
          setImageLoaded(true);
        };
        img.onerror = () => {
          setImageLoaded(true); // fallback on error
        };
        img.src = imageURL;
      }

      setSelectedFile(null);
      setPreviewURL(null); // ✅ Clear preview
      fileInputRef.current.value = "";
    } catch (err) {
      console.error("Image upload failed:", err);
    } finally {
      setLoading(false);
    }
  };

  // $(document).ready(function () {
  //   $("img").bind("error", function () {
  //     // Set the default image
  //     $(this).attr("src", male);
  //   });
  // });

  const SpinnerLoader = () => (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        width: 120,
        height: 120,
      }}
    >
      <div
        className="spinner-border text-primary"
        role="status"
        style={{ width: 60, height: 60 }}
      >
        <span className="sr-only">Loading...</span>
      </div>
      <div style={{ marginTop: 16, color: "#fff", fontWeight: 500 }}>
        Loading...
      </div>
    </div>
  );

  return (
    <>
      <div id="content-page" class="content-page">
        <div class="container-fluid">
          <div className="row">
            <div className="col-sm-12">
              <div className="iq-card mt-2">
                <div className="iq-card-header">
                  <h4 className="card-title">Admin Profile</h4>
                </div>
                <div className="iq-card-body profile-page p-0">
                  <div className="profile-info p-3">
                    <div className="row">
                      <div className="col-sm-12 col-md-4">
                        <div className="iq-card pt-3  mb-4">
                          <div className="card-body">
                            <center className="mt-2">
                              <div
                                className="text-center"
                                style={{ cursor: "pointer" }}
                              >
                                {loading ? (
                                  <div
                                    style={{
                                      width: 267,
                                      height: 267,
                                      display: "flex",
                                      alignItems: "center",
                                      justifyContent: "center",
                                      background: "#22213a",
                                      borderRadius: "22px",
                                      margin: "0 auto",
                                    }}
                                  >
                                    <SpinnerLoader />
                                  </div>
                                ) : (
                                  <img
                                    src={previewURL || imagePath || male}
                                    onLoad={() => setImageLoaded(true)}
                                    onError={(e) => {
                                      e.target.onerror = null; // Prevents infinite loop
                                      e.target.src = male; // Default image path
                                      setImageLoaded(true);
                                    }}
                                    onClick={() => fileInputRef.current.click()}
                                    alt="Profile"
                                    width="267"
                                    height="267"
                                    style={{
                                      borderRadius: "22px",
                                      objectFit: "cover",
                                    }}
                                  />
                                )}
                                <input
                                  type="file"
                                  accept="image/png, image/jpeg, image/jpg"
                                  hidden
                                  ref={fileInputRef}
                                  onChange={handleFileSelect}
                                />
                              </div>

                              <h4 className="card-title mt-3 text-capitalize">
                                {admin.name}
                              </h4>
                              {/* <div className="row justify-content-center">
                                <div className="col-4 cursorPointer text-center">
                                  <label
                                    htmlFor="fileupload"
                                    style={{ cursor: "pointer" }}
                                  >
                                    <i
                                      className="ri-image-2-fill fs-3"
                                      aria-hidden="true"
                                      style={{ color: "#fff" }}
                                    ></i>
                                  </label>
                                  <input
                                    type="file"
                                    id="fileupload"
                                    accept="image/png, image/jpeg, image/jpg"
                                    hidden
                                    onChange={handleImageUpload} 
                                  />
                                </div>
                              </div> */}

                              <div className="col-sm-12 d-flex align-item-center justify-content-center">
                                <button
                                  className="btn btn-primary mb-3 mt-1"
                                  type="button"
                                  style={{ background: "rgba(34, 31, 58, 1)" }}
                                  onClick={handleChangeImage}
                                >
                                  Update Image
                                </button>
                              </div>

                              {/* <div className="row justify-content-center">
                                <div className="col-4 cursorPointer">
                                  <a
                                    href={() => false}
                                    className="link justify-content-center"
                                  >
                                    <label for="fileupload"
                                      style={{ cursor: 'pointer' }}
                                    >
                                      <i
                                        className="ri-image-2-fill fs-3"
                                        aria-hidden="true"
                                        style={{ color: '#fff' }}
                                      ></i>
                                    </label>
                                    <input
                                      type="file"
                                      id="fileupload"
                                      accept="image/png, image/jpeg ,image/jpg"
                                      hidden
                                      onChange={imageLoad}
                                    />
                                  </a>
                                </div>
                              </div>
                              <div className="col-sm-12 d-flex align-item-center justify-content-center">
                                <button
                                  className="btn btn-primary mb-3 mt-1 "
                                  type="button"
                                  style={{
                                    background:
                                      'rgba(34, 31, 58, 1) !important',
                                  }}
                                  onClick={handleChangeImage}
                                >
                                  Update Image
                                </button>
                              </div> */}
                            </center>
                          </div>
                        </div>
                      </div>
                      <div className="col-sm-12 col-md-8">
                        <div className="iq-card">
                          <div className="iq-card-header">
                            <h4 class="card-title">Admin information</h4>
                          </div>
                          <div className="iq-card-body py-2">
                            <form>
                              <div class="p-2">
                                <div class="iq-card p-3">
                                  <div class=" p-0">
                                    <div class="form-group">
                                      <label
                                        class="form-control-label"
                                        for="input-username"
                                      >
                                        Full Name
                                      </label>
                                      <input
                                        type="text"
                                        id="input-username"
                                        class="form-control"
                                        value={name}
                                        onChange={(event) => {
                                          setName(event.target.value);
                                          if (!event.target.value) {
                                            return setErrors({
                                              ...errors,
                                              name: "Name is Required!",
                                            });
                                          } else {
                                            return setErrors({
                                              ...errors,
                                              name: "",
                                            });
                                          }
                                        }}
                                      />
                                      {errors.name && (
                                        <span style={{ color: "#ee2e47" }}>
                                          {errors.name}
                                        </span>
                                      )}
                                    </div>
                                  </div>
                                  <div class=" p-0">
                                    <div class="form-group">
                                      <label
                                        class="form-control-label"
                                        for="input-email"
                                      >
                                        Email address
                                      </label>
                                      <input
                                        type="email"
                                        id="input-email"
                                        class="form-control"
                                        value={email}
                                        onChange={(event) => {
                                          setEmail(event.target.value);
                                          if (!event.target.value) {
                                            return setErrors({
                                              ...errors,
                                              email: "Email is Required!",
                                            });
                                          } else {
                                            return setErrors({
                                              ...errors,
                                              email: "",
                                            });
                                          }
                                        }}
                                        name="example-email"
                                      />
                                      {errors.email && (
                                        <span style={{ color: "#ee2e47" }}>
                                          {errors.email}
                                        </span>
                                      )}
                                    </div>
                                  </div>
                                  <div class=" p-0">
                                    <button
                                      className="btn btn-primary  mb-1"
                                      type="button"
                                      onClick={updateNameAndEmail}
                                    >
                                      Update Profile
                                    </button>
                                  </div>
                                </div>
                              </div>
                              {/* <div class="row">
                                <div class="col-lg-12">
                                  <button
                                    className="btn btn-primary  mb-1 float-right"
                                    type="button"
                                    onClick={updateNameAndEmail}
                                  >
                                    Update Profile
                                  </button>
                                </div>
                              </div> */}

                              {/* <!-- Address --> */}
                              <div className="p-2">
                                <div className="iq-card">
                                  <div className="iq-card-header">
                                    <h4 className="card-title">
                                      Change Password
                                    </h4>
                                  </div>
                                  <div class="iq-card-body p-3 ">
                                    <div class="">
                                      <div class="p-0">
                                        <div class="form-group">
                                          <label
                                            class="form-control-label"
                                            for="input-city"
                                          >
                                            Old Password
                                          </label>
                                          <input
                                            type="password"
                                            id="input-city"
                                            placeholder="Enter old password"
                                            class="form-control"
                                            value={oldPassword}
                                            onChange={(event) => {
                                              setOldPassword(
                                                event.target.value
                                              );
                                              if (!event.target.value) {
                                                return setErrors({
                                                  ...errors,
                                                  oldPassword:
                                                    "Old Password is Required!",
                                                });
                                              } else {
                                                return setErrors({
                                                  ...errors,
                                                  oldPassword: "",
                                                });
                                              }
                                            }}
                                          />
                                          {errors.oldPassword && (
                                            <span style={{ color: "#ee2e47" }}>
                                              {errors.oldPassword}
                                            </span>
                                          )}
                                        </div>
                                      </div>
                                      <div class="p-0">
                                        <div class="form-group">
                                          <label
                                            class="form-control-label"
                                            for="input-country"
                                          >
                                            New Password
                                          </label>
                                          <input
                                            type="password"
                                            id="input-country"
                                            class="form-control"
                                            placeholder="Enter new password"
                                            value={newPassword}
                                            onChange={(event) => {
                                              setNewPassword(
                                                event.target.value
                                              );
                                              if (!event.target.value) {
                                                return setErrors({
                                                  ...errors,
                                                  newPassword:
                                                    "New is Required!",
                                                });
                                              } else {
                                                return setErrors({
                                                  ...errors,
                                                  newPassword: "",
                                                });
                                              }
                                            }}
                                            name="example-email"
                                          />
                                          {errors.newPassword && (
                                            <span style={{ color: "#ee2e47" }}>
                                              {errors.newPassword}
                                            </span>
                                          )}
                                        </div>
                                      </div>
                                      <div class="p-0">
                                        <div class="form-group">
                                          <label
                                            class="form-control-label"
                                            for="input-country"
                                          >
                                            Confirm Password
                                          </label>
                                          <input
                                            type="password"
                                            id="input-postal-code"
                                            class="form-control"
                                            placeholder="Enter confirm password"
                                            value={confirmPassword}
                                            onChange={(event) => {
                                              setConfirmPassword(
                                                event.target.value
                                              );
                                              if (!event.target.value) {
                                                return setErrors({
                                                  ...errors,
                                                  confirmPassword:
                                                    "Confirm Password is Required!",
                                                });
                                              } else {
                                                return setErrors({
                                                  ...errors,
                                                  confirmPassword: "",
                                                });
                                              }
                                            }}
                                            name="example-email"
                                          />
                                          {errors.confirmPassword && (
                                            <span style={{ color: "#ee2e47" }}>
                                              {errors.confirmPassword}
                                            </span>
                                          )}
                                          {error && (
                                            <span style={{ color: "#ee2e47" }}>
                                              {error}
                                            </span>
                                          )}
                                        </div>
                                      </div>
                                      <div class="">
                                        <button
                                          className="btn btn-primary"
                                          type="button"
                                          onClick={changePassword}
                                        >
                                          Set Password
                                        </button>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                              </div>



                            </form>
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
      </div>
    </>
  );
};

export default connect(null, {
  getProfile,
  updateImage,
  updateProfile,
})(Profile);
