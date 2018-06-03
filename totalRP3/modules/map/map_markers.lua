----------------------------------------------------------------------------------
-- Total RP 3
-- Map marker and coordinates system
--	---------------------------------------------------------------------------
--	Copyright 2014 Sylvain Cossement (telkostrasz@telkostrasz.be)
--
--	Licensed under the Apache License, Version 2.0 (the "License");
--	you may not use this file except in compliance with the License.
--	You may obtain a copy of the License at
--
--		http://www.apache.org/licenses/LICENSE-2.0
--
--	Unless required by applicable law or agreed to in writing, software
--	distributed under the License is distributed on an "AS IS" BASIS,
--	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--	See the License for the specific language governing permissions and
--	limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local _, TRP3_API = ...;

TRP3_API.map = {};

-- Ellyb imports
local YELLOW = TRP3_API.Ellyb.ColorManager.YELLOW;

local Ellyb = TRP3_API.Ellyb;
local Utils, Events, Globals = TRP3_API.utils, TRP3_API.events, TRP3_API.globals;
local Comm = TRP3_API.communication;
local setupIconButton = TRP3_API.ui.frame.setupIconButton;
local displayDropDown = TRP3_API.ui.listbox.displayDropDown;
local loc = TRP3_API.loc;
local tinsert, assert, tonumber, pairs, _G, wipe = tinsert, assert, tonumber, pairs, _G, wipe;
local CreateFrame = CreateFrame;
local after = C_Timer.After;
local playAnimation = TRP3_API.ui.misc.playAnimation;
local getConfigValue = TRP3_API.configuration.getValue;

-- Ellyb Imports.
local Color = Ellyb.Color;

local CONFIG_UI_ANIMATIONS = "ui_animations";

---@type Frame
local TRP3_ScanLoaderFrame = TRP3_ScanLoaderFrame;


local MAP_PLAYER_SCAN_FAKE_DATA =  {
		["Reÿner-KirinTor"] = {
			["y"] = "0.60678493976593",
			["x"] = "0.50766050815582",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Elmerin-KirinTor"] = {
			["y"] = "0.3834725022316",
			["x"] = "0.61304694414139",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Pennie-KirinTor"] = {
			["y"] = "0.54757648706436",
			["x"] = "0.51022660732269",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Isuríth-KirinTor"] = {
			["y"] = "0.41543352603912",
			["x"] = "0.49844843149185",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Blâck-KirinTor"] = {
			["y"] = "0.556685090065",
			["x"] = "0.53704488277435",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Arnaryl-KirinTor"] = {
			["y"] = "0.66763138771057",
			["x"] = "0.51786541938782",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Kwanlin-KirinTor"] = {
			["y"] = "0.49703234434128",
			["x"] = "0.40575069189072",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Turin-KirinTor"] = {
			["y"] = "0.36676359176636",
			["x"] = "0.60277342796326",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Theorode-KirinTor"] = {
			["y"] = "0.64680576324463",
			["x"] = "0.4408170580864",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Kragondamos-KirinTor"] = {
			["y"] = "0.55116212368011",
			["x"] = "0.53862798213959",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Emerîc-KirinTor"] = {
			["y"] = "0.5673896074295",
			["x"] = "0.6110874414444",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Fens-KirinTor"] = {
			["y"] = "0.66889435052872",
			["x"] = "0.41254568099976",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Sinn-KirinTor"] = {
			["y"] = "0.14970761537552",
			["x"] = "0.57783901691437",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Ethaldreï-KirinTor"] = {
			["y"] = "0.55946469306946",
			["x"] = "0.53822684288025",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Théssa-KirinTor"] = {
			["y"] = "0.73487943410873",
			["x"] = "0.61616134643555",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Amadriell-KirinTor"] = {
			["y"] = "0.46248984336853",
			["x"] = "0.55367183685303",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Cøuleuvre-KirinTor"] = {
			["y"] = "0.54584395885468",
			["x"] = "0.54839766025543",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Demiora-KirinTor"] = {
			["y"] = "0.51580685377121",
			["x"] = "0.5506774187088",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Gahïsha-KirinTor"] = {
			["y"] = "0.5024516582489",
			["x"] = "0.59479212760925",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Mëgan-KirinTor"] = {
			["y"] = "0.68937945365906",
			["x"] = "0.48209416866302",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Raysia-KirinTor"] = {
			["y"] = "0.52907431125641",
			["x"] = "0.48840838670731",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Ïwar-KirinTor"] = {
			["y"] = "0.44089359045029",
			["x"] = "0.21403139829636",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Alicenzâh-KirinTor"] = {
			["y"] = "0.46876484155655",
			["x"] = "0.67261040210724",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Rebëca-KirinTor"] = {
			["y"] = "0.63509458303452",
			["x"] = "0.42925941944122",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Soldian-KirinTor"] = {
			["y"] = "0.55404794216156",
			["x"] = "0.53767573833466",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Aërius-KirinTor"] = {
			["y"] = "0.71858865022659",
			["x"] = "0.61503678560257",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Crocmaïs-KirinTor"] = {
			["y"] = "0.45551425218582",
			["x"] = "0.49850684404373",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Welkîn-KirinTor"] = {
			["y"] = "0.30851542949677",
			["x"] = "0.65353715419769",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Fenraë-KirinTor"] = {
			["y"] = "0.33015382289886",
			["x"] = "0.2127690911293",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Fåûve-KirinTor"] = {
			["y"] = "0.48705542087555",
			["x"] = "0.62864226102829",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Synrion-KirinTor"] = {
			["y"] = "0.54267483949661",
			["x"] = "0.53812497854233",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Reed-KirinTor"] = {
			["y"] = "0.62574738264084",
			["x"] = "0.4617692232132",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Êlenwë-KirinTor"] = {
			["y"] = "0.5440456867218",
			["x"] = "0.50891488790512",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Skÿrion-KirinTor"] = {
			["y"] = "0.56983542442322",
			["x"] = "0.55313539505005",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Jarvis-KirinTor"] = {
			["y"] = "0.47200226783752",
			["x"] = "0.67596989870071",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Reîner-KirinTor"] = {
			["y"] = "0.48638767004013",
			["x"] = "0.62824153900146",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Geurius-KirinTor"] = {
			["y"] = "0.63808161020279",
			["x"] = "0.45860457420349",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Shaanary-KirinTor"] = {
			["y"] = "0.73677968978882",
			["x"] = "0.61992514133453",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Anath-KirinTor"] = {
			["y"] = "0.54692983627319",
			["x"] = "0.51086533069611",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Agero-KirinTor"] = {
			["y"] = "0.04039853811264",
			["x"] = "0.18749862909317",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Mänäe-KirinTor"] = {
			["y"] = "0.5562652349472",
			["x"] = "0.53854978084564",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Winea-KirinTor"] = {
			["y"] = "0.55368793010712",
			["x"] = "0.53637450933456",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Sélinà-KirinTor"] = {
			["y"] = "0.55717158317566",
			["x"] = "0.53466963768005",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Anïs-KirinTor"] = {
			["y"] = "0.69055640697479",
			["x"] = "0.48140722513199",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Wynchester-KirinTor"] = {
			["y"] = "0.2451953291893",
			["x"] = "0.60007554292679",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Cid-KirinTor"] = {
			["y"] = "0.4674808382988",
			["x"] = "0.67281079292297",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Ludivïne-KirinTor"] = {
			["y"] = "0.64550995826721",
			["x"] = "0.5912150144577",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Markal-KirinTor"] = {
			["y"] = "0.70887553691864",
			["x"] = "0.61279499530792",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Lucrézia-KirinTor"] = {
			["y"] = "0.57613229751587",
			["x"] = "0.56595313549042",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Violettë-KirinTor"] = {
			["y"] = "0.43863159418106",
			["x"] = "0.55039596557617",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Oursage-KirinTor"] = {
			["y"] = "0.36587750911713",
			["x"] = "0.60468745231628",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Nidhal-KirinTor"] = {
			["y"] = "0.82513999938965",
			["x"] = "0.4116068482399",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Gâbrielle-KirinTor"] = {
			["y"] = "0.54451274871826",
			["x"] = "0.5085254907608",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Lanae-KirinTor"] = {
			["y"] = "0.4128857254982",
			["x"] = "0.49959033727646",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Gentilhomme-KirinTor"] = {
			["y"] = "0.6873265504837",
			["x"] = "0.6393256187439",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Thendar-KirinTor"] = {
			["y"] = "0.58764708042145",
			["x"] = "0.57876652479172",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Blumwald-KirinTor"] = {
			["y"] = "0.41571509838104",
			["x"] = "0.49922144412994",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Ykin-KirinTor"] = {
			["y"] = "0.65036273002625",
			["x"] = "0.61728602647781",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Elarielle-KirinTor"] = {
			["y"] = "0.777399122715",
			["x"] = "0.62649613618851",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Vaalar-KirinTor"] = {
			["y"] = "0.55474007129669",
			["x"] = "0.53483647108078",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Lysange-KirinTor"] = {
			["y"] = "0.44195753335953",
			["x"] = "0.43777847290039",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Dàllis-KirinTor"] = {
			["y"] = "0.57740449905396",
			["x"] = "0.56742715835571",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Khassim-KirinTor"] = {
			["y"] = "0.43915265798569",
			["x"] = "0.43781077861786",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Jayed-KirinTor"] = {
			["y"] = "0.5641176700592",
			["x"] = "0.53366088867188",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Rôan-KirinTor"] = {
			["y"] = "0.55791765451431",
			["x"] = "0.53596603870392",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
		["Uldarieth-KirinTor"] = {
			["y"] = "0.67988133430481",
			["x"] = "0.62811863422394",
			["mapId"] = "301",
			["addon"] = "TRP3",
		},
}

local formattedData = {}
for name, data in pairs(MAP_PLAYER_SCAN_FAKE_DATA) do
	table.insert(formattedData, {
		name = name,
		position = CreateVector2D(data.x, data.y);
	})
end
MAP_PLAYER_SCAN_FAKE_DATA = formattedData

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Utils
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local GetPlayerMapPosition = GetPlayerMapPosition;
local GetCurrentMapAreaID = GetCurrentMapAreaID;

function TRP3_API.map.getCurrentCoordinates()
	return 0, 0, 0;
	--[[
	TODO FIX ME
	local mapID = GetCurrentMapAreaID();
	local x, y = GetPlayerMapPosition("player");
	return mapID, x, y;]]
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Marker logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
---@type GameTooltip
local WorldMapTooltip = WorldMapTooltip
local WorldMapPOIFrame = WorldMapPOIFrame;
local MARKER_NAME_PREFIX = "TRP3_WordMapMarker";

local MAX_DISTANCE_MARKER = math.sqrt(0.5 * 0.5 + 0.5 * 0.5);

--- TOOLTIP_CATEGORY_TEXT_COLOR is the text color used for category headers
--  in the displayed tooltip.
local TOOLTIP_CATEGORY_TEXT_COLOR = Color.CreateFromRGBAAsBytes(255, 209, 0);

--- TOOLTIP_CATEGORY_SEPARATOR is a texture string displayed as a separator.
local TOOLTIP_CATEGORY_SEPARATOR =
	[[|TInterface\Common\UI-TooltipDivider-Transparent:8:128:0:0:8:8:0:128:0:8:255:255:255|t]];

local function hideAllMarkers()
	local i = 1;
	while(_G[MARKER_NAME_PREFIX .. i]) do
		local marker = _G[MARKER_NAME_PREFIX .. i];
		marker:Hide();
		marker.scanLine = nil;
		i = i + 1;
	end
end

--- Temporary table used by writeMarkerTooltipLines when it queries the marker
--  list for widgets currently under the mouse cursor.
local markerTooltipEntries = {};

--- Custom sorting function that compares entries. The resulting order is
--  in order of their category priority (descending), or if equal, their
--  sortable name equivalent (ascending).
local function sortMarkerEntries(a, b)
	local categoryA = a.categoryPriority or -math.huge;
	local categoryB = b.categoryPriority or -math.huge;

	local nameA = a.sortName or "";
	local nameB = b.sortName or "";

	return (categoryA > categoryB)
		or (categoryA == categoryB and nameA < nameB);
end

--- Writes the required lines for a world map marker tooltip based on the
--  current location of the cursor.
local function writeMarkerTooltipLines(tooltip)
	-- Iterate over the blips in a first pass to build a list of all the
	-- ones we're mousing over.
	local index = 1;
	while(_G[MARKER_NAME_PREFIX .. index]) do
		local marker = _G[MARKER_NAME_PREFIX .. index];
		if marker:IsVisible() and marker:IsMouseOver() then
			tinsert(markerTooltipEntries, marker);
		end
		index = index + 1;
	end

	-- Sort the entries prior to display.
	table.sort(markerTooltipEntries, sortMarkerEntries);

	-- Tracking variable for our last category inserted into the tip.
	-- If it changes we'll stick in a separator.
	local lastCategory = nil;

	-- This layout will put the category status text above entries
	-- when the type changes. Requires the entries be sorted by category.
	for i = 1, #markerTooltipEntries do
		local marker = markerTooltipEntries[i];
		if marker.categoryName ~= lastCategory then
			-- If the previous category was nil we assume this is
			-- the first, so we'll not put a separating border in.
			if lastCategory ~= nil then
				tooltip:AddLine(TOOLTIP_CATEGORY_SEPARATOR, 1, 1, 1);
			end

			tooltip:AddLine(marker.categoryName or "", TOOLTIP_CATEGORY_TEXT_COLOR:GetRGB());
			lastCategory = marker.categoryName;
		end

		tooltip:AddLine(marker.scanLine or "", 1, 1, 1);

		-- Wipe the table as we go.
		markerTooltipEntries[i] = nil;
	end
end

local function getMarker(i, tooltip)
	---@type Frame
	local marker = _G[MARKER_NAME_PREFIX .. i];

	if not marker then
		marker = CreateFrame("Frame", MARKER_NAME_PREFIX .. i, WorldMapButton, "TRP3_WorldMapUnit");
		marker:SetScript("OnEnter", function(self)
			WorldMapPOIFrame.allowBlobTooltip = false;

			WorldMapTooltip:Hide();
			WorldMapTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0);
			WorldMapTooltip:AddLine(self.tooltip, 1, 1, 1, true);

			writeMarkerTooltipLines(WorldMapTooltip);

			WorldMapTooltip:Show();
		end);
		marker:SetScript("OnLeave", function()
			WorldMapPOIFrame.allowBlobTooltip = true;
			WorldMapTooltip:Hide();
		end);
	end
	marker.tooltip = YELLOW(tooltip or "");
	return marker;
end

---@param marker Frame
---@param x nubmer
---@param y number
local function placeMarker(marker, x, y)
	x = (x or 0) * WorldMapDetailFrame:GetWidth();
	y = - (y or 0) * WorldMapDetailFrame:GetHeight();
	marker:ClearAllPoints();
	marker:SetPoint("CENTER", "WorldMapDetailFrame", "TOPLEFT", x, y);
end

local function animateMarker(marker, x, y, directAnimation)
	if getConfigValue(CONFIG_UI_ANIMATIONS) then

		local distanceX = 0.5 - x;
		local distanceY = 0.5 - y;
		local distance = math.sqrt(distanceX * distanceX + distanceY * distanceY);
		local factor = distance/MAX_DISTANCE_MARKER;

		if not directAnimation then
			after(4 * factor, function()
				marker:Show();
				marker:SetAlpha(0);
				playAnimation(marker.Bounce);
			end);
		else
			marker:Show();
			marker:SetAlpha(0);
			playAnimation(marker.Bounce);
		end
	else
		-- The default alpha on the widget is zero, so need to change it here.
		marker:SetAlpha(1);
		marker:Show();
	end
end
TRP3_API.map.animateMarker = animateMarker;

local DECORATION_TYPES = {
	HOUSE = "house",
	CHARACTER = "character"
};
TRP3_API.map.DECORATION_TYPES = DECORATION_TYPES;

local function decorateMarker(marker, decorationType)
	-- Custom atlases on the marker take priority; after that we'll fall
	-- back to given decoration types.
	if marker.iconAtlas then
		marker.Icon:SetAtlas(marker.iconAtlas);
	elseif not decorationType or decorationType == DECORATION_TYPES.CHARACTER then
		marker.Icon:SetAtlas("PartyMember");
	elseif decorationType == DECORATION_TYPES.HOUSE then
		marker.Icon:SetAtlas("poi-town");
	end

	-- Set a custom vertex color on the atlas or reset it to normal if not
	-- explicitly overridden.
	if marker.iconColor then
		marker.Icon:SetVertexColor(marker.iconColor:GetRGBA());
	else
		marker.Icon:SetVertexColor(1, 1, 1, 1);
	end

	-- Change the draw layer if requested.
	local layer = marker.Icon:GetDrawLayer();
	marker.Icon:SetDrawLayer(layer, marker.iconSublevel or 0);
end
TRP3_API.map.decorateMarker = decorateMarker;

---@param structure table
local function displayMarkers(structure)
	if not WorldMapFrame:IsVisible() then
		return;
	end

	local i = 1;
	for key, entry in pairs(structure.saveStructure) do
		local marker = getMarker(i, structure.scanTitle);

		-- Implementation can be adapted by decorator.
		--
		-- Do this before the rest so the decorators have more control over
		-- the resulting display.
		if structure.scanMarkerDecorator then
			structure.scanMarkerDecorator(key, entry, marker);
		end

		placeMarker(marker, entry.x, entry.y);
		decorateMarker(marker, DECORATION_TYPES.CHARACTER);
		animateMarker(marker, entry.x, entry.y, structure.noAnim);

		i = i + 1;
	end
end

function TRP3_API.map.placeSingleMarker(x, y, tooltip, decorationType)
	hideAllMarkers();
	local marker = getMarker(1, tooltip);
	placeMarker(marker, x, y);
	animateMarker(marker, x, y, true);
	decorateMarker(marker, decorationType);
end

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Scan logic
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

local SCAN_STRUCTURES = {};
local currentMapID;
local launchScan;

local function registerScan(structure)
	assert(structure and structure.id, "Must have a structure and a structure.id!");
	SCAN_STRUCTURES[structure.id] = structure;
	if structure.scanResponder and structure.scanCommand then
		Comm.broadcast.registerCommand(structure.scanCommand, structure.scanResponder);
	end
	if not structure.saveStructure then
		structure.saveStructure = {};
	end
	if structure.scanAssembler and structure.scanCommand then
		Comm.broadcast.registerP2PCommand(structure.scanCommand, function(...)
			structure.scanAssembler(structure.saveStructure, ...);
		end)
	end
end
TRP3_API.map.registerScan = registerScan;

function launchScan(scanID)
	assert(SCAN_STRUCTURES[scanID], ("Unknown scan id %s"):format(scanID));
	local structure = SCAN_STRUCTURES[scanID];

	if true then
		TRP3_API.MapDataProvider:OnScan(MAP_PLAYER_SCAN_FAKE_DATA, "TRP3_PlayerMapPinTemplate")
		return
	end
	if structure.scan then
		hideAllMarkers();
		wipe(structure.saveStructure);
		structure.scan(structure.saveStructure);
		if structure.scanDuration then
			local mapID = GetCurrentMapAreaID();
			currentMapID = mapID;
			TRP3_WorldMapButton:Disable();
			setupIconButton(TRP3_WorldMapButton, "ability_mage_timewarp");
			TRP3_WorldMapButton.Cooldown:SetCooldown(GetTime(), structure.scanDuration)
			TRP3_ScanLoaderFrame.time = structure.scanDuration;
			TRP3_ScanLoaderFrame:Show();
			TRP3_ScanLoaderAnimationRotation:SetDuration(structure.scanDuration);
			TRP3_ScanLoaderGlowRotation:SetDuration(structure.scanDuration);
			TRP3_ScanLoaderBackAnimation1Rotation:SetDuration(structure.scanDuration);
			TRP3_ScanLoaderBackAnimation2Rotation:SetDuration(structure.scanDuration);
			playAnimation(TRP3_ScanLoaderAnimation);
			playAnimation(TRP3_ScanFadeIn);
			playAnimation(TRP3_ScanLoaderGlow);
			playAnimation(TRP3_ScanLoaderBackAnimation1);
			playAnimation(TRP3_ScanLoaderBackAnimation2);
			TRP3_API.ui.misc.playSoundKit(40216);
			after(structure.scanDuration, function()
				TRP3_WorldMapButton:Enable();
				setupIconButton(TRP3_WorldMapButton, "icon_treasuremap");
				if mapID == GetCurrentMapAreaID() then
					if structure.scanComplete then
						structure.scanComplete(structure.saveStructure);
					end
					TRP3_API.MapDataProvider:SignalEvent("TRP3_MARKERS_UPDATED", structure);
					TRP3_API.ui.misc.playSoundKit(43493);
				end
				playAnimation(TRP3_ScanLoaderBackAnimationGrow1);
				playAnimation(TRP3_ScanLoaderBackAnimationGrow2);
				playAnimation(TRP3_ScanFadeOut);
				if getConfigValue(CONFIG_UI_ANIMATIONS) then
					after(1, function()
						TRP3_ScanLoaderFrame:Hide();
						TRP3_ScanLoaderFrame:SetAlpha(1);
					end);
				else
					TRP3_ScanLoaderFrame:Hide();
				end
			end);
		else
			if structure.scanComplete then
				structure.scanComplete(structure.saveStructure);
			end
			TRP3_API.MapDataProvider:SignalEvent("TRP3_MARKERS_UPDATED", structure);
			TRP3_API.ui.misc.playSoundKit(43493);
		end
	end
end
TRP3_API.map.launchScan = launchScan;

local function onButtonClicked(self)
	local structure = {};
	for scanID, scanStructure in pairs(SCAN_STRUCTURES) do
		if not scanStructure.canScan or scanStructure.canScan() == true then
			tinsert(structure, { Utils.str.icon(scanStructure.buttonIcon or "Inv_misc_enggizmos_20", 20) .. " " .. (scanStructure.buttonText or scanID), scanID});
		end
	end
	if #structure == 0 then
		tinsert(structure, {loc.MAP_BUTTON_NO_SCAN, nil});
	end
	displayDropDown(self, structure, launchScan, 0, true);
end

--[[
TODO REMOVE THIS (it shouldn't be necessary anymore)
local function onWorldMapUpdate()
	local mapID = GetCurrentMapAreaID();
	if currentMapID ~= mapID then
		currentMapID = mapID;
		hideAllMarkers();
	end
end]]

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOAD, function()
	setupIconButton(TRP3_WorldMapButton, "icon_treasuremap");
	TRP3_WorldMapButton.title = loc.MAP_BUTTON_TITLE;
	TRP3_WorldMapButton.subtitle = YELLOW(loc.MAP_BUTTON_SUBTITLE);
	TRP3_WorldMapButton:SetScript("OnClick", onButtonClicked);
	TRP3_ScanLoaderFrameScanning:SetText(loc.MAP_BUTTON_SCANNING);

	TRP3_ScanLoaderFrame:SetScript("OnShow", function(self)
		self.refreshTimer = 0;
	end);
	TRP3_ScanLoaderFrame:SetScript("OnUpdate", function(self, elapsed)
		self.refreshTimer = self.refreshTimer + elapsed;
	end);

--[[	Utils.event.registerHandler("WORLD_MAP_UPDATE", onWorldMapUpdate);]]
end);

local CONFIG_MAP_BUTTON_POSITION = "MAP_BUTTON_POSITION";
local getConfigValue, registerConfigKey, setConfigValue = TRP3_API.configuration.getValue, TRP3_API.configuration.registerConfigKey, TRP3_API.configuration.setValue;

---@param position string
local function placeMapButton(position)
	position = position or "BOTTOMLEFT";

	---@type Frame
	local worldMapButton = TRP3_WorldMapButton;

	worldMapButton:SetParent(WorldMapFrame.BorderFrame);
	TRP3_ScanLoaderFrame:SetParent(WorldMapFrame.BorderFrame)
	worldMapButton:ClearAllPoints();

	local xPadding = 10;
	local yPadding = 10;

	if position == "TOPRIGHT" then
		xPadding = -10;
		yPadding = -45;
	elseif position == "TOPLEFT" then
		yPadding = -30;
	elseif position == "BOTTOMRIGHT" then
		xPadding = -10;
		yPadding = 40;
	end

	worldMapButton:SetPoint(position, WorldMapFrame.ScrollContainer, position, xPadding, yPadding);

	setConfigValue(CONFIG_MAP_BUTTON_POSITION, position);
end

TRP3_API.events.listenToEvent(TRP3_API.events.WORKFLOW_ON_LOADED, function()
	registerConfigKey(CONFIG_MAP_BUTTON_POSITION, "BOTTOMLEFT");

	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigH1",
		title = loc.CO_MAP_BUTTON,
	});

	tinsert(TRP3_API.configuration.CONFIG_FRAME_PAGE.elements, {
		inherit = "TRP3_ConfigDropDown",
		widgetName = "TRP3_ConfigurationFrame_MapButtonWidget",
		title = loc.CO_MAP_BUTTON_POS,
		listContent = {
			{loc.CO_ANCHOR_BOTTOM_LEFT, "BOTTOMLEFT"},
			{loc.CO_ANCHOR_TOP_LEFT, "TOPLEFT"},
			{loc.CO_ANCHOR_BOTTOM_RIGHT, "BOTTOMRIGHT"},
			{loc.CO_ANCHOR_TOP_RIGHT, "TOPRIGHT"}
		},
		listCallback = placeMapButton,
		listCancel = true,
		configKey = CONFIG_MAP_BUTTON_POSITION,
	});

	placeMapButton(getConfigValue(CONFIG_MAP_BUTTON_POSITION));

end);

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- Broadcast Lifecycle
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

-- When we get BROADCAST_CHANNEL_CONNECTING we'll ensure the button is
-- disabled and tell the user things are firing up.
TRP3_API.events.listenToEvent(TRP3_API.events.BROADCAST_CHANNEL_CONNECTING, function()
	TRP3_WorldMapButton:SetEnabled(false);
	TRP3_WorldMapButton.subtitle = YELLOW(loc.MAP_BUTTON_SUBTITLE_CONNECTING);

	TRP3_WorldMapButtonIcon:SetDesaturated(true);
end);

-- If we get BROADCAST_CHANNEL_OFFLINE we'll ensure the button remains
-- disabled and dump the localised error into the tooltip, to be useful.
TRP3_API.events.listenToEvent(TRP3_API.events.BROADCAST_CHANNEL_OFFLINE, function(reason)
	TRP3_WorldMapButton:SetEnabled(false);
	TRP3_WorldMapButton.subtitle = YELLOW(loc.MAP_BUTTON_SUBTITLE_OFFLINE):format(reason);

	TRP3_WorldMapButtonIcon:SetDesaturated(true);
end);

-- When we get BROADCAST_CHANNEL_READY it's time to enable the button use the
-- standard tooltip description.
TRP3_API.events.listenToEvent(TRP3_API.events.BROADCAST_CHANNEL_READY, function()
	TRP3_WorldMapButton:SetEnabled(true);
	TRP3_WorldMapButton.subtitle = YELLOW(loc.MAP_BUTTON_SUBTITLE);

	TRP3_WorldMapButtonIcon:SetDesaturated(false);
end);
