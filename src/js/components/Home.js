import React from 'react';
import Intro from './Intro';
import KeyComponents from './KeyComponents';
import TokenSwap from './TokenSwap';
import '../../css/home.css';

const Home = () => {
  return (
    <>
    <Intro></Intro>
    <TokenSwap></TokenSwap>
    <KeyComponents></KeyComponents>
    </>
  );
};

export default Home;
