//Alert
import Swal from "sweetalert2";


export const warning = () => {
  return Swal.fire({
    title: "Are you sure?",
    text: "You won't be able to revert this!",
    icon: "warning",
    showCancelButton: true,
    confirmButtonColor: "#2992ff",
    cancelButtonColor: "#d33",
    confirmButtonText: "Yes, Delete it!",
    // title: "Are You Sure!",
    // icon: "warning",
    // dangerMode: true,
    // buttons: true,
  });
};

export const alert = (title, data, type) => {
  return Swal.fire(title, data, type);
};
