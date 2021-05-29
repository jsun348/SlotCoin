import React from 'react';
import mainBall from '../../local-assets/intro-visual-full/main-ball.svg';
import mainGlow from '../../local-assets/intro-visual-full/main-glow.svg';
import otherBalls from '../../local-assets/intro-visual-full/other-balls.svg';
import platforms from '../../local-assets/intro-visual-full/platforms.svg';
import tokens from '../../local-assets/intro-visual-full/tokens.svg';
import '../../css/intro-visual.css';

const Intro = () => {
  return (
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
  )
}

export default Intro;
