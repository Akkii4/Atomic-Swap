const Token = artifacts.require("Token.sol");
const HashedTimeLocked = artifacts.require("HashedTimeLocked.sol");

module.exports = async function (deployer, network, addresses) {
  const [userA, userB] = addresses;

  if (network === "goerli") {
    await deployer.deploy(Token, "Token A", "TKNA", { from: userA });
    const tokenA = await Token.deployed();
    await deployer.deploy(HashedTimeLocked, userB, tokenA.address, 1000, {
      from: userA,
    });
    const htlc = await HashedTimeLocked.deployed();
    await tokenA.approve(htlc.address, 1000, { from: userA });
    await htlc.deposit({ from: userA });
  }
  if (network === "binanceTestnet") {
    await deployer.deploy(Token, "Token B", "TKNB", { from: userB });
    const tokenB = await Token.deployed();
    await deployer.deploy(HashedTimeLocked, userA, tokenB.address, 500, {
      from: userB,
    });
    const htlc = await HashedTimeLocked.deployed();
    await tokenB.approve(htlc.address, 500, { from: userB });
    await htlc.deposit({ from: userB });
  }
};
