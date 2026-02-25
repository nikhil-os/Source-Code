import React, { useState, useEffect } from "react";

//react-redux
import { connect, useDispatch, useSelector } from "react-redux";

//action
import {
  getAdvertise,
  updateAdvertise,
  advertisementSwitch,
} from "../store/Advertisement/advertisement.action";

//mui
import Switch from "@mui/material/Switch";

//Toast
import { setToast } from "../util/Toast";

//type
import { CLOSE_ADS_TOAST } from "../store/Advertisement/advertisement.type";

const Advertisement = (props) => {
  const dispatch = useDispatch();
  const { advertisement, toast, toastData, actionFor } = useSelector(
    (state) => state.advertisement
  );

  const [data, setData] = useState("");
  const [industrialId, setIndustrialId] = useState("");
  const [bannerId, setBannerId] = useState("");
  const [nativeId, setNativeId] = useState("");
  const [mongoId, setMongoId] = useState("");
  const [reward, setReward] = useState("");
  const [industrialIdIos, setIndustrialIdIos] = useState("");
  const [bannerIdIos, setBannerIdIos] = useState("");
  const [nativeIdIos, setNativeIdIos] = useState("");
  const [rewardIos, setRewardIos] = useState("");

  const [show, setShow] = useState(false);



  useEffect(() => {
    dispatch(getAdvertise());
  }, [dispatch]);

  useEffect(() => {
    setData(advertisement);
  }, [advertisement]);

  useEffect(() => {
    setIndustrialId(advertisement?.interstitial);
    setMongoId(advertisement?._id);
    setBannerId(advertisement?.banner);
    setNativeId(advertisement?.native);
    setReward(advertisement?.reward);
    setIndustrialIdIos(advertisement?.interstitialIos);
    setBannerIdIos(advertisement?.bannerIos);
    setNativeIdIos(advertisement?.nativeIos);
    setRewardIos(advertisement?.rewardIos);
    setShow(advertisement?.isGoogleAdd);

    // ✅ Ensure always 3 fields even if API gives less

  }, [advertisement]);

  const handleSubmit = () => {
    let data = {
      interstitial: industrialId,
      native: nativeId,
      banner: bannerId,
      interstitialIos: industrialIdIos,
      nativeIos: nativeIdIos,
      bannerIos: bannerIdIos,
      reward,
      rewardIos,
    };
    console.log('data: ', data);

    props.updateAdvertise(data, mongoId);
  };
  const handleChangeShow = () => {

    props.advertisementSwitch(mongoId);
  };

  //toast
  useEffect(() => {
    if (toast) {
      setToast(toastData, actionFor);
      dispatch({ type: CLOSE_ADS_TOAST });
    }
  }, [toast, toastData, actionFor, dispatch]);

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          <div className="iq-card mt-2 mb-5">
            <div className="iq-card-header d-flex justify-content-between">
              <div class="iq-header-title">
                <h4 class="card-title">Advertisement Setting</h4>
              </div>
              <div class="">
                <div className="align-items-center d-flex justify-content-end">
                  <h6>Google Ads</h6>
                  <label className="switch mb-0">
                    <Switch
                      onChange={handleChangeShow}
                      checked={show}
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
            <div className="iq-card-body">
              <form className="form-horizontal form-material px-3">
                <div className="row">
                  <div className="col-lg-6 py-3">
                    <div className="form-group iq-card mb-0">
                      <div className="iq-card-header d-flex justify-content-between">
                        <div class="iq-header-title">
                          <h4 class="card-title">Android</h4>
                        </div>
                      </div>
                      <div className="iq-card-body p-3">
                        <div className="">
                          <label>Interstitial Id(Android)</label>
                          <input
                            type="text"
                            className="form-control"
                            value={industrialId}
                            onChange={(e) => {
                              setIndustrialId(e.target.value);
                            }}
                          />
                        </div>
                        <div className="mt-2">
                          <label>Native Id(Android)</label>
                          <input
                            type="text"
                            className="form-control"
                            value={nativeId}
                            onChange={(e) => {
                              setNativeId(e.target.value);
                            }}
                          />
                        </div>

                        <div className="mt-2">
                          <label>Banner Id(Android)</label>
                          <input
                            type="text"
                            className="form-control"
                            value={bannerId}
                            onChange={(e) => {
                              setBannerId(e.target.value);
                            }}
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                  <div className="col-lg-6 py-3">
                    <div className="form-group iq-card mb-0">
                      <div className="iq-card-header d-flex justify-content-between">
                        <div class="iq-header-title">
                          <h4 class="card-title">IOS</h4>
                        </div>
                      </div>
                      <div className="iq-card-body p-3">
                        <div className="">
                          <label>Interstitial Id(IOS)</label>
                          <input
                            type="text"
                            className="form-control"
                            value={industrialIdIos}
                            onChange={(e) => {
                              setIndustrialIdIos(e.target.value);
                            }}
                          />
                        </div>
                        <div className="mt-2">
                          <label>Native Id(IOS)</label>
                          <input
                            type="text"
                            className="form-control"
                            value={nativeIdIos}
                            onChange={(e) => {
                              setNativeIdIos(e.target.value);
                            }}
                          />
                        </div>

                        <div className="mt-2">
                          <label>Banner Id(IOS)</label>
                          <input
                            type="text"
                            className="form-control"
                            value={bannerIdIos}
                            onChange={(e) => {
                              setBannerIdIos(e.target.value);
                            }}
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </form>
            </div>
            <div className="iq-card-footer">
              <div className="d-flex form-group justify-content-end mb-0">
                <button
                  className="btn text-white dark-icon btn-primary"
                  type="button"
                  onClick={handleSubmit}
                >
                  Submit
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default connect(null, {
  getAdvertise,
  updateAdvertise,
  advertisementSwitch,
})(Advertisement);
