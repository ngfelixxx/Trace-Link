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

    //default drug information 
    string private f_name = "Paracetamol";
    string private f_ingred = "Acetylation of Para-aminophenol";
    uint private f_dos = 2;
    string private f_warn = "Out of reach of children";
    string private f_manufac = "PSM Healthcare";
    bool private f_init = true;
 
    //events and errors for certain events
    event drugTransfer(address indexed oldStakeholder, address indexed newStakeholder);
    error endUserReached(string message); 
    error illegalSubstance(string message);
    error tooManyDrugs(string message);
 
    //initalise the smart contract
    constructor() { 
        //alarms console 
        console.log("Stakeholder contract deployed by:", manufacturer);
        //sets variables 
        stakeholderAddr = manufacturer;
        stakeholderName = "Manufacturer";
        emit drugTransfer(address(0), stakeholderAddr);
        //creates the drug on initiation of contract
        createDrug();
    }

    //functions for setting drug proporties - manufacturers act 
    function setName(string memory s) public {
        f_name = s;
    }
    function setIngredient(string memory s) public {
        f_ingred = s;
    }
    function setDosage(uint i) public {
        f_dos = i;
    }
    function setWarning(string memory s) public {
        f_warn = s;
    }
    function setManufacurer(string memory s) public {
        f_manufac = s;
    }
    function setInitialisated(bool b) public {
        f_init = b;
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
            revert endUserReached("Patient already has the drug, data currently being collected.");
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
    mapping (uint => Drug) private Drugs;
    function createDrug() private {
        //pre check for testing demonstration purposes
        if(numDrugs == 1){
            revert tooManyDrugs("One drug at a time is allowed to pass through the supply chain");
        }
        Drug memory d = Drugs[0];
        d.name = f_name;
        d.ingred = f_ingred;
        d.dos = f_dos;
        d.warn = f_warn;
        d.manufac = f_manufac;
        d.init = f_init;
        SHdrugs.push(d);
        numDrugs = 1;
    }
 
    //Only check for the ingredients, other stuff not so important.
    function safeDrug() external view returns (bool) {
        //name 
        string memory name_a = SHdrugs[0].name;
        string memory name_b = f_name;
        //ingredients
        string memory ingred_a = SHdrugs[0].ingred;
        string memory ingred_b = f_ingred;
        //dosage 
        uint dos_a = SHdrugs[0].dos;
        uint dos_b = f_dos;
        //warning 
        string memory warn_a = SHdrugs[0].warn;
        string memory warn_b = f_warn;
        //manufactuer
        string memory manufac_a = SHdrugs[0].manufac;
        string memory manufac_b = f_manufac;
        //initialisation 
        bool init_a = SHdrugs[0].init;
        bool init_b = f_init;
        if(keccak256(abi.encodePacked((name_a))) == keccak256(abi.encodePacked((name_b)))){
            if(keccak256(abi.encodePacked((ingred_a))) == keccak256(abi.encodePacked((ingred_b)))){
                if(dos_a == dos_b){
                    if(keccak256(abi.encodePacked((warn_a))) == keccak256(abi.encodePacked((warn_b)))){
                        if(keccak256(abi.encodePacked((manufac_a))) == keccak256(abi.encodePacked((manufac_b)))){
                            if(init_a == init_b){
                                console.log("Drug is safe");
                                return true;
                            }
                        }
                    }
                }
            }
        } else {
            console.log("Drug is unsafe!");
            return false;
        }
    }
 
    //functions for changing the proporties of the drug - criminal act 
    function changeName(string memory s) public {
        SHdrugs[0].name = s;
    }
    function changeIngredients(string memory s) public {
        SHdrugs[0].ingred = s;
    }
    function changeDosage(uint i) public {
        SHdrugs[0].dos = i;
    }
    function changeWarning(string memory s) public {
        SHdrugs[0].warn = s;
    }
    function changeManufacturer(string memory s) public {
        SHdrugs[0].manufac = s;
    }
    function changeInitilisation(bool b) public {
        SHdrugs[0].init = b;
    }
 
    //Only mutable for demonstration purposes so ignore warning
    function showDrug() public {
        console.log("Drug Name:", SHdrugs[0].name, ", Ingredients include: ", SHdrugs[0].ingred);
        console.log("Dosage is: ", SHdrugs[0].dos, ", Warnings are: ", SHdrugs[0].warn);
        console.log("Manufacturer is: ", SHdrugs[0].manufac);
    }
 
}
