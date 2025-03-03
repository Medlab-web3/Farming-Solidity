// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Migrations {
    address public immutable owner;
    uint256 public lastCompletedMigration;

    modifier restricted() {
        require(msg.sender == owner, "Access restricted to owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setCompleted(uint256 completed) external restricted {
        lastCompletedMigration = completed;
    }

    function upgrade(address newAddress) external restricted {
        require(newAddress != address(0), "Invalid address");
        Migrations upgraded = Migrations(newAddress);
        upgraded.setCompleted(lastCompletedMigration);
    }
}
