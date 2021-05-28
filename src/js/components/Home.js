import React from 'react';
import pancakeSwapIcon from '../../local-assets/pancakeswap-logo.svg';
import darkCoin from '../../local-assets/dark-coin.svg'
import greyCoin from '../../local-assets/grey-coin-flipped.svg'
import lightgreyCoin from '../../local-assets/lightgrey-coin-flipped.svg'
import fadedCoin from '../../local-assets/faded-coin-flipped.svg'
import colorCoin from '../../local-assets/full-color-no-logo-coin.svg'

import mainBall from '../../local-assets/intro-visual-full/main-ball.svg';
import mainGlow from '../../local-assets/intro-visual-full/main-glow.svg';
import otherBalls from '../../local-assets/intro-visual-full/other-balls.svg';
import platforms from '../../local-assets/intro-visual-full/platforms.svg';
import tokens from '../../local-assets/intro-visual-full/tokens.svg';

import colorMatteBall from '../../local-assets/matte-spheres/glow-color-sphere-matte.png';
import greyMatteBall from '../../local-assets/matte-spheres/grey-sphere.png';

import '../../css/home.css';
import '../../css/intro-visual.css';
import '../../css/cards-section.css';

const Home = () => {
  const contractAddress = "0x5e90253fbae4Dab78aa351f4E6fed08A64AB5590"

  const pancakeswapRoute = () => {
    window.open("https://exchange.pancakeswap.finance/#/swap")
  }
  const priceChartRoute = () => {
    window.open(`https://charts.bogged.finance/?token=${contractAddress}`)
  }

  return (
    <>
    <div id="app-intro">
      <div id="app-intro--main-text">
        <h1>POWERBALL</h1>
        <p>Every token you own increases the probability of winning the jackpot!</p>
      </div>
      <div id="app-intro--visual-container">
        <img id="platforms" src={platforms} alt=""/>
        <img id="floating-tokens" src={tokens} alt=""/>
        <img id="floating-other-balls" src={otherBalls} alt=""/>
        <img id="main-glow" src={mainGlow} alt=""/>
        <img id="floating-main-ball" src={mainBall} alt=""/>
      </div>
    </div>

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

    <div id="swap-token">
      <div id="swap-token--visual">
        <img className="flip-coin" id="flip-coin-1" src={darkCoin} alt=""/>
        <img className="flip-coin" id="flip-coin-2" src={greyCoin} alt=""/>
        <img className="flip-coin" id="flip-coin-3" src={lightgreyCoin} alt=""/>
        <img className="flip-coin" id="flip-coin-4" src={fadedCoin} alt=""/>
        <img className="flip-coin" id="flip-coin-5" src={colorCoin} alt=""/>
        <p id="swap-token--text">Swap Boring Tokens for a Chance to Win!</p>
      </div>
      <div className="button" onClick={() => pancakeswapRoute()}><img src={pancakeSwapIcon} alt=""/>SWAP</div>
    </div>

    <div id="token-info">
      <div className="button" onClick={() => priceChartRoute()}>Price Chart</div>
    </div>

    </>
  );
};

export default Home;
