// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadmansSwitch {
    address public owner;
    address payable public backupAddress;
    uint public lastAliveBlock;
    uint public inactivityLimit = 10; // Number of blocks of inactivity before the switch activates

    constructor(address payable _backupAddress) {
        owner = msg.sender; // The deployer of the contract is the owner
        backupAddress = _backupAddress; // Backup address to receive funds
        lastAliveBlock = block.number; // Set the lastAliveBlock to the current block during deployment
    }

    // Function to indicate that the owner is still alive
    function still_alive() external {
        require(msg.sender == owner, "Only the owner can call this function");
        lastAliveBlock = block.number; // Update the last block number when the owner calls this
    }

    // Function to activate the switch and send funds to the backup address
    function activateSwitch() external {
        require(block.number > lastAliveBlock + inactivityLimit, "Owner is still active");
        uint amountTransferred = address(this).balance; // Get the contract's balance
        require(amountTransferred > 0, "No Ether in the contract to transfer");
        backupAddress.transfer(amountTransferred); // Transfer funds to the backup address
    }

    // Function to simulate the passage of blocks (mining)
    function mineBlock() external {

    }

    // Function to get the current block number
    function getCurrentBlockNumber() external view returns (uint) {
        return block.number; // Return the current block number
    }

    // Function to get the balances of the owner, backup address, and contract
    function getBalances() external view returns (uint ownerBalance, uint backupBalance, uint contractBalance) {
        ownerBalance = owner.balance;          // Balance of the owner's wallet
        backupBalance = backupAddress.balance; // Balance of the backup address
        contractBalance = address(this).balance; // Balance of the contract itself
    }

    // Function to receive Ether into the contract
    receive() external payable {}

    // Function to allow the owner to deposit any amount of Ether into the contract
    function depositToContract() external payable {
        require(msg.sender == owner, "Only the owner can deposit Ether");
        require(msg.value > 0, "You must deposit a positive amount of Ether");
    }
}