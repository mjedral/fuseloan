import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox-viem/network-helpers";
import { expect } from "chai";
import hre from "hardhat";
import { getAddress, parseGwei } from "viem";

describe("FuseLoan", function () {
  async function deploy() {
    // Contracts are deployed using the first signer/account by default
    const [owner, alice] = await hre.viem.getWalletClients();
    const FuseLoan = await hre.viem.deployContract("FuseLoan", [42]);
    const publicClient = await hre.viem.getPublicClient();

    return {
      FuseLoan,
      owner,
      publicClient,
    };
  }

  describe("Deployment", function () {
    it("Should set the right number to store", async () => {
      const { FuseLoan, owner, publicClient } = await loadFixture(deploy);
      expect(await FuseLoan.read.getStore()).to.eq(42);
    });
  });

  describe("logic", function (){
    it("should write right number to store", async () => {
      const { FuseLoan, owner, publicClient } = await loadFixture(deploy);
      await FuseLoan.write.setStore([0]);
      expect(await FuseLoan.read.getStore()).to.eq(0);
    })
  })
});
