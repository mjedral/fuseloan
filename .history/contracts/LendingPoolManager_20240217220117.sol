// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LendingPoolManager {

    // add liquidationThreshold
    struct LendingPool {
        address asset;
        uint256 interestRate;
        uint256 totalLiquidity;
        uint256 lastInterestTime;
    }

    IERC20 public lendingToken;
    mapping(uint256 => LendingPool) public lendingPools;
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public borrows;
    uint256 public nextPoolId;

    event PoolCreated(uint256 poolId, address asset, uint256 interestRate);

    function createLendingPool(address asset, uint256 interestRate) external {
        lendingPools[nextPoolId] = LendingPool({
            asset: asset,
            interestRate: interestRate,
            totalLiquidity: 0,
            lastInterestTime: block.timestamp
        });

        emit PoolCreated(nextPoolId, asset, interestRate);
        nextPoolId++;
    }


    // Funkcja umożliwiająca depozyt do puli pożyczkowej
    function deposit(uint256 poolId, uint256 amount) external {
        require(lendingToken.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        deposits[msg.sender] += amount;
    }

    function withdraw(uint256 poolId, uint256 amount) external {
        require(deposits[msg.sender] >= amount, "Insufficient balance");
        deposits[msg.sender] -= amount;
        require(lendingToken.transfer(msg.sender, amount), "Transfer failed");
    }

    function borrow(uint256 _amount, uint256 interestRate) external {
        // Uproszczona weryfikacja zdolności kredytowej
        uint256 maxBorrow = deposits[msg.sender] * 100 / interestRate; // Uproszczony wzór
        require(borrows[msg.sender] + _amount <= maxBorrow, "Borrow limit exceeded");
        borrows[msg.sender] += _amount;
        require(lendingToken.transfer(msg.sender, _amount), "Transfer failed");
    }

    function repay(uint256 _amount) external {
        require(borrows[msg.sender] >= _amount, "Amount exceeds borrowed");
        require(lendingToken.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        borrows[msg.sender] -= _amount;
    }

    // function calculateInterest(uint256 _poolId) external {
    //     LendingPool storage pool = lendingPools[_poolId];
    //     uint256 timeElapsed = block.timestamp - pool.lastInterestTime;
    //     uint256 daysElapsed = timeElapsed / 1;
    //     if (daysElapsed > 0) {
    //         uint256 dailyRate = pow((1 + pool.interestRate), 1 / 365) - 1;
    //         uint256 interest = pool.totalLiquidity * (pow(1e18 + dailyRate, daysElapsed) / 1e18) - pool.totalLiquidity;
    //         pool.totalLiquidity += interest;
    //         pool.lastInterestTime = block.timestamp;
    //     }
    // }

    // function pow(uint256 base, uint256 exponent) internal pure returns (uint256) {
    //     uint256 result = 1e18;
    //     while (exponent > 0) {
    //         if (exponent % 2 == 1) {
    //             result = (result * base) / 1e18;
    //         }
    //         base = (base * base) / 1e18;
    //         exponent /= 2;
    //     }

    //     return result;
    // }

}

