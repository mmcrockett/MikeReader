import React from 'react';
import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';
import EntryService from './EntryService';
import _ from 'lodash';
import { DateTime } from 'luxon';

const tzOptions = {
  timeZone: 'America/Chicago'
};
const dateOptions = {
  year: 'numeric',
  month: 'numeric',
  day: 'numeric',
  ...tzOptions
}
const timeOptions = {
  hour: 'numeric',
  minute: 'numeric',
  ...tzOptions
};

function Navigation(props) {
  const [history, setHistory] = React.useState({});
  const getClassNames = () => {
    if ('production' == process.env.RAILS_ENV) {
      return 'primary';
    } else if ('staging' == process.env.RAILS_ENV) {
      return 'secondary';
    } else {
      return 'warning';
    }
  };
  const lastChecked = () => {
    let lc = '- - -';

    if (history.checked_at) {
      let lc_date = new Date(history.checked_at);
      let options = timeOptions;
      let yesterday = DateTime.local().minus({days: 1});

      if (yesterday > lc_date) {
        options = dateOptions;
      }

      lc = new Intl.DateTimeFormat('en-US', options).format(new Date(lc_date));
    }

    return (
      <React.Fragment>
        <Navbar.Text>{lc}</Navbar.Text>
      </React.Fragment>
    );
  };

  React.useEffect(() => {
    EntryService.getHistory().then((response) => { setHistory(response.data); }).catch((err) => { console.error(err); });
  }, []);

  return (
    <React.Fragment>
      <Navbar bg={getClassNames()} variant={'dark'} expand={'lg'}>
        <Navbar.Brand href="/entries">Mike Reader</Navbar.Brand>
        <Nav className="mr-auto">
          <Nav.Link href="/feeds">Feeds</Nav.Link>
          <Nav.Link href="/entries">Entries</Nav.Link>
        </Nav>
        {lastChecked()}
      </Navbar>
    </React.Fragment>
  );
}

export default Navigation;
