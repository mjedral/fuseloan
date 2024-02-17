// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LendingPoolManager {
    struct LendingPool {
        address asset;
        uint256 interestRate;
        uint256 totalLiquidity;
        uint256 lastInterestTime;
    }

    mapping(uint256 => LendingPool) public lendingPools;
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

    // Funkcje do interakcji z pulą, np. depozyty, wypłaty, obliczanie odsetek itp.
    // ...

    // Funkcja umożliwiająca depozyt do puli pożyczkowej
    function deposit(uint256 poolId, uint256 amount) external {
        // Logika depozytu
        // ...
    }

    // Funkcja umożliwiająca wypłatę z puli pożyczkowej
    function withdraw(uint256 poolId, uint256 amount) external {
        // Logika wypłaty
        // ...
    }

    function calculateInterest(uint256 _poolId) external {
        LendingPool storage pool = lendingPools[_poolId];
        // Oblicz czas, który minął od ostatniej kapitalizacji odsetek
        uint256 timeElapsed = block.timestamp - pool.lastInterestTime;
        // Przelicz na dni dla dziennego złożenia odsetek
        uint256 daysElapsed = timeElapsed / 1 days;
        // Jeśli nie minął jeszcze dzień, nie ma potrzeby przeliczania
        if (daysElapsed > 0) {
            // Używamy rocznej stopy procentowej do obliczenia dziennego złożenia
            // Dzienna stopa procentowa = (1 + roczna stopa)^{1/365} - 1
            uint256 dailyRate = pow((1e18 + pool.interestRate), (1e18 / 365)) - 1e18;
            uint256 interest = pool.totalLiquidity * pow((1e18 + dailyRate), daysElapsed) - pool.totalLiquidity;
            pool.totalLiquidity += interest;
            pool.lastInterestTime = block.timestamp;
        }
    }

    function pow(uint256 a, uint256 n) internal pure returns (uint256) {
        uint256 result = 1e18;
        for (uint256 i = 0; i < n; i++) {
            result = (result * a) / 1e18;
        }
        return result;
    }
}

