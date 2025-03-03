// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICongress {
    function getStakeholder(uint u_Id) external view returns(bytes32, uint, uint, bytes32, uint, uint, uint);
    function updateGameData(uint u_Id, uint landSize, uint level) external;
    function addMember() external;
    function initPlayerData(bytes32 _name, bytes32 _character) external;
}

interface IUsingProperty {
    function addUserPropertyType(uint u_Id, uint p_Id) external;
}

interface IGameProperty {
    function addUserLandConfiguration(uint u_Id, uint landSize) external;
}

contract PlayerSetting {
    ICongress public congress;
    IUsingProperty public property;
    IGameProperty public gameProperty;

    uint public unlockCropNum = 3;
    uint public unlockCropLevel = 5;

    constructor(address _congressAddress, address _usingPropertyInstanceAddress, address _gamePropertyAddress) {
        require(_congressAddress != address(0), "Invalid Congress address");
        require(_usingPropertyInstanceAddress != address(0), "Invalid Property address");
        require(_gamePropertyAddress != address(0), "Invalid GameProperty address");
        
        congress = ICongress(_congressAddress);
        property = IUsingProperty(_usingPropertyInstanceAddress);
        gameProperty = IGameProperty(_gamePropertyAddress);

        congress.addMember();
        initGameData(0, "Moderator", "guard");
    }

    function levelCap(uint _level) public pure returns(uint) {
        return (2 ** _level) * 100;
    }

    function playerLevelUp(uint u_Id, uint random) public {
        (
            bytes32 name, 
            uint exp, 
            uint totalExp, 
            bytes32 character, 
            uint landSize, 
            uint level, 
            uint stamina
        ) = congress.getStakeholder(u_Id);

        level += 1;
        if (level % 5 == 0) {
            landSize += 1;
            uint p_Id = random + ((level / unlockCropLevel) * unlockCropNum);
            property.addUserPropertyType(u_Id, p_Id);
            gameProperty.addUserLandConfiguration(u_Id, landSize);
        }
        congress.updateGameData(u_Id, landSize, level);
    }

    function initGameData(uint s_Id, bytes32 _name, bytes32 _character) public {
        congress.initPlayerData(_name, _character);
        gameProperty.addUserLandConfiguration(s_Id, 3);
    }
}
