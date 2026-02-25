import React from "react";
import { connect } from "react-redux";
import { size, toArray } from "lodash";
import UploadItem from "./UploadItem";
import { useEffect } from "react";
import "./upload.css";
import { uploadFile } from "../store/Episode/episode.action";
const EpisodeUploadProgress = (props) => {
  const { fileProgress, data, mongoId, update } = props;
  const uploadedFileAmount = size(fileProgress);


  useEffect(() => {
    const fileToUpload = toArray(fileProgress).filter(
      (file) => file.progress === 0
    );

    // props.uploadFile(fileToUpload, data, mongoId, update);
  }, [uploadedFileAmount, data, mongoId, update]);

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
  uploadFile: (files, data, mongoId, update) =>
    dispatch(uploadFile(files, data, mongoId, update)),
});
export default connect(
  mapStateToProps,
  mapDispatchToProps
)(EpisodeUploadProgress);
