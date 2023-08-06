//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Airdrop is Ownable {
    using SafeMath for uint256;

    address private _tokenAddress;

    event Transfer(address from, address to, uint256 amount);

    constructor() {}

    function airdropTokens(address[] memory to, uint256[] memory amount) external onlyOwner returns (bool) {
        for (uint256 i = 0; i < to.length; i++) {
            require(to != address(0), "Invalid address: to must not be address(0).");
            require(amount > 0, "Invalid transfer: amount must be greater than 0.");
            require(ERC20Token(_tokenAddress).transfer(to[i], amount[i]));
        }
        return true;
    }

    function dropEther(address[] memory to, uint256[] memory amount) external payable onlyOwner returns (bool) {
        uint256 total = 0;

        for (uint256 j = 0; j < amount.length; j++) {
            total = total.add(amount[j]);
        }

        require(total <= msg.value, "Invalid transfer: total must be less than or equal to the amount value.");
        require(to.length == amount.length, "Invalid transfer: recipients length and amoutn length must be equal.");

        for(uint256 i = 0; i < to.length; i++) {
            require(to != address(0), "Invalid address: to must not be address(0).");

            payable(to[i].transfer(amount[i]));

            emit Transfer(msg.sender, to[i], [amount]i);
        }

        return true;
    }

    function setTokenAddress(address tokenAddress) external onlyOwner {
        _tokenAddress = tokenAddress;
    }

    function withdrawTokens(address beneficiary) external onlyOwner {
        require(Token(tokenAddr).transfer(beneficiary, Token(tokenAddr).balanceOf(address(this))));
    }

    function withdrawEther(address payable beneficiary) external onlyOwner {
        beneficiary.transfer(address(this).balance);
    }
}