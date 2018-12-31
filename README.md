# keep It

> A DApp built by solidity and vue.js

## What's it?
It is just a clock in app built by blockchain.

## How to run it?
### First
You should run a **private Ethereum chain** on local. If you don't know how to do that, [this way](https://7cthunder.github.io/2018/11/04/%E5%8C%BA%E5%9D%97%E9%93%BE%20%7C%20%E5%88%9D%E6%8E%A2%E4%BB%A5%E5%A4%AA%E5%9D%8A/).

### Second
Go to the directory `./vue-client`, this client is a pure client, I have not finished a server side. So, the following instructions are running a dev env client.
1. The first one is to download dependecy.
2. The second one is to run a dev env client, which built by Vue.
3. If you wanna to build a production env app, just run the third one.

``` bash
# install dependencies
npm install

# serve with hot reload at localhost:8080
npm run dev

# build for production with minification
npm run build
```

**If your ethereum chain doesn't run on localhost:8545, please go to './src/utils/contract.js' and modify the following code:** 

```javascript
export var web3 = new Web3(Web3.givenProvider || 'http://localhost:8545')

