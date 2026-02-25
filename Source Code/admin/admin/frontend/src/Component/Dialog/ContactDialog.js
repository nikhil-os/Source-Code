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
import {
  insertContact,
  updateContact,
} from '../../store/Contact/contact.action';
import { CLOSE_DIALOG } from '../../store/Contact/contact.type';

//Alert
import { uploadFile } from '../../util/AwsFunction';
import { folderStructurePath } from '../../util/config';
import noImage from '../../Component/assets/images/noImage.png';
import { use } from 'react';
import { CLOSE_LOADER, OPEN_LOADER } from '../../store/Loader/loader.type';
import { IconX } from '@tabler/icons-react';

const ContactDialog = (props) => {
  const { dialog: open, dialogData } = useSelector((state) => state.contact);

  const dispatch = useDispatch();

  //define states
  const [name, setName] = useState('');
  const [link, setLink] = useState('');
  const [image, setImage] = useState([]);
  const [imagePath, setImagePath] = useState('');
  const [contactId, setContactId] = useState('');
  const [resURL, setResURL] = useState('');
  const [selectedFile, setSelectedFile] = useState('');
  const [error, setError] = useState({
    name: '',
    link: '',
    image: '',
  });



  //Insert Data Functionality

  //Empty Data After Insert
  useEffect(() => {
    setName('');
    setLink('');
    setImagePath('');
    setContactId('');
    setError({
      name: '',
      link: '',
      image: '',
    });
  }, [open]);

  //Set Data Value
  useEffect(() => {
    if (dialogData) {
      setName(dialogData.name);
      setLink(dialogData.link);
      setImagePath(dialogData.image);
      setContactId(dialogData._id);
    }
  }, [dialogData]);

  //Update Function

  //Close Dialog
  const handleClose = () => {
    dispatch({ type: CLOSE_DIALOG });
  };

  let folderStructure = folderStructurePath + 'contactUs';

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSelectedFile(file);
      setImagePath(URL.createObjectURL(file));
    }
  };

  //  Image Load fffff
  const imageLoad = async (event) => {
    setImage(selectedFile);

    const { resDataUrl, imageURL } = await uploadFile(
      selectedFile,
      folderStructure
    );
    setResURL(resDataUrl);
    setImagePath(imageURL);
  };

  // const submitInsert = () => {
  //   if (!name || !link || !image) {
  //     const error = {};
  //     if (!name) error.name = 'Name is Required !';
  //     if (!link) error.link = 'Link is Required !';
  //     if (image.length === 0) error.image = 'Image is Require !';

  //     return setError({ ...error });
  //   }
  //   dispatch({ type: CLOSE_DIALOG });
  //   

  //   let contactUs = {
  //     name,
  //     link,
  //     image: resURL,
  //   };

  //   props.insertContact(contactUs);
  // };

  const submitInsert = async () => {
    // Step 1: Basic validation

    dispatch({ type: OPEN_LOADER });

    if (!name || !link || !selectedFile) {
      const error = {};
      if (!name) error.name = 'Name is Required !';
      if (!link) error.link = 'Link is Required !';
      if (!selectedFile) error.image = 'Image is Required !';
      return setError(error);
    }

    try {
      // Step 2: Upload image first
      const { resDataUrl, imageURL } = await uploadFile(
        selectedFile,
        folderStructure
      );
      
      console.log('resDataUrl: ', resDataUrl);
      console.log('imageURL: ', imageURL);
      if (!resDataUrl) {
        return setError({ image: 'Image upload failed' });
      }

      // Step 3: Set states if needed (optional, if used elsewhere)
      setImage(selectedFile);
      setResURL(resDataUrl);
      setImagePath(imageURL);

      // Step 4: Now submit the form
      const contactUs = {
        name,
        link,
        image: resDataUrl,
      };

      props.insertContact(contactUs);
    } catch (error) {
      console.error('Form submission error:', error);
      // Optionally handle the error
    } finally {
      // Always close loader after operation completes
      dispatch({ type: CLOSE_LOADER });
    }

    // Optional: close the dialog after success
    dispatch({ type: CLOSE_DIALOG });
  };

  // const submitUpdate = () => {
  //   if (!name || !link) {
  //     const error = {};
  //     if (!name) error.name = 'Name is Required !';
  //     if (!link) error.link = 'Link is Required !';
  //     if (image.length === 0) error.image = 'Image is Required !';

  //     return setError({ ...error });
  //   } else {
  //     

  //     if (resURL) {
  //       let contactUs = {
  //         name,
  //         link,
  //         image: resURL,
  //       };

  //       props.updateContact(contactId, contactUs);
  //     } else {
  //       let contactUs = {
  //         name,
  //         link,
  //       };
  //       props.updateContact(contactId, contactUs);
  //     }
  //     dispatch({ type: CLOSE_DIALOG });
  //   }
  // };

  const submitUpdate = async () => {
    // Step 1: Basic validation

    dispatch({ type: OPEN_LOADER });

    if (!name || !link || !selectedFile) {
      const error = {};
      if (!name) error.name = 'Name is Required !';
      if (!link) error.link = 'Link is Required !';
      if (!selectedFile) error.image = 'Image is Required !';
      dispatch({ type: CLOSE_LOADER }); // Close loader if validation fails
      return setError(error);
    }
    try {
      // Step 2: Upload image first
      const { resDataUrl, imageURL } = await uploadFile(
        selectedFile,
        folderStructure
      );

      if (!resDataUrl) {
        return setError({ image: 'Image upload failed' });
      }

      // Step 3: Set state values if needed
      setImage(selectedFile);
      setResURL(resDataUrl);
      setImagePath(imageURL);

      // Step 4: Prepare and send updated data
      const contactUs = {
        name,
        link,
        image: resDataUrl,
      };

      await props.updateContact(contactId, contactUs); // Await in case it's async
    } catch (error) {
      console.error('Update error:', error);
      // Optionally handle or show error
    } finally {
      // Always close loader and dialog after attempt
      dispatch({ type: CLOSE_LOADER });
      dispatch({ type: CLOSE_DIALOG });
    }
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
        {/* <DialogTitle id="responsive-dialog-title">
          {dialogData ? <h5>Edit Contact</h5> : <h5>Add Contact</h5>}
        </DialogTitle>

        <Tooltip title="Close">
          <Cancel
            className="cancelButton"
            style={{
              position: 'absolute',
              top: '10px',
              right: '10px',
              color: '#fff',
            }}
            onClick={handleClose}
          />
        </Tooltip> */}

        <div className="modal-header">
          <h2 class="modal-title m-0">{dialogData ? "Edit Contact" : "Add Contact"}</h2>
          <button
            className="btn btn-sm custom-action-button"
            onClick={handleClose}
          >
            <IconX className="text-secondary" />
          </button>
        </div>


        {/* </IconButton> */}
        <DialogContent>

          <div className="d-flex flex-column">
            <form>

              <div className="row">
                <div className="col-md-12 my-2">
                  <label className="float-left styleForTitle">Name</label>
                  <input
                    type="text"
                    placeholder="Name"
                    // className="form-control form-control-line"
                    className="form-control"
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
                          name: 'name is Required!',
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
                      <Typography
                        variant="caption"
                        color="error"
                        style={{
                          fontFamily: 'Circular-Loom',
                          // color: "#FF2929",
                        }}
                      >
                        {error.name}
                      </Typography>
                    </div>
                  )}
                </div>
              </div>

              <div className="row">
                <div className="col-md-12 my-2">
                  <label className="float-left styleForTitle">Link</label>
                  <input
                    type="text"
                    placeholder="Link"
                    // className="form-control form-control-line"
                    className="form-control"
                    required
                    value={link}
                    onChange={(e) => {
                      setLink(e.target.value);

                      if (!e.target.value) {
                        return setError({
                          ...error,
                          link: 'Link is Required!',
                        });
                      } else {
                        return setError({
                          ...error,
                          link: '',
                        });
                      }
                    }}
                  />
                  {error.link && (
                    <div className="pl-1 text-left">
                      <Typography
                        variant="caption"
                        color="error"
                        style={{
                          fontFamily: 'Circular-Loom',
                          // color: "#FF2929",
                        }}
                      >
                        {error.link}
                      </Typography>
                    </div>
                  )}
                </div>
              </div>

              <div className="row">
                <div className="col-md-12 my-2">
                  <label className="float-left styleForTitle">Image</label>
                  <input
                    type="file"
                    id="customFile"
                    className="form-control pt-0 pl-0 pb-0"
                    accept="image/png, image/jpeg ,image/jpg"
                    required=""
                    // onChange={imageLoad}
                    onChange={handleFileChange}
                  // style={{
                  //   paddingTop: "0px !important",
                  //   paddingBottom: "0px !important",
                  //   paddingLeft: "0px !important",
                  // }}
                  />
                  <p className='extention-show'>Accept only .png, .jpeg and .jpg</p>
                  {/* <div className="d-flex justify-content-end">
                        <button
                          type="button"
                          className="btn btn-success btn-sm px-3 py-1 mt-4 "
                          onClick={imageLoad} // actual upload logic
                        >
                          Upload
                        </button>
                      </div> */}

                  {image.length === 0 ? (
                    <div className="pl-1 text-left">
                      <Typography
                        variant="caption"
                        color="error"
                        style={{ fontFamily: 'Circular-Loom' }}
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
                          // boxShadow: "0 0 0 1.2px #7f65ad80",
                          borderRadius: 10,
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

            </form>
          </div>

        </DialogContent>

        <DialogActions className='modal-footer'>
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
              onClick={submitUpdate}
            >
              Update
            </button>
          ) : (
            <button
              type="button"
              className="btn btn-success btn-sm px-3 py-1"
              onClick={submitInsert}
            >
              Insert
            </button>
          )}
        </DialogActions>
      </Dialog>
    </>
  );
};

export default connect(null, { insertContact, updateContact })(ContactDialog);
