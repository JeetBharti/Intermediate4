// SPDX-License-Identifier: MIT

/*
Your task is to create a ERC20 token and deploy it on the Avalanche network for Degen Gaming.
 The smart contract should have the following functionality:

1) Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
2) Transferring tokens: Players should be able to transfer their tokens to others.
3) Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
4) Checking token balance: Players should be able to check their token balance at any time.
5) Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.
*/

pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract TokenDegen is ERC20, Ownable, ERC20Burnable {

    constructor() ERC20("JEET", "JT") Ownable(msg.sender) {}

    // Enum for collectible items
    enum Collectibles {Normal, Average, Special, Extinct, Legend}

    struct Buyer {
        address buyerAddress;
        uint quantity;
    }
    // Queue for buyers wanting to purchase TokenDegen
    Buyer[] public buyerQueue;

    struct UserCollectibles {
        uint normal;
        uint average;
        uint special;
        uint extinct;
        uint legend;
    }

    // Mapping to store redeemed collectibles
    mapping(address => UserCollectibles) public userCollectibles;

    function purchaseTokens(address _buyerAddress, uint _quantity) public {
        buyerQueue.push(Buyer({buyerAddress: _buyerAddress, quantity: _quantity}));
    }

    // Mint tokens for buyers in the queue
    function mintTokens() public onlyOwner {
        // Loop to mint tokens for buyers in the queue
        while (buyerQueue.length != 0) {
            uint index = buyerQueue.length - 1;
            if (buyerQueue[index].buyerAddress != address(0)) { // Check for non-zero address
                _mint(buyerQueue[index].buyerAddress, buyerQueue[index].quantity);
                buyerQueue.pop();
            }
        }
    }
    
    // Transfer tokens to another user
    function transferTokens(address _recipient, uint _quantity) public {
        require(_quantity <= balanceOf(msg.sender), "Insufficient balance for token to transfer");
        _transfer(msg.sender, _recipient, _quantity);
    }

    // Redeem different collectibles
    function redeemCollectibles(Collectibles _collectible) public {
        if (_collectible == Collectibles.Normal) {
            require(balanceOf(msg.sender) >= 15, "Insufficient balance for token to redeem");
            userCollectibles[msg.sender].normal += 1;
            burn(15);
        } else if (_collectible == Collectibles.Average) {
            require(balanceOf(msg.sender) >= 25, "Insufficient balance");
            userCollectibles[msg.sender].average += 1;
            burn(25);
        } else if (_collectible == Collectibles.Special) {
            require(balanceOf(msg.sender) >= 35, "Insufficient balance");
            userCollectibles[msg.sender].special += 1;
            burn(35);
        } else if (_collectible == Collectibles.Extinct) {
            require(balanceOf(msg.sender) >= 45, "Insufficient balance");
            userCollectibles[msg.sender].extinct += 1;
            burn(45);
        } else if (_collectible == Collectibles.Legend) {
            require(balanceOf(msg.sender) >= 60, "Insufficient balance");
            userCollectibles[msg.sender].legend += 1;
            burn(60);
        } else {
            revert("Invalid collectible selected");
        }
    }

    // Function to burn tokens
    function burnTokens(address _holder, uint _quantity) public {
        _burn(_holder, _quantity);
    }

    // Function to check the balance of tokens
    function getBalance() public view returns (uint) {
        return balanceOf(msg.sender);
    }
}
