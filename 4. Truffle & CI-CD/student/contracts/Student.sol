pragma solidity 0.8.13;
import "./node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Student {

    struct Etudiant {
        string nom;
        uint8 note;
    }

    mapping(address => Etudiant) public etudiantsMap;

    Etudiant[] public etudiantsArray;

    function getter

}