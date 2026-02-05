// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// Interface for the ArbSys precompile to access L2-specific data.
// Since LitVM is based on Arbitrum Orbit, standard 'block.number' returns 
// the L1 block number. We use this interface to get the actual L2 block height.
interface ArbSys {
    function arbBlockNumber() external view returns (uint256);
}

/**
 * @title LitVault
 * @dev Main vault contract for staking assets on LitVM.
 * Implements ArbSys integration for accurate block tracking.
 */
contract LitVault is ReentrancyGuard {
    IERC20 public immutable stakingToken;
    
    // The address of the ArbSys precompile is always 0x00...064 (integer 100)
    address constant ARBSYS_ADDRESS = address(100); 

    mapping(address => uint256) public balances;

    // Events include the 'l2Block' to help indexers track precise timing on LitVM
    event Staked(address indexed user, uint256 amount, uint256 l2Block);
    event Withdrawn(address indexed user, uint256 amount);

    constructor(address _stakingToken) {
        require(_stakingToken != address(0), "Invalid token address");
        stakingToken = IERC20(_stakingToken);
    }

    /**
     * @notice Deposits tokens into the vault.
     * @param amount The amount of tokens to stake.
     */
    function deposit(uint256 amount) external nonReentrant {
        require(amount > 0, "Cannot deposit 0");
        
        // Transfer staking tokens from user to contract (Requires prior approval)
        bool success = stakingToken.transferFrom(msg.sender, address(this), amount);
        require(success, "Transfer failed");
        
        balances[msg.sender] += amount;
        
        // CRITICAL: Retrieve the actual LitVM L2 block number via ArbSys
        // This ensures accurate reward calculation based on L2 block time
        uint256 currentL2Block = ArbSys(ARBSYS_ADDRESS).arbBlockNumber();
        
        emit Staked(msg.sender, amount, currentL2Block);
    }

    /**
     * @notice Withdraws staked tokens from the vault.
     * @param amount The amount of tokens to withdraw.
     */
    function withdraw(uint256 amount) external nonReentrant {
        require(amount > 0, "Cannot withdraw 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        
        bool success = stakingToken.transfer(msg.sender, amount);
        require(success, "Transfer failed");
        
        emit Withdrawn(msg.sender, amount);
    }

    /**
     * @notice Helper function to get the current L2 block number.
     * @return The actual block number of the LitVM chain.
     */
    function getLitVMBlockNumber() external view returns (uint256) {
        return ArbSys(ARBSYS_ADDRESS).arbBlockNumber();
    }
}
