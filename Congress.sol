// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract Congress {
    struct Stakeholder {
        uint256 id;
        address addr;
        uint256 since;
        uint256 farmerLevel;
        uint256 propertyIndex;
    }

    struct StakeholderGameData {
        bytes32 name;
        bytes32 character;
        uint256 exp;
        uint256 totalExp;
        uint256 landSize;
        uint256 level;
        uint256 stamina;
        uint256 guardId;
        uint256[] thiefId;
        uint256 propertyCount;
        uint256[] propertyId;
        bytes32 lastLogin;
        uint256[] matchesId;
    }

    struct Syndicate {
        uint256 id;
        uint256 progress;
        uint256 exp;
        uint256 totalExp;
        uint256 level;
        int256 success;
        int256 fail;
        bytes32 character;
        int256 guardMatchId;
        uint256 guardFarmerId;
    }

    mapping(address => uint256) public stakeholderId;
    Stakeholder[] public stakeholders;
    StakeholderGameData[] public stakeholdersGameData;
    Syndicate[] public syndicateData;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function getStakeholdersLength() external view returns (uint256) {
        return stakeholders.length;
    }

    function getStakeholder(uint256 s_Id)
        external
        view
        returns (
            bytes32,
            uint256,
            uint256,
            bytes32,
            uint256,
            uint256,
            uint256
        )
    {
        StakeholderGameData storage data = stakeholdersGameData[s_Id];
        return (
            data.name,
            data.exp,
            data.totalExp,
            data.character,
            data.landSize,
            data.level,
            data.stamina
        );
    }

    function getStakeholderRank()
        external
        view
        returns (
            bytes32[] memory,
            address[] memory,
            uint256[] memory
        )
    {
        uint256 length = stakeholdersGameData.length;
        bytes32[] memory stakeholderName = new bytes32[](length);
        address[] memory stakeholderAddress = new address[](length);
        uint256[] memory stakeholderLevel = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            stakeholderName[i] = stakeholdersGameData[i].name;
            stakeholderAddress[i] = stakeholders[i].addr;
            stakeholderLevel[i] = stakeholdersGameData[i].level;
        }

        return (stakeholderName, stakeholderAddress, stakeholderLevel);
    }

    function getStakeholderAddr(uint256 s_Id) external view returns (address) {
        return stakeholders[s_Id].addr;
    }

    function getStakeholderMatches(uint256 s_Id)
        external
        view
        returns (uint256[] memory)
    {
        return stakeholdersGameData[s_Id].matchesId;
    }

    function getStakeholderLastLogin(uint256 s_Id)
        external
        view
        returns (bytes32)
    {
        return stakeholdersGameData[s_Id].lastLogin;
    }

    function getStakeholder_Mission(uint256 s_Id)
        external
        view
        returns (uint256)
    {
        return stakeholdersGameData[s_Id].level;
    }

    function getPropertyList(uint256 s_Id)
        external
        view
        returns (uint256[] memory)
    {
        return stakeholdersGameData[s_Id].propertyId;
    }

    function getPropertyId(uint256 s_Id, uint256 index)
        external
        view
        returns (uint256)
    {
        return stakeholdersGameData[s_Id].propertyId[index];
    }

    function getStakeholderPropertyCount(uint256 s_Id)
        external
        view
        returns (uint256)
    {
        return stakeholdersGameData[s_Id].propertyCount;
    }

    function addProperty(uint256 _id, uint256 p_Id) external {
        stakeholdersGameData[_id].propertyCount++;
        stakeholdersGameData[_id].propertyId.push(p_Id);
    }

    function addMember() external {
        address targetStakeholder = msg.sender;
        if (stakeholderId[targetStakeholder] == 0) {
            uint256 id = stakeholders.length;
            stakeholderId[targetStakeholder] = id;
            stakeholders.push(
                Stakeholder(id, targetStakeholder, block.timestamp, 0, 0)
            );
        }
    }

    function getPropertyIndex(uint256 u_Id) external view returns (uint256) {
        return stakeholders[u_Id].propertyIndex;
    }

    function setPropertyIndex(uint256 u_Id, uint256 _index) external {
        stakeholders[u_Id].propertyIndex = _index;
    }

    function initPlayerData(bytes32 _name, bytes32 _character) external {
        uint256 _id = stakeholdersGameData.length;
        stakeholdersGameData.push(
            StakeholderGameData(
                _name,
                _character,
                0,
                0,
                3,
                0,
                100,
                0,
                new uint256[](0),
                0,
                new uint256[](0),
                0,
                new uint256[](0)
            )
        );

        initSyndicateData(_character);
    }

    function updateGuardId(uint256 s_Id, uint256 g_Id) external {
        stakeholdersGameData[s_Id].guardId = g_Id;
    }

    function getGuardId(uint256 s_Id) external view returns (uint256) {
        return stakeholdersGameData[s_Id].guardId;
    }

    function initSyndicateData(bytes32 _character) internal {
        uint256 _id = syndicateData.length;
        syndicateData.push(
            Syndicate(
                _id,
                0,
                0,
                0,
                1,
                0,
                0,
                _character,
                -1,
                0
            )
        );
    }

    function updateFarmerId(uint256 s_Id, uint256 g_Id) external {
        syndicateData[s_Id].guardFarmerId = g_Id;
    }

    function getFarmerId(uint256 s_Id) external view returns (uint256) {
        return syndicateData[s_Id].guardFarmerId;
    }

    function getSyndicateData(uint256 u_Id)
        external
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        Syndicate storage data = syndicateData[u_Id];
        return (data.exp, data.totalExp, data.level);
    }

    function getGuardReqInfo(uint256 u_Id)
        external
        view
        returns (uint256, uint256)
    {
        Syndicate storage data = syndicateData[u_Id];
        return (data.guardFarmerId, data.progress);
    }

    function updateUserExp(uint256 u_Id, uint256 exp) external {
        StakeholderGameData storage data = stakeholdersGameData
::contentReference[oaicite:0]{index=0}
     function updateUserExp(uint256 u_Id, uint256 exp) external {
        StakeholderGameData storage data = stakeholdersGameData[u_Id];
        data.exp = exp;
        data.totalExp += exp;
    }

    function updateSyndicateExp(uint256 u_Id, uint256 exp, uint256 level) external {
        Syndicate storage data = syndicateData[u_Id];
        data.exp = exp;
        data.totalExp += exp;
        data.level = level;
    }

    function updateStealRecord(uint256 u_Id, bool result) external {
        Syndicate storage data = syndicateData[u_Id];
        if (result) {
            data.success += 1;
        } else {
            data.fail += 1;
        }
    }

    function updateSyndicateProgress(uint256 u_Id, uint256 progress) external {
        syndicateData[u_Id].progress = progress;
    }

    function updateGuardMatchId(uint256 u_Id, int256 g_Id) external {
        syndicateData[u_Id].guardMatchId = g_Id;
    }

    function getGuardMatchId(uint256 u_Id) external view returns (int256) {
        return syndicateData[u_Id].guardMatchId;
    }

    function updateUserStamina(uint256 u_Id, uint256 sta) external {
        stakeholdersGameData[u_Id].stamina = sta;
    }

    function updateStakeholderLastLogin(uint256 u_Id, bytes32 _lastLogin) external {
        stakeholdersGameData[u_Id].lastLogin = _lastLogin;
    }

    function updateGameData(uint256 u_Id, uint256 _landSize, uint256 _level) external {
        StakeholderGameData storage data = stakeholdersGameData[u_Id];
        data.landSize = _landSize;
        data.level = _level;
    }

    function insertMatchesId(uint256 s_Id, uint256 m_Id) external {
        stakeholdersGameData[s_Id].matchesId.push(m_Id);
    }

    function deleteMatchesId(uint256 s_Id, uint256 m_Id) external {
        StakeholderGameData storage data = stakeholdersGameData[s_Id];
        uint256 length = data.matchesId.length;
        for (uint256 i = m_Id; i < length - 1; i++) {
            data.matchesId[i] = data.matchesId[i + 1];
        }
        data.matchesId.pop();
    }

    function removeStakeholder(address targetStakeholder) external {
        uint256 id = stakeholderId[targetStakeholder];
        require(id != 0, "Stakeholder does not exist");

        uint256 length = stakeholders.length;
        for (uint256 i = id; i < length - 1; i++) {
            stakeholders[i] = stakeholders[i + 1];
            stakeholderId[stakeholders[i].addr] = i;
        }
        stakeholders.pop();
        delete stakeholderId[targetStakeholder];
    }
}

