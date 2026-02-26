import $ from 'jquery';
import { useEffect, useRef } from "react";
import logo from '../assets/images/logo.png';
//MUI
import { makeStyles } from '@mui/styles';
//react-router-dom
import { NavLink, useHistory } from 'react-router-dom';

//Alert
import Swal from 'sweetalert2';

//Redux - Action
import { useDispatch } from 'react-redux';
import { UNSET_ADMIN } from '../../store/Admin/admin.type';

// icon
import { IconBadgeAd, IconBasketDollar, IconBrandNetflix, IconClipboardData, IconConfetti, IconDeviceTvOld, IconHelp, IconHistory, IconHome2, IconLogout, IconMovie, IconPhotoVideo, IconSettings, IconTicket, IconTimezone, IconUser, IconUserCircle } from '@tabler/icons-react';
import { projectName } from '../../util/config';

const useStyles = makeStyles(() => ({
  navLink: {
    '&.active': {
      background: "linear-gradient(90deg,rgba(73, 137, 247, 1) 0%, rgba(133, 177, 255, 1) 100%)",
      color: '#fff !important',
      fontWeight: 500,
      fontSize: 16,
    },
    '&.active i': {
      background: "linear-gradient(90deg,rgba(73, 137, 247, 1) 0%, rgba(133, 177, 255, 1) 100%)",
      color: '#fff !important',
      fontWeight: 500,
    },
    '&.active i a span': {
      background: "linear-gradient(90deg,rgba(73, 137, 247, 1) 0%, rgba(133, 177, 255, 1) 100%)",
      color: '#fff !important',
      fontWeight: 500,
    },
  },
}));

const handleClick = () => {
  $('.setting').toggleClass('active');
};

const handleRemove = () => {
  $('.setting').toggleClass('active');
};

const handleCollapse = () => {
  $('body').toggleClass('sidebar-main');
  $('.wrapper-menu').toggleClass('open');
};

const closeSidebar = () => {
  $('body').removeClass('sidebar-main');
  $('.wrapper-menu').removeClass('open');
};


const Sidebar = () => {

  const sidebarRef = useRef(null);

  const dispatch = useDispatch();
  const history = useHistory();
  const classes = useStyles();


  useEffect(() => {
    const handleOutsideClick = (event) => {
      if (
        sidebarRef.current &&
        !sidebarRef.current.contains(event.target)
      ) {
        // Agar sidebar open hai tabhi close kare
        if ($("body").hasClass("sidebar-main")) {
          $("body").removeClass("sidebar-main");
          $(".wrapper-menu").removeClass("open");
        }
      }
    };

    document.addEventListener("mousedown", handleOutsideClick);

    return () => {
      document.removeEventListener("mousedown", handleOutsideClick);
    };
  }, []);

  const logout = () => {
    Swal.fire({
      title: 'Are you sure?',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Logout',
    })
      .then((result) => {
        if (result.isConfirmed) {
          dispatch({ type: UNSET_ADMIN });
          history.push('/login');
        }
      })
      .catch((err) => console.log(err));
  };

  return (
    <>
      <div className="iq-sidebar" ref={sidebarRef}>
        <div className="iq-sidebar-logo d-flex justify-content-between">
          <NavLink to="/admin/dashboard">
            <div clssName="iq-light-logo">
              {/* <div className="iq-light-logo">
                <img src="images/logo.gif" className="img-fluid" alt />
              </div> */}
              <div className="iq-dark-logo ml-3">
                <img src={logo} className="img-fluid" alt />
              </div>
            </div>

            <span
              style={{ fontWeight: '600', fontSize: '30px', color: '#000' }}
            >
              {projectName}
            </span>
          </NavLink>
          <div className="iq-menu-bt-sidebar">
            <div className="iq-menu-bt align-self-center">
              <div className="wrapper-menu">
                <div onClick={() => handleCollapse}>
                  <i className="ri-menu-3-line" />
                </div>
              </div>
            </div>
          </div>
        </div>
        <div id="sidebar-scrollbar">
          <div
            className="scroll-content mt-2"
          // style={{ transform: "translate3d(0px, -550px, 0px)" }}
          >
            <nav className="iq-sidebar-menu">
              <ul id="iq-sidebar-toggle" className="iq-menu">
                <div className="custom-sidebar-label">General</div>
                <li>
                  <NavLink
                    to="/admin/dashboard"
                    className={`${classes.navLink} `}
                    onClick={closeSidebar}
                  >

                    <IconHome2 />
                    <span className="pl-2">Dashboard</span>
                  </NavLink>
                </li>
                <li>
                  <NavLink to="/admin/user" className={`${classes.navLink}`} onClick={closeSidebar}
                  >
                    {/* className="iq-waves-effect"  */}
                    <IconUser />
                    <span className="pl-2">User</span>
                  </NavLink>
                </li>
                <div className="custom-sidebar-label">Explore</div>
                <li>
                  {/* <NavLink to="/admin/movie" className={`${classes.navLink}`}> */}
                  <NavLink
                    to="/admin/movie"
                    className={`${classes.navLink}`}
                    onClick={closeSidebar}

                    isActive={(_, location) =>
                      location.pathname.startsWith('/admin/movie') ||
                      location.pathname === '/admin/trailer/trailer_form' ||
                      location.pathname === '/admin/cast/cast_form'
                    }
                  >
                    {/* className="iq-waves-effect" */}
                    <IconMovie />
                    <span className="pl-2">Movie</span>
                  </NavLink>
                </li>
                <li>
                  <NavLink
                    to="/admin/web_series"
                    className={`${classes.navLink}`}
                    onClick={closeSidebar}
                    isActive={(_, location) =>
                      location.pathname.startsWith('/admin/web_series') ||
                      location.pathname === '/admin/episode' ||
                      location.pathname ===
                      '/admin/series_trailer/trailer_form' ||
                      location.pathname === '/admin/episode/episode_form' ||
                      location.pathname === '/admin/series_cast/cast_form'
                    }
                  >
                    <IconBrandNetflix />
                    <span className="pl-2">Web Series</span>
                  </NavLink>
                </li>

                <li>
                  <NavLink to="/admin/live_tv" className={`${classes.navLink}`} onClick={closeSidebar}
                  >
                    <IconDeviceTvOld />
                    <span className="pl-2">Live TV</span>
                  </NavLink>
                </li>

                <li>
                  <NavLink
                    to="/admin/shortVideo"
                    className={`${classes.navLink}`}
                    onClick={closeSidebar}

                  >
                    <IconPhotoVideo />
                    <span className="pl-2">Shorts</span>
                  </NavLink>
                </li>
                <div className="custom-sidebar-label">Content & Metadata</div>
                <li>
                  <NavLink to="/admin/content" className={`${classes.navLink}`} onClick={closeSidebar}
                  >
                    <IconConfetti />
                    <span className="pl-2">Content</span>
                  </NavLink>
                </li>
                <li>
                  <NavLink to="/admin/region" className={`${classes.navLink}`} onClick={closeSidebar}
                  >
                    <IconTimezone />
                    <span className="pl-2">Region</span>
                  </NavLink>
                </li>
                <li>
                  <NavLink to="/admin/genre" className={`${classes.navLink}`} onClick={closeSidebar}
                  >
                    <IconClipboardData />
                    <span className="pl-2">Genre</span>
                  </NavLink>
                </li>

                <div className="custom-sidebar-label">Package</div>
                <li>
                  <NavLink
                    to="/admin/premium_plan"
                    className={`${classes.navLink}`}
                    onClick={closeSidebar}

                  >
                    <IconBasketDollar />
                    <span className="pl-2">Purchase Plan</span>
                  </NavLink>
                </li>
                <li>
                  <NavLink
                    to="/admin/premium_plan_history"
                    className={`${classes.navLink}`}
                    onClick={closeSidebar}

                  >
                    <IconHistory />
                    <span className="pl-2">Purchase Plan History</span>
                  </NavLink>
                </li>
                <li>
                  <NavLink
                    to="/admin/advertisement"
                    className={`${classes.navLink}`}
                    onClick={closeSidebar}

                  >
                    <IconBadgeAd />
                    <span className="pl-2">Advertisement</span>
                  </NavLink>
                </li>
                <div className="custom-sidebar-label">Support</div>

                <li>
                  <NavLink
                    to="/admin/raisedTicket"
                    className={`${classes.navLink}`}
                    onClick={closeSidebar}

                  >
                    <IconTicket />
                    <span className="pl-2">Raised Tickets</span>
                  </NavLink>
                </li>
                <li>
                  <NavLink
                    to="/admin/help_center/faq"
                    className={`${classes.navLink}`}
                    onClick={closeSidebar}

                  >
                    <IconHelp />
                    <span className="pl-2">Help Center</span>
                  </NavLink>
                </li>
                <div className="custom-sidebar-label">Setting</div>
                <li>
                  <NavLink
                    to="/admin/profile/admin_info"
                    className={`${classes.navLink}`}
                    onClick={closeSidebar}

                  // onClick={handleRemove}
                  >
                    <IconUserCircle />
                    <span className="pl-2">Profile</span>
                  </NavLink>
                </li>
                <li>
                  <NavLink to="/admin/setting" className={`${classes.navLink}`} onClick={closeSidebar}
                  >
                    <IconSettings />
                    <span className="pl-2">Setting</span>
                  </NavLink>
                </li>

                <li>
                  <NavLink
                    to="/login"
                    className={`${classes.navLink}`}
                    onClick={logout}
                  >
                    <IconLogout />
                    <span className="pl-2">Logout</span>
                  </NavLink>
                </li>
              </ul>
            </nav>
          </div>
          <div
            className="scrollbar-track scrollbar-track-x"
            // style={{ display: "none" }}
            style={{ display: 'block' }}
          >
            <div
              className="scrollbar-thumb scrollbar-thumb-x"
              style={{
                width: '260px',
                transform: 'translate3d(0px, 0px, 0px)',
              }}
            ></div>
          </div>
          <div
            className="scrollbar-track scrollbar-track-y"
            // style={{ display: "block" }}
            style={{ display: 'none' }}
          >
            <div
              className="scrollbar-thumb scrollbar-thumb-y"
              style={{
                height: '235.982px',
                transform: 'translate3d(0px, 0px, 0px)',
              }}
            ></div>
          </div>

          <div className="p-3" />
        </div>
      </div>
    </>
  );
};

export default Sidebar;
