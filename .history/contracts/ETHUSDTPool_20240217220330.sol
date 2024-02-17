// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./LendingPoolManager.sol";

contract ETHUSDTPool {
    address public owner;
    LendingPoolManager private manager;
    IERC20 private usdtToken;
    uint256 private poolId;

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    constructor(address _lendingPoolManager, address _usdtToken) {
        manager = LendingPoolManager(_lendingPoolManager);
        usdtToken = IERC20(_usdtToken);
        uint256 interestRate = 5; // fixed interest rate 5%
        manager.createLendingPool(address(usdtToken), interestRate);
        poolId = manager.nextPoolId() - 1;
    }

    function depositETH(uint256 _amount) external payable {
        manager.deposit(poolId, _amount);
    }

   // rest functions
   //       |
   //       |
   //      \/

}
