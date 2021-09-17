// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface Gold {
    function approve(
        uint256 from,
        uint256 spender,
        uint256 amount
    ) external returns (bool);

    function transfer(
        uint256 from,
        uint256 to,
        uint256 amount
    ) external returns (bool);

    function transferFrom(
        uint256 executor,
        uint256 from,
        uint256 to,
        uint256 amount
    ) external returns (bool);
}

interface rarity {
    function ownerOf(uint) external view returns (address);
    function getApproved(uint) external view returns (address);
    function summon(uint) external;
    function next_summoner() external view returns (uint);
}

contract rarity_portable_gold is ERC20 {
    uint public this_token_id;
    rarity constant rm = rarity(0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb);
    Gold constant gold = Gold(0x2069B76Afe6b734Fb65D1d099E7ec64ee9CC76B2);
    constructor() ERC20("Rarity Portable Gold", "RPG") {
        this_token_id = rm.next_summoner();
        rm.summon(1);
    }

    
    function exchangeRPG(uint from, uint amount) external {
        require(_isApprovedOrOwner(from), "Only can exchange your owner or approved summoner");
        gold.transferFrom(this_token_id, from, this_token_id, amount);
        _mint(_msgSender(), amount);
    }

    function exchangeGold(uint to, uint amount) external {
        require(_isApprovedOrOwner(to), "Only can exchange your owner or approved summoner");
        gold.transfer(this_token_id, to, amount);
        _burn(_msgSender(), amount);
    }

     function _isApprovedOrOwner(uint _summoner) internal view returns (bool) {
        return rm.getApproved(_summoner) == _msgSender() || rm.ownerOf(_summoner) == _msgSender();
    }

}
