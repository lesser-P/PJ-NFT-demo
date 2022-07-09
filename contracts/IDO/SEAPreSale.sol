// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

contract SEAPreSale is Initializable, OwnableUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using SafeMathUpgradeable for uint256;

    address public alphaSEA;
    address public DAOAddress;
    address public usdc;

    uint256 public minAmount;
    uint256 public maxAmount;
    uint256 public salePrice;
    uint256 public startTimestamp;
    uint256 public endTimestamp;
    uint256 public toTalAmount;
    uint256 public sellAmount;
    uint256 public remainingPurchasesMaxAmt;

    bool public saleStarted;

    mapping(address => bool) public boughtSEA;
    mapping(address => bool) public whiteListed;

    function whiteListBuyers(address[] memory _buyers)
        external
        onlyOwner
        returns (bool)
    {
        for (uint256 i; i < _buyers.length; i++) {
            whiteListed[_buyers[i]] = true;
        }
        return true;
    }

    function initialize(
        address _DAOAddress,
        address _alphaSEA,
        address _usdc,
        uint256 _minAmount, //0
        uint256 _maxAmount, //2000000000    2,000 usdc
        uint256 _toTalAmount, //500000000000   500,000 usdc
        uint256 _salePrice,
        uint256 _startTimestamp,
        uint256 _endTimestamp,
        uint256 _remainingPurchasesMaxAmt
    ) external initializer {
        __Ownable_init();
        alphaSEA = _alphaSEA;
        usdc = _usdc;
        salePrice = _salePrice;
        startTimestamp = _startTimestamp;
        endTimestamp = _endTimestamp;
        DAOAddress = _DAOAddress;
        minAmount = _minAmount;
        maxAmount = _maxAmount;
        toTalAmount = _toTalAmount;
        remainingPurchasesMaxAmt = _remainingPurchasesMaxAmt;
        saleStarted = true;
    }

    function SET(
        address _DAOAddress,
        address _alphaSEA,
        address _usdc,
        uint256 _minAmount,
        uint256 _maxAmount,
        uint256 _toTalAmount,
        uint256 _salePrice,
        uint256 _startTimestamp,
        uint256 _endTimestamp,
        uint256 _remainingPurchasesMaxAmt
    ) external onlyOwner returns (bool) {
        alphaSEA = _alphaSEA;

        usdc = _usdc;

        salePrice = _salePrice;

        startTimestamp = _startTimestamp;
        endTimestamp = _endTimestamp;

        DAOAddress = _DAOAddress;

        minAmount = _minAmount;

        maxAmount = _maxAmount;

        toTalAmount = _toTalAmount;

        remainingPurchasesMaxAmt = _remainingPurchasesMaxAmt;

        saleStarted = true;
        return true;
    }

    function setStart() external onlyOwner returns (bool) {
        saleStarted = !saleStarted;
        return saleStarted;
    }

    function purchaseaSEA(uint256 _val) external returns (bool) {
        require(_val >= minAmount, "Below minimum allocation");
        require(_val <= maxAmount, "More than allocation");
        sellAmount = sellAmount.add(_val);
        require(
            sellAmount <= toTalAmount,
            "The amount entered exceeds Fundraise Goal"
        );
        require(saleStarted == true, "Not started");
        require(boughtSEA[msg.sender] == false, "Already participated");
        require(startTimestamp < block.timestamp, "Not started yet");

        boughtSEA[msg.sender] = true;

        if (endTimestamp < block.timestamp) {
            require(_val <= remainingPurchasesMaxAmt, "Exceeded IDO limit");
        } else {
            require(whiteListed[msg.sender] == true, "Not whitelisted");
            require(block.timestamp < endTimestamp, "Sale over");
        }
        IERC20Upgradeable(usdc).safeTransferFrom(
            msg.sender,
            address(this),
            _val
        );
        IERC20Upgradeable(usdc).safeTransfer(DAOAddress, _val);
        uint256 _purchaseAmount = _calculateSaleQuote(_val);
        IERC20Upgradeable(alphaSEA).safeTransfer(msg.sender, _purchaseAmount);
        return true;
    }

    function _calculateSaleQuote(uint256 paymentAmount_)
        internal
        view
        returns (uint256)
    {
        return uint256(1e18).mul(paymentAmount_).div(salePrice); //1e18 * 1e18 / 8e17
    }

    function calculateSaleQuote(uint256 paymentAmount_)
        external
        view
        returns (uint256)
    {
        return _calculateSaleQuote(paymentAmount_);
    }
}
