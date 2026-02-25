import React, { useEffect } from 'react';

//router
import { Route, Switch, useHistory, useRouteMatch } from 'react-router-dom';

//component
import Navbar from '../Component/Navbar/Navbar';
import Sidebar from '../Component/Navbar/Sidebar';
import Dashboard from '../Pages/Dashboard';
import User from '../Component/Table/User';
import Region from '../Component/Table/Region';
import Genre from '../Component/Table/Genre';
import Movie from '../Component/Table/Movie';
import TvSeries from '../Component/Table/TvSeries';
import SeriesForm from '../Component/Dialog/SeriesForm';
import Profile from '../Pages/Profile';
import Trailer from '../Component/Table/Trailer';
import TeamMember from '../Component/Table/TeamMember';
import MovieDetails from '../Component/DetailsPage/MovieDetails';
import Episode from '../Component/Table/Episode';
import TrailerForm from '../Component/Dialog/TrailerForm';
import SeriesTrailerForm from '../Component/Dialog/SeriesTrailerForm';
import EpisodeForm from '../Component/Dialog/EpisodeForm';
import TeamMemberForm from '../Component/Dialog/TeamMemberForm';
import SeriesTeamMemberForm from '../Component/Dialog/SeriesTeamMemberForm';
import Loader from '../Pages/Loader';
import UserHistory from '../Pages/UserHistory';
import PremiumPlan from '../Component/Table/PremiumPlan';
import PurchasePremiumPlanTable from '../Component/Table/purchasePremiumPlanHistory';
import ContactUs from '../Pages/ContactUs';
import Faq from '../Pages/Faq';
import Content from '../Pages/Content';
import Setting from '../Pages/Setting';
import AdminInfo from './AdminInfo';
import Advertisement from './Advertisement';
import Season from '../Component/Table/Season';
import MovieDialog from '../Component/Dialog/MovieDialog';
import MovieForm from '../Component/Dialog/MovieForm';
import LiveTv from '../Component/Table/LiveTv';
import SeriesTrailer from '../Component/Table/SeriesTrailer';
import SeriesCast from '../Component/Table/SeriesCast';
import WebSeriesDetail from '../Component/Dialog/WebSeriesDetail';
import SeriesManual from '../Component/Dialog/SeriesManual';
import LiveTvDialogue from '../Component/Dialog/LiveTvDialogue';
import { useSelector } from 'react-redux';
import UserRaisedTicket from '../Component/Table/UserRaisedTicket';
import MovieEpisode from '../Component/DetailsPage/MovieEpisode';
import Shorts from './Shorts';
import WebSeriesEpisode from '../Component/DetailsPage/WebSeriesEpisode';
import ContentForm from '../Component/Dialog/ContentForm';

const Admin = () => {
  const location = useRouteMatch();
  const history = useHistory();

  const { fileUpload } = useSelector((state) => state.movie);

  useEffect(() => {
    if (
      history.location.pathname === '/' ||
      history.location.pathname === '/admin' ||
      history.location.pathname === '' ||
      history.location.pathname === '/admin/'
    ) {
      history.push('/admin/dashboard');
    }
  }, []);

  return (
    <>
      <div id="layout-wrapper">
        <Navbar />
        <Sidebar />
        <Switch>
          <Route
            path={`${location.path}/dashboard`}
            exact
            component={Dashboard}
          />
          <Route exact path={`${location.path}/user`} component={User} />
          <Route
            exact
            path={`${location.path}/raisedTicket`}
            component={UserRaisedTicket}
          />
          <Route
            exact
            path={`${location.path}/user/history`}
            component={UserHistory}
          />

          <Route exact path={`${location.path}/movie`} component={Movie} />
          <Route
            exact
            path={`${location.path}/web_series`}
            component={TvSeries}
          />
          <Route
            exact
            path={`${location.path}/shortVideo`}
            component={Shorts}
          />

          <Route
            exact
            path={`${location.path}/web_series/webSeriesDetail`}
            component={WebSeriesDetail}
          />

          <Route
            exact
            path={`${location.path}/movie/trailer`}
            component={Trailer}
          />
          <Route
            exact
            path={`${location.path}/web_series/trailer`}
            component={SeriesTrailer}
          />
          <Route
            exact
            path={`${location.path}/web_series/season`}
            component={Season}
          />
          <Route exact path={`${location.path}/episode`} component={Episode} />
          <Route exact path={`${location.path}/live_tv`} component={LiveTv} />

          <Route
            exact
            path={`${location.path}/live_tv/createLiveTv`}
            component={LiveTvDialogue}
          />
          <Route exact path={`${location.path}/region`} component={Region} />
          <Route exact path={`${location.path}/genre`} component={Genre} />
          <Route
            exact
            path={`${location.path}/premium_plan`}
            component={PremiumPlan}
          />
          <Route
            exact
            path={`${location.path}/premium_plan_history`}
            component={PurchasePremiumPlanTable}
          />
          <Route
            exact
            path={`${location.path}/advertisement`}
            component={Advertisement}
          />
          <Route
            exact
            path={`${location.path}/episode/episode_form`}
            component={EpisodeForm}
          />
          <Route
            exact
            path={`${location.path}/movie/cast`}
            component={TeamMember}
          />
          <Route
            exact
            path={`${location.path}/web_series/cast`}
            component={SeriesCast}
          />
          <Route
            exact
            path={`${location.path}/cast/cast_form`}
            component={TeamMemberForm}
          />
          <Route
            exact
            path={`${location.path}/series_cast/cast_form`}
            component={SeriesTeamMemberForm}
          />
          <Route exact path={`${location.path}/profile`} component={Profile} />
          <Route
            exact
            path={`${location.path}/movie/movie_details`}
            component={MovieDetails}
          />

          <Route
            exact
            path={`${location.path}/movie/movide_episode`}
            component={MovieEpisode}
          />

          <Route
            exact
            path={`${location.path}/web_series/webSeries_episode`}
            component={WebSeriesEpisode}
          />

          <Route
            exact
            path={`${location.path}/movie/movie_form`}
            component={MovieDialog}
          />
          <Route
            exact
            path={`${location.path}/movie/movie_manual`}
            component={MovieForm}
          />

          <Route
            exact
            path={`${location.path}/web_series/series_form`}
            component={SeriesForm}
          />

          <Route
            exact
            path={`${location.path}/web_series/series_manual`}
            component={SeriesManual}
          />
          <Route
            exact
            path={`${location.path}/trailer/trailer_form`}
            component={TrailerForm}
          />
          <Route
            exact
            path={`${location.path}/series_trailer/trailer_form`}
            component={SeriesTrailerForm}
          />
          <Route
            exact
            path={`${location.path}/profile/admin_info`}
            component={Profile}
          />

          <Route
            exact
            path={`${location.path}/help_center/faq`}
            component={Faq}
          />
          <Route exact path={`${location.path}/content`} component={Content} />
          <Route
            exact
            path={`${location.path}/content/content_form`}
            component={ContentForm}
          />
          <Route
            exact
            path={`${location.path}/help_center/contact_us`}
            component={ContactUs}
          />
          <Route exact path={`${location.path}/setting`} component={Setting} />
        </Switch>
        {/* <Loader /> */}
      </div>
      {/* <div class="vertical-overlay"></div> */}
    </>
  );
};

export default Admin;
