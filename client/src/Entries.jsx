import React from 'react';
import Container from 'react-bootstrap/Container';
import Entry from './Entry';
import EntryService from './EntryService';

function Entries({ updateMessages }) {
  const [entries, setEntries] = React.useState([]);

  const errorMessage = React.useCallback((err) => {
    updateMessages({danger: 'There was an error.'});
    console.log(err);
  }, [updateMessages]);

  React.useEffect(() => {
    EntryService.get().then((response) => { setEntries(response.data); }).catch(errorMessage);
  }, [errorMessage]);

  const entryRows = () => {
    return entries.map((entry, i) => {
      return (<Entry updateMessages={updateMessages} key={entry.id} isLast={(entries.length - 1) === i} entry={entry} />);
    });
  };

  return (
    <Container fluid>
      {entryRows()}
    </Container>
  );
}

export default Entries;
