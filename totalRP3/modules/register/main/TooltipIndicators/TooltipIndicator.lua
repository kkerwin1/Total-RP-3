local Ellyb = Ellyb(...)

--- Tooltip indicator module
--- Create a new TooltipIndicator to automatically register a new indicator to be displayed a unit tooltip
---@class UnitTooltipIndicator : Object
local UnitTooltipIndicator, _private = Ellyb.Class("TooltipIndicator")

---@type UnitTooltipIndicator[]
AddOn_TotalRP3.unitTooltipIndicators = {}

function UnitTooltipIndicator:initialize(configurationKey, configurationLocaleText, shouldBeEnabledByDefault, priority, allowedTargetTypes)
	_private[self] = {}

	_private[self].allowedTargetTypes = allowedTargetTypes

	TRP3_API.Events.registerCallback(TRP3_API.Events.WORKFLOW_ON_LOADED, function()

		TRP3_API.configuration.registerConfigKey(configurationKey, shouldBeEnabledByDefault)

		table.insert(TRP3_API.ui.tooltip.CONFIG.elements,{
			inherit = "TRP3_ConfigCheck",
			title = configurationLocaleText,
			configKey = configurationKey,
		})
	end)

	table.insert(AddOn_TotalRP3.unitTooltipIndicators, priority, self)
end

function UnitTooltipIndicator:IsValidTargetType(targetType)
	return tContains(_private[self].allowedTargetTypes, targetType)
end

---DisplayInsideTooltipForTarget
--- This is the private version. It should never be called directly, use the public version instead
---@private
---@param tooltip GameTooltip
---@param target string
---@param targetType string @ A target type, as defined in AddOn_TotalRP3.TARGET_TYPES
--[[ Override ]] function UnitTooltipIndicator:_DisplayInsideTooltipForTarget(tooltip, target, targetType) end

---DisplayInsideTooltipForTarget
--- This is the public version, that will automatically call :IsValidTargetType for us and then call the private version.
---@param tooltip GameTooltip
---@param target string
---@param targetType string @ A target type, as defined in AddOn_TotalRP3.TARGET_TYPES
function UnitTooltipIndicator:DisplayInsideTooltipForTarget(tooltip, target, targetType)
	if self:IsValidTargetType(targetType) then
		self:_DisplayInsideTooltipForTarget(tooltip, target, targetType)
	end
end

-- Public constructor
---UnitTooltipIndicator
---@param configurationKey string
---@param configurationLocaleText string
---@param shouldBeEnabledByDefault boolean
---@param priority number
---@param allowedTargetTypes string[] @ Table of allowed target types as defined in AddOn_TotalRP3.TARGET_TYPES
---@overload fun(configurationKey:string, configurationLocaleText:string, shouldBeEnabledByDefault:boolean)
---@return UnitTooltipIndicator
function AddOn_TotalRP3.UnitTooltipIndicator(configurationKey, configurationLocaleText, shouldBeEnabledByDefault, priority, allowedTargetTypes)
	return UnitTooltipIndicator(configurationKey, configurationLocaleText, shouldBeEnabledByDefault, priority, allowedTargetTypes)
end