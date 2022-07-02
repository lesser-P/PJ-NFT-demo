// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

interface IhelperLogic {
    function jointExecution() external returns (bool);
}

interface IOracle {
    function getkey(
        bool marketStatus,
        uint256 _price18,
        uint256 _timestamp,
        string memory _symbols,
        bytes memory _signature
    ) external view returns (bool);
}

interface IUSC {
    function burn(uint256 amount) external;

    function mint(address account_, uint256 amount_) external returns (bool);
}

contract mirrorseaMain is Initializable, OwnableUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using SafeMathUpgradeable for uint256;

    //Executor
    mapping(address => bool) public executor;
    address public signer;
    IERC20Upgradeable public usc;
    IhelperLogic public helperLogic;
    IOracle public oracle;
    mapping(uint256 => OrderInfo) internal _orderInfo;
    uint256 public OrderIndex;

    uint256[] public openOrderIdList;
    mapping(uint256 => uint256) public openOrderIdList_index;

    mapping(address => uint256[]) public myOpenOrderIdList;
    mapping(address => mapping(uint256 => uint256))
        public myOpenOrderIdList_index;

    mapping(address => uint256[]) public myCloseOrderIdList;
    mapping(address => mapping(uint256 => uint256))
        public myCloseOrderIdList_index;

    uint256 public feePercent;
    uint256 public PRECISION;

    uint256 public minVal;

    struct OrderInfo {
        address user;
        uint256 _type; //[Stock Futures Forex Crypto ]
        string symbols;
        uint256 state; //[1user openPosition 2user closePosition 3liquidation 4forcedLiquidation ]
        uint256 direction; //[1long 2shout]
        uint256 openPrice18;
        uint256 openTime;
        uint256 closePrice18;
        uint256 closeTime;
        uint256 amt;
        uint256 margin;
    }

    function initialize(
        address _signer,
        IhelperLogic _helperLogic,
        IERC20Upgradeable _usc,
        IOracle _oracle
    ) external initializer {
        __Ownable_init();
        signer = _signer;
        helperLogic = _helperLogic;
        usc = _usc;
        PRECISION = 10000;
        oracle = _oracle;
        minVal = 1e18;
        feePercent = 50;
    }

    //openOrderIdList
    function openOrderIdListLength() public view returns (uint256) {
        return openOrderIdList.length;
    }

    function myOpenOrderIdListLength(address _user)
        public
        view
        returns (uint256)
    {
        return myOpenOrderIdList[_user].length;
    }

    function myCloseOrderIdListLength(address _user)
        public
        view
        returns (uint256)
    {
        return myCloseOrderIdList[_user].length;
    }

    function setExecutor(address _address, bool _type)
        external
        onlyOwner
        returns (bool)
    {
        executor[_address] = _type;
        return true;
    }

    modifier onlyExecutor() {
        require(executor[msg.sender], "executor: caller is not the executor");
        _;
    }

    //feePercent
    function setFeePercent(uint256 _val) external onlyOwner returns (bool) {
        feePercent = _val;
        return true;
    }

    //signer
    function setSigner(address _address) external onlyOwner returns (bool) {
        signer = _address;
        return true;
    }

    function orderInfo(uint256 _id) external view returns (OrderInfo memory) {
        return _orderInfo[_id];
    }

    function setOrderInfo(
        uint256 id,
        address user,
        uint256 _type,
        string memory symbols,
        uint256 state,
        uint256 direction,
        uint256 openPrice18,
        uint256 openTime,
        uint256 closePrice18,
        uint256 closeTime,
        uint256 amt,
        uint256 margin
    ) external onlyOwner returns (bool) {
        _orderInfo[id] = OrderInfo({
            user: user,
            _type: _type,
            symbols: symbols,
            state: state,
            direction: direction,
            openPrice18: openPrice18,
            openTime: openTime,
            closePrice18: closePrice18,
            closeTime: closeTime,
            amt: amt,
            margin: margin
        });
        return true;
    }

    function pagination(
        address _user,
        uint256 _type,
        uint256 _row,
        uint256 _page
    ) external view returns (uint256[] memory) {
        uint256 index;
        uint256 arr;
        uint256[] memory _list;
        if (_type == 0) {
            _list = openOrderIdList;
        } else if (_type == 1) {
            _list = myOpenOrderIdList[_user];
        } else if (_type == 2) {
            _list = myCloseOrderIdList[_user];
        }
        uint256 remAmt = _list.length.sub(_row.mul(_page).sub(_row));
        if (remAmt >= _row) {
            arr = _row;
        } else {
            arr = remAmt;
        }

        require(_row.mul(_page).sub(_row) < _list.length, "length err");
        require(arr != 0, "arr no good");

        uint256[] memory newList = new uint256[](arr);

        for (uint256 i = remAmt.sub(1); index < arr; i--) {
            newList[index] = _list[i];
            if (i == 0) {
                break;
            }
            index++;
        }
        // for (uint256 i = (_row * _page) - _row; i < _row * _page; i++) {
        //     newList[index] = _list[i];
        //     index++;
        //     if (arr == index) {
        //         break;
        //     }
        // }
        return newList;
    }

    function openPosition(
        bool _marketState,
        uint256 _margin,
        uint256 _timestamp,
        uint256 _direction,
        uint256 _type,
        string memory _symbols,
        uint256 _price18,
        uint256 _amt,
        bytes memory _signature
    ) external returns (bool) {
        OrderInfo storage order = _orderInfo[OrderIndex];
        require(_margin != 0, "margin no good");
        require(order.state == 0, "state err");
        require(
            oracle.getkey(
                _marketState,
                _price18,
                _timestamp,
                _symbols,
                _signature
            ),
            "oracle err"
        );
        require(_margin > minVal, "The transaction amount is too small");
        uint256 fee = _price18.mul(_amt).mul(feePercent).div(PRECISION).div(
            1e18
        );
        usc.safeTransferFrom(msg.sender, address(this), _margin.add(fee));
        uint256 uscBalanceOf = usc.balanceOf(address(this));

        usc.safeTransfer(address(helperLogic), fee);
        helperLogic.jointExecution();
        IUSC(address(usc)).burn(uscBalanceOf.sub(fee));

        openOrderIdList.push(OrderIndex);
        openOrderIdList_index[OrderIndex] = openOrderIdList.length.sub(1);

        myOpenOrderIdList[msg.sender].push(OrderIndex);
        myOpenOrderIdList_index[msg.sender][OrderIndex] = myOpenOrderIdList[
            msg.sender
        ].length.sub(1);

        OrderIndex++;

        order.user = msg.sender;
        order._type = _type;
        order.symbols = _symbols;
        order.state = 1; //[1user openPosition 2user closePosition 3liquidation 4forcedLiquidation ]
        order.direction = _direction; //[1long 2shout]
        order.openPrice18 = _price18;
        order.openTime = _timestamp;
        order.amt = _amt;
        order.margin = uscBalanceOf.sub(fee);

        return true;
    }

    function _closePosition(
        bool _marketState,
        OrderInfo storage order,
        uint256 _state,
        uint256 _id,
        uint256 _timestamp,
        string memory _symbols,
        uint256 _price18,
        bytes memory _signature
    ) internal returns (bool) {
        require(order.user != address(0), "order does not exist");
        require(order.state < 2, "state err");
        require(
            oracle.getkey(
                _marketState,
                _price18,
                _timestamp,
                _symbols,
                _signature
            ),
            "oracle err"
        );

        order.closePrice18 = _price18;
        uint256 diffPrice18;
        uint256 diffMargin;
        uint256 mintAmt;
        uint256 order_amt = order.amt;
        uint256 order_closePrice18 = order.closePrice18;
        uint256 fee = order_closePrice18
            .mul(order_amt)
            .mul(feePercent)
            .div(PRECISION)
            .div(1e18);
        if (order.direction == 1) {
            if (order.closePrice18 > order.openPrice18) {
                diffPrice18 = order.closePrice18.sub(order.openPrice18);
                diffMargin = diffPrice18.mul(order_amt).div(1e18);
                mintAmt = order.margin.add(diffMargin);
                // IUSC(address(usc)).mint(address(helperLogic), fee);
                // IUSC(address(usc)).mint(order.user, mintAmt.sub(fee));
                usc.safeTransferFrom(msg.sender, address(helperLogic), fee);
                IUSC(address(usc)).mint(order.user, mintAmt);
            } else {
                diffPrice18 = order.openPrice18.sub(order.closePrice18);
                diffMargin = diffPrice18.mul(order_amt);

                if (diffMargin > order.margin) {
                    mintAmt = 0;
                } else {
                    mintAmt = order.margin.sub(diffMargin);
                    // IUSC(address(usc)).mint(address(helperLogic), fee);
                    // IUSC(address(usc)).mint(order.user, mintAmt.sub(fee));
                    usc.safeTransferFrom(msg.sender, address(helperLogic), fee);
                    IUSC(address(usc)).mint(order.user, mintAmt);
                }
            }
        } else {
            if (order.closePrice18 < order.openPrice18) {
                diffPrice18 = order.openPrice18.sub(order.closePrice18);
                diffMargin = diffPrice18.mul(order_amt).div(1e18);
                mintAmt = order.margin.add(diffMargin);
                // IUSC(address(usc)).mint(address(helperLogic), fee);
                // IUSC(address(usc)).mint(order.user, mintAmt.sub(fee));
                usc.safeTransferFrom(msg.sender, address(helperLogic), fee);
                IUSC(address(usc)).mint(order.user, mintAmt);
            } else {
                diffPrice18 = order.closePrice18.sub(order.openPrice18);
                diffMargin = diffPrice18.mul(order_amt).div(1e18);
                if (diffMargin > order.margin) {
                    mintAmt = 0;
                } else {
                    mintAmt = order.margin.sub(diffMargin);
                    // IUSC(address(usc)).mint(address(helperLogic), fee);
                    // IUSC(address(usc)).mint(order.user, mintAmt.sub(fee));
                    usc.safeTransferFrom(msg.sender, address(helperLogic), fee);
                    IUSC(address(usc)).mint(order.user, mintAmt);
                }
            }
        }

        helperLogic.jointExecution();

        order.state = _state;
        order.closePrice18 = _price18;
        order.closeTime = _timestamp;

        cutListItem(_id, openOrderIdList_index, openOrderIdList);
        cutListItem(
            _id,
            myOpenOrderIdList_index[msg.sender],
            myOpenOrderIdList[msg.sender]
        );

        myCloseOrderIdList[msg.sender].push(_id);

        myCloseOrderIdList_index[msg.sender][_id] = myCloseOrderIdListLength(
            msg.sender
        ).sub(1);
        // uint256 delIndex = openOrderIdList_index[_id];
        // uint256 lastID = openOrderIdList[openOrderIdList.length - 1];
        // openOrderIdList_index[lastID] = delIndex;
        // openOrderIdList[delIndex] = lastID;
        // delete openOrderIdList_index[_id];
        // openOrderIdList.pop();
        return true;
    }

    function closePosition(
        bool _marketState,
        uint256 _id,
        uint256 _timestamp,
        string memory _symbols,
        uint256 _price18,
        bytes memory _signature
    ) external returns (bool) {
        OrderInfo storage order = _orderInfo[_id];
        require(order.user == msg.sender, "user err");

        return
            _closePosition(
                _marketState,
                order,
                2,
                _id,
                _timestamp,
                _symbols,
                _price18,
                _signature
            );
    }

    function cutListItem(
        uint256 _id,
        mapping(uint256 => uint256) storage _List_index,
        uint256[] storage _List
    ) internal {
        uint256 delIndex = _List_index[_id];
        uint256 lastID = _List[_List.length.sub(1)];
        _List_index[lastID] = delIndex;
        _List[delIndex] = lastID;
        delete _List_index[_id];
        _List.pop();
    }

    function liquidation(
        bool _marketState,
        uint256[] memory _id,
        uint256[] memory _timestamp,
        string[] memory _symbols,
        uint256[] memory _price18,
        bytes[] memory _signature
    ) external onlyExecutor returns (bool) {
        uint256 number = 0;
        for (uint256 i = 0; i < _id.length; i++) {
            OrderInfo storage order = _orderInfo[_id[i]];
            if (!_isSolvent(_id[i], _price18[i], order.margin)) {
                number++;
                _closePosition(
                    _marketState,
                    order,
                    3,
                    _id[i],
                    _timestamp[i],
                    _symbols[i],
                    _price18[i],
                    _signature[i]
                );
            }
        }
        require(number != 0, "No liquidation");
        return true;
    }

    function forcedLiquidation(
        bool _marketState,
        uint256 _id,
        uint256 _timestamp,
        string memory _symbols,
        uint256 _price18,
        bytes memory _signature
    ) external onlyExecutor returns (bool) {
        OrderInfo storage order = _orderInfo[_id];
        return
            _closePosition(
                _marketState,
                order,
                4,
                _id,
                _timestamp,
                _symbols,
                _price18,
                _signature
            );
    }

    function _isSolvent(
        uint256 _id,
        uint256 _price18,
        uint256 _margin
    ) public view returns (bool) {
        OrderInfo storage order = _orderInfo[_id];
        uint256 diffPrice18;
        uint256 diffMargin;
        uint256 fee;
        uint256 amt = order.amt;
        uint256 price18 = _price18;
        fee = amt.mul(price18).mul(feePercent).div(PRECISION).div(1e18);
        if (order.direction == 1) {
            if (price18 < order.openPrice18) {
                diffPrice18 = order.openPrice18.sub(price18);
                diffMargin = diffPrice18.mul(amt).div(1e18);
                if (_margin < diffMargin + fee) {
                    return false;
                }
            } else {
                if (_margin < fee) {
                    return false;
                }
            }
        } else {
            if (price18 > order.openPrice18) {
                diffPrice18 = price18.sub(order.openPrice18);
                diffMargin = diffPrice18.mul(amt).div(1e18);
                if (_margin < diffMargin + fee) {
                    return false;
                }
            } else {
                if (_margin < fee) {
                    return false;
                }
            }
        }
        return true;
    }

    function adjustPosition(
        bool _marketState,
        uint256 _id,
        uint256 _timestamp,
        string memory _symbols,
        uint256 _price18,
        bytes memory _signature,
        uint256 _adjustMargin
    ) external returns (bool) {
        OrderInfo storage order = _orderInfo[_id];
        require(order.user != address(0), "order does not exist");
        require(order.state < 2, "state err");
        require(
            oracle.getkey(
                _marketState,
                _price18,
                _timestamp,
                _symbols,
                _signature
            ),
            "oracle err"
        );
        require(_isSolvent(_id, _price18, _adjustMargin), "User is bankrupt");
        uint256 amt = order.amt;
        uint256 margin = order.margin;
        uint256 fee = amt.mul(_price18).mul(feePercent).div(PRECISION).div(
            1e18
        );
        uint256 diffMargin;
        if (_adjustMargin > margin) {
            diffMargin = _adjustMargin.sub(margin);
            usc.safeTransferFrom(msg.sender, address(this), diffMargin);
            IUSC(address(usc)).burn(diffMargin);
        } else {
            diffMargin = margin.sub(_adjustMargin);
            IUSC(address(usc)).mint(order.user, diffMargin);
        }
        usc.safeTransferFrom(msg.sender, address(this), fee);
        usc.safeTransfer(address(helperLogic), fee);
        helperLogic.jointExecution();
        order.margin = _adjustMargin;
        return true;
    }
}
