import React from 'react';
import pancakeSwapIcon from '../../local-assets/pancakeswap-logo.svg';
import darkCoin from '../../local-assets/dark-coin.svg'
import greyCoin from '../../local-assets/grey-coin-flipped.svg'
import lightgreyCoin from '../../local-assets/lightgrey-coin-flipped.svg'
import fadedCoin from '../../local-assets/faded-coin-flipped-teal.svg'
import colorCoin from '../../local-assets/full-color-no-logo-coin-teal.svg'
import '../../css/token-swap.css';

const TokenSwap = () => {
  const pancakeswapRoute = () => {
    window.open("https://exchange.pancakeswap.finance/#/swap")
  }

  return (
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
  )
}

export default TokenSwap;
