----------------------------------------------------------------------------------
--- Total RP 3
---
--- World map data provider
---	---------------------------------------------------------------------------
--- Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
---	Licensed under the Apache License, Version 2.0 (the "License");
---	you may not use this file except in compliance with the License.
---	You may obtain a copy of the License at
---
---		http://www.apache.org/licenses/LICENSE-2.0
---
---	Unless required by applicable law or agreed to in writing, software
---	distributed under the License is distributed on an "AS IS" BASIS,
---	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
---	See the License for the specific language governing permissions and
---	limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

-- This is the name of the template as defined in the XML file
local MAP_PIN_TEMPLATE = "TRP3_MapPinTemplate";

---@type MapCanvasDataProviderMixin|{GetMap:fun():MapCanvasMixin}
TRP3_MapDataProviderMixin = CreateFromMixins(MapCanvasDataProviderMixin);

function TRP3_MapDataProviderMixin:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(MAP_PIN_TEMPLATE);
end

function TRP3_MapDataProviderMixin:RefreshAllData(structure)
	self:RemoveAllData();

	if not structure then return
	self:GetMap():RemovePin()
	end

	for key, entry in pairs(structure.saveStructure) do
		local marker = self:GetMap():AcquirePin(MAP_PIN_TEMPLATE, entry);

		if structure.scanMarkerDecorator then
			structure.scanMarkerDecorator(key, entry, marker);
		end

		TRP3_API.map.decorateMarker(marker, TRP3_API.map.DECORATION_TYPES.CHARACTER);
		TRP3_API.map.animateMarker(marker, entry.x, entry.y, structure.noAnim);
	end
end

function TRP3_MapDataProviderMixin:OnEvent(event, ...)
	if event == "TRP3_MARKERS_UPDATED" then
		self:RefreshAllData(...);
	end

end

-- Create the pin template, above group members
TRP3_MapPinMixin = BaseMapPoiPinMixin:CreateSubPin("PIN_FRAME_LEVEL_VEHICLE_ABOVE_GROUP_MEMBER");

---@type TRP3_MapDataProviderMixin|MapCanvasDataProviderMixin|{GetMap:fun():MapCanvasMixin}
TRP3_API.MapDataProvider = CreateFromMixins(TRP3_MapDataProviderMixin);


TestWorldMapFrame:AddDataProvider(TRP3_API.MapDataProvider);