/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import {
  ethers,
  EventFilter,
  Signer,
  BigNumber,
  BigNumberish,
  PopulatedTransaction,
  BaseContract,
  ContractTransaction,
  Overrides,
  CallOverrides,
} from "ethers";
import { BytesLike } from "@ethersproject/bytes";
import { Listener, Provider } from "@ethersproject/providers";
import { FunctionFragment, EventFragment, Result } from "@ethersproject/abi";
import type { TypedEventFilter, TypedEvent, TypedListener } from "./common";

interface ITWAPOracleInterface extends ethers.utils.Interface {
  functions: {
    "priceTokenAddressForPricingTokenAddressForLastEpochUpdateBlockTimstamp(address,address,uint256)": FunctionFragment;
    "pricedTokenForPricingTokenForEpochPeriodForLastEpochPrice(address,address,uint256)": FunctionFragment;
    "pricedTokenForPricingTokenForEpochPeriodForPrice(address,address,uint256)": FunctionFragment;
    "uniV2CompPairAddressForLastEpochUpdateBlockTimstamp(address)": FunctionFragment;
    "updateTWAP(address,uint256)": FunctionFragment;
  };

  encodeFunctionData(
    functionFragment: "priceTokenAddressForPricingTokenAddressForLastEpochUpdateBlockTimstamp",
    values: [string, string, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "pricedTokenForPricingTokenForEpochPeriodForLastEpochPrice",
    values: [string, string, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "pricedTokenForPricingTokenForEpochPeriodForPrice",
    values: [string, string, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "uniV2CompPairAddressForLastEpochUpdateBlockTimstamp",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "updateTWAP",
    values: [string, BigNumberish]
  ): string;

  decodeFunctionResult(
    functionFragment: "priceTokenAddressForPricingTokenAddressForLastEpochUpdateBlockTimstamp",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "pricedTokenForPricingTokenForEpochPeriodForLastEpochPrice",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "pricedTokenForPricingTokenForEpochPeriodForPrice",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "uniV2CompPairAddressForLastEpochUpdateBlockTimstamp",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "updateTWAP", data: BytesLike): Result;

  events: {};
}

export class ITWAPOracle extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  listeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter?: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): Array<TypedListener<EventArgsArray, EventArgsObject>>;
  off<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  on<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  once<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeListener<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>,
    listener: TypedListener<EventArgsArray, EventArgsObject>
  ): this;
  removeAllListeners<EventArgsArray extends Array<any>, EventArgsObject>(
    eventFilter: TypedEventFilter<EventArgsArray, EventArgsObject>
  ): this;

  listeners(eventName?: string): Array<Listener>;
  off(eventName: string, listener: Listener): this;
  on(eventName: string, listener: Listener): this;
  once(eventName: string, listener: Listener): this;
  removeListener(eventName: string, listener: Listener): this;
  removeAllListeners(eventName?: string): this;

  queryFilter<EventArgsArray extends Array<any>, EventArgsObject>(
    event: TypedEventFilter<EventArgsArray, EventArgsObject>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TypedEvent<EventArgsArray & EventArgsObject>>>;

  interface: ITWAPOracleInterface;

  functions: {
    priceTokenAddressForPricingTokenAddressForLastEpochUpdateBlockTimstamp(
      tokenToPrice_: string,
      tokenForPriceComparison_: string,
      epochPeriod_: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    pricedTokenForPricingTokenForEpochPeriodForLastEpochPrice(
      arg0: string,
      arg1: string,
      arg2: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    pricedTokenForPricingTokenForEpochPeriodForPrice(
      arg0: string,
      arg1: string,
      arg2: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    uniV2CompPairAddressForLastEpochUpdateBlockTimstamp(
      arg0: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    updateTWAP(
      uniV2CompatPairAddressToUpdate_: string,
      eopchPeriodToUpdate_: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;
  };

  priceTokenAddressForPricingTokenAddressForLastEpochUpdateBlockTimstamp(
    tokenToPrice_: string,
    tokenForPriceComparison_: string,
    epochPeriod_: BigNumberish,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  pricedTokenForPricingTokenForEpochPeriodForLastEpochPrice(
    arg0: string,
    arg1: string,
    arg2: BigNumberish,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  pricedTokenForPricingTokenForEpochPeriodForPrice(
    arg0: string,
    arg1: string,
    arg2: BigNumberish,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  uniV2CompPairAddressForLastEpochUpdateBlockTimstamp(
    arg0: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  updateTWAP(
    uniV2CompatPairAddressToUpdate_: string,
    eopchPeriodToUpdate_: BigNumberish,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    priceTokenAddressForPricingTokenAddressForLastEpochUpdateBlockTimstamp(
      tokenToPrice_: string,
      tokenForPriceComparison_: string,
      epochPeriod_: BigNumberish,
      overrides?: CallOverrides
    ): Promise<number>;

    pricedTokenForPricingTokenForEpochPeriodForLastEpochPrice(
      arg0: string,
      arg1: string,
      arg2: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    pricedTokenForPricingTokenForEpochPeriodForPrice(
      arg0: string,
      arg1: string,
      arg2: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    uniV2CompPairAddressForLastEpochUpdateBlockTimstamp(
      arg0: string,
      overrides?: CallOverrides
    ): Promise<number>;

    updateTWAP(
      uniV2CompatPairAddressToUpdate_: string,
      eopchPeriodToUpdate_: BigNumberish,
      overrides?: CallOverrides
    ): Promise<boolean>;
  };

  filters: {};

  estimateGas: {
    priceTokenAddressForPricingTokenAddressForLastEpochUpdateBlockTimstamp(
      tokenToPrice_: string,
      tokenForPriceComparison_: string,
      epochPeriod_: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    pricedTokenForPricingTokenForEpochPeriodForLastEpochPrice(
      arg0: string,
      arg1: string,
      arg2: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    pricedTokenForPricingTokenForEpochPeriodForPrice(
      arg0: string,
      arg1: string,
      arg2: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    uniV2CompPairAddressForLastEpochUpdateBlockTimstamp(
      arg0: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    updateTWAP(
      uniV2CompatPairAddressToUpdate_: string,
      eopchPeriodToUpdate_: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    priceTokenAddressForPricingTokenAddressForLastEpochUpdateBlockTimstamp(
      tokenToPrice_: string,
      tokenForPriceComparison_: string,
      epochPeriod_: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    pricedTokenForPricingTokenForEpochPeriodForLastEpochPrice(
      arg0: string,
      arg1: string,
      arg2: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    pricedTokenForPricingTokenForEpochPeriodForPrice(
      arg0: string,
      arg1: string,
      arg2: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    uniV2CompPairAddressForLastEpochUpdateBlockTimstamp(
      arg0: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    updateTWAP(
      uniV2CompatPairAddressToUpdate_: string,
      eopchPeriodToUpdate_: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;
  };
}
