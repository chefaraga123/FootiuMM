### Contracts

| Contract                     | LOC | Description                                  |
| ---------------------------- | --- | -------------------------------------------- |
| FootiuMM.sol                 | ?   | Contract that holds the NFT<>Token AMM Logic |
| PlayerPricing.sol            | ?   | Contract that holds the NFT pricing logic    |
| *testing* Dummy NFT Contract |     |                                              |

## Alpha Testing
### Depositing an NFT in a pool
The only type of trading is **Footium Players <> Points** 
When you deposit an NFT in the pool you get some points that are simply internal accounting within a smart contract 
Those points allow you to withdraw NFTs from the contract with points corresponding less than or equal to the number of points controlled by the address 
### Taking an NFT from the pool 
The points you've received from the pool allow you to then withdraw players from the pool 


## Beta Testing
### Rarity Pools 
**Bronze**: <60
**Silver**: 60 - 70 
**Gold**: 70 - 80 
**Diamond**: 80 - 90 

### Depositing an NFT in a pool
The only type of trading is **Footium Players <> Points** 
When you deposit an NFT in the pool you get some points that are simply internal accounting within a smart contract 
Those points allow you to withdraw NFTs from the contract with a points value less than or equal to the number of points owned 

## V1 
### Rarity Scoring 
The amount of points attributed to an NFT is a function of 


```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
