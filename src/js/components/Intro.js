import React from 'react';
import colorCoin from '../../local-assets/full-color-no-logo-coin-teal.svg'
import mainBall from '../../local-assets/intro-visual-full/main-ball.svg';
import mainGlow from '../../local-assets/intro-visual-full/main-glow.svg';
import otherBalls from '../../local-assets/intro-visual-full/other-balls.svg';
import platforms from '../../local-assets/intro-visual-full/platforms.svg';
import tokens from '../../local-assets/intro-visual-full/tokens.svg';
import '../../css/intro-visual.css';

const Intro = () => {
  const jackpotAmount = 500000;

  const contractAddress = "0x5e90253fbae4Dab78aa351f4E6fed08A64AB5590"
  const priceChartRoute = () => {
    window.open(`https://charts.bogged.finance/?token=${contractAddress}`)
  }

  return (
    <div id="app-intro">
      <div id="app-intro--main-text">
        <div id="jackpot">
          Current Jackpot: <p>{jackpotAmount} SLOT</p>
          <div className="coin-stack">
            <img id="coin1" className="coin-stack--coins" src={colorCoin} alt=""/>
            <img id="coin2" className="coin-stack--coins" src={colorCoin} alt=""/>
            <img id="coin3" className="coin-stack--coins" src={colorCoin} alt=""/>
            <img id="coin4" className="coin-stack--coins" src={colorCoin} alt=""/>
          </div>
        </div>
        <p>Welcome to</p>
        <h1>SlotCoin</h1>
        <p>Every token you own increases the probability of winning the jackpot!</p>
        <div id="price-chart-button" onClick={() => priceChartRoute()}><p>Live Chart</p></div>
      </div>
      <div id="app-intro--visual-container">
        <img id="platforms" src={platforms} alt=""/>
        <img id="floating-tokens" src={tokens} alt=""/>
        <img id="floating-other-balls" src={otherBalls} alt=""/>
        <img id="main-glow" src={mainGlow} alt=""/>
        <img id="floating-main-ball" src={mainBall} alt=""/>
      </div>
    </div>
  )
}

export default Intro;
