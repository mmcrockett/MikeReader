import React from 'react';
import Table from 'react-bootstrap/Table';
import Form from 'react-bootstrap/Form';
import FeedService from './FeedService';
import _ from 'lodash';

function Feeds({ updateMessages }) {
  const [feeds, setFeeds] = React.useState([]);

  const errorMessage = React.useCallback((err) => {
    updateMessages({danger: 'There was an error.'});
    console.log(err);
  }, [updateMessages]);

  const successMessage = (response) => {
    updateMessages({success: "Saved changes to '" + response.data.name + "'."});
  };

  const updateFeed = (i, event) => {
    let updatedFeeds = [...feeds];

    updatedFeeds[i].display = event.target.checked;

    FeedService.put(updatedFeeds[i]).then(successMessage).catch(errorMessage);

    setFeeds(updatedFeeds);
  };

  React.useEffect(() => {
    FeedService.get().then((response) => { setFeeds(response.data); }).catch(errorMessage);
  }, [errorMessage]);

  const toggleTd = (feed, i) => {
    return (
        <Form.Switch
          key={feed.id}
          onChange={(event) => { updateFeed(i, event); } }
          id={'enable-switch-' + feed.id}
          label={feed.id}
          aria-label={'Enable ' + feed.name}
          checked={feed.display}
        />
    );
  };

  const feedRows = () => {
    return feeds.map((feed, i) => {
      let attr = _.pick(feed, ['id', 'name', 'url']);
      let tds  = _.map(attr, (v, k) => { return (<td key={k}>{v}</td>); });

      return (
        <tr key={i}>
          {tds}
          <td>{toggleTd(feed, i)}</td>
        </tr>
      );
    });
  };

  return (
    <React.Fragment>
      <Table striped responsive size="sm">
        <thead>
          <tr>
            <th>id</th>
            <th>name</th>
            <th>url</th>
            <th>active?</th>
          </tr>
        </thead>
        <tbody>
          {feedRows()}
        </tbody>
      </Table>
    </React.Fragment>
  );
}

export default Feeds;
