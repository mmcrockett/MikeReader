import React from 'react';
import Navbar from 'react-bootstrap/Navbar';
import Nav from 'react-bootstrap/Nav';

function Navigation(props) {
  return (
    <React.Fragment>
      <Navbar bg="secondary" variant="dark" expand="lg">
        <Navbar.Brand href="/entries">Mike Reader</Navbar.Brand>
        <Nav className="mr-auto">
          <Nav.Link href="/feeds">Feeds</Nav.Link>
          <Nav.Link href="/entries">Entries</Nav.Link>
        </Nav>
      </Navbar>
    </React.Fragment>
  );
}

export default Navigation;
