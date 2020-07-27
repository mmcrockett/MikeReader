import React from 'react';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
import Button from 'react-bootstrap/Button';
import { BsX } from 'react-icons/bs';
import { FaAsterisk } from 'react-icons/fa';
import EntryService from './EntryService';
import _ from 'lodash';

const getUniqueRgbHtmlColor = (index) => {
  const colorList = [
    [240,163,255],
    [0,117,220],
    [153,63,0],
    [76,0,92],
    [25,25,25],
    [0,92,49],
    [43,206,72],
    [255,204,153],
    [128,128,128],
    [148,255,181],
    [143,124,0],
    [157,204,0],
    [194,0,136],
    [0,51,128],
    [255,164,5],
    [255,168,187],
    [66,102,0],
    [255,0,16],
    [94,241,242],
    [0,153,143],
    [224,255,102],
    [116,10,255],
    [153,0,0],
    [255,255,128],
    [255,255,0],
    [255,80,5]
  ];

  return 'rgb(' + colorList[index % colorList.length].join() + ')';
}

const allRowClassNames  = ['border-top', 'entry'];
const progressClassName = 'mikefeed-ui-progressbar-overlay';
const readClassName     = ['read'];

function Entry({ updateMessages, entry, isLast }) {
  const asteriskStyle = { color: getUniqueRgbHtmlColor(entry.feed_id) };
  const [rowClassNames, setRowClassNames]   = React.useState(allRowClassNames);

  const errorMessage = React.useCallback((err) => {
    setRowClassNames(prevState => { return _.without(prevState, progressClassName) });
    updateMessages({danger: 'There was an error.'});
    console.log(err);
  }, [updateMessages]);

  const successMessage = () => {
    setRowClassNames(prevState => { return [readClassName, ..._.without(prevState, progressClassName)] });
  };

  const goToUrl = (clickEvent) => {
    if ('a' !== clickEvent.target.tagName.toLowerCase()) {
      window.open(entry.link, '_blank');
    }

    markEntryRead();
  };

  const markEntryRead = () => {
    setRowClassNames(prevState => { return [progressClassName, ...prevState]; });
    EntryService.delete(entry).then(successMessage).catch(errorMessage);
  };

  React.useEffect(() => {
    if (true === isLast) {
      setRowClassNames(prevState => { return ['border-bottom', ...prevState]; });
    }
  }, [isLast]);

  return (
    <Row key={entry.id} className={rowClassNames}>
      <Col variant={'light'} className={'bg-transparent'} xs={'auto'} as={Button} onClick={markEntryRead}>
        <BsX />
      </Col>
      <Col xs={'auto'} className={'align-self-center'} onClick={goToUrl}>
        <FaAsterisk style={asteriskStyle} />
      </Col>
      <Col className={'text-truncate align-self-center'} onClick={goToUrl}>
        <a className={'text-decoration-none'} style={{corationLine: 'none', color: 'black'}} rel="noopener noreferrer" target="_blank" href={entry.link}>{entry.subject}</a>
      </Col>
    </Row>
  );
}

export default Entry;
