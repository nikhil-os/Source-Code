import { useEffect, useState } from "react";

//redux
import { connect, useDispatch, useSelector } from "react-redux";

//react-router-dom

//mui
import Switch from "@mui/material/Switch";

//action
import {
  getSetting,
  handleSwitch,
  StorageSetting,
  updateSetting,
} from "../store/Setting/setting.action";
import { CLOSE_SETTING_TOAST } from "../store/Setting/setting.type";
import { setToast } from "../util/Toast";
import { NavLink } from "react-router-dom/cjs/react-router-dom";

const Setting = (props) => {
  const dispatch = useDispatch();
  const [mongoId, setMongoId] = useState("");
  const [privacyPolicyLink, setPrivacyPolicyLink] = useState("");
  const [termConditionLink, setTermConditionLink] = useState("");
  const [privacyPolicyText, setPrivacyPolicyText] = useState("");
  const [razorPayKeyId, setRazorPayKeyId] = useState("");
  const [googlePlayEmail, setGooglePlayEmail] = useState("");
  const [googlePlayKey, setGooglePlayKey] = useState("");
  const [stripePublishableKey, setStripePublishableKey] = useState("");
  const [stripeSecretKey, setStripeSecretKey] = useState("");
  const [razorSecretKey, setRazorSecretKey] = useState("");
  const [googlePlaySwitch, setGooglePlaySwitch] = useState(false);
  const [stripeSwitch, setStripeSwitch] = useState(false);
  const [isAppActive, setIsAppActive] = useState(false);
  const [razorPaySwitch, setRazorPaySwitch] = useState(false);
  const [currency, setCurrency] = useState("$");
  const [paymentGateway, setPaymentGateway] = useState([]);
  const [selectedValue, setSelectedValue] = useState([]);
  const [isIptvAPI, setIsIptvAPI] = useState(false);
  const [durationOfShorts, setDurationOfShorts] = useState("");
  const [resendApiKey, setResendApiKey] = useState("");
  const [privateKey, setPrivateKey] = useState("");
  const [localStorage, setLocalStorage] = useState(false);
  const [awsS3Storage, setAwsS3Storage] = useState(false);
  const [digitalOceanStorage, setDigitalOceanStorage] = useState(false);
  const [selectedStorage, setSelectedStorage] = useState("");

  const [flutterWaveId, setFlutterWaveId] = useState("");
  const [flutterWaveSwitch, setFlutterWaveSwitch] = useState(false);

  const [doEndpoint, setdoEndpoint] = useState("");
  const [doAccessKey, setdoAccessKey] = useState("");
  const [doSecretKey, setdoSecretKey] = useState("");
  const [doHostname, setdoHostname] = useState("");
  const [doBucketName, setdoBucketName] = useState("");
  const [doRegion, setdoRegion] = useState("");

  const [awsEndpoint, setawsEndpoint] = useState("");
  const [awsAccessKey, setawsAccessKey] = useState("");
  const [awsSecretKey, setawsSecretKey] = useState("");
  const [awsHostname, setawsHostname] = useState("");
  const [awsBucketName, setawsBucketName] = useState("");
  const [awsRegion, setawsRegion] = useState("");

  const [error, setError] = useState({
    privateKey: "",
  });

  const [activeTab, setActiveTab] = useState("APP");

  const changeTab = (tab) => {
    setActiveTab(tab);
  };



  useEffect(() => {
    dispatch(getSetting());
  }, [dispatch]);

  const { setting, toast, toastData, actionFor } = useSelector(
    (state) => state.setting
  );

  useEffect(() => {
    // if (setting) {
    //   const data = setting?.paymentGateway?.map((data) => {
    //     return {
    //       name: data,
    //     };
    //   });

    setMongoId(setting._id);
    setPrivacyPolicyLink(setting.privacyPolicyLink);
    setTermConditionLink(setting.termConditionLink);
    setPrivacyPolicyText(setting.privacyPolicyText);
    setGooglePlayEmail(setting.googlePlayEmail);
    setGooglePlayKey(setting.googlePlayKey);
    setStripePublishableKey(setting.stripePublishableKey);
    setStripeSecretKey(setting.stripeSecretKey);
    setRazorSecretKey(setting.razorSecretKey);
    setCurrency(setting.currency);
    setGooglePlaySwitch(setting.googlePlaySwitch);
    setStripeSwitch(setting.stripeSwitch);
    setIsAppActive(setting.isAppActive);
    setRazorPaySwitch(setting.razorPaySwitch);
    setPaymentGateway(setting.paymentGateway);
    setRazorPayKeyId(setting.razorPayId);
    setIsIptvAPI(setting.isIptvAPI);
    setDurationOfShorts(setting?.durationOfShorts);
    setResendApiKey(setting?.resendApiKey);
    setFlutterWaveId(setting.flutterWaveId);
    setFlutterWaveSwitch(setting.flutterWaveSwitch);
    setPrivateKey(JSON.stringify(setting.privateKey));
    setDurationOfShorts(setting?.durationOfShorts);
    if (setting?.storage) {
      setAwsS3Storage(setting?.storage?.awsS3);
      setDigitalOceanStorage(setting?.storage?.digitalOcean);
      setLocalStorage(setting?.storage?.local);
    }

    setdoEndpoint(setting?.doEndpoint);
    setdoAccessKey(setting?.doAccessKey);
    setdoSecretKey(setting?.doSecretKey);
    setdoHostname(setting?.doHostname);
    setdoBucketName(setting?.doBucketName);
    setdoRegion(setting?.doRegion);

    setawsEndpoint(setting?.awsEndpoint);
    setawsAccessKey(setting?.awsAccessKey);
    setawsSecretKey(setting?.awsSecretKey);
    setawsHostname(setting?.awsHostname);
    setawsBucketName(setting?.awsBucketName);
    setawsRegion(setting?.awsRegion);
    // setSelectedValue(data);
    // }
  }, [setting]);

  const handleStorageChange = (type) => {
    console.log("type", type);
    setLocalStorage(type === "local");
    setAwsS3Storage(type === "awsS3");
    setDigitalOceanStorage(type === "digitalOcean");

    setSelectedStorage(type);
  };

  const handleSaveStorage = () => {


    const payload = {
      settingId: setting?._id ? setting?._id : "",
      type: selectedStorage,
    };
    console.log("payload", payload);

    dispatch(StorageSetting(payload));
  };

  const handleSubmit = (e) => {
    e.preventDefault();


    const data = {
      razorPayId: razorPayKeyId,
      privacyPolicyLink,
      termConditionLink,
      privacyPolicyText,
      flutterWaveId,
      googlePlayEmail,
      googlePlayKey,
      stripePublishableKey,
      stripeSecretKey,
      razorSecretKey,
      currency,
      paymentGateway,
      privateKey,
      durationOfShorts,
      resendApiKey,
      doEndpoint,
      doAccessKey,
      doSecretKey,
      doHostname,
      doBucketName,
      doRegion,
      awsEndpoint,
      awsAccessKey,
      awsSecretKey,
      awsHostname,
      awsBucketName,
      awsRegion,
    };

    props.updateSetting(mongoId, data);
  };

  const handleSwitch_ = (type) => {

    props.handleSwitch(mongoId, type);
  };

  const handleGooglePlay = (type) => {


    props.handleSwitch(mongoId, type);
  };

  //toast
  useEffect(() => {
    if (toast) {
      setToast(toastData, actionFor);
      dispatch({ type: CLOSE_SETTING_TOAST });
    }
  }, [toast, toastData, actionFor, dispatch]);

  const fakeFirebaseJson = {
    type: "service_account",
    project_id: "demo-project-12345",
    private_key_id: "fakeprivatekeyid1234567890abcdef",
    private_key:
      "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0FAKEFAASCBKcwggSjAgEAAoIBAQDUMMYKEYEXAMPLE\n-----END PRIVATE KEY-----\n",
    client_email:
      "firebase-adminsdk-abcde@demo-project-12345.iam.gserviceaccount.com",
    client_id: "123456789012345678901",
    auth_uri: "https://accounts.google.com/o/oauth2/auth",
    token_uri: "https://oauth2.googleapis.com/token",
    auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
    client_x509_cert_url:
      "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-abcde%40demo-project-12345.iam.gserviceaccount.com",
    universe_domain: "googleapis.com",
  };

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid ">
          <div className="nav nav-pills mb-3">
            <button
              className="nav-item navCustom border-0"
              onClick={() => {
                changeTab("APP");
              }}
            >
              <div
                className={`nav-link c-link ${activeTab === "APP" ? "active" : " "
                  }`}
              >
                App Setting
              </div>
            </button>
            <button
              className="nav-item navCustom border-0"
              onClick={() => {
                changeTab("PAYMENT");
              }}
            >
              <div
                className={`nav-link c-link ${activeTab === "PAYMENT" ? "active" : " "
                  }`}
              >
                Payment Setting
              </div>
            </button>
            <button
              className="nav-item navCustom  border-0"
              onClick={() => {
                changeTab("STORAGE");
              }}
            >
              <div
                className={`nav-link c-link ${activeTab === "STORAGE" ? "active" : " "
                  }`}
              >
                Storage Setting
              </div>
            </button>
          </div>
          <div className=" mb-5">
            <div className="row">
              {activeTab === "APP" ? (
                <>
                  <div class="col-sm-6">
                    <div class="iq-card iq-mb-3">
                      <div className="iq-card-header">
                        <h4 className="card-title">App Setting</h4>
                      </div>
                      <div class="iq-card-body  pr-0">
                        <div class=" p-3">
                          <div className="mb-3 d-flex justify-content-between align-items-center">
                            <p className="m-0 custom-btn-title">
                              Enable/Disable App Status
                            </p>
                            <label class="switch m-0 ">
                              <Switch
                                onChange={() => handleSwitch_("app active")}
                                checked={isAppActive}
                                color="primary"
                                name="checkedB"
                                inputProps={{
                                  "aria-label": "primary checkbox",
                                }}
                              />
                            </label>
                          </div>
                          <form>
                            <div class="mb-3 form-group">
                              <label for="publishableKey" class="form-label">
                                Privacy Policy Link
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="policyLink"
                                placeholder={

                                  `EnterPrivacy policy link`

                                }
                                value={privacyPolicyLink}
                                onChange={(e) =>
                                  setPrivacyPolicyLink(e.target.value)
                                }
                              />
                            </div>
                            <div class="mb-3 form-group">
                              <label for="secretKey" class="form-label">
                                Terms And Codition Link
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="policyText"
                                value={termConditionLink}
                                placeholder={`Enter Term And Codition link`
                                }
                                onChange={(e) =>
                                  setTermConditionLink(e.target.value)
                                }
                              />
                            </div>
                          </form>
                        </div>
                      </div>
                      <div className="iq-card-footer">
                        <div className="d-flex justify-content-end ">
                          <button
                            type="button"
                            class="btn dark-icon btn-success"
                            onClick={handleSubmit}
                          >
                            Submit
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-sm-6">
                    <div class="iq-card iq-mb-3">
                      <div className="iq-card-header">
                        <h4 className="card-title">
                          Firebase Notification Setting
                        </h4>
                      </div>
                      <div class="iq-card-body  pr-0">
                        <div class=" p-3">
                          <form>
                            <div class=" form-group">
                              <label for="privateKey" class="form-label">
                                Firebase Private Key
                              </label>
                              <textarea
                                name=""
                                className="form-control mt-2 h-100"
                                id="privateKey"
                                rows={10}
                                value={privateKey}
                                placeholder={`Enter firebaseKey`}
                                onChange={(e) => {
                                  const newValue = e.target.value;
                                  try {
                                    const newData = JSON.parse(newValue);
                                    setPrivateKey(newValue);
                                    setError("");
                                  } catch (error) {
                                    // Handle invalid JSON input
                                    console.error("Invalid JSON input:", error);
                                    setPrivateKey(newValue);
                                    return setError({
                                      ...error,
                                      privateKey: "Invalid JSON input",
                                    });
                                  }
                                }}
                              ></textarea>
                            </div>
                          </form>
                        </div>
                      </div>
                      <div className="iq-card-footer">
                        <div className="d-flex justify-content-end ">
                          <button
                            type="button"
                            class="btn dark-icon btn-success"
                            onClick={handleSubmit}
                          >
                            Submit
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>


                  <div class="col-sm-6 mt-3">
                    <div class="iq-card iq-mb-3">
                      <div className="iq-card-header">
                        <h4 className="card-title">Email Setting</h4>
                      </div>
                      <div class="iq-card-body  pr-0">
                        <div class=" p-3">
                          <form>
                            <div class=" form-group">
                              <label for="resendApiKey" class="form-label">
                                Email Setting
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                placeholder={`Enter Resend API key`
                                }
                                id="resendApiKey"
                                value={resendApiKey}
                                onChange={(e) =>
                                  setResendApiKey(e.target.value)
                                }
                              />
                            </div>
                          </form>
                        </div>
                      </div>
                      <div className="iq-card-footer">
                        <div className="d-flex justify-content-end ">
                          <button
                            type="button"
                            class="btn dark-icon btn-success"
                            onClick={handleSubmit}
                          >
                            Submit
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div class="col-sm-6 mt-3">
                    <div class="iq-card iq-mb-3">
                      <div className="iq-card-header">
                        <h4 className="card-title">Shorts Duration Setting</h4>
                      </div>
                      <div class="iq-card-body  pr-0">
                        <div class=" p-3">
                          <form>
                            <div class=" form-group">
                              <label for="durationOfShorts" class="form-label">
                                Duration of Shorts (Maximum time in seconds)
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="durationOfShorts"
                                value={durationOfShorts}
                                placeholder={`Enter Duration of Shorts`
                                }
                                onChange={(e) =>
                                  setDurationOfShorts(e.target.value)
                                }
                              />
                            </div>
                          </form>
                        </div>
                      </div>
                      <div className="iq-card-footer">
                        <div className="d-flex justify-content-end ">
                          <button
                            type="button"
                            class="btn dark-icon btn-success"
                            onClick={handleSubmit}
                          >
                            Submit
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>

                </>
              ) : (
                ""
              )}

              {activeTab === "PAYMENT" ? (
                <>
                  <div class="col-sm-6 mb-3">
                    <div class="iq-card iq-mb-3">
                      <div className="iq-card-header">
                        <h4 className="card-title">Stripe Setting</h4>
                      </div>
                      <div class="iq-card-body  pr-0">
                        <div class=" p-3">
                          <div className="mb-3 d-flex justify-content-between align-items-center">
                            <p className="m-0 custom-btn-title">
                              Enable/Disable Stripe Payment Setting For App
                            </p>
                            <label class="switch m-0 ">
                              <Switch
                                onChange={() => handleSwitch_("stripe")}
                                checked={stripeSwitch}
                                color="primary"
                                name="checkedB"
                                inputProps={{
                                  "aria-label": "primary checkbox",
                                }}
                              />
                            </label>
                          </div>

                          <form>
                            <div class="mb-3 form-group">
                              <label for="publishableKey" class="form-label">
                                Publishable Key
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="publishableKey"
                                value={stripePublishableKey}
                                placeholder={` Stripe Publishable Key`
                                }
                                onChange={(e) =>
                                  setStripePublishableKey(e.target.value)
                                }
                              />
                            </div>
                            <div class="mb-3 form-group">
                              <label for="secretKey" class="form-label">
                                Secret Key
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="secretKey"
                                value={stripeSecretKey}
                                placeholder={`Stripe Secret Key`
                                }
                                onChange={(e) =>
                                  setStripeSecretKey(e.target.value)
                                }
                              />
                            </div>
                          </form>
                        </div>
                      </div>
                      <div className="iq-card-footer">
                        <div className="d-flex justify-content-end ">
                          <button
                            type="button"
                            class="btn dark-icon btn-success"
                            onClick={handleSubmit}
                          >
                            Submit
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-sm-6 mb-3">
                    <div class="iq-card iq-mb-3">
                      <div className="iq-card-header">
                        <h4 className="card-title">Razorpay Setting</h4>
                      </div>
                      <div class="iq-card-body  pr-0">
                        <div class=" p-3">
                          <div className="mb-3 d-flex justify-content-between align-items-center">
                            <p className="m-0 custom-btn-title">
                              Enable/Disable Razorpay Payment Setting For App
                            </p>
                            <label class="switch m-0 ">
                              <Switch
                                onChange={() => handleSwitch_("razorPay")}
                                checked={razorPaySwitch}
                                color="primary"
                                name="checkedB"
                                inputProps={{
                                  "aria-label": "primary checkbox",
                                }}
                              />
                            </label>
                          </div>
                          <form>
                            <div class="mb-3 form-group">
                              <label for="publishableKey" class="form-label">
                                Razorpay key ID
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="publishableKey"
                                value={razorPayKeyId}
                                placeholder={` RazorPay Id`
                                }
                                onChange={(e) =>
                                  setRazorPayKeyId(e.target.value)
                                }
                              />
                            </div>
                            <div class="mb-3 form-group">
                              <label for="secretKey" class="form-label">
                                Secret Key
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="secretKey"
                                value={razorSecretKey}
                                placeholder={`Razorpay Secret Key`
                                }
                                onChange={(e) =>
                                  setRazorSecretKey(e.target.value)
                                }
                              />
                            </div>
                          </form>
                        </div>
                      </div>
                      <div className="iq-card-footer">
                        <div className="d-flex justify-content-end ">
                          <button
                            type="button"
                            class="btn dark-icon btn-success"
                            onClick={handleSubmit}
                          >
                            Submit
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-sm-6">
                    <div class="iq-card iq-mb-3">
                      <div className="iq-card-header">
                        <h4 className="card-title">Flutter Wave Setting</h4>
                      </div>
                      <div class="iq-card-body  pr-0">
                        <div class=" p-3">
                          <div className="mb-3 d-flex justify-content-between align-items-center">
                            <p className="m-0 custom-btn-title">
                              Enable/Disable Flutter Wave Payment Setting For
                              App
                            </p>
                            <label class="switch m-0 ">
                              <Switch
                                onChange={() => handleSwitch_("flutterWave")}
                                checked={flutterWaveSwitch}
                                color="primary"
                                name="checkedB"
                                inputProps={{
                                  "aria-label": "primary checkbox",
                                }}
                              />
                            </label>
                          </div>
                          <form>
                            <div class="mb-3 form-group">
                              <label for="publishableKey" class="form-label">
                                Flutter Wave ID
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="flutterWaveId"
                                placeholder={`FlutterWave Key`
                                }
                                value={flutterWaveId}
                                onChange={(e) =>
                                  setFlutterWaveId(e.target.value)
                                }
                              />
                            </div>
                          </form>
                        </div>
                      </div>
                      <div className="iq-card-footer">
                        <div className="d-flex justify-content-end ">
                          <button
                            type="button"
                            class="btn dark-icon btn-success"
                            onClick={handleSubmit}
                          >
                            Submit
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-sm-6">
                    <div class="iq-card h-100 iq-mb-3">
                      <div className="iq-card-header">
                        <h4 className="card-title">Google play Setting</h4>
                      </div>
                      <div class="iq-card-body  pr-0">
                        <div class=" p-3">
                          <div className=" d-flex justify-content-between align-items-center">
                            <p className="m-0 custom-btn-title">
                              Enable/Disable Google Play Payment Setting For
                              App
                            </p>
                            <label class="switch m-0 ">
                              <Switch
                                onChange={() => handleSwitch_("googlePlay")}
                                checked={googlePlaySwitch}
                                color="primary"
                                name="checkedB"
                                inputProps={{
                                  "aria-label": "primary checkbox",
                                }}
                              />
                            </label>
                          </div>

                        </div>
                      </div>

                    </div>
                  </div>
                </>
              ) : (
                ""
              )}

              {activeTab === "STORAGE" ? (
                <>
                  <div class="col-sm-6 mb-3">
                    <div class="iq-card iq-mb-3">
                      <div className="iq-card-header">
                        <h4 className="card-title">Digital Ocean Setting</h4>
                      </div>
                      <div class="iq-card-body  pr-0">
                        <div class=" p-3">
                          <form className="row">
                            <div class=" col-6 mb-3 form-group">
                              <label for="doEndpoint" class="form-label">
                                Endpoint
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="doEndpoint"
                                value={doEndpoint}
                                placeholder={"Endpoint"
                                }
                                onChange={(e) => setdoEndpoint(e.target.value)}
                              />
                              <p
                                className="text-danger"
                                style={{
                                  fontSize: "small",
                                  wordWrap: "break-word",
                                }}
                              >
                                e.g. https://bucketname.region.digitaloceanspaces.com
                              </p>
                            </div>
                            <div class=" col-6 mb-3 form-group">
                              <label for="doHostname" class="form-label">
                                Hostname
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="doHostname"
                                value={doHostname}
                                placeholder={"Host name"
                                }
                                onChange={(e) => setdoHostname(e.target.value)}
                              />
                              <p
                                className="text-danger mb-0 "
                                style={{
                                  fontSize: "small",
                                  wordWrap: "break-word",
                                }}
                              >
                                e.g.
                                https://region.digitaloceanspaces.com

                              </p>
                            </div>
                            <div class=" col-6 mb-3 form-group">
                              <label for="doSecretKey" class="form-label">
                                Secret Key
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="doSecretKey"
                                value={doSecretKey}
                                placeholder={"Secret Key"
                                }
                                onChange={(e) => setdoSecretKey(e.target.value)}
                              />
                            </div>
                            <div class=" col-6 mb-3 form-group">
                              <label for="doAccessKey" class="form-label">
                                Access Key
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="doAccessKey"
                                value={doAccessKey}
                                placeholder={"Access Key"
                                }
                                onChange={(e) => setdoAccessKey(e.target.value)}
                              />
                            </div>
                            <div class=" col-6 mb-3 form-group">
                              <label for="doBucketName" class="form-label">
                                Bucket Name
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="doBucketName"
                                value={doBucketName}
                                placeholder={"Bucket Name"
                                }
                                onChange={(e) =>
                                  setdoBucketName(e.target.value)
                                }
                              />
                            </div>
                            <div class=" col-6 mb-3 form-group">
                              <label for="doRegion" class="form-label">
                                Region
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="doRegion"
                                value={doRegion}
                                placeholder={"Region"
                                }
                                onChange={(e) => setdoRegion(e.target.value)}
                              />
                            </div>
                          </form>
                        </div>
                      </div>
                      <div className="iq-card-footer">
                        <div className="d-flex justify-content-end ">
                          <button
                            type="button"
                            class="btn dark-icon btn-success"
                            onClick={handleSubmit}
                          >
                            Submit
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-sm-6 mb-3">
                    <div class="iq-card iq-mb-3">
                      <div className="iq-card-header">
                        <h4 className="card-title">AWS Setting</h4>
                      </div>
                      <div class="iq-card-body  pr-0">
                        <div class=" p-3">
                          <form className="row">
                            <div class=" col-6 mb-3 form-group">
                              <label for="awsEndpoint" class="form-label">
                                Endpoint
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="awsEndpoint"
                                value={awsEndpoint}
                                placeholder={"Endpoint"
                                }
                                onChange={(e) => setawsEndpoint(e.target.value)}
                              />
                              <p
                                className="text-danger"
                                style={{
                                  fontSize: "small",
                                  wordWrap: "break-word",
                                }}
                              >
                                e.g. https://bucketname.s3.region.amazonaws.com
                              </p>
                            </div>
                            <div class=" col-6 mb-3 form-group">
                              <label for="awsHostname" class="form-label">
                                Hostname
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="awsHostname"
                                value={awsHostname}
                                placeholder={"Host Name"
                                }
                                onChange={(e) => setawsHostname(e.target.value)}
                              />
                              <p
                                className="text-danger mb-0 "
                                style={{
                                  fontSize: "small",
                                  wordWrap: "break-word",
                                }}
                              >
                                e.g. https://s3.region.amazonaws.com

                              </p>
                            </div>
                            <div class=" col-6 mb-3 form-group">
                              <label for="awsSecretKey" class="form-label">
                                Secret Key
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="awsSecretKey"
                                value={awsSecretKey}
                                placeholder={"Secret Key"
                                }
                                onChange={(e) =>
                                  setawsSecretKey(e.target.value)
                                }
                              />
                            </div>
                            <div class=" col-6 mb-3 form-group">
                              <label for="awsAccessKey" class="form-label">
                                Access Key
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="awsAccessKey"
                                value={awsAccessKey}
                                placeholder={"Access Key"
                                }
                                onChange={(e) =>
                                  setawsAccessKey(e.target.value)
                                }
                              />
                            </div>
                            <div class=" col-6 mb-3 form-group">
                              <label for="awsBucketName" class="form-label">
                                Bucket Name
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="awsBucketName"
                                value={awsBucketName}
                                placeholder={"Bucket Name"
                                }
                                onChange={(e) =>
                                  setawsBucketName(e.target.value)
                                }
                              />
                            </div>
                            <div class=" col-6 mb-3 form-group">
                              <label for="awsRegion" class="form-label">
                                Region
                              </label>
                              <input
                                type="text"
                                class="form-control"
                                id="awsRegion"
                                value={awsRegion}
                                placeholder={"Region"
                                }
                                onChange={(e) => setawsRegion(e.target.value)}
                              />
                            </div>
                          </form>
                        </div>
                      </div>
                      <div className="iq-card-footer">
                        <div className="d-flex justify-content-end ">
                          <button
                            type="button"
                            class="btn dark-icon btn-success"
                            onClick={handleSubmit}
                          >
                            Submit
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="col-sm-6 mt-3">
                    <div class="iq-card iq-mb-3">
                      <div className="iq-card-header">
                        <h4 className="card-title">Storage Setting</h4>
                      </div>
                      <div class="iq-card-body  pr-0">
                        <div class=" p-3">
                          <div className=" d-flex justify-content-between align-items-center">
                            <p className="m-0 fw-bold">Local</p>
                            <label class="switch m-0">
                              <Switch
                                checked={localStorage === true ? true : false}
                                color="primary"
                                name="checkedB"
                                inputProps={{
                                  "aria-label": "primary checkbox",
                                }}
                                onClick={() => handleStorageChange("local")}
                              />
                            </label>
                          </div>
                          <div className=" d-flex justify-content-between align-items-center">
                            <p className="m-0  fw-bold">AWS S3</p>
                            <label class="switch m-0 ">
                              <Switch
                                checked={awsS3Storage === true ? true : false}
                                color="primary"
                                name="checkedB"
                                inputProps={{
                                  "aria-label": "primary checkbox",
                                }}
                                onClick={() => handleStorageChange("awsS3")}
                              />
                            </label>
                          </div>

                          <div className=" d-flex justify-content-between align-items-center">
                            <p className="m-0 fw-bold">Digital Ocean Space</p>
                            <label class="switch m-0 ">
                              <Switch
                                checked={
                                  digitalOceanStorage === true ? true : false
                                }
                                color="primary"
                                name="checkedB"
                                inputProps={{
                                  "aria-label": "primary checkbox",
                                }}
                                onClick={() =>
                                  handleStorageChange("digitalOcean")
                                }
                              />
                            </label>
                          </div>
                        </div>
                      </div>
                      <div className="iq-card-footer">
                        <div className="d-flex justify-content-end ">
                          <button
                            type="button"
                            class="btn dark-icon btn-success"
                            onClick={handleSaveStorage}
                          >
                            Submit
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                </>
              ) : (
                ""
              )}
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default connect(null, { getSetting, updateSetting, handleSwitch })(
  Setting
);
