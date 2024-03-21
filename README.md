## Auditing an ERC20 token using Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

Starts up a local blockchain available at rpc-url http://127.0.0.1:8545

```shell
$ anvil
```

### Deploy

Deploy your smart contract to a blockchain network

```shell
$ forge script script/Token.s.sol:TokenScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

Note: you should NEVER expose a private key, it is only convinient for fast and local tests

### Cast

```shell
$ cast <subcommand>
```

Use cast command to create a wallet using a private key. Then you can use that wallet to safely deploy a contract. 

```shell
$ cast wallet import --interactive <account-name>
```

and you will be asked to enter the private key and a password

or alternatively you can specifiy the private key, like in the example below (where the account is named anvil0)


```shell
$ cast wallet import --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 anvil0
```

And now we can deploy the contract using the wallet, as in the command below: 

```shell
$ forge script script/Token.s.sol:TokenScript --rpc-url http://localhost:8545 --broadcast --account anvil0 --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
```

Mind that the sender address is the corresponding one to the private key used to create the wallet. 



### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
