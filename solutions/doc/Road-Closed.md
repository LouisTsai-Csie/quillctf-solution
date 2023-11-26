# Road Closed

## Information

+ Challenge: `Road Closed`
+ Category: `Solidity Security`
+ Status: `Solved`
+ Link: [Road Closed](https://academy.quillaudits.com/challenges/quillctf-challenges/road-closed)
+ Goal
  + Become the owner of the contract
  + Change the value of hacked to true

## Solution
To pass this challenge, we start by using `changeOwner` to transfer ownership. The function has a rule that requires setting `whitelistedMinters[addr]` to `true` . We can simply meet this requirement by adding the contract address to the whitelist. The next step is to set `hack` state variable to `true`. Both of these steps share a common condition: the return value of `isContract` should not be zero.



The `isContract` function is provided below:

```solidity
function isContract(address addr) public view returns (bool) {
    uint size;
    assembly {
        size := extcodesize(addr)
    }
    return size > 0;
}
```


The assembly code retrieves the byte code at the specified address. If it is an Externally Owned Account (EOA), there is no byte code stored under that address. However, for a contract address, the compiled byte code is stored. Note that there is an exception to this rule: the contract byte code is stored after construction. This vulnerability can be exploited by launching an attack during the construction phase, specifically in the `constructor`. The specification of  implementation of isContract can be reviewed in the [oppenzeppelin documentaiton](https://docs.openzeppelin.com/contracts/2.x/api/utils):

> It is unsafe to assume that an address for which this function returns false is an externally-owned account (EOA) and not a contract. Among others, `isContract` will return false for the following types of addresses: 
+ an externally-owned account 
+ a contract in construction 
+ an address where a contract will be created
+ an address where a contract lived, but was destroyed

In the `attack.sol` file, we perform the following action to manipulate the ownership and data, with the following actions executed:

1. Utilize `addToWhitelist` to include the attacker contract address in the whitelist.
2. Invoke `changeOwner` to manipulate ownership.
3. Activate `pwn` to set the `hack` value to true.

During steps 2 and 3, as these procedures occur during the contract creation phase, the `isContract` will return `false`, bypassing the restriction.

## Reference
+ [EXTCODESIZE Checks - Ethereum Smart Contract Best Practices](https://consensys.github.io/smart-contract-best-practices/development-recommendations/solidity-specific/extcodesize-checks/)
+ [Intro to Smart Contract Security Auditing: Comprehensive Guide to Contract Size Checks](https://slowmist.medium.com/intro-to-smart-contract-security-auditing-comprehensive-guide-to-contract-size-checks-d6f6be00973c)