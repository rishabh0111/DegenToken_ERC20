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
