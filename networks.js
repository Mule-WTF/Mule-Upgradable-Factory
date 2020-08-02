const HDWalletProvider = require("truffle-hdwallet-provider");
const dotenv = require('dotenv');
dotenv.config();

const MNEMONIC_OR_PK = process.env.MNEMONIC_OR_PK;
const INFURA_KEY = process.env.INFURA_KEY;

if (!MNEMONIC_OR_PK || !INFURA_KEY) {
  console.error("Please set a MNEMONIC_OR_PK and infura key.")
  return
}

module.exports = {
  networks: {
    development: {
      protocol: 'http',
      host: 'localhost',
      port: 8545,
      gas: 5000000,
      gasPrice: 5e9,
      networkId: '*',
    },
     mainnet: {
      provider: function() {
        return new HDWalletProvider(
          MNEMONIC_OR_PK,
          "https://mainnet.infura.io/v3/" + INFURA_KEY
        );
      },
      network_id: "*",
      gas: 4000000
    },
     rinkeby: {
      provider: function() {
        return new HDWalletProvider(
          MNEMONIC_OR_PK,
          "https://rinkeby.infura.io/v3/" + INFURA_KEY
        );
      },
      network_id: "*",
      gas: 4000000
    },
     kovan: {
      provider: function() {
        return new HDWalletProvider(
          MNEMONIC_OR_PK,
          "https://kovan.infura.io/v3/" + INFURA_KEY
        );
      },
      network_id: "*",
      gas: 4000000
    },
     matic: {
      provider: function() {
        return new HDWalletProvider(
          MNEMONIC_OR_PK,
          "https://rpc-mainnet.matic.network"
        );
      },
      network_id: "*",
      gas: 4000000
    },
     maticMumbai: {
      provider: function() {
        return new HDWalletProvider(
          MNEMONIC_OR_PK,
          "https://rpc-mumbai.matic.today"
        );
      },
      network_id: "*",
      gas: 4000000
    }
  },
};
