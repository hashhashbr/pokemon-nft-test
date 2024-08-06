// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract PokemonNFT is ERC721 {
    struct Pokemon {
        string name;
        uint256 level;
        string img;
    }

    Pokemon[] public pokemons;
    address public gameOwner;

    constructor() ERC721("PokemonNFT", "PKNFT") {
        gameOwner = msg.sender;
    }

    modifier onlyOwnerOf(uint256 _monsterId) {
        require(
            ownerOf(_monsterId) == msg.sender,
            "Apenas o dono pode batalhar com este Pokemon"
        );
        _;
    }

    function battle(uint _attackingPokemon, uint  _defendingPokemon) public 
        onlyOwnerOf(_attackingPokemon)
    {
        Pokemon storage attacker = pokemons[_attackingPokemon];
        Pokemon storage defender = pokemons[_defendingPokemon];


        if(attacker.level >= defender.level){
            attacker.level += 2;
            defender.level += 1;
        }else{
            attacker.level += 1;
            attacker.level += 2;
        }
    }

    function createNewPokemon(string memory _name, address _to, string memory _img)public  {
        require(msg.sender == gameOwner, "Apenas o dono do jogo pode criar novos Pokemons");
        uint id = pokemons.length;
        pokemons.push(Pokemon(_name, 1, _img));
        _safeMint(_to, id);
    }
}
