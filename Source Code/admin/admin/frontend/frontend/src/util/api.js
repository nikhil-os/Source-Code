import { CLOSE_LOADER, OPEN_LOADER } from "../store/Loader/loader.type";
import { baseURL, secretKey } from "./config";
import store from "../store/Provider";

export const openSpinner = () => {
  return store.dispatch({ type: OPEN_LOADER });
};

export const closeSpinner = () => {
  return store.dispatch({ type: CLOSE_LOADER });
};
const token = sessionStorage.getItem("token");
export const apiInstanceFetch = {
  baseURL: `${baseURL}`, // Set your default base URL here
  headers: {
    "Content-Type": "application/json",
    key: `${secretKey}`,
    Authorization: `${sessionStorage.getItem("token")}`,
  },
  get: (url) => {
    openSpinner();
    return fetch(`${apiInstanceFetch?.baseURL}${url}`, {
      method: "GET",
      headers: apiInstanceFetch?.headers,
    })
      .then(handleErrors)
      .finally(() => closeSpinner());
  },

  post: (url, data) => {
    openSpinner();
    return fetch(`${apiInstanceFetch.baseURL}${url}`, {
      method: "POST",
      headers: { ...apiInstanceFetch.headers },
      body: JSON.stringify(data),
    })
      .then(handleErrors)
      .finally(() => closeSpinner());
  },

  patch: (url, data) => {
    openSpinner();
    return fetch(`${apiInstanceFetch.baseURL}${url}`, {
      method: "PATCH",
      headers: { ...apiInstanceFetch.headers },
      body: JSON.stringify(data),
    })
      .then(handleErrors)
      .finally(() => closeSpinner());
  },

  put: (url, data) => {
    openSpinner();
    return fetch(`${apiInstanceFetch.baseURL}${url}`, {
      method: "PUT",
      headers: { ...apiInstanceFetch.headers },
      body: JSON.stringify(data),
    })
      .then(handleErrors)
      .finally(() => closeSpinner());
  },

  delete: (url) => {
    openSpinner();
    return fetch(`${apiInstanceFetch.baseURL}${url}`, {
      method: "DELETE",
      headers: apiInstanceFetch.headers,
    })
      .then(handleErrors)
      .finally(() => closeSpinner());
  },
};

function handleErrors(response) {
  if (response.status === 401) {
    throw new Error(`HTTP error! Status: ${response?.status}`);
  }
  return response.json();
}
