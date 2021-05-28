import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import Home from './components/Home';
import Error from './components/Error';

const ReactRouterSetup = () => {
  return (
    <>
      <Router>
        <div className="appContent">
          <Switch>
            <Route exact path="/">
              <Home></Home>
            </Route>

            <Route path="*">
              <Error></Error>
            </Route>
          </Switch>
        </div>
      </Router>
    </>
  );
};

export default ReactRouterSetup;
