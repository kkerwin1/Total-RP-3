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
local Ellyb = Ellyb(...);

-- This is the name of the template as defined in the XML file
local MAP_PIN_TEMPLATE = "TRP3_PlayerMapPinTemplate";

---@type MapCanvasDataProviderMixin|{GetMap:fun():MapCanvasMixin}
TRP3_MapDataProviderMixin = CreateFromMixins(MapCanvasDataProviderMixin);

function TRP3_MapDataProviderMixin:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(MAP_PIN_TEMPLATE);
end

function TRP3_MapDataProviderMixin:RefreshAllData(fromOnShow, ...)
	self:RemoveAllData();

	if not self.data then return end

	for _, POIInfo in pairs(self.data) do
		self:GetMap():AcquirePin(self.pinTemplate, POIInfo);
	end

end

function TRP3_MapDataProviderMixin:OnScan(data, pinTemplate)
	self.data = data;
	self.pinTemplate = pinTemplate;
	self:RefreshAllData();
end

function TRP3_MapDataProviderMixin:OnMapChanged()
	self.data = nil;
	self:RefreshAllData();
end

-- Create the pin template, above group members
---@type BaseMapPoiPinMixin|MapCanvasPinMixin|{GetMap:fun():MapCanvasMixin}
TRP3_PlayerMapPinMixin = BaseMapPoiPinMixin:CreateSubPin("PIN_FRAME_LEVEL_VEHICLE_ABOVE_GROUP_MEMBER");

local MAX_DISTANCE_MARKER = math.sqrt(0.5 * 0.5 + 0.5 * 0.5);

---@param poiInfo {position:Vector2DMixin}
function TRP3_PlayerMapPinMixin:OnAcquired(poiInfo)
	poiInfo.atlasName = "RaidMember";
	BaseMapPoiPinMixin.OnAcquired(self, poiInfo);

	self.Texture:SetSize(16, 16);
	self:SetSize(16, 16);
	Ellyb.Tooltips.getTooltip(self):ClearLines():SetTitle("Players")

	local x, y= poiInfo.position:GetXY();
	local distanceX = 0.5 - x;
	local distanceY = 0.5 - y;
	local distance = math.sqrt(distanceX * distanceX + distanceY * distanceY);
	local factor = distance/MAX_DISTANCE_MARKER;

	self:Hide();
	C_Timer.After(factor, function()
		self:Show();
		TRP3_API.ui.misc.playAnimation(self.Bounce);
	end);
end

function TRP3_PlayerMapPinMixin:OnMouseEnter()

	local tooltip = Ellyb.Tooltips.getTooltip(self)
	-- Iterate over the blips in a first pass to build a list of all the
	-- ones we're mousing over.
	for marker in self:GetMap():EnumerateAllPins() do
		if marker:IsVisible() and marker:IsMouseOver() then
			tooltip:AddTempLine(marker.name);
		end
	end

	tooltip:Show();

end

TRP3_API.MapDataProvider = TRP3_MapDataProviderMixin;

WorldMapFrame:AddDataProvider(TRP3_MapDataProviderMixin);