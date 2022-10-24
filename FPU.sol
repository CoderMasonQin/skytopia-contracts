// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract FPU is ERC20Burnable, Ownable {
    
    using SafeMath for uint;

    uint256 immutable private MaxSupply;

    constructor() ERC20("Flying Processing Unit", "FPU") {
        MaxSupply = 1 * 10 ** 9 * 10 ** uint256(decimals()); // 1B
        _mint(msg.sender, MaxSupply);
    }
    
    function getFPUBurnedTotal() external view returns (uint256 _amount) {
        return MaxSupply.sub(totalSupply());
    }

}
