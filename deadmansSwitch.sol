// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadmansSwitch {
    address public owner;
    address payable public backupAddress;
    uint public lastAliveBlock;
    uint public inactivityLimit = 10; 

    constructor(address payable _backupAddress) {
        owner = msg.sender; 
        backupAddress = _backupAddress; 
        lastAliveBlock = block.number; 
    }

    function still_alive() external {
        require(msg.sender == owner, "Only the owner can call this function");
        lastAliveBlock = block.number; 
    }

    function activateSwitch() external {
        require(block.number > lastAliveBlock + inactivityLimit, "Owner is still active");
        uint amountTransferred = address(this).balance; 
        require(amountTransferred > 0, "No Ether in the contract to transfer");
        backupAddress.transfer(amountTransferred); 
    }

    function mineBlock() external {
    }

    function getCurrentBlockNumber() external view returns (uint) {
        return block.number; 
    }

    function getBalances() external view returns (uint ownerBalance, uint backupBalance, uint contractBalance) {
        ownerBalance = owner.balance;          
        backupBalance = backupAddress.balance; 
        contractBalance = address(this).balance; 
    }

    receive() external payable {}

    function depositToContract() external payable {
        require(msg.sender == owner, "Only the owner can deposit Ether");
        require(msg.value > 0, "You must deposit a positive amount of Ether");
    }
}
