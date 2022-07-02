// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Pair.sol";
import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Factory.sol";
import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Router02.sol";

interface IFarm {
    function setPool(
        uint256 _pid,
        uint256 _allocPoint,
        bool _withUpdate
    ) external;
}

interface IStabilizer {
    function goStabilizer() external returns (bool);
}

contract helperLogic is Initializable, OwnableUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using SafeMathUpgradeable for uint256;

    //Executor
    mapping(address => bool) public executor;
    IERC20Upgradeable public usc;
    IERC20Upgradeable public usdc;
    IERC20Upgradeable public sea;
    IERC20Upgradeable public ssea;
    address public op;
    address public dev;

    IUniswapV2Router02 public Router;
    IUniswapV2Factory public Factory;

    uint256 public toSseaPercent;
    uint256 public toOpPercent;
    uint256 public toDevPercent;
    uint256 public PRECISION;

    uint256 public basePoint;
    uint256 public pid;

    IFarm public farm;

    bool public autoAdjustFarm;
    bool public openStabilizer;

    address public stabilizer;

    function initialize(
        // address _mirrorseaMain,
        IUniswapV2Factory _Factory,
        IUniswapV2Router02 _Router,
        IERC20Upgradeable _usc,
        IERC20Upgradeable _usdc,
        IERC20Upgradeable _sea,
        IERC20Upgradeable _ssea,
        IFarm _farm
    )
        external
        // address _stabilizer
        initializer
    {
        __Ownable_init();
        // executor[_mirrorseaMain] = true;
        Router = _Router;
        Factory = _Factory;
        usc = _usc;
        sea = _sea;
        ssea = _ssea;
        op = msg.sender;
        dev = msg.sender;
        toSseaPercent = 5000;
        toOpPercent = 2500;
        toDevPercent = 2500;
        PRECISION = 10000;
        basePoint = 1000;
        autoAdjustFarm = true;
        openStabilizer = false;
        farm = _farm;
        usdc = _usdc;
        // stabilizer = _stabilizer;
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

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 amountOut) {
        uint256 amountInWithFee = amountIn.mul(9970);
        uint256 numerator = amountInWithFee.mul(reserveOut);
        uint256 denominator = reserveIn.mul(10000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    function buySea(uint256 uscAmt) internal returns (uint256) {
        address sea_usc_lpAddress = Factory.getPair(address(sea), address(usc));
        usc.safeTransfer(sea_usc_lpAddress, uscAmt);
        (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(
            sea_usc_lpAddress
        ).getReserves();
        address token0 = IUniswapV2Pair(sea_usc_lpAddress).token0();
        (uint256 reserveIn, uint256 reserveOut) = token0 == address(usc)
            ? (reserve0, reserve1)
            : (reserve1, reserve0);
        uint256 amountOut = getAmountOut(uscAmt, reserveIn, reserveOut);
        (uint256 amount0Out, uint256 amount1Out) = token0 == address(usc)
            ? (uint256(0), amountOut)
            : (amountOut, uint256(0));
        IUniswapV2Pair(sea_usc_lpAddress).swap(
            amount0Out,
            amount1Out,
            address(this),
            new bytes(0)
        );
        return amountOut;
    }

    function jointExecution() external onlyExecutor returns (bool) {
        uint256 uscBalanceOf = usc.balanceOf(address(this));
        if (uscBalanceOf == 0) {
            return true;
        }
        uint256 toSsea = uscBalanceOf.mul(toSseaPercent).div(PRECISION);
        uint256 toOp = uscBalanceOf.mul(toOpPercent).div(PRECISION);
        uint256 toDev = uscBalanceOf.sub(toSsea).sub(toOp);

        uint256 seaAmt = buySea(toSsea);
        sea.safeTransfer(address(ssea), seaAmt);
        usc.safeTransfer(address(op), toOp);
        usc.safeTransfer(address(dev), toDev);

        if (autoAdjustFarm) {
            adjustFarm();
        }

        if (openStabilizer) {
            IStabilizer(stabilizer).goStabilizer();
        }

        return true;
    }

    function adjustFarm() internal {
        address pairAddress = Factory.getPair(address(usdc), address(usc));
        uint256 uscBalanceOf = usc.balanceOf(pairAddress);
        uint256 usdcBalanceOf = usdc.balanceOf(pairAddress);
        uint256 usdcDecimals = IUniswapV2Pair(address(usdc)).decimals();
        uint256 addDecimals = 0;
        if (usdcDecimals < 18) {
            addDecimals = 18 - usdcDecimals;
        }
        uint256 r = 1e18 * (10**addDecimals);
        uint256 uscPrice = usdcBalanceOf.mul(r).div(uscBalanceOf);
        uint256 USDC_USC_LP_farmPoint;
        uint256 diffPoint;
        if (uscPrice > 1e18) {
            //higt 1
            diffPoint = (uscPrice.sub(1e18)).div(1e14);
            if (diffPoint > basePoint) {
                USDC_USC_LP_farmPoint = 0;
            } else {
                USDC_USC_LP_farmPoint = basePoint.sub(diffPoint);
            }
        } else {
            //low 1
            diffPoint = (1e18 - uscPrice).div(1e14);
            USDC_USC_LP_farmPoint = basePoint.add(diffPoint);
        }
        farm.setPool(pid, USDC_USC_LP_farmPoint, true);
    }

    function withdrawalERC20(address _address, uint256 _amt)
        external
        onlyOwner
        returns (bool)
    {
        IERC20Upgradeable(_address).safeTransfer(msg.sender, _amt);
        return true;
    }

    function setOp(address _address) external onlyOwner returns (bool) {
        op = _address;
        return true;
    }

    function setDev(address _address) external onlyOwner returns (bool) {
        dev = _address;
        return true;
    }

    function setToSseaPercent(uint256 _val) external onlyOwner returns (bool) {
        toSseaPercent = _val;
        return true;
    }

    function setToOpPercent(uint256 _val) external onlyOwner returns (bool) {
        toOpPercent = _val;
        return true;
    }

    function setToDevPercent(uint256 _val) external onlyOwner returns (bool) {
        toDevPercent = _val;
        return true;
    }

    function setAutoAdjustFarm(bool _bool) external onlyOwner returns (bool) {
        autoAdjustFarm = _bool;
        return true;
    }

    function setOpenStabilizer(bool _bool) external onlyOwner returns (bool) {
        openStabilizer = _bool;
        return true;
    }

    function setStabilizer(address _address) external onlyOwner returns (bool) {
        stabilizer = _address;
        return true;
    }

    function setPid(uint256 _val) external onlyOwner returns (bool) {
        pid = _val;
        return true;
    }

    function setUSDCAddress(IERC20Upgradeable _usdc)
        external
        onlyOwner
        returns (bool)
    {
        usdc = _usdc;
        return true;
    }

    function setFarm(IFarm _farm) external onlyOwner returns (bool) {
        farm = _farm;
        return true;
    }
}
