----------------------------------------------------------------------------------
--- Total RP 3
---
--- Color picker button mixin
--- ---------------------------------------------------------------------------
--- Copyright 2018 Renaud "Ellypse" Parize <ellypse@totalrp3.info> @EllypseCelwe
---
--- Licensed under the Apache License, Version 2.0 (the "License");
--- you may not use this file except in compliance with the License.
--- You may obtain a copy of the License at
---
--- http://www.apache.org/licenses/LICENSE-2.0
---
--- Unless required by applicable law or agreed to in writing, software
--- distributed under the License is distributed on an "AS IS" BASIS,
--- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--- See the License for the specific language governing permissions and
--- limitations under the License.
----------------------------------------------------------------------------------

---@type TRP3_API
local addonName, TRP3_API = ...;
local Ellyb = Ellyb(addonName);

-- Lua imports
local type = type;

-- Ellyb imports
local Color = Ellyb.Color;
local WHITE = Ellyb.ColorManager.WHITE;

-- WoW imports
local IsShiftKeyDown = IsShiftKeyDown;

-- Total RP 3 imports
local getConfigValue = TRP3_API.configuration.getValue;
local playUISound = TRP3_API.ui.misc.playUISound;
local showDefaultColorPicker = TRP3_API.popup.showDefaultColorPicker;
local showPopup = TRP3_API.popup.showPopup;

local DEFAULT_ICON = [[Interface\ICONS\icon_petfamily_mechanical]];
local USE_DEFAULT_COLOR_PICKER = "default_color_picker";

TRP3_ColorPickerButtonMixin = {};

function TRP3_ColorPickerButtonMixin:OnLoad()
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	self:ResetColor();

	-- Function to scope self, to be used as a callback for the color pickers
	self.colorPickerSetColor = function(red, green, blue)
		self:SetColor(red, green, blue);
	end
end

---SetColor
function TRP3_ColorPickerButtonMixin:SetColor(red, green, blue)
	if not red then
		self:ResetColor();
		return
	elseif type(red) == "table" and red.isInstanceOf and red:isInstanceOf("Color") then
		self.color = red;
	else
		self.color = Color(red, green, blue);
	end

	self.Background:SetColorTexture(self:GetColor():GetRGB());
	self.Highlight:SetVertexColor(self:GetColor():GetRGB());

	self:OnSelection(self:GetColor());
end

function TRP3_ColorPickerButtonMixin:ResetColor()
	self.color = nil;

	self.Background:SetTexture(DEFAULT_ICON);
	self.Highlight:SetVertexColor(WHITE:GetRGB());

	self:OnSelection(nil);
end

---@return Color color
function TRP3_ColorPickerButtonMixin:GetColor()
	return self.color or WHITE;
end

--- Function called when a color is selected. Can be overridden to declare a specific behavior
---@param optional color Color @ An instance of the Color class that represents the color value selected in the picker.
---Empty when resetting the color
function TRP3_ColorPickerButtonMixin:OnSelection(color)
	-- Backward compatibility: before we would add a onSelection attribute to the button to be the callback
	-- If we have that we will call it and give it the red, green and blue values
	if self.onSelection then
		self.onSelection(color and color:GetRGB() or nil);
	end
end

function TRP3_ColorPickerButtonMixin:OnClick(button)
	if button == "LeftButton" then
		if IsShiftKeyDown() or getConfigValue(USE_DEFAULT_COLOR_PICKER) then
			showDefaultColorPicker({ self.colorPickerSetColor, self:GetColor():GetRGB() });
		else
			showPopup(TRP3_API.popup.COLORS, nil, { self.colorPickerSetColor, self:GetColor():GetRGB() });
		end

	elseif button == "RightButton" then
		self:ResetColor();
	end

	playUISound("gsCharacterSelection");
end

function TRP3_ColorPickerButtonMixin:OnEnter()
	TRP3_RefreshTooltipForFrame(self);
end

function TRP3_ColorPickerButtonMixin:OnLeave()
	TRP3_MainTooltip:Hide();
end

function TRP3_ColorPickerButtonMixin:Blink()
	self.Blink.Animation:Play();
end