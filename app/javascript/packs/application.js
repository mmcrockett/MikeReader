require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")


import React from 'react';
import { render } from 'react-dom';
import App from '../components/App';

document.addEventListener('DOMContentLoaded', () => {
  const container = document.body.appendChild(document.createElement('div'));
  render(<App />, container);
});
