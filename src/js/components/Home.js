import React from 'react';
import Intro from './Intro';
import KeyComponents from './KeyComponents';
import TokenSwap from './TokenSwap';
import '../../css/home.css';

const Home = () => {
  const contractAddress = "0x5e90253fbae4Dab78aa351f4E6fed08A64AB5590"
  const priceChartRoute = () => {
    window.open(`https://charts.bogged.finance/?token=${contractAddress}`)
  }

  return (
    <>
    <Intro></Intro>
    <KeyComponents></KeyComponents>
    <TokenSwap></TokenSwap>

    <div id="token-info">
      <div className="button" onClick={() => priceChartRoute()}>Price Chart</div>
    </div>

    </>
  );
};

export default Home;
