local Ellyb = Ellyb(...)
local loc = TRP3_API.loc
local RED, ORANGE = Ellyb.ColorManager.RED, Ellyb.ColorManager.ORANGE

local HealthTooltipIndicator = AddOn_TotalRP3.UnitTooltipIndicator(
	"SHOW_HEALTH_PERCENTAGE_IN_TOOLTIP",
	loc.CO_TOOLTIP_HEALTH_INDICATOR,
	false,
	50,
	{
		AddOn_TotalRP3.TARGET_TYPES.TYPE_CHARACTER,
		AddOn_TotalRP3.TARGET_TYPES.TYPE_PET
	}
)

---@param tooltip GameTooltip
function HealthTooltipIndicator:_DisplayInsideTooltipForTarget(tooltip, target, targetType)
	if not tooltip then
		tooltip = TRP3_CharacterTooltip
	end
	if not target then
		target = "mouseover"
	end
	local targetHealth, targetMaxHealth = UnitHealth(target), UnitHealthMax(target)
	if targetHealth and targetMaxHealth then
		local healthValue
		if targetHealth == 0 then
			RED(DEAD)
		else
			local healthPercentage = targetHealth / targetMaxHealth
			local healthColor
			if healthColor > 0.5 then
				healthColor = Ellyb.Color.CreateFromRGBA((1 - healthPercentage) * 2,1,0)
			else
				healthColor = Ellyb.Color.CreateFromRGBA(1,healthPercentage * 2,0)
			end
			healthValue = healthColor(healthPercentage .. "%")
		end
		tooltip:AddLine(ORANGE(loc.REG_TT_HEALTH) .. " " .. healthValue, 1, 1, 1, TRP3_API.ui.tooltip.getSubLineFontSize())
	end
end