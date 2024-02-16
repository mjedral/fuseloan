import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    fuse: {
      url: "https://rpc.fuse.io/",
      accounts: {
        // put dev menomonic or PK here
      },
    },
  },
};

export default config;
