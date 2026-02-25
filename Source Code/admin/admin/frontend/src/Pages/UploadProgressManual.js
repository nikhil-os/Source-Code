import React from "react";
import { connect } from "react-redux";
import { size, toArray } from "lodash";
import UploadItem from "./UploadItem";
import { useEffect } from "react";
import "./upload.css";
import { manualMovie } from "../store/Movie/movie.action";
const UploadProgress = (props) => {
  const { fileProgress, data } = props;
  const uploadedFileAmount = size(fileProgress);


  useEffect(() => {
    
    const fileToUpload = toArray(fileProgress).filter(
      (file) => file.progress === 0
    );

    props.manualMovie(fileToUpload, data);
  }, [uploadedFileAmount, data]);

  return uploadedFileAmount > 0 ? (
    <div>
      {/* <div className="wrapper-1"> */}
      {/* <h4>Uploading File</h4> */}
      {size(fileProgress)
        ? toArray(fileProgress).map((file) => (
            <UploadItem key={file.id} file={file} />
          ))
        : null}
    </div>
  ) : null;
};

const mapStateToProps = (state) => ({
  fileProgress: state.movie.fileProgress,
});

// const mapStateToProps = (state) =>

const mapDispatchToProps = (dispatch) => ({
  manualMovie: (files, data) => dispatch(manualMovie(files, data)),
});
export default connect(mapStateToProps, mapDispatchToProps)(UploadProgress);
