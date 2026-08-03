// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ISovereignInbox
 * @dev Interface for the SovereignInbox contract to allow forced operations.
 */
interface ISovereignInbox {
    /**
     * @dev Adds a forced operation to the inbox for a given key hash.
     * This is intended to be called by a trusted contract like MissMinute
     * when a key's TTL has expired.
     * @param keyHash The hash of the key that requires a forced rotation.
     * @param operationType A string identifier for the operation, e.g., "FORCE_ROTATION".
     */
    function addForcedOperation(bytes32 keyHash, string calldata operationType) external;
}

/**
 * @title MissMinute
 * @dev The Time Guardian contract responsible for enforcing Time-To-Live (TTL) on keys.
 * It monitors key expiration and triggers a forced rotation through the SovereignInbox
 * when a key's lifecycle ends. This acts as a critical backstop for security.
 */
contract MissMinute is Ownable {
    // --- State Variables ---

    ISovereignInbox public sovereignInbox;
    mapping(bytes32 => uint256) public keyExpirations;

    // --- Events ---

    event KeyRegistered(bytes32 indexed keyHash, uint256 expirationTimestamp);
    event KeyExpired(bytes32 indexed keyHash, uint256 timestamp);
    event RotationForced(bytes32 indexed keyHash);
    event SovereignInboxUpdated(address indexed newInboxAddress);

    // --- Constructor ---

    constructor(address initialOwner) Ownable(initialOwner) {}

    // --- Admin Functions ---

    /**
     * @dev Sets or updates the address of the SovereignInbox contract.
     * Only the owner can call this function.
     * @param _inbox The address of the ISovereignInbox compliant contract.
     */
    function setSovereignInbox(address _inbox) external onlyOwner {
        require(_inbox != address(0), "MissMinute: Inbox address cannot be the zero address");
        sovereignInbox = ISovereignInbox(_inbox);
        emit SovereignInboxUpdated(_inbox);
    }

    // --- Core Logic ---

    /**
     * @dev Registers a new key hash with a specific Time-To-Live (TTL).
     * The expiration is calculated as `block.timestamp + ttl`.
     * @param keyHash The unique identifier for the key.
     * @param ttl The duration in seconds for which the key is valid.
     */
    function registerKey(bytes32 keyHash, uint256 ttl) external {
        // In a real implementation, this might be restricted to certain roles
        uint256 expirationTime = block.timestamp + ttl;
        keyExpirations[keyHash] = expirationTime;
        emit KeyRegistered(keyHash, expirationTime);
    }

    /**
     * @dev Audits a key to check if its TTL has expired.
     * This is a publicly callable function that can be executed by keepers or any external actor.
     * If the key is expired, it triggers a forced rotation operation via the SovereignInbox.
     * @param keyHash The key hash to audit.
     */
    function auditKey(bytes32 keyHash) external {
        uint256 expirationTime = keyExpirations[keyHash];
        require(expirationTime > 0, "MissMinute: Key not registered");

        // CRITICAL LOGIC: Check if the current time has surpassed the key's expiration
        if (block.timestamp >= expirationTime) {
            emit KeyExpired(keyHash, block.timestamp);

            // Ensure the SovereignInbox is set before trying to call it
            require(address(sovereignInbox) != address(0), "MissMinute: SovereignInbox not set");
            
            // Call the inbox to enforce the rotation policy
            sovereignInbox.addForcedOperation(keyHash, "FORCE_ROTATION");
            
            emit RotationForced(keyHash);
        }
    }
}