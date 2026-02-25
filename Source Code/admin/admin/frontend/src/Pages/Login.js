import React, { useState, useEffect } from "react";
//login css
// import './login.css';

//login form logo
import logo from "../Component/assets/images/logo.png";
import bgLogin from "../Component/assets/images/bg.jpg";

//router
import { NavLink, useHistory } from "react-router-dom";

//react-redux
import { connect, useDispatch, useSelector } from "react-redux";

//import action
import { login } from "../store/Admin/admin.action";

//type
import { CLOSE_ADMIN_TOAST } from "../store/Admin/admin.type";

//toast
import { setToast } from "../util/Toast";
import { IconEye, IconEyeOff } from "@tabler/icons-react";
import { projectName } from "../util/config";

const Login = (props) => {
  const dispatch = useDispatch();
  const { toast, toastData, actionFor } = useSelector((state) => state.admin);

  //State Define
  const [email, setEmail] = useState("");

  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  //toast;
  useEffect(() => {
    if (toast) {
      setToast(toastData, actionFor);
      dispatch({ type: CLOSE_ADMIN_TOAST });
    }
  }, [toast, toastData, actionFor]);

  //Submit Functionality
  const handleSubmit = () => {
    if (!email || !password) {
      const error = {};
      if (!email) {
        error.email = "Email is required !";
      }
      if (!password) {
        error.password = "Password is required !";
      }
      return setError({ ...error });
    } else {
      const details = {
        email,
        password,
      };
      setLoading(true)
      props.login(details, () => {
        setLoading(false);
      });
    }

  };

  const [type, setType] = useState("password");
  const hideShow = () => {
    type === "password" ? setType("text") : setType("password");
  };

  return (
    <>
      <div className=" d-flex " style={{ height: "100vh" }}>
        <div className=" d-md-block d-none  w-100">
          <img src={bgLogin} alt="Login" className=" w-100 h-100" />
        </div>
        <div className=" w-100">
          <div className="align-items-center d-flex h-100 justify-content-center w-100">
            <div className="w-50 w-md-100">
              <div>
                <img
                  src={logo}
                  alt="Logo"
                  className="mb-2 border rounded"
                  height={75}
                  width={75}
                />
              </div>
              <h2 className="fw-semibold m-0">Login to your account</h2>
              <p className="text-secondary mt-2">
                Let's connect, chat, and spark real connections. Enter your
                credentials to continue your journey on {projectName}.
              </p>
              <form>
                <div className="custom-input form-group">
                  <label className="float-left">Email</label>
                  <input
                    className="form-control"
                    label={`Email`}
                    id={`loginEmail`}
                    placeholder={"Enter Email"}
                    type={`email`}
                    value={email}
                    errorMessage={error.email && error.email}
                    onChange={(e) => {
                      setEmail(e.target.value);

                      if (!e.target.value) {
                        return setError({
                          ...error,
                          email: "Email is required !",
                        });
                      } else {
                        return setError({
                          ...error,
                          email: "",
                        });
                      }
                    }}
                  />
                  {error.email && <span className="error">{error.email}</span>}
                </div>
                <div className="custom-input form-group">
                  <label className="float-left">Password</label>
                  <div className="input-group">
                    <input
                      type={type}
                      value={password}
                      className="border-end-0 border-right-0 form-control password-input"
                      placeholder="Enter Password"
                      onChange={(e) => {
                        setPassword(e.target.value);

                        if (!e.target.value) {
                          return setError({
                            ...error,
                            password: "Password is required !",
                          });
                        } else {
                          return setError({
                            ...error,
                            password: "",
                          });
                        }
                      }}
                    />
                    <span className="bg-white show-password" id="basic-addon2">
                      {type === "password" ? (
                        <IconEyeOff
                          onClick={hideShow}
                          className="text-secondary cursor-pointer"
                        />
                      ) : (
                        <IconEye
                          onClick={hideShow}
                          className="text-secondary cursor-pointer"
                        />
                      )}
                    </span>
                  </div>
                  {error.password && (
                    <span className="error">{error.password}</span>
                  )}
                </div>
              </form>

              <div className="w-100">
                <NavLink to="/forgotPassword" className="fs-5 fw-bold">
                  Forgot password?
                </NavLink>
              </div>
              <div className="d-flex flex-column justify-content-center w-100 gap-3 mt-4">
                <button
                  className={"btn btn-sm login-btn  w-100 py-2 mb-2 fw-medium"}
                  onClick={handleSubmit}
                  disabled={loading}
                >
                  Login
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default connect(null, { login })(Login);
