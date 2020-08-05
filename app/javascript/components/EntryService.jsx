import axios from 'axios';

const baseUrl = '/api/entries';

class EntryService {
  static getPods() {
    return axios.get([baseUrl, 'pods.json'].join('/'));
  };

  static getHistory() {
    return axios.get([baseUrl, 'history.json'].join('/'));
  }

  static get() {
    return axios.get(baseUrl + '.json', { params: {timestamp: new Date()} });
  }

  static delete(entry) {
    return axios.delete([baseUrl, entry.id + '.json'].join('/'));
  }
};

export default EntryService;
