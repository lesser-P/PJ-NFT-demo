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

interface StabilizerInterface extends ethers.utils.Interface {
  functions: {
    "executor(address)": FunctionFragment;
    "goStabilizer()": FunctionFragment;
    "initialize(address,address,address)": FunctionFragment;
    "openBuy()": FunctionFragment;
    "openSell()": FunctionFragment;
    "owner()": FunctionFragment;
    "renounceOwnership()": FunctionFragment;
    "setExecutor(address,bool)": FunctionFragment;
    "setOpenBuy(bool)": FunctionFragment;
    "setOpenSell(bool)": FunctionFragment;
    "transferOwnership(address)": FunctionFragment;
    "usc()": FunctionFragment;
    "usdc()": FunctionFragment;
    "usdc_usc_lpAddress()": FunctionFragment;
    "withdrawalERC20(address,uint256)": FunctionFragment;
  };

  encodeFunctionData(functionFragment: "executor", values: [string]): string;
  encodeFunctionData(
    functionFragment: "goStabilizer",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "initialize",
    values: [string, string, string]
  ): string;
  encodeFunctionData(functionFragment: "openBuy", values?: undefined): string;
  encodeFunctionData(functionFragment: "openSell", values?: undefined): string;
  encodeFunctionData(functionFragment: "owner", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "renounceOwnership",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "setExecutor",
    values: [string, boolean]
  ): string;
  encodeFunctionData(functionFragment: "setOpenBuy", values: [boolean]): string;
  encodeFunctionData(
    functionFragment: "setOpenSell",
    values: [boolean]
  ): string;
  encodeFunctionData(
    functionFragment: "transferOwnership",
    values: [string]
  ): string;
  encodeFunctionData(functionFragment: "usc", values?: undefined): string;
  encodeFunctionData(functionFragment: "usdc", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "usdc_usc_lpAddress",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "withdrawalERC20",
    values: [string, BigNumberish]
  ): string;

  decodeFunctionResult(functionFragment: "executor", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "goStabilizer",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "initialize", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "openBuy", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "openSell", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "owner", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "renounceOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setExecutor",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "setOpenBuy", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "setOpenSell",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "transferOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "usc", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "usdc", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "usdc_usc_lpAddress",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "withdrawalERC20",
    data: BytesLike
  ): Result;

  events: {
    "OwnershipTransferred(address,address)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "OwnershipTransferred"): EventFragment;
}

export type OwnershipTransferredEvent = TypedEvent<
  [string, string] & { previousOwner: string; newOwner: string }
>;

export class Stabilizer extends BaseContract {
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

  interface: StabilizerInterface;

  functions: {
    executor(arg0: string, overrides?: CallOverrides): Promise<[boolean]>;

    goStabilizer(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    initialize(
      _usdc_usc_lpAddress: string,
      _usdc: string,
      _usc: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    openBuy(overrides?: CallOverrides): Promise<[boolean]>;

    openSell(overrides?: CallOverrides): Promise<[boolean]>;

    owner(overrides?: CallOverrides): Promise<[string]>;

    renounceOwnership(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    setExecutor(
      _address: string,
      _type: boolean,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    setOpenBuy(
      _type: boolean,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    setOpenSell(
      _type: boolean,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    transferOwnership(
      newOwner: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;

    usc(overrides?: CallOverrides): Promise<[string]>;

    usdc(overrides?: CallOverrides): Promise<[string]>;

    usdc_usc_lpAddress(overrides?: CallOverrides): Promise<[string]>;

    withdrawalERC20(
      _address: string,
      _amt: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<ContractTransaction>;
  };

  executor(arg0: string, overrides?: CallOverrides): Promise<boolean>;

  goStabilizer(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  initialize(
    _usdc_usc_lpAddress: string,
    _usdc: string,
    _usc: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  openBuy(overrides?: CallOverrides): Promise<boolean>;

  openSell(overrides?: CallOverrides): Promise<boolean>;

  owner(overrides?: CallOverrides): Promise<string>;

  renounceOwnership(
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  setExecutor(
    _address: string,
    _type: boolean,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  setOpenBuy(
    _type: boolean,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  setOpenSell(
    _type: boolean,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  transferOwnership(
    newOwner: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  usc(overrides?: CallOverrides): Promise<string>;

  usdc(overrides?: CallOverrides): Promise<string>;

  usdc_usc_lpAddress(overrides?: CallOverrides): Promise<string>;

  withdrawalERC20(
    _address: string,
    _amt: BigNumberish,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    executor(arg0: string, overrides?: CallOverrides): Promise<boolean>;

    goStabilizer(overrides?: CallOverrides): Promise<boolean>;

    initialize(
      _usdc_usc_lpAddress: string,
      _usdc: string,
      _usc: string,
      overrides?: CallOverrides
    ): Promise<void>;

    openBuy(overrides?: CallOverrides): Promise<boolean>;

    openSell(overrides?: CallOverrides): Promise<boolean>;

    owner(overrides?: CallOverrides): Promise<string>;

    renounceOwnership(overrides?: CallOverrides): Promise<void>;

    setExecutor(
      _address: string,
      _type: boolean,
      overrides?: CallOverrides
    ): Promise<boolean>;

    setOpenBuy(_type: boolean, overrides?: CallOverrides): Promise<boolean>;

    setOpenSell(_type: boolean, overrides?: CallOverrides): Promise<boolean>;

    transferOwnership(
      newOwner: string,
      overrides?: CallOverrides
    ): Promise<void>;

    usc(overrides?: CallOverrides): Promise<string>;

    usdc(overrides?: CallOverrides): Promise<string>;

    usdc_usc_lpAddress(overrides?: CallOverrides): Promise<string>;

    withdrawalERC20(
      _address: string,
      _amt: BigNumberish,
      overrides?: CallOverrides
    ): Promise<boolean>;
  };

  filters: {
    "OwnershipTransferred(address,address)"(
      previousOwner?: string | null,
      newOwner?: string | null
    ): TypedEventFilter<
      [string, string],
      { previousOwner: string; newOwner: string }
    >;

    OwnershipTransferred(
      previousOwner?: string | null,
      newOwner?: string | null
    ): TypedEventFilter<
      [string, string],
      { previousOwner: string; newOwner: string }
    >;
  };

  estimateGas: {
    executor(arg0: string, overrides?: CallOverrides): Promise<BigNumber>;

    goStabilizer(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    initialize(
      _usdc_usc_lpAddress: string,
      _usdc: string,
      _usc: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    openBuy(overrides?: CallOverrides): Promise<BigNumber>;

    openSell(overrides?: CallOverrides): Promise<BigNumber>;

    owner(overrides?: CallOverrides): Promise<BigNumber>;

    renounceOwnership(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    setExecutor(
      _address: string,
      _type: boolean,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    setOpenBuy(
      _type: boolean,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    setOpenSell(
      _type: boolean,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    transferOwnership(
      newOwner: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;

    usc(overrides?: CallOverrides): Promise<BigNumber>;

    usdc(overrides?: CallOverrides): Promise<BigNumber>;

    usdc_usc_lpAddress(overrides?: CallOverrides): Promise<BigNumber>;

    withdrawalERC20(
      _address: string,
      _amt: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    executor(
      arg0: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    goStabilizer(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    initialize(
      _usdc_usc_lpAddress: string,
      _usdc: string,
      _usc: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    openBuy(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    openSell(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    owner(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    renounceOwnership(
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    setExecutor(
      _address: string,
      _type: boolean,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    setOpenBuy(
      _type: boolean,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    setOpenSell(
      _type: boolean,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    transferOwnership(
      newOwner: string,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;

    usc(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    usdc(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    usdc_usc_lpAddress(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    withdrawalERC20(
      _address: string,
      _amt: BigNumberish,
      overrides?: Overrides & { from?: string | Promise<string> }
    ): Promise<PopulatedTransaction>;
  };
}