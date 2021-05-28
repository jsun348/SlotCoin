const FreePowerball = artifacts.require("FreePowerball");

contract('FreePowerball', (accounts) => {
  it('should initiate 10000 coins in the contract account', async () => {
    aa = await FreePowerball.deployed();
    balance0 = await aa.balanceOf.call(accounts[0]);

    // print others
    aa.getTotalBalance.call()
    aa.getRewardBalance.call()
    aa.getTotalCirculation.call()


    aa.transfer(accounts[1], 10000);
    aa.transfer(accounts[0], 10000);
    aa.balanceOf.call(accounts[0]);
    aa.balanceOf.call(accounts[1]);
    aa.getCurrentRound.call()
    aa.getAvailabilityForLottery(accounts[0])
    aa.getHistPersonalInfo(accounts[1])
    aa.getTotalCirculation.call()
    aa.getCurrentRandomNumber()
    aa.getWinningProb.call(accounts[0])
    aa.getHistRoundInfo(0)
    aa.transfer(accounts[0], 10000);


    assert.equal(balance.valueOf(), 2 * 10 ** 12 * 10 ** 18, "wrong account");
  });
});
