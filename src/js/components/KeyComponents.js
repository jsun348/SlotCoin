import React from 'react';
import colorMatteBall from '../../local-assets/matte-spheres/glow-color-sphere-matte.png';
import greyMatteBall from '../../local-assets/matte-spheres/grey-sphere.png';
import '../../css/cards-section.css';

const KeyComponents = () => {
  return (
    <div id="cards-section">
      <img id="color-sphere" class="sphere" src={colorMatteBall} alt=""/>
      <img id="sphere-1" class="sphere" src={greyMatteBall} alt=""/>
      <img id="sphere-2" class="sphere" src={greyMatteBall} alt=""/>
      <img id="sphere-3" class="sphere" src={greyMatteBall} alt=""/>

      <div className="container">
        <div className="card">
          <div className="content">
            <h2>01</h2>
            <h3>Card One</h3>
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
            <a href="#">Read More</a>
          </div>
        </div>
        <div className="card">
          <div className="content">
            <h2>02</h2>
            <h3>Card Two</h3>
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
            <a href="#">Read More</a>
          </div>
        </div>
        <div className="card">
          <div className="content">
            <h2>03</h2>
            <h3>Card Three</h3>
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
            <a href="#">Read More</a>
          </div>
        </div>
      </div>
    </div>
  )
}

export default KeyComponents;
