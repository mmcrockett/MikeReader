import axios from 'axios';

const baseUrl = '/api/entries';

class EntryService {
  static getPods() {
    return axios.get([baseUrl, 'pods.json'].join('/'));
  };

  static get() {
    return axios.get(baseUrl + '.json');
  }

  static delete(entry) {
    return axios.delete([baseUrl, entry.id + '.json'].join('/'));
  }
};

export default EntryService;
