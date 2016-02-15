--[[--------------------------------------------------------------------
	PhanxConfig-Panel
	Simple background panel widget generator.
	Requires LibStub.
	https://github.com/phanx/PhanxConfigWidgets
	Copyright (c) 2009-2014 Phanx. All rights reserved.
	See the accompanying README and LICENSE files for more information.
----------------------------------------------------------------------]]

local MINOR_VERSION = tonumber(strmatch("$Revision: 172 $", "%d+"))

local lib, oldminor = LibStub:NewLibrary("PhanxConfig-Panel", MINOR_VERSION)
if not lib then return end

local panelBackdrop = {
	bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tile = true, tileSize = 16,
	edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
	insets = { left = 5, right = 5, top = 5, bottom = 5 }
}

local function SetPoint(f, a, to, b, x, y)
	if f.label:GetText() and strfind(a, "TOP") then
		if x and not y then
			a, to, b, x, y = a, to, a, b, x
		elseif b and not x then
			a, to, b, x, y = a, f:GetParent(), a, to, b
		end
		y = y - f.label:GetHeight()
	end
	f.__SetPoint(f, a, to, b, x, y)
end

local function SetLabel(f, labelText)
	local prev = f.label:GetText()
	f.label:SetText(labelText)
	if (not not prev) ~= (not not labelText) then
		for i = 1, f:GetNumPoints() do
			f:SetPoint(f:GetPoint(i))
		end
	end
end

function lib:New(parent, labelText, width, height)
	assert(type(parent) == "table" and type(rawget(parent, 0)) == "userdata", "PhanxConfig-Panel: Parent is not a valid frame!")
	if type(label) == "number" then
		label, width, height = nil, label, width -- backwards compat
	end

	local frame = CreateFrame("Frame", nil, parent)
	frame:SetBackdrop(panelBackdrop)
	frame:SetBackdropColor(0.06, 0.06, 0.06, 0.4)
	frame:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	label:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 4, 0)
	label:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, 0)
	label:SetJustifyH("LEFT")
	frame.label = label

	frame.__SetPoint = frame.SetPoint
	frame.SetPoint = SetPoint

	frame.SetLabel = SetLabel

	label:SetText(labelText)
	if width and height then
		frame:SetSize(width, height)
	end

	return frame
end

function lib.CreatePanel(...) return lib:New(...) end