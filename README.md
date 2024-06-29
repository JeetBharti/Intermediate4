# DegenToken

## Overview
DegenToken is an ERC20 token deployed on the Avalanche network for Degen Gaming. It supports in-game rewards, item exchanges, and token management for players.

## Description
DegenToken is specifically designed for Degen Gaming on the Avalanche network. The smart contract facilitates minting, transferring, redeeming, balance checking, and burning of tokens. Only the owner has the authority to mint new tokens, ensuring controlled distribution for rewards. Players can use the tokens to exchange for in-game items, transfer tokens to other players, and manage their token balances. Additionally, the contract includes functionality for burning tokens that are no longer needed.

## Getting Started

### Installation
To use this contract, you'll need to use Remix, an online Solidity IDE. Follow these steps:

1. Visit [Remix](https://remix.ethereum.org/).
2. Create a new file by clicking the "+" icon in the sidebar.
3. Save the file with a `.sol` extension, e.g., `degen.sol`.
4. Copy and paste the provided code into the file.

### Running the Program

1. **Compile the Code:**
   - Go to the "Solidity Compiler" tab in Remix.
   - Ensure the compiler version is set to "0.8.23" or a compatible version.
   - Click "Compile Degen.sol".

2. **Deploy the Contract:**
   - Navigate to the "Deploy & Run Transactions" tab in Remix.
   - Select the "Degen" contract from the dropdown menu.
   - Click the "Deploy" button.

3. **Interact with the Contract:**
   - **Minting Tokens:** Upon deployment, 10 DGN tokens are minted to the contract address.
   - **Creating Tokens:** Call the `purchaseTokens` function.
   - **Destroying Tokens:** Call the `burnTokens` function with the amount to burn tokens.

## Solidity Code for TokenDegen.sol

```solidity
// SPDX-License-Identifier: MIT

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
```
## Help

Common Issues:

Insufficient Tokens for Exchange or Transfer:
Ensure you have enough tokens in your balance before performing exchange or transfer operations. Use viewBalance to check your balance.

Invalid Recipient Address:
When transferring tokens, make sure the recipient address is valid and not the zero address.
## Authors

Jeet Bharti
@Jeet

## License

This project is licensed under the License - see the LICENSE.md file for details
