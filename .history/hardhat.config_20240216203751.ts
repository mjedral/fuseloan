import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
require('dotenv').config()

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    fuse: {
      url: "https://rpc.fuse.io/",
      accounts: {
        [process.env.ADMIN_PRIV_KEY || ""]
      },
    },
  },
};

export default config;
