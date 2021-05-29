import React, { useEffect } from 'react';
import logo from '../../local-assets/logo.svg';
import '../../css/navbar.css';

const Navbar = () => {
  const handleScroll = () => {
    const currentYOffset = window.pageYOffset
    const navbar = document.getElementById("navbar")

    if (currentYOffset > 60) {
      navbar.style.background = "rgba(255, 255, 255, 0.1)"
      navbar.style.boxShadow = "0px 8px 10px 0 rgba(0,0,0,.4)"
    }
    else {
      navbar.style.background = "transparent"
      navbar.style.boxShadow = "none"
    }
  };

  useEffect(() => {
    window.addEventListener("scroll", handleScroll);
    return () => {
      window.removeEventListener("scroll", handleScroll);
    }
  }, [])

  return (
    <header id="navbar">
      <a href="/"><img src={logo} alt="logo" className="shadow-filter logo"/></a>
      <input className="menu-btn" type="checkbox" id="menu-btn" />
      <label className="menu-icon" htmlFor="menu-btn"><span className="navicon"></span></label>
      <ul className="menu">
        <li><a href="#app-intro">Home</a></li>
        <li><a href="#swap-token">Buy</a></li>            
        <li><a href="#cards-section">About</a></li>
        <li><a href="#">Tokenomics</a></li>
      </ul>
    </header>
  );
};

export default Navbar;
