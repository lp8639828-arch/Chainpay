// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ChainPay
 * @dev A simple decentralized payment contract for peer-to-peer transactions.
 *      Users can deposit, send, and withdraw funds securely using Ethereum.
 */
contract ChainPay {
    address public owner;

    mapping(address => uint256) private balances;

    event Deposited(address indexed user, uint256 amount);
    event Sent(address indexed from, address indexed to, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Deposit ETH into the contract.
     */
    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposited(msg.sender, msg.value);
    }

    /**
     * @dev Send ETH from sender's balance to another user.
     * @param recipient The address to send funds to.
     * @param amount The amount to send.
     */
    function sendPayment(address recipient, uint256 amount) external {
        require(recipient != address(0), "Invalid recipient address");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;

        emit Sent(msg.sender, recipient, amount);
    }

    /**
     * @dev Withdraw user's ETH balance from the contract.
     */
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

        emit Withdrawn(msg.sender, amount);
    }

    /**
     * @dev Check a user's balance.
     */
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}

