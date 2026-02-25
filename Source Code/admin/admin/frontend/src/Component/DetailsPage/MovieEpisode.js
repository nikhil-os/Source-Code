import { connect, useDispatch, useSelector } from 'react-redux';
import Pagination from '../../Pages/Pagination';
import React, { useEffect, useState } from 'react';
import {
  deleteEpisode,
  getMovieOfWebSeriesWiseShortVideo,
} from '../../store/EpisodeList/EpisodeList.action';
import { useLocation } from 'react-router-dom';
import noImage from '../../Component/assets/images/noImage.png';
import { warning } from '../../util/Alert';
import { Toast } from '../../util/Toast_';
import {
  OPEN_INSERT_DIALOG,
  OPEN_SHORT_DIALOG,
} from '../../store/EpisodeList/EpisodeList.type';
import EpisodeListDialogue from '../Dialog/EpisodeListDialog';
import { IconEdit, IconTrash } from '@tabler/icons-react';

const MovieEpisode = () => {
  const { loader } = useSelector((state) => state.loader);


  const [activePage, setActivePage] = useState(1);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const { episode, total } = useSelector((state) => state.episodeList);

  const location = useLocation();

  const dispatch = useDispatch();

  useEffect(() => {
    const payload = {
      start: activePage,
      limit: rowsPerPage,
      movieSeriesId: location?.state?._id,
    };
    dispatch(getMovieOfWebSeriesWiseShortVideo(payload));
  }, [activePage, rowsPerPage, location?.state?._id]);

  const handlePageChange = (pageNumber) => {
    setActivePage(pageNumber);
  };

  const handleRowsPerPage = (value) => {
    setActivePage(1);
    setRowsPerPage(value);
  };

  const deleteOpen = (movieId) => {
    const data = warning();
    data
      .then((result) => {
        if (result.isConfirmed) {

          dispatch(deleteEpisode(movieId));
          Toast('success', 'Short Video deleted successfully.');
        }
      })
      .catch((err) => console.log(err));
  };

  const updateOpen = (data) => {
    dispatch({ type: OPEN_SHORT_DIALOG, payload: data });
  };

  return (
    <>
      <EpisodeListDialogue />
      <div id="content-page" className="content-page">
        <div className="container-fluid">
          <div className='iq-card mt-2'>

            <div className="iq-card-body">
              <div className="table-responsive custom-table">
                <table
                  id="user-list-table"
                  className="table table-striped table-borderless mb-0"
                  role="grid"
                  aria-describedby="user-list-page-info"
                >
                  <thead class="text-nowrap">
                    <tr>
                      <th className="tableAlign">ID</th>
                      <th className="tableAlign">Video</th>
                      <th className="tableAlign">Image</th>
                      <th className="tableAlign">Share Count</th>
                      <th className="tableAlign">Total Likes</th>
                      <th className="tableAlign">Duration (Second)</th>
                      {/* <th className="tableAlign">Edit</th> */}
                      <th className="tableAlign">Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {episode?.length > 0 ? (
                      episode.map((data, index) => {
                        return (
                          <React.Fragment key={index}>
                            <tr>
                              <td className="pr-3 tableAlign">{index + 1}</td>
                              <td className="text-center">
                                <video
                                  controls
                                  src={data?.videoUrl}
                                  height={100}
                                  width={100}
                                />
                              </td>

                              <td className="pr-3 text-center">
                                <img
                                  className="img-fluid"
                                  style={{
                                    height: '100px',
                                    width: '80px',
                                    boxShadow:
                                      '0 5px 15px 0 rgb(105 103 103 / 0%)',
                                    border:
                                      '0.5px solid rgba(255, 255, 255, 0.20)',
                                    borderRadius: 10,
                                    objectFit: 'cover',
                                  }}
                                  src={
                                    data?.videoImage ? data?.videoImage : noImage
                                  }
                                  onError={(e) => {
                                    e.target.onerror = null; // Prevents infinite loop
                                    e.target.src = noImage; // Default image path
                                  }}
                                  alt=""
                                />
                              </td>

                              <td className="text-start text-capitalize text-center">
                                {data?.totalLikes || 0}
                              </td>
                              <td className="description-text text-center">
                                {data?.shareCount || 0}
                              </td>
                              <td className="description-text text-center">
                                {data?.duration || 0}
                              </td>
                              <td className="pr-3 tableAlign">
                                <div className='d-flex justify-content-center '>
                                  <button
                                    type="button"
                                    className="btn custom-action-button btn-sm mr-2"
                                    onClick={() => updateOpen(data)}
                                  >
                                    <IconEdit className='text-secondary' />
                                  </button>
                                  <button
                                    type="button"
                                    className="btn custom-action-button btn-sm"
                                    onClick={() => deleteOpen(data._id)}
                                  >
                                    <IconTrash className='text-secondary' />
                                  </button>
                                </div>
                              </td>
                              {/* <td className="pr-3 tableAlign">
                              <button
                                type="button"
                                className="btn iq-bg-primary btn-sm"
                                onClick={() => deleteOpen(data._id)}
                              >
                                <i
                                  class="ri-delete-bin-6-line"
                                  style={{ fontSize: '19px' }}
                                ></i>
                              </button>
                            </td> */}
                            </tr>
                          </React.Fragment>
                        );
                      })
                    ) : (
                      ""
                    )}
                  </tbody>
                </table>
              </div>
            </div>
            <div className='iq-card-footer'>

              <Pagination
                activePage={activePage}
                rowsPerPage={rowsPerPage}
                userTotal={total}
                handleRowsPerPage={handleRowsPerPage}
                handlePageChange={handlePageChange}
              />

            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default connect(null, {})(MovieEpisode);
