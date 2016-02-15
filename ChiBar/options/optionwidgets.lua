-- Addon:	ChiBar: widget generating function for the optionpanel
-- Author:	Fushui(EU-Azshara)
--
-- Using the Library:
-- NoTaint UIDropDownMenu by another@curse
-- http://wow.curseforge.com/addons/notaint-uidropdownmenu/
--

if select(2, UnitClass("player")) ~= "MONK" then
    return
end

function ChiBar:createCheckbox(parentFrame, elementName, script, dbData, localisedText, point, relativeTo, relativePoint, ofsx, ofsy, reversed)

	local enable = {}
    
    
	enable.element = CreateFrame("CheckButton", elementName, parentFrame, "OptionsBaseCheckButtonTemplate")
	enable.element:SetPoint(point, relativeTo, relativePoint, ofsx, ofsy)
    if reversed then
        enable.element:SetChecked(not ChiBarDB[dbData])
        enable.reversed = true
    else
        enable.element:SetChecked(ChiBarDB[dbData])
        enable.reversed = false
    end
	
	enable.element:SetScript("OnClick", script)
	enable.text = parentFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	enable.text:SetPoint("LEFT", enable.element, "RIGHT", 10, 1)
	enable.text:SetJustifyH("LEFT")
	enable.text:SetText(localisedText)
    
    enable.UpdateValue = function (self)
        if enable.reversed then
            self.element:SetChecked(not ChiBarDB[dbData])
        else
            self.element:SetChecked(ChiBarDB[dbData])
        end
    end

	return enable
end

function ChiBar:createTitle(parentFrame, text, textsizeType, point, relativeTo, relativePoint, ofsx, ofsy)

	if parentFrame and text and textsizeType and point and relativeTo and relativePoint and ofsx and ofsy then

		local title = parentFrame:CreateFontString(nil, "ARTWORK", textsizeType)
		title:SetPoint(point, relativeTo, relativePoint, ofsx, ofsy)
		title:SetText(text)

		return title
	else
		-- if not all 8 needed arguments are given, we assume that we want to create a Fontstring with a specific
		-- position and not a relative one
		local new_ofsx = relativeTo
		local new_ofsy = relativePoint

		local title = parentFrame:CreateFontString(nil, "ARTWORK", textsizeType)
		title:SetPoint(point, new_ofsx, new_ofsy)
		title:SetText(text)

		return title
	end
end

function ChiBar:createButton(parentFrame, elementName, text, script, point, relativeTo, relativePoint, ofsx, ofsy)

	local button = CreateFrame("Button", elementName, parentFrame, "GameMenuButtonTemplate")
	button:SetHeight(25)
	button:SetWidth(100)
	button:SetPoint(point, relativeTo, relativePoint, ofsx, ofsy)
	button:SetText(text)
	button:SetScript("OnClick", script)

	return button
end

function ChiBar:createSlider(parentFrame, elementName, script, dbData, flooringFactor, minValue, maxValue, point, relativeTo, relativePoint, ofsx, ofsy, textsizeType)

	local slider = CreateFrame('Slider', elementName, parentFrame, 'OptionsSliderTemplate')
    slider.editbox = CreateFrame("EditBox", nil, slider)
    
    -- Slider properties
	slider:SetPoint(point, relativeTo, relativePoint, ofsx, ofsy)
	slider:SetMinMaxValues(minValue, maxValue)
	slider:SetValue(ChiBarDB[dbData])
	getglobal(slider:GetName() .. 'Low'):SetText(minValue)
	getglobal(slider:GetName() .. 'High'):SetText(maxValue)
    
    -- Editbox properties
	slider.editbox:SetWidth(50)
	slider.editbox:SetHeight(20)
	slider.editbox:SetPoint("LEFT", slider, "RIGHT", 20, 0)
	slider.editbox:SetFontObject(textsizeType)
	slider.editbox:SetMultiLine(false)
	slider.editbox:SetAutoFocus(false)
	slider.editbox:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
                			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
                			tile = true, edgeSize = 1, tileSize = 5,
        				})
	slider.editbox:SetBackdropColor(0, 0, 0, 0.2)
    slider.editbox:SetBackdropBorderColor(0.3, 0.3, 0.30, 0.80)
    slider.editbox:SetJustifyH("CENTER")
	slider.editbox:SetText(ChiBarDB[dbData])
	slider.editbox:SetCursorPosition(0)
    
    
    -- Slider scripts
    slider:SetScript("OnValueChanged", function()
		local value = floor(slider:GetValue()*flooringFactor)/flooringFactor
        slider.editbox:SetText(value)
        ChiBarDB[dbData] = value
		script()
	end)
    
    
    -- Editbox scripts
	slider.editbox:SetScript("OnEnterPressed", function()
		slider.editbox:ClearFocus()
		local text = slider.editbox:GetText()
		text = text:gsub("%,", "%.")
		local textAsNumber = tonumber(text)
		if textAsNumber ~= nil and textAsNumber <= maxValue and textAsNumber >= minValue then
			slider:SetValue(floor(textAsNumber*flooringFactor)/flooringFactor)
		end
	end)

	slider.editbox:SetScript("OnEscapePressed", function()
		slider.editbox:ClearFocus()
		slider.editbox:SetText(ChiBarDB[dbData])
	end)

	slider.editbox:SetScript("OnEditFocusLost", function(self)
		slider.editbox:ClearFocus()
	end)

    
    slider.UpdateValue = function (self)
        self:SetValue(ChiBarDB[dbData])
    end

	return slider
end

function ChiBar:createDropdownMenu(parentFrame, elementName, script, items, dbData, point, relativeTo, relativePoint, ofsx, ofsy)

	local menu = {}

	menu.element = CreateFrame("Frame", elementName, parentFrame, "Lib_UIDropDownMenuTemplate")
	menu.element:SetPoint(point, relativeTo, relativePoint, ofsx, ofsy)
	menu.items = items
	local function OnClick(self)
		Lib_UIDropDownMenu_SetSelectedID(menu.element, self:GetID())
		ChiBarDB[dbData] = self:GetID()
		script()
	end
	local function initialize(self, level)
		local info = Lib_UIDropDownMenu_CreateInfo()
		for k, v in pairs(menu.items) do
			info = Lib_UIDropDownMenu_CreateInfo()
			info.text = v
			info.value = v
			info.func = OnClick
			Lib_UIDropDownMenu_AddButton(info, level)
		end
	end
	Lib_UIDropDownMenu_Initialize(menu.element, initialize)
	Lib_UIDropDownMenu_SetWidth(menu.element, 120)
	Lib_UIDropDownMenu_SetButtonWidth(menu.element, 120)
	Lib_UIDropDownMenu_JustifyText(menu.element, "LEFT")
	Lib_UIDropDownMenu_SetSelectedID(menu.element, ChiBarDB[dbData])

    menu.UpdateValue = function (self)
        Lib_UIDropDownMenu_SetSelectedID(self.element, ChiBarDB[dbData])
    end
    
	return menu
end