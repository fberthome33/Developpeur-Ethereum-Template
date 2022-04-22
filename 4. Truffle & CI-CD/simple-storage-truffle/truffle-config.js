const path = require('path');
const HDWalletProvider = require("@truffle/hdwallet-provider");
require('dotenv').config();

module.exports = {
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. If you don't specify one truffle
   * will spin up a development blockchain for you on port 9545 when you
   * run `develop` or `test`. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  networks: {
    // Useful for testing. The `development` name is special - truffle uses it by default
    // if it's defined here and no other network is specified at the command line.
    // You should run a client (like ganache-cli, geth or parity) in a separate terminal
    // tab if you use this network and you must also set the `host`, `port` and `network_id`
    // options below to some value.
    //
    develop: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 9545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    },
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    },

    rinkeby: {
      provider: function() {
        return new HDWalletProvider(`${process.env.MNEMONIC}`, `https://rinkeby.infura.io/v3/${process.env.INFURA_PROJECT_ID}`)
      },
      network_id: 4
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(`${process.env.MNEMONIC}`, `https://ropsten.infura.io/v3/${process.env.INFURA_PROJECT_ID}`)
      },
      network_id: 3
    },
    kovan: {
      provider: () => new HDWalletProvider(`${process.env.MNEMONIC}`, `https://kovan.infura.io/v3/${process.env.INFURA_PROJECT_ID}`),
      from: "0x362e75e2744Fa57f7F272913b692c6bFbF5692da",
      network_id: 42,
      gas: 3000000,
      gasPrice: 10000000000
      },
      Mumbai: {
        provider: function() {
          return new HDWalletProvider(`${process.env.MNEMONIC}`, `https://polygon-mumbai.infura.io/v3/${process.env.INFURA_ID}`)
        },
        network_id: 80001
      },
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.13",    
    }
  }
}
