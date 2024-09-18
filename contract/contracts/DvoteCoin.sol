pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract DvoteCoin is ERC20, ERC20Permit {
    constructor() ERC20("DvoteCoin", "DV") ERC20Permit("DvoteCoin") {
        _mint(msg.sender, 100000 * 10**decimals());
    }
}
