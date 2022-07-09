// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

contract aSEAMigration is Initializable, OwnableUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using SafeMathUpgradeable for uint256;

    uint256 public endTimestamp;
    uint256 public startTimestamp;

    uint256 public maxAmt;

    IERC20Upgradeable public SEA;
    IERC20Upgradeable public aSEA;

    bool public isInitialized;

    mapping(address => uint256) public senderInfo;

    modifier onlyInitialized() {
        require(isInitialized, "not initialized");
        _;
    }

    modifier notInitialized() {
        require(!isInitialized, "already initialized");
        _;
    }

    function initialize(
        address _SEA,
        address _aSEA,
        uint256 _startTimestamp,
        uint256 _endTimestamp
    ) external initializer {
        __Ownable_init();
        SEA = IERC20Upgradeable(_SEA);
        aSEA = IERC20Upgradeable(_aSEA);
        startTimestamp = _startTimestamp;
        endTimestamp = _endTimestamp;
        isInitialized = false;
        maxAmt = 2500 * 1e18;
    }

    function open(bool _bool) external onlyOwner {
        isInitialized = _bool;
    }

    function migrate() external onlyInitialized {
        uint256 amount = aSEA.balanceOf(msg.sender);
        require(amount <= maxAmt, "Exceed the specified amount");
        require(startTimestamp < block.timestamp, "Not started yet");
        require(block.timestamp < endTimestamp, "swapping of aSEA has ended");

        aSEA.transferFrom(msg.sender, address(this), amount);
        senderInfo[msg.sender] = senderInfo[msg.sender].add(amount);
        SEA.transfer(msg.sender, amount);
    }

    // function reclaim() external {
    //     require(senderInfo[msg.sender] > 0, "user has no aSEA to withdraw");
    //     require(block.timestamp > endTimestamp, "aSEA swap is still ongoing");

    //     uint256 amount = senderInfo[msg.sender];
    //     senderInfo[msg.sender] = 0;
    //     aSEA.transfer(msg.sender, amount);
    // }

    function withdraw() external onlyOwner {
        require(
            block.timestamp > endTimestamp,
            "swapping of aSEA has not ended"
        );
        uint256 amount = SEA.balanceOf(address(this));

        SEA.transfer(msg.sender, amount);
    }

    function setEndTimestamp(uint256 val) external onlyOwner {
        endTimestamp = val;
    }

    function setStartTimestamp(uint256 val) external onlyOwner {
        startTimestamp = val;
    }

    function setMaxAmt(uint256 val) external onlyOwner {
        maxAmt = val;
    }
}
