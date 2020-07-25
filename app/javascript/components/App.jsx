import React from 'react';
import Navigation from './Navigation';
import Feeds from './Feeds';
import Entries from './Entries';
import Alert from 'react-bootstrap/Alert';
import { BrowserRouter as Router, Route, Switch, Redirect } from 'react-router-dom';
import _ from 'lodash';
import './App.css';

import 'bootstrap/dist/css/bootstrap.min.css';

function App() {
  React.useEffect(() => {
    console.warn('Node Env: ' + process.env.NODE_ENV);
  }, []);

  const [messages, setMessages] = React.useState({});

  const updateMessages = (messages) => {
    setMessages(messages);
  };

  const alertsFragment = () => {
    if (_.isEmpty(messages)) {
      return (<Alert style={{minHeight: '50px'}}>{' '}</Alert>);
    } else {
      return _.map(messages, (v, k) => {
        return (
          <Alert key={k} variant={k} dismissible onClose={ () => { setMessages(); } }>{v}</Alert>
        );
      });
    }
  };

  return (
    <React.Fragment>
      <Router forceRefresh={true}>
        <Navigation />
        {alertsFragment()}
        <Switch>
          <Route exact path="/">
            <Redirect to="/entries" />
          </Route>
          <Route path='/feeds'>
            <Feeds updateMessages={updateMessages}/>
          </Route>
          <Route path='/entries'>
            <Entries updateMessages={updateMessages}/>
          </Route>
        </Switch>
      </Router>
    </React.Fragment>
  );
}

export default App;
