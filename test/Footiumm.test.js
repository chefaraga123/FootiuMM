/* eslint-disable no-undef */
// Right click on the script name and hit "Run" to execute
import { expect } from "chai";
import * as hardhat from "hardhat"

describe("Multiple Contracts Test", function () {
  let DummyPlayer;
  let dummyPlayer;
  let PlayerPricing;
  let playerPricing;
  let FootiuMM;
  let footiuMM;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    PlayerPricing = await ethers.getContractFactory("PlayerPricing");
    playerPricing = await PlayerPricing.deploy();
    await playerPricing.deployed();

    FootiuMM = await ethers.getContractFactory("FootiuMM");
    footiuMM = await FootiuMM.deploy(playerPricing.address);
    await footiuMM.deployed();


    DummyPlayer = await ethers.getContractFactory("DummyPlayer");
    dummyPlayer = await DummyPlayer.deploy(owner);
    await dummyPlayer.deployed();


  });

  context("testing dummy NFT contract ", async function () {
    beforeEach(async function () {
      await dummyPlayer.mintWithRandomRating(addr1.address, 2);
    });

    it("should mint a player", async function () {
      // Check if the NFT exists and owner is correct
      const ownerOfNFT = await dummyPlayer.ownerOf(2);
      expect(ownerOfNFT).to.equal(addr1.address);
    })


    it("should have a pseudorandom rating ", async function () {
      const rating_2 = await dummyPlayer.getRating(2);
      expect(rating_2).to.be.within(0, 100);

      await dummyPlayer.mintWithRandomRating(addr1.address, 3);
      const rating_3 = await dummyPlayer.getRating(3);
      expect(rating_3).to.be.within(0, 100);
    });
      
    it("should have locked the NFT", async function () { 
      const ownerOfNFT = await dummyPlayer.ownerOf(2);
      expect(ownerOfNFT).to.equal(addr1.address);

      const rating = await dummyPlayer.getRating(2);
      
      // Approve the FootiuMM contract to transfer the NFT on behalf of addr1
      await dummyPlayer.connect(addr1).approve(footiuMM.address, 2);

      await footiuMM.connect(addr1).lockUpNFT(
        dummyPlayer.address, 
        2, 
        rating
      );
      // Verify that the NFT is locked up
      const lockedNFT = await footiuMM.lockedNFTs(addr1.address);
      expect(lockedNFT.locked).to.be.true;
      //Checking the emitted event 
      expect(lockedNFT)
          .to.emit(footiuMM, 'PlayerLocked')
          .withArgs(addr1.address, dummyPlayer.address, 2);
    });

    it("should prevent the seller transferring the NFT", async function () {
      await dummyPlayer.mintWithRandomRating(addr1.address, 2);
      const rating = await dummyPlayer.getRating(2);
      // Approve the FootiuMM contract to transfer the NFT on behalf of addr1
      await dummyPlayer.connect(addr1).approve(footiuMM.address, 2);

      await footiuMM.connect(addr1).lockUpNFT(
        dummyPlayer.address, 
        2, 
        rating
      );
        await expect(
          dummyPlayer.connect(
            addr1
            ).transferFrom(
              addr1.address, 
              owner.address, 
              2
          ))
          .to.be.revertedWith("ERC721: transfer caller is not owner nor approved");
      });
  });
});