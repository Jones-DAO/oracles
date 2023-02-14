![banner](https://pbs.twimg.com/profile_banners/1460314480601022465/1669608449/1500x500)
# jGLP and jUSDC oracles
TWAP oracles for JonesDAO advanced strategies vaults.
# Getting Started

1. <a href="https://book.getfoundry.sh/getting-started/installation">Install</a> Foundry/forge
2. Clone this repo
3. `forge install`

# How it works

### Common aspects: 

* In order to get prices, it is necessary to interact with the function `getUsdPrice(address _asset)` in `OracleAggreagator.sol`, passing jUSDC or jGLP <a href="https://docs.jonesdao.io/jones-dao/other/contracts">addresses</a> **WE DO NOT RECOMMEND INTERACTING WITH THE ORACLES DIRECTLY.**

* All prices returns the USD value using 18 decimals.

* Both oracles are an average of 4 prices snapshot, taken with at least 30 minutes space between them. Anyone can call the function to take a price snapshot as long as it has passed 30 minutes or more from the latest one.

### Pricing

* jGLP: Firstly we get the average between buy and sell price from GMXs contracts, then the jGLP-GLP ratio is fetched **(important to point that it does not include any retention)**. Lastly, using these two parameters we are able to get the price in USD for 1 jGLP.

* jUSDC: The jUSDC-USDC ratio is fetched and using chainlink oracles we calculate how much USD 1 jUSDC is worth **not considering any retention**.

# Deployment

First step is to deploy the oracles, then the `OracleAggregator` and finally link the oracles with the aggregator.

1. The constructors take 3 parameters: `address _asset, uint128 _min, uint64 _collected`. Which are respectively: the oracle asset, minimum time between snapshosts and the amount of snapshots taken in consideration for the final price average

2. Our OracleAggregator contract uses the <a href="https://docs.openzeppelin.com/contracts/3.x/api/proxy#TransparentUpgradeableProxy">OpenZeppelin Transparent Upgradeable Proxy pattern</a>, you can either use Hardhat or Forge to deploy it. If using Forge, we recommend <a href="https://github.com/odyslam/foundry-upgrades">this</a> to deploy it **(do not forget to call `initialize()`)**.

3. After deploying everything, the `OracleAggregator` admin should call `addOracle(address _oracle)` and add the addresses of the deployed oracles.

# Live Contracts

* Oracle Aggregator: <a href="https://arbiscan.io/address/0x0a4b5223698CA750f0061E93c1dE8CfDE19c982a">0x0a4b5223698CA750f0061E93c1dE8CfDE19c982a</a>
* jGLP Oracle: <a href="https://arbiscan.io/address/0x70c7e4834a3f7565b7cd8977b33c93d347af9bf6">0x70c7e4834a3f7565b7cd8977b33c93d347af9bf6</a>
* jUSDC Oracle: <a href="https://arbiscan.io/address/0x263c4fABd13b3822f5d476683bBFe2C437BB4Cc2">0x263c4fABd13b3822f5d476683bBFe2C437BB4Cc2</a> 
