// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICongress {
    function stakeholderId(address) external view returns (uint);
    function getStakeholder_Mission(uint s_Id) external view returns (uint);
    function getStakeholdersLength() external view returns (uint);
    function getStakeholder(uint) external view returns (bytes32, uint, uint, bytes32, uint, uint, uint);
}

interface IUsingProperty {
    function getPropertyTypeLength() external view returns (uint);
    function getPropertyType_forMission(uint p_id, uint cropStage) external view returns (bytes32, uint, bytes32);
}

contract GameCore {
    struct Mission {
        uint id;
        bytes32 name;
        uint exp;
        uint lvl_limitation;
        bool[] accountStatus;
        bool missionStatus;
        uint[] cropId;
        uint[] quantity;
    }

    Mission[] public MissionList;
    ICongress public congress;
    IUsingProperty public usingPropertyInstance;

    constructor(address _congressAddress, address _usingPropertyInstanceAddress) {
        congress = ICongress(_congressAddress);
        usingPropertyInstance = IUsingProperty(_usingPropertyInstanceAddress);
        addMission("Mission0", 9999, 9999, false);
    }

    function getPropertyTypeLength() external view returns (uint) {
        return usingPropertyInstance.getPropertyTypeLength();
    }

    function pushMissionAccountStatus() external {
        uint stakeholderLength = congress.getStakeholdersLength();
        for (uint i = 0; i < MissionList.length; i++) {
            while (MissionList[i].accountStatus.length < stakeholderLength) {
                MissionList[i].accountStatus.push(false);
            }
        }
    }

    function addMission(bytes32 _name, uint _exp, uint _lvl_limitation, bool _missionStatus) public {
        uint stakeholderLength = congress.getStakeholdersLength();
        MissionList.push();
        uint _id = MissionList.length - 1;

        Mission storage obj = MissionList[_id];
        obj.id = _id;
        obj.name = _name;
        obj.exp = _exp;
        obj.lvl_limitation = _lvl_limitation;
        obj.missionStatus = _missionStatus;
        obj.accountStatus = new bool[](stakeholderLength);
    }

    function addMissionItem(uint mId, uint _cropId, uint _quantity) external {
        require(mId < MissionList.length, "Invalid mission ID");
        Mission storage obj = MissionList[mId];
        obj.cropId.push(_cropId);
        obj.quantity.push(_quantity);
    }

    function getMission(uint m_Id) external view returns (uint, bytes32, uint, uint, bool) {
        require(m_Id < MissionList.length, "Invalid mission ID");

        uint s_Id = congress.stakeholderId(msg.sender);
        uint user_level = congress.getStakeholder_Mission(s_Id);
        Mission storage obj = MissionList[m_Id];

        if (obj.missionStatus && user_level >= obj.lvl_limitation) {
            return (obj.id, obj.name, obj.exp, obj.lvl_limitation, obj.accountStatus[s_Id]);
        } else {
            return obj.missionStatus ? (999, "lv_limited", 0, 999, true) : (0, "mission close", 0, 999, true);
        }
    }

    function getMissionItemsArray(uint mId) external view returns (uint[] memory, uint[] memory) {
        require(mId < MissionList.length, "Invalid mission ID");
        Mission storage obj = MissionList[mId];
        return (obj.cropId, obj.quantity);
    }

    function getMissionItems(uint mId, uint itemId) external view returns (uint, bytes32, uint, bytes32) {
        require(mId < MissionList.length, "Invalid mission ID");
        Mission storage obj = MissionList[mId];
        require(itemId < obj.cropId.length, "Invalid item ID");
        
        (bytes32 name, uint id, bytes32 img) = usingPropertyInstance.getPropertyType_forMission(obj.cropId[itemId], 3);
        return (obj.cropId[itemId], name, obj.quantity[itemId], img);
    }

    function getMissionsLength() external view returns (uint) {
        return MissionList.length;
    }

    function getMissionItemsLength(uint mId) external view returns (uint) {
        require(mId < MissionList.length, "Invalid mission ID");
        return MissionList[mId].cropId.length;
    }

    function submitMission(uint mId) external {
        require(mId < MissionList.length, "Invalid mission ID");
        uint s_Id = congress.stakeholderId(msg.sender);
        MissionList[mId].accountStatus[s_Id] = true;
    }
}
