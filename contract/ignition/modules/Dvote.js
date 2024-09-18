const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("DvoteModule", (m) => {
  const dvoteCoin = m.contract("DvoteCoin");

  const dvoteCandidate = m.contract("DvoteCandidate",[dvoteCoin]);

  const dvote = m.contract("Dvote", [dvoteCoin, dvoteCandidate]);

  return { dvoteCoin, dvoteCandidate, dvote };
});
