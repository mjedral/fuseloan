// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./LendingPoolManager.sol";

contract ETHUSDTPool {
    LendingPoolManager private manager;
    IERC20 private usdtToken;
    uint256 private poolId;

    constructor(address _lendingPoolManager, address _usdtToken) {
        manager = LendingPoolManager(_lendingPoolManager);
        usdtToken = IERC20(_usdtToken);
        uint256 interestRate = 5; // fixed interest rate 5%
        manager.createLendingPool(address(usdtToken), interestRate);
        poolId = manager.nextPoolId() - 1;
    }

    // Użytkownik może wysłać ETH i otrzymać w zamian USDT
    function depositETH(uint256 _amount) external payable {
        manager.deposit(poolId, _amount);
    }

    // Użytkownik może wypłacić USDT, otrzymując w zamian ETH
    function withdrawUSDT(uint256 usdtAmount) external {
        manager.withdraw(poolId, usdtAmount);
    }

    // Przykładowe funkcje do interakcji z LendingPoolManager
    function depositUSDT(uint256 usdtAmount) external {
        usdtToken.transferFrom(msg.sender, address(this), usdtAmount);
        // Tutaj dodatkowa logika dotycząca depozytowania USDT do puli
        // ...
    }

    function withdrawUSDTToUser(uint256 usdtAmount) external {
        // Logika pozwalająca użytkownikowi na wypłatę USDT z puli
        // ...
    }
    // Możesz dodać funkcje do obsługi zabezpieczeń, obliczania odsetek, likwidacji itd.
    // ...

    // Pamiętaj, aby dodać odpowiednie zabezpieczenia i sprawdzenia, np. czy użytkownik ma wystarczające saldo
}
