# DegenToken - ERC20 Token for Degen Gaming

## Description

DegenToken is an ERC20 token designed for the Degen Gaming platform on the Avalanche network. The token allows players to earn rewards, transfer tokens to others, and redeem tokens for in-game items available in the platform's store. This smart contract is based on the OpenZeppelin library and includes features like token minting (for the platform owner), transferring tokens, and burning tokens. Additionally, players can redeem their tokens for in-game items from the store.

## Getting Started

### Installing

To use the DegenToken contract, you can clone this GitHub repository to your local machine.

### Executing program

To interact with the DegenToken contract, follow these steps:

1. Deploy the contract on the Avalanche network.
2. Mint new tokens and distribute them to players as rewards.
3. Players can transfer their tokens to others using the `transferTokens` function.
4. Players can redeem their tokens for in-game items by calling the `redeem` function.
5. Players can burn their tokens using the `burn` function when they are no longer needed.

## Video walkthrough: 
https://www.loom.com/share/dd019300e3a046d4b55fe011538fa724

## Code: 
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    constructor() ERC20("Degen", "DGN") {
        // Add examples to storeItems during contract deployment
        addStoreItem("Health Elixir", 25);
        addStoreItem("Mana Potion", 30);
        addStoreItem("Scroll of Wisdom", 10);

    }

    // Store item structure
    struct StoreItem {
        string itemName;
        uint256 price;
    }

    // Store items list
    StoreItem[] public storeItems;

    // Add store items (onlyOwner)
    function addStoreItem(string memory itemName, uint256 price) internal onlyOwner {
        storeItems.push(StoreItem(itemName, price));
    }

    // Mint new tokens and distribute them to players as rewards. Only the owner can do this.
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Transfer tokens from the sender's account to another account.
    function transferTokens(address to, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Don't have enough Degen Tokens");
        approve(msg.sender, amount);
        transferFrom(msg.sender, to, amount);
    }

    // Redeem tokens for items in the in-game store based on the store item index.
    function redeem(uint256 itemIndex) public virtual {
        require(itemIndex < storeItems.length, "Invalid store item index");
        uint256 price = storeItems[itemIndex].price;
        require(balanceOf(msg.sender) >= price, "Not enough Degen Tokens to redeem this item");

        _burn(msg.sender, price);
    }

    // Check the token balance of an account.
    function balanceOf(address account) public view virtual override returns (uint256) {
        return super.balanceOf(account);
    }

    // Anyone can burn their own tokens that are no longer needed.
    function burn(uint256 amount) public virtual {
        _burn(msg.sender, amount);
    }

    // Show all store items with their index, name, and price
    function showStoreItems() public view returns (StoreItem[] memory) {
        return storeItems;
    }
}


```

