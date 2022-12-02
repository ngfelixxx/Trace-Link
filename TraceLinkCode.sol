// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "hardhat/console.sol";
 
contract Stakeholder {
 
    address private stakeholderAddr;
    string private stakeholderName;
    //every stakeholder has some drug
    Drug[] private SHdrugs;
    //other metrics
    uint private numDrugs;
 
    //could add function to move stakeholders automatically
    address private manufacturer = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address private wholesaler = 0xc0ffee254729296a45a3885639AC7E10F9d54979;
    address private pharmacist = 0x71C7656EC7ab88b098defB751B7401B5f6d8976F;
    address private patient = 0x0000000000000000000000000000000000000000;
 
    //events and errors for certain events
    event drugTransfer(address indexed oldStakeholder, address indexed newStakeholder);
    error endUserReached(string message);
    error illegalSubstance(string message);
    error tooManyDrugs(string message);
 
    //initalise the smart contract
    constructor() {
        console.log("Stakeholder contract deployed by:", manufacturer);
        stakeholderAddr = manufacturer;
        stakeholderName = "Manufacturer";
        emit drugTransfer(address(0), stakeholderAddr);
        //creates the drug on initiation of contract
        createDrug();
    }
 
    //Changes the stakeholder of the drug
    function changeStakeholder(address newStakeholderAddr) private {
        if(this.safeDrug()){
            //determines stakeolder name
            if(newStakeholderAddr == manufacturer){
                stakeholderName = "Manufacturer";
            } else if(newStakeholderAddr == wholesaler){
                stakeholderName = "Wholesaler";
            } else if(newStakeholderAddr == pharmacist){
                stakeholderName = "Pharmacist";
            } else if(newStakeholderAddr == patient){
                stakeholderName = "Patient";
            }
            emit drugTransfer(stakeholderAddr, newStakeholderAddr);
            //renaming will change the ownership of the drug as we only have one instance
            stakeholderAddr = newStakeholderAddr;
        } else {
            revert illegalSubstance("Thats not allowed!");
        }
    }

    function nextStakeholder() public {
        if(stakeholderAddr == manufacturer){
            changeStakeholder(wholesaler);
        } else if (stakeholderAddr == wholesaler){
            changeStakeholder(pharmacist);
        } else if (stakeholderAddr == pharmacist){
            changeStakeholder(patient);
        } else if (stakeholderAddr == patient){
            revert endUserReached("Patient already has the drug");
        }
    }
 
    //getter for the current stakeholder of the drug
    function getStakeholder() external view returns (address) {
        console.log("Stakeholder is now:", stakeholderName);
        return stakeholderAddr;
    }
 
    //Drug object
    struct Drug {
        string name;
        string ingred;
        uint dos;
        string warn;
        string manufac;
        bool init;
    }
 
    //creates only one drug for now but could be any kind in the world
    mapping (uint => Drug) public Drugs;
    function createDrug() private {
        //pre check for testing demonstration purposes
        if(numDrugs == 1){
            revert tooManyDrugs("One drug at a time is allowed to pass through the supply chain");
        }
        Drug memory d = Drugs[0];
        d.name = "Paracetamol";
        d.ingred = "Acetylation of Para-aminophenol";
        d.dos = 2;
        d.warn = "Out of reach of children";
        d.manufac = "PSM Healthcare";
        d.init = true;
        SHdrugs.push(d);
        numDrugs = 1;
    }
 
    //Only check for the ingredients, other stuff not so important.
    function safeDrug() external view returns (bool) {
        string memory a = SHdrugs[0].ingred;
        string memory b = "Acetylation of Para-aminophenol";
        if(keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b)))){
            return true;
        } else {
            return false;
        }
    }
 
    //changes the ingredients  
    function changeDrug(string memory s) public {
        SHdrugs[0].ingred = s;
    }
 
    //Only mutable for demonstration purposes so ignore warning
    function showDrug() public {
        console.log("Drug Name:", SHdrugs[0].name, " and ingredients include: ", SHdrugs[0].ingred);
    }
 
}