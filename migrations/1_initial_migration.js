//2_initial_migration.js
const Proyects = artifacts.require("Proyects"); //Instancia de nuestro contrato CrowdFunding.sol

module.exports = function (deployer) {
  deployer.deploy(Proyects); //Este script hace deploy de nuestro contrato a la blockchain
};