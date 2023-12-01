# hardhat cli

Compile

```shell
$ npx hardhat compile
```

Deploy

```shell
$ npx hardhat run --network {network_name} {path_of_script_deploy}

example
$ npx hardhat run --network bkc_testnet scripts/deploy.ts

```

Flatten

```shell
$ npx hardhat flatten > Flattened.sol
```

```shell
$ npx hardhat flatten contracts/Foo.sol
```


\*ps need to specific the version of solidity in the code contract (for verify) as match as solidiry_version in hardhat.config.ts
