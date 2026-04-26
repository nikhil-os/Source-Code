import React, { useState } from "react";

import noImage1 from "../assets/images/moviePlaceHolder.png";
import LoadingGif from "../assets/images/loading_gray.gif";

const LazyImage = ({ imageSrc, noImage = noImage1 }) => {
  const [loading, setLoading] = useState(true);

  return (
<div style={{ position: "relative", width: 80, height: 100 }}>
      {/* Loader */}
      {loading && (
        <div
          style={{
            position: "absolute",
            top: 0,
            left: 0,
            width: "100%",
            height: "100%",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            background: "#f0f0f0",
            borderRadius: 10,
          }}
        >
          {/* <span>Loading...</span> */}
        </div>
      )}

      {/* Image */}
      <img
        className="img-fluid"
        style={{
          height: "100px",
          width: "80px",
          boxShadow: "0 5px 15px 0 rgb(105 103 103 / 0%)",
          border: "0.5px solid rgba(255, 255, 255, 0.20)",
          borderRadius: 10,
          objectFit: "cover",
        }}
        src={imageSrc || noImage}
        onLoad={() => setLoading(false)}
        onError={(e) => {
          e.target.onerror = null;
          e.target.src = noImage;
          setLoading(false);
        }}
        alt=""
      />
    </div>
  );
};

export default LazyImage;
