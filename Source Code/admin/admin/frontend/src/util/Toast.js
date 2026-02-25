//Toast
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
// :root {
//   --toastify-toast-background: rgba(34, 31, 58, 1) !important;
// }

export const setToast = (toastData, actionFor) => {
  
  if (["insert" , "success"].includes(actionFor)) {
  // if (actionFor === "insert") {
    toast.configure();
    toast.success(toastData, {
      autoClose: 2000,
      position: "top-right",
      pauseOnHover: true,
      hiddenProgressBar: false,
      progress: undefined,
      draggable: true,
    });
  } else if (actionFor === "update") {
    toast.configure();
    toast.info(toastData, {
      autoClose: 2000,
      position: "top-right",
      pauseOnHover: true,
      hiddenProgressBar: false,
      progress: undefined,
      draggable: true,
    });
  } else {
    toast.configure();
    toast.error(toastData, {
      autoClose: 2000,
      position: "top-right",
      pauseOnHover: true,
      hiddenProgressBar: false,
      progress: undefined,
      draggable: true,
    });
  }
};
