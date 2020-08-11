import React from 'react';
import Container from 'react-bootstrap/Container';
import Entry from './Entry';
import EntryService from './EntryService';

function Entries({ updateMessages }) {
  const [entries, setEntries] = React.useState([]);

  const getWebsocketsEndpoint = () => {
    if ('production' == process.env.RAILS_ENV) {
      return 'ws://reader.mmcrockett.com/cable';
    } else if ('staging' == process.env.RAILS_ENV) {
      return 'ws://reader.test.mmcrockett.com/cable';
    } else {
      return 'ws://localhost:5000/cable';
    }
  };

  const errorMessage = React.useCallback((err) => {
    updateMessages({danger: 'There was an error.'});
    console.log(err);
  }, [updateMessages]);

  React.useEffect(() => {
    EntryService.get().then((response) => { setEntries(response.data); }).catch(errorMessage);

    const interval = setInterval(() => {
      EntryService.get().then((response) => { setEntries(response.data); }).catch(errorMessage);
    }, 60 * 60 * 1000);

    return () => clearInterval(interval);
  }, [errorMessage]);

  const entryRows = () => {
    return entries.map((entry, i) => {
      return (<Entry updateMessages={updateMessages} key={entry.id} isLast={(entries.length - 1) === i} entry={entry} />);
    });
  };

  const handleReceivedEntries = (message) => {
    setEntries(message);
  };

  return (
    <Container fluid>
      {entryRows()}
    </Container>
  );
}

export default Entries;
