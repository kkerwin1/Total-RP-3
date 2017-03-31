----------------------------------------------------------------------------------
-- Total RP 3
-- Automator equipement sets module
-- ---------------------------------------------------------------------------
-- Copyright 2017 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
----------------------------------------------------------------------------------
local function init()
	
	local pairs, tinsert = pairs, tinsert;
	
	-- WoW API imports
	local GetEquipmentSetIDs = C_EquipmentSet.GetEquipmentSetIDs;
	local GetEquipmentSetInfo = C_EquipmentSet.GetEquipmentSetInfo;

	local function listEquipmentSets()
		local equipmentSets = {};
		for _, equipmentSetID in pairs(GetEquipmentSetIDs()) do
			local name, iconFileID, setID, isEquipped = GetEquipmentSetInfo(equipmentSetID);
			tinsert(equipmentSets, {
				name       = name,
				iconFileID = iconFileID,
				setID      = setID,
				isEquipped = isEquipped
			})
		end
	end
	
	TRP3_API.events.listenToEvent("WEAR_EQUIPMENT_SET", function(setID)
		print("Equipment set", GetEquipmentSetInfo(setID))
	end)
end

TRP3_API.automator.registerModule({
	["name"] = "Equipment sets",
	["description"] = "Adapt your profile when switching equipment sets",
	["id"] = "equipment_sets",
	["init"] = init
});