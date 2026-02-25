import React, { useState } from "react";
import { connect } from "react-redux";
import { signupAdmin } from "../store/Admin/admin.action";
//login form logo
import logo from "../Component/assets/images/logo.png";
import bgLogin from "../Component/assets/images/bg.jpg";
//login css
import "./login.css";
import { projectName } from "../util/config";
import { IconEye, IconEyeOff } from "@tabler/icons-react";

const Registration = (props) => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [code, setCode] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const isEmail = (value) => {
    const val = value === "" ? 0 : value;
    const validNumber = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(val);
    return validNumber;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (
      !email ||
      !password ||
      !code ||
      !newPassword ||
      !isEmail(email) ||
      newPassword !== password
    ) {
      let error = {};
      if (!email) error.email = "Email Is Required !";
      if (!password) error.password = "password is required !";
      if (!newPassword) error.newPassword = "new password is required !";

      if (newPassword !== password)
        error.newPassword = "New Password and Confirm Password doesn't match !";
      if (!code) error.code = "purchase code is required !";
      return setError({ ...error });
    } else {
      let login = {
        email,
        password,
        code,
      };
      setLoading(true);
      props.signupAdmin(login, () => {
        setLoading(false)
      });
    }
  };

  const [type, setType] = useState("text");

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
              <h2 className="fw-semibold m-0">Signup to your account</h2>
              <p className="text-secondary mt-2">
                Let's connect, chat, and spark real connections. Enter your
                credentials to continue your journey on {projectName}.
              </p>
              <form>
                <div class="custom-input form-group">
                  <label className="float-left">Email</label>
                  <input
                    type="email"
                    className="form-control"
                    id="floatingInput"
                    placeholder="name@example.com"
                    required
                    value={email}
                    onChange={(e) => {
                      setEmail(e.target.value);
                      if (!e.target.value) {
                        return setError({
                          ...error,
                          email: "Email is Required !",
                        });
                      } else {
                        return setError({
                          ...error,
                          email: "",
                        });
                      }
                    }}
                  />


                  {error.email && (
                    <span className="error">{error.email}</span>
                  )}

                </div>

                <div class="custom-input form-group">
                  <label
                    for="floatingPassword"
                    className="float-left"
                  >
                    Password
                  </label>

                  <input
                    type="password"
                    className="form-control"
                    id="floatingPassword"
                    placeholder="Password"
                    value={password}
                    onChange={(e) => {
                      setPassword(e.target.value);
                      if (!e.target.value) {
                        return setError({
                          ...error,
                          password: "Password is Required !",
                        });
                      } else {
                        return setError({
                          ...error,
                          password: "",
                        });
                      }
                    }}
                  />


                  {error.password && (
                    <span className="error">{error.password}</span>
                  )}

                </div>

                <div class="custom-input form-group">
                  <label
                    for="floatingPassword"

                  >

                    Confirm Password
                  </label>
                  <input
                    type="password"
                    class="form-control"
                    id="newPassword"
                    name="newPassword"
                    placeholder="Confirm Password"
                    value={newPassword}
                    onChange={(e) => {
                      setNewPassword(e.target.value);
                      if (!e.target.value) {
                        return setError({
                          ...error,
                          newPassword: "Password is Required !",
                        });
                      } else {
                        return setError({
                          ...error,
                          newPassword: "",
                        });
                      }
                    }}
                  />


                  {error.newPassword && (
                    <span className="error">{error.newPassword}</span>
                  )}

                </div>

                <div class="custom-input form-group">
                  <label
                    for="floatingPassword"
                    c
                  >

                    Purchase Code
                  </label>
                  <input
                    type="text"
                    class="form-control"
                    id="code"
                    name="code"
                    placeholder="Purchase code"
                    value={code}
                    onChange={(e) => {
                      setCode(e.target.value);
                      if (!e.target.value) {
                        return setError({
                          ...error,
                          code: "purchase Code  is Required !",
                        });
                      } else {
                        return setError({
                          ...error,
                          code: "",
                        });
                      }
                    }}
                  />


                  {error.code && <span className="error">{error.code}</span>}
                </div>

              </form>


              <div className="d-flex flex-column justify-content-center w-100 gap-3 mt-4">
                <button
                  className={"btn btn-sm login-btn  w-100 py-2 mb-2 fw-medium"}
                  onClick={handleSubmit}
                  disabled={loading}
                >
                  Sign Up
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default connect(null, { signupAdmin })(Registration);
