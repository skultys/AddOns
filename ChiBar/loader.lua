-- Addon:	ChiBar: widget generating function for the optionpanel
-- Author:	Fushui(EU-Azshara)

if select(2, UnitClass("player")) ~= "MONK" then
	--DisableAddon("ChiBar")
    return
end

if not ChiBar then
	ChiBar = {}
end

if not ChiBarLocalization then
	ChiBarLocalization = {}
end

-- Creating MainFrame
ChiBar.mainFrame = CreateFrame("Frame", "ChiBarFrame", UIParent)