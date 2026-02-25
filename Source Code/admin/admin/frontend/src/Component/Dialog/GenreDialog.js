import React, { useState, useEffect } from 'react';

// material-ui
import {
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  IconButton,
  Typography,
  Tooltip,
} from '@mui/material';
import Cancel from '@mui/icons-material/Cancel';

//react-redux
import { useDispatch, useSelector } from 'react-redux';
import { connect } from 'react-redux';

//action
import { insertGenre, updateGenre } from '../../store/Genre/genre.action';
import { CLOSE_DIALOG } from '../../store/Genre/genre.type';

import { folderStructurePath, baseURL, secretKey } from '../../util/config';
import { CLOSE_LOADER, OPEN_LOADER } from '../../store/Loader/loader.type';
import noImage from '../../Component/assets/images/noImage.png';
import { IconX } from '@tabler/icons-react';

const GenreDialog = (props) => {
  const { dialog: open, dialogData } = useSelector((state) => state.genre);

  const dispatch = useDispatch();

  const [name, setName] = useState('');
  const [image, setImage] = useState([]);
  const [imagePath, setImagePath] = useState('');
  const [genreId, setGenreId] = useState('');

  const [error, setError] = useState({
    name: '',
    image: '',
  });



  const imageLoad = (event) => {
    const file = event.target.files[0];
    if (file) {
      setImage(file); // Store image file
      setImagePath(URL.createObjectURL(file)); // Show preview
    }
  };

  //Insert and update Data Functionality
  const handleSubmit = async (e) => {
    e.preventDefault();
    dispatch({ type: OPEN_LOADER });


    if (!name || !imagePath) {
      const error = {};
      if (!name) error.name = 'Name is Required!';
      if (image.length === 0 || !imagePath) error.image = 'Image is Required!';
      setError({ ...error });
      dispatch({ type: CLOSE_LOADER });
      return;
    }

    let uploadedImageURL = imagePath;
    if (image && typeof image !== 'string') {
      const formData = new FormData();
      formData.append('folderStructure', folderStructurePath + 'genreImage');
      formData.append('keyName', image.name);
      formData.append('content', image);

      const response = await fetch(baseURL + `file/upload-file`, {
        method: 'POST',
        headers: {
          key: secretKey,
        },
        body: formData,
      });

      const responseData = await response.json();
      if (responseData?.url) {
        uploadedImageURL = responseData?.url;
      }
    }

    const updatedPayload = {
      genreId, // always required
    };

    if (name !== dialogData?.name) {
      updatedPayload.name = name;
    }

    if (uploadedImageURL !== dialogData?.image) {
      updatedPayload.image = uploadedImageURL;
    }

    const data = {
      name,
      image: uploadedImageURL,
    };

    if (genreId) {
      props.updateGenre(updatedPayload);
    } else {
      props.insertGenre(data);
    }
    dispatch({ type: CLOSE_LOADER });
  };

  useEffect(() => {
    setName('');
    setImage('');
    setGenreId('');
    setError({
      name: '',
      image: '',
    });
  }, [open]);

  //Set Data Value
  useEffect(() => {
    if (dialogData) {
      setName(dialogData.name);
      setImagePath(dialogData.image);
      setGenreId(dialogData._id);
    }
  }, [dialogData]);

  //Close Dialog
  const handleClose = () => {
    dispatch({ type: CLOSE_DIALOG });
  };

  return (
    <>
      <Dialog
        open={open}
        aria-labelledby="responsive-dialog-title"
        onClose={handleClose}
        disableBackdropClick
        disableEscapeKeyDown
        fullWidth
        maxWidth="sm"
      >


        <div className="modal-header">
          {dialogData ? <h2 class="modal-title m-0">Edit Genre</h2> : <h2 class="modal-title m-0">Add Genre</h2>}
          <button
            className="btn btn-sm custom-action-button"
            onClick={handleClose}
          >
            <IconX className="text-secondary" />
          </button>
        </div>



        <DialogContent>

          <div className="d-flex flex-column">
            <form>
              <div className="form-group">
                <div className="row">
                  <div className="col-md-12 my-2">
                    <label className="float-left styleForTitle ">
                      Name
                    </label>
                    <input
                      type="text"
                      placeholder="Name"
                      className="form-control form-control-line text-capitalize"
                      required
                      value={name}
                      onChange={(e) => {
                        setName(
                          e.target.value.charAt(0).toUpperCase() +
                          e.target.value.slice(1)
                        );

                        if (!e.target.value) {
                          return setError({
                            ...error,
                            name: 'Name is Required!',
                          });
                        } else {
                          return setError({
                            ...error,
                            name: '',
                          });
                        }
                      }}
                    />
                    {error.name && (
                      <div className="pl-1 text-left">
                        {error.name && (
                          <span className="error">{error.name}</span>
                        )}
                      </div>
                    )}
                  </div>
                  <div className="col-md-12 my-2">
                    <label className="float-left styleForTitle">Image</label>
                    <input
                      type="file"
                      id="customFile"
                      className="form-control"
                      accept="image/png"
                      Required=""
                      onChange={imageLoad}
                    />
                    <p className='extention-show'>Accept only .png, .jpeg and .jpg</p>
                    {image.length === 0 ? (
                      <div className="pl-1 text-left">
                        <Typography
                          variant="caption"
                          style={{
                            fontFamily: 'Circular-Loom',
                            color: '#ee2e47',
                          }}
                        >
                          {error.image}
                        </Typography>
                      </div>
                    ) : (
                      ''
                    )}

                    {imagePath && (
                      <>
                        <img
                          height="100px"
                          width="100px"
                          alt="app"
                          src={imagePath}
                          onError={(e) => {
                            e.target.onerror = null; // Prevents infinite loop
                            e.target.src = noImage; // Default image path
                          }}
                          style={{
                            boxShadow:
                              ' rgba(105, 103, 103, 0) 0px 5px 15px 0px',
                            border: '0.5px solid rgba(255, 255, 255, 0.2)',
                            borderRadius: '10px',
                            marginTop: '10px',
                            float: 'left',
                          }}
                        />

                        <div
                          className="img-container"
                          style={{
                            display: 'inline',
                            position: 'relative',
                            float: 'left',
                          }}
                        ></div>
                      </>
                    )}
                  </div>
                </div>
              </div>
            </form>
          </div>

        </DialogContent>

        <DialogActions className="modal-footer">
          <button
            type="button"
            className="btn btn-danger btn-sm px-3 py-1"
            onClick={handleClose}
          >
            Cancel
          </button>
          {dialogData ? (
            <button
              type="button"
              className="btn btn-success btn-sm px-3 py-1 mr-3"
              onClick={handleSubmit}
            >
              Update
            </button>
          ) : (
            <button
              type="button"
              className="btn btn-success btn-sm px-3 py-1 "
              onClick={handleSubmit}
            >
              Insert
            </button>
          )}
        </DialogActions>
      </Dialog>
    </>
  );
};

export default connect(null, { insertGenre, updateGenre })(GenreDialog);
