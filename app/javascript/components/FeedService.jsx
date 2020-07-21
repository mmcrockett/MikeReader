import axios from 'axios';

const baseUrl = '/api/feeds';

class FeedService {
  static get() {
    return axios.get(baseUrl + '.json');
  }

  static put(feed) {
    return axios.put([baseUrl, feed.id + '.json'].join('/'), feed);
  }
};

export default FeedService;
