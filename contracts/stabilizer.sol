// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Pair.sol";

interface IUSC {
    function burn(uint256 amount) external;

    function mint(address account_, uint256 amount_) external returns (bool);
}

contract stabilizer is Initializable, OwnableUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using SafeMathUpgradeable for uint256;

    //Executor
    mapping(address => bool) public executor;
    address public usdc_usc_lpAddress;
    address public usdc;
    address public usc;

    bool public openBuy;
    bool public openSell;

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

    function initialize(
        // address _helperLogic,
        address _usdc_usc_lpAddress,
        address _usdc,
        address _usc
    ) external initializer {
        __Ownable_init();
        // executor[_helperLogic] = true;
        usdc_usc_lpAddress = _usdc_usc_lpAddress;
        usdc = _usdc;
        usc = _usc;
        openBuy = true;
        openSell = true;
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

    function goStabilizer() external onlyExecutor returns (bool) {
        (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(
            usdc_usc_lpAddress
        ).getReserves();
        address token0 = IUniswapV2Pair(usdc_usc_lpAddress).token0();
        // address token1 = IUniswapV2Pair(usdc_usc_lpAddress).token1();

        (uint256 reserveIn, uint256 reserveOut) = token0 == address(usc)
            ? (reserve1, reserve0)
            : (reserve0, reserve1);

        uint256 usdcForLP = IERC20Upgradeable(usdc).balanceOf(
            usdc_usc_lpAddress
        );
        uint256 uscForLP = IERC20Upgradeable(usc).balanceOf(usdc_usc_lpAddress);
        uint256 usdcDecimals = IUniswapV2Pair(address(usdc)).decimals();
        uint256 addDecimals = 0;
        if (usdcDecimals < 18) {
            addDecimals = 18 - usdcDecimals;
        }
        usdcForLP = usdcForLP * (10**addDecimals);
        uint256 price = usdcForLP.mul(1e18).div(uscForLP);
        if (price > 1e18 && openSell) {
            uint256 neetSellAmt = (usdcForLP.sub(uscForLP)).div(2);
            IUSC(address(usc)).mint(address(this), neetSellAmt);

            IERC20Upgradeable(usc).safeTransfer(
                usdc_usc_lpAddress,
                neetSellAmt
            );
            uint256 amountOut = getAmountOut(
                neetSellAmt,
                reserveOut,
                reserveIn
            );

            (uint256 amount0Out, uint256 amount1Out) = token0 == address(usc)
                ? (uint256(0), amountOut)
                : (amountOut, uint256(0));
            IUniswapV2Pair(usdc_usc_lpAddress).swap(
                amount0Out,
                amount1Out,
                address(this),
                new bytes(0)
            );
        }

        if (price < 1e18 && openBuy) {
            uint256 neetBuyAmt = (uscForLP.sub(usdcForLP)).div(2);
            uint256 thisAddressBalance = IERC20Upgradeable(usdc).balanceOf(
                address(this)
            );
            uint256 amountIn;
            if (neetBuyAmt > thisAddressBalance) {
                amountIn = thisAddressBalance;
            } else {
                amountIn = neetBuyAmt;
            }
            if (amountIn != 0) {
                IERC20Upgradeable(usdc).safeTransfer(
                    usdc_usc_lpAddress,
                    amountIn
                );
                uint256 amountOut = getAmountOut(
                    amountIn,
                    reserveIn,
                    reserveOut
                );

                (uint256 amount0Out, uint256 amount1Out) = token0 ==
                    address(usdc)
                    ? (uint256(0), amountOut)
                    : (amountOut, uint256(0));
                IUniswapV2Pair(usdc_usc_lpAddress).swap(
                    amount0Out,
                    amount1Out,
                    address(this),
                    new bytes(0)
                );
            }
        }
        return true;
    }

    function withdrawalERC20(address _address, uint256 _amt)
        external
        onlyOwner
        returns (bool)
    {
        IERC20Upgradeable(_address).safeTransfer(msg.sender, _amt);
        return true;
    }

    function setOpenBuy(bool _type) external onlyOwner returns (bool) {
        openBuy = _type;
        return true;
    }

    function setOpenSell(bool _type) external onlyOwner returns (bool) {
        openSell = _type;
        return true;
    }
}
