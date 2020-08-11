import axios from 'axios';
import _ from 'lodash';

const baseUrl = '/api/entries';

class EntryService {
  static getPods() {
    return axios.get([baseUrl, 'pods.json'].join('/'));
  };

  static getHistory() {
    return axios.get([baseUrl, 'history.json'].join('/'), { params: {timestamp: _.now()} });
  }

  static get() {
    return axios.get(baseUrl + '.json', { params: {timestamp: _.now()} });
  }

  static delete(entry) {
    return axios.delete([baseUrl, entry.id + '.json'].join('/'));
  }
};

export default EntryService;
