// SPDX-License-Identifier: AGPL-3.0-only
// Using the same Copyleft License as in the original Repository
pragma solidity 0.8.0;
pragma experimental ABIEncoderV2;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Oracle is Initializable, OwnableUpgradeable {
    using SafeMath for uint256;
    using ECDSA for bytes32;

    address public signer;
    uint256 public timeLimit;
    //Executor
    mapping(address => bool) public executor;

    // constructor() {
    //     __Ownable_init();
    //     _setExecutor(msg.sender, true);
    //     signer = msg.sender;
    //     timeLimit = 60;
    // }

    function initialize(address _signer) external initializer {
        __Ownable_init();
        _setExecutor(_signer, true);
        signer = _signer;
        timeLimit = 60;
    }

    function setExecutor(address _address, bool _type)
        external
        onlyOwner
        returns (bool)
    {
        return _setExecutor(_address, _type);
    }

    function _setExecutor(address _address, bool _type)
        internal
        returns (bool)
    {
        executor[_address] = _type;
        return true;
    }

    modifier onlyExecutor() {
        require(executor[msg.sender], "executor: caller is not the executor");
        _;
    }

    function setTimeLimit(uint256 _val) external onlyOwner returns (bool) {
        timeLimit = _val;
        return true;
    }

    function setSigner(address _address) external onlyOwner returns (bool) {
        signer = _address;
        return true;
    }

    function getkey(
        bool _marketState,
        uint256 _price18,
        uint256 _timestamp,
        string memory _symbols,
        bytes memory _signature
    ) public view returns (bool) {
        require(executor[msg.sender], "executor err");
        require(block.timestamp - timeLimit < _timestamp, "timestamp err");
        require(_marketState, "Market not open");
        bytes32 hash = keccak256(
            abi.encodePacked(_marketState, _price18, _timestamp, _symbols)
        );
        address _signer = ECDSA.recover(
            ECDSA.toEthSignedMessageHash(hash),
            _signature
        );
        return (signer == _signer);
    }
}
