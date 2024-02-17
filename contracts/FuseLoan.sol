// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract FuseLoan {
    uint8 public store;

    event SetStore(uint8);

    constructor(uint8 number) {
        store = number;
    }

    function setStore(uint8 number) public {
        store = number;
    }

    function getStore() public view returns(uint8){
        return store;
    }
}
