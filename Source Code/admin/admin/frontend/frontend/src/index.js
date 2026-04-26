import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
//react-router-dom
import { BrowserRouter } from 'react-router-dom';

//axios
import axios from 'axios';

//react-redux
import { Provider } from 'react-redux';

//Provider
import store from './store/Provider';
import { OPEN_LOADER, CLOSE_LOADER } from './store/Loader/loader.type';

//BaseUrl
import { baseURL, secretKey } from './util/config';
import { CLOSE_GENRE_TOAST } from './store/Genre/genre.type';
axios.defaults.baseURL = baseURL;
axios.defaults.validateStatus = function (status) {
  return true; // Accept all HTTP status codes
};

const apiInstance = axios.create({
  baseURL: baseURL,
  headers: {
    'Content-Type': 'application/json',
    key: secretKey,
  },
});

//Spinner
apiInstance.interceptors.request.use(
  (req) => {
    // Dispatch loading action
    store.dispatch({ type: OPEN_LOADER });

    // Attach token dynamically
    const token = sessionStorage.getItem('token');
    if (token) {
      req.headers.Authorization = token;
    }

    return req;
  },
  (error) => {
    store.dispatch({ type: CLOSE_LOADER });
    return Promise.reject(error);
  }
);

apiInstance.interceptors.response.use(
  (res) => {
    store.dispatch({ type: CLOSE_LOADER });

    if (res.status === 401 || res.status === 403) {
      localStorage.clear();
      sessionStorage.clear();
      window.location.href = '/';
    }

    return res;
  },
  (err) => {
    store.dispatch({ type: CLOSE_LOADER });

    if (err.message === 'Network Error') {
      console.error('Network Error');
    }

    return Promise.reject(err);
  }
);

export const api = {
  get: (url, config = {}) => apiInstance.get(url, config),
  post: (url, data, config = {}) => apiInstance.post(url, data, config),
  patch: (url, data, config = {}) => apiInstance.patch(url, data, config),
  put: (url, data, config = {}) => apiInstance.put(url, data, config),
  delete: (url, config = {}) => apiInstance.delete(url, config),
};

ReactDOM.render(
  <React.StrictMode>
    <BrowserRouter>
      <Provider store={store}>
        {/* <AxiosInterceptor />  */}
        <div className="">
        {/* <div className="dark"> */}
          <App />
        </div>
      </Provider>
    </BrowserRouter>
  </React.StrictMode>,
  document.getElementById('root')
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
