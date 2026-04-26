import { useEffect, useRef, useState } from 'react';

//react-router-dom
import { useHistory } from 'react-router-dom';

//material-ui
import { Typography } from '@mui/material';
import { makeStyles } from '@mui/styles';
import noImage from '../assets/images/noImage.png';

//editor
import SunEditor from 'suneditor-react';
import 'suneditor/dist/css/suneditor.min.css';

//Multi Select Dropdown

//react-redux
import { connect, useDispatch, useSelector } from 'react-redux';

//all actions

import {
  loadMovieData
} from '../../store/Movie/movie.action';
//Alert
import {
  getContent,
  insertContent,
  updateContent,
} from '../../store/Content/content.action';
import { CLOSE_LOADER, OPEN_LOADER } from '../../store/Loader/loader.type';

import { baseURL, folderStructurePath, secretKey } from '../../util/config';

const useStyles1 = makeStyles((theme) => ({
  root: {
    maxWidth: 345,
    display: 'flex',
    flexWrap: 'wrap',
    '& > *': {
      margin: theme?.spacing && theme?.spacing(1),
      marginBottom: '22px',
    },
  },
}));

const ContentForm = (props) => {


  const dialogData = JSON.parse(sessionStorage.getItem('updateContent'));
  console.log('dialogData: ', dialogData);
  const { content } = useSelector((state) => state.content);
  console.log('content: ', content);
  const editor = useRef(null);
  const dispatch = useDispatch();

  const [title, setTitle] = useState('');
  const [name, setName] = useState('');
  const [description, setDescription] = useState('');
  const [image, setImage] = useState([]);
  const [imagePath, setImagePath] = useState('');
  const [contentId, setContentId] = useState('');
  const [data, setData] = useState({
    title: '',
    name: '',
    icon: '',
    description: '',
  });

  const [error, setError] = useState({
    title: '',
    name: '',
    image: '',
    description: '',
  });

  //useEffect for Get Data
  useEffect(() => {
    dispatch(getContent());
  }, [dispatch]);

  //Set Data after Getting
  useEffect(() => {
    setData(content);
  }, [content]);

  // set data in dialog
  useEffect(() => {
    if (dialogData) {
      setTitle(dialogData?.title);
      setName(dialogData?.name);
      setDescription(dialogData.description);
      // setImage(dialogData?.icon);
      setImagePath(dialogData?.icon);
      setContentId(dialogData?._id);
    }
  }, []);

  const history = useHistory();

  const handlePaste = (e) => {
    const bufferText = (e?.originalEvent || e).clipboardData.getData(
      'text/plain'
    );
    e.preventDefault();
    document.execCommand('insertText', false, bufferText);
  };
  const [editorOptions, setEditorOptions] = useState({
    // Other SunEditor options you may want to set
    // For the complete list of options, check the documentation.
    buttonList: [
      ['undo', 'redo'],
      ['fontSize', 'formatBlock'],
      ['bold', 'underline', 'italic', 'strike', 'subscript', 'superscript'],
      ['removeFormat'],
      ['outdent', 'indent'],
      ['align', 'horizontalRule', 'list', 'table'],
      ['link', 'image', 'video'],
      ['fullScreen', 'showBlocks', 'codeView'],
      ['preview', 'print'],
      ['save'],
    ],
    // Add the custom onPaste handler to the options
    onPaste: handlePaste,
  });

  //  Image Load
  const imageLoad = (event) => {
    console.log('event: ', event);
    const file = event?.target?.files[0];
    if (file) {
      setImage(file);
      setImagePath(URL.createObjectURL(file));
    }
  };

  let folderStructureImage = folderStructurePath + 'movieThumbnail';
  let folderStructureContentImage = folderStructurePath + 'contentImage';

  // //insert function
  const handleSubmit = async (e) => {
    e.preventDefault();

    dispatch({ type: OPEN_LOADER }); // ✅ Start loader

    try {
      if (!title || !name || !description || !image) {
        const error = {};
        const nameRegex = /^[a-zA-Z0-9_-]*$/;
        if (!image || !imagePath) error.image = 'Image is Required!';
        if (!title) error.title = 'Title is Required !';
        if (!name) {
          error.name = 'Name is Required !';
        } else if (!nameRegex.test(name)) {
          error.name = 'Name must not contain spaces or special characters';
        }
        if (!description) error.description = 'Description is Required !';
        setError({ ...error });
        dispatch({ type: CLOSE_LOADER });
        return;
      }

      let uploadedImageURL = imagePath;
      if (image && typeof image !== 'string') {
        const formData = new FormData();
        formData.append('folderStructure', folderStructureContentImage);
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
      console.log('uploadedImageURL: ', uploadedImageURL);
      // for updating content
      const updatedPayload = {
        contentId,
      };
      if (
        name !== dialogData?.name ||
        title !== dialogData?.title ||
        description !== dialogData?.description
      ) {
        updatedPayload.name = name;
        updatedPayload.title = title;
        updatedPayload.description = description;
      }

      if (uploadedImageURL !== dialogData?.icon) {
        updatedPayload.icon = uploadedImageURL;
      }

      let objData = {
        title,
        name,
        description,
        icon: uploadedImageURL,
      };
      console.log('objData: ', objData);

      if (contentId) {
        props.updateContent(updatedPayload);
      } else {
        props.insertContent(objData);
      }

      setTimeout(() => {
        history.push('/admin/content');
      }, 3000);
    } catch (error) {
      console.error('Submit Error:', error);
      dispatch({ type: CLOSE_LOADER });
    }
  };

  //Close Dialog
  const handleClose = () => {
    sessionStorage.removeItem('updateMovieData');

    if (dialogData) {
      history.goBack();
    } else {
      history.push('/admin/content');
    }
  };

  return (
    <>
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          <div className="row">
            <div className="col-lg-12">
              {/* {dialogData ? (
                <div className="col-sm-12 col-lg-12 mb-4 pr-0 pl-0">
                  <div className="iq-card ml-2">
                    <div className="iq-card-header d-flex justify-content-between">
                      <div className="iq-header-title d-flex">
                        <MovieFilterIcon
                          className="mr-2"
                          style={{ fontSize: '30px', color: '#ffff' }}
                        />

                        <h4 className="card-title my-0">Edit Content</h4>
                      </div>
                    </div>
                    <div className="iq-card-body">
                      <div className="tab-content" id="pills-tabContent-2">
                        <div
                          className="tab-pane fade show active"
                          id="pills-home"
                          role="tabpanel"
                          aria-labelledby="pills-home-tab"
                        ></div>
                        <div
                          className="tab-pane fade"
                          id="pills-profile"
                          role="tabpanel"
                          aria-labelledby="pills-profile-tab"
                        ></div>
                        <div
                          className="tab-pane fade"
                          id="pills-contact"
                          role="tabpanel"
                          aria-labelledby="pills-contact-tab"
                        ></div>
                      </div>
                    </div>
                  </div>
                </div>
              ) : (
                <div className="col-sm-12 col-lg-12 mb-4 pr-0 pl-0">
                  <div className="iq-card ml-2">
                    <div className="iq-card-header d-flex justify-content-between">
                      <div className="iq-header-title d-flex align-items-center">
                        <MovieFilterIcon
                          className="mr-2"
                          style={{ fontSize: '30px', color: '#ffff' }}
                        />

                        <h4 className="card-title my-0">Insert Content </h4>
                      </div>
                    </div>
                  </div>
                </div>
              )} */}

              <div className="iq-card mb-5 mt-2">
                <div className="iq-card-header d-flex justify-content-between">
                  <div className="iq-header-title">
                    <h4 className="card-title">Content</h4>
                  </div>
                </div>
                <div className="iq-card-body">
                  <div className="col-lg-12">
                    <div className="">
                      <div
                        className="d-flex flex-column"
                        style={{
                          border: '0.5px solid rgba(255, 255, 255, 0.3)',
                          borderRadius: '10px',
                        }}
                      >
                        <form>
                          <div className="form-group">
                            <div className="row ">
                              <div className="col-md-4 my-2 ">
                                <label className="float-left styleForTitle">
                                  Name
                                </label>
                                <input
                                  type="text"
                                  placeholder="Name"
                                  className="form-control form-control-line"
                                  required
                                  disabled={dialogData?.name ? true : false}
                                  value={name}
                                  onChange={(e) => {
                                    setName(e.target.value);
                                    const nameRegex = /^[a-zA-Z0-9_-]*$/;
                                    if (!e.target.value) {
                                      return setError({
                                        ...error,
                                        name: 'Name is Required!',
                                      });
                                    } else if (
                                      !nameRegex.test(e.target.value)
                                    ) {
                                      return setError({
                                        ...error,
                                        name: 'Name must not contain spaces or special characters',
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
                                        color: '#ee2e47',
                                      }}
                                    >
                                      {error.name}
                                    </Typography>
                                  </div>
                                )}
                              </div>
                              <div className="col-md-4 my-2 ">
                                <label className="float-left styleForTitle">
                                  Title
                                </label>
                                <input
                                  type="text"
                                  placeholder="Title"
                                  className="form-control form-control-line"
                                  required
                                  value={title}
                                  onChange={(e) => {
                                    setTitle(e.target.value);

                                    if (!e.target.value) {
                                      return setError({
                                        ...error,
                                        title: 'Title is Required!',
                                      });
                                    } else {
                                      return setError({
                                        ...error,
                                        title: '',
                                      });
                                    }
                                  }}
                                />
                                {error.title && (
                                  <div className="pl-1 text-left">
                                    <Typography
                                      variant="caption"
                                      color="error"
                                      style={{
                                        fontFamily: 'Circular-Loom',
                                        color: '#ee2e47',
                                      }}
                                    >
                                      {error.title}
                                    </Typography>
                                  </div>
                                )}
                              </div>
                              <div className="col-md-4 my-2 styleForTitle">
                                <label className="float-left styleForTitle">
                                  Image
                                </label>

                                <input
                                  type="file"
                                  id="customFile"
                                  className="form-control"
                                  accept="image/png, image/jpeg, image/jpg"
                                  onChange={imageLoad} // just stores file
                                />
                                <p className='extention-show'>Accept only .png, .jpeg and .jpg</p>

                                {image.length === 0 && (
                                  <div className="pl-1 text-left">
                                    <Typography
                                      variant="caption"
                                      color="error"
                                      style={{
                                        fontFamily: 'Circular-Loom',
                                        color: '#ee2e47',
                                      }}
                                    >
                                      {error.image}
                                    </Typography>
                                  </div>
                                )}

                                <>
                                  {imagePath && (
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
                                          'rgb(101 146 173 / 34%) 0px 0px 0px 1.2px',
                                        borderRadius: 10,
                                        marginTop: 10,
                                        float: 'left',
                                      }}
                                    />
                                  )}

                                  <div
                                    className="img-container"
                                    style={{
                                      display: 'inline',
                                      position: 'relative',
                                      float: 'left',
                                    }}
                                  ></div>
                                </>
                              </div>
                              <div className="col-12">
                                <label
                                  htmlFor="description"
                                  className="styleForTitle mt-3 movieForm"
                                >
                                  Description
                                </label>

                                <SunEditor
                                  value={description}
                                  setContents={description}
                                  ref={editor}
                                  height={318}
                                  onChange={(e) => {
                                    setDescription(e);

                                    if (!e) {
                                      return setError({
                                        ...error,
                                        description:
                                          'Description is Required !',
                                      });
                                    } else {
                                      return setError({
                                        ...error,
                                        description: '',
                                      });
                                    }
                                  }}
                                  placeholder="Description"
                                  setOptions={editorOptions}
                                />

                                {error.description && (
                                  <div className="pl-1 text-left">
                                    <Typography
                                      variant="caption"
                                      style={{
                                        fontFamily: 'Circular-Loom',
                                        color: '#ee2e47',
                                      }}
                                    >
                                      {error.description}
                                    </Typography>
                                  </div>
                                )}
                              </div>
                            </div>
                          </div>
                        </form>
                      </div>
                    </div>
                  </div>

                  <div className="iq-card-footer">
                    <div className='d-flex justify-content-end'>
                      {dialogData ? (
                        <button
                          type="button"
                          className="btn btn-success btn-sm mr-2 px-4 py-2"
                          onClick={handleSubmit}
                        >
                          Update
                        </button>
                      ) : (
                        <button
                          type="button"
                          className="btn btn-sm btn-success mr-2 px-4 py-2"
                          onClick={handleSubmit}
                        >
                          Insert
                        </button>
                      )}
                      <button
                        type="button"
                        className="btn btn-danger btn-sm  px-4 py-2"
                        onClick={handleClose}
                      >
                        Cancel
                      </button>
                    </div>
                  </div>
                  {/* <UploadProgress data={data} movieId={movieId} /> */}
                  {/* <UploadProgressManual data={data} /> */}
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
  getContent,
  updateContent,
  loadMovieData,
  insertContent,
})(ContentForm);
