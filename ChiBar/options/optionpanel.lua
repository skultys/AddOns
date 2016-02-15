-- Addon:	ChiBar: option panel
-- Author:	Fushui(EU-Azshara)

if select(2, UnitClass("player")) ~= "MONK" then
    return
end


------------------------------------------
--		OptionsPanel					--
------------------------------------------

function ChiBar:CreateOptionsUI()
	ChiBar.opanel = CreateFrame("Frame", "ChiBarOptionsPanel", UIParent)
	ChiBar.opanel.name = "ChiBar";
	InterfaceOptions_AddCategory(ChiBar.opanel);
    
    --scrollframe 
    ChiBar.opanel.scrollframe = CreateFrame("ScrollFrame", nil, ChiBar.opanel) 
    ChiBar.opanel.scrollframe:SetPoint("TOPLEFT", ChiBar.opanel, "TOPLEFT", 10, -10) 
    ChiBar.opanel.scrollframe:SetPoint("BOTTOMRIGHT", ChiBar.opanel, "BOTTOMRIGHT", -10, 10) 
    ChiBar.opanel.scrollframe:EnableMouseWheel(true)
    ChiBar.opanel.scrollframe:SetScript("OnMouseWheel", 
        function (self, value) 
            local minV, maxV = ChiBar.opanel.scrollbar:GetMinMaxValues()
            local currV = ChiBar.opanel.scrollbar:GetValue()
            local height, viewheight = ChiBar.opanel.scrollframe:GetHeight(), ChiBar.opanel.content:GetHeight()
            
            if value > 0 and currV - minV > 0 then
                ChiBar.opanel.scrollbar:SetValue(currV - value*(maxV/((height - viewheight)/(maxV*0.07)))) 
            end            
            if value < 0 and maxV - currV > 0 then
                ChiBar.opanel.scrollbar:SetValue(currV - value*(maxV/((height - viewheight)/(maxV*0.07))))
            end
        end) 
     
    --scrollbar 
    ChiBar.opanel.scrollbar = CreateFrame("Slider", nil, ChiBar.opanel.scrollframe, "UIPanelScrollBarTemplate") 
    ChiBar.opanel.scrollbar:SetPoint("TOPRIGHT", ChiBar.opanel, "TOPRIGHT", -10, -25) 
    ChiBar.opanel.scrollbar:SetPoint("BOTTOMRIGHT", ChiBar.opanel, "BOTTOMRIGHT", -10, 25) 
    ChiBar.opanel.scrollbar:SetMinMaxValues(1, 200) 
    ChiBar.opanel.scrollbar:SetValueStep(1) 
    ChiBar.opanel.scrollbar.scrollStep = 1
    ChiBar.opanel.scrollbar:SetValue(0) 
    ChiBar.opanel.scrollbar:SetWidth(16) 
    ChiBar.opanel.scrollbar:SetScript("OnValueChanged", 
        function (self, value) 
            self:GetParent():SetVerticalScroll(value) 
        end) 
        
        
     
    --content frame 
    ChiBar.opanel.content = CreateFrame("Frame", nil, ChiBar.opanel.scrollframe) 
    ChiBar.opanel.content:SetSize(128, 128) 
     
    ChiBar.opanel.scrollframe:SetScrollChild(ChiBar.opanel.content)

	-- Widget
	ChiBar.Widgets = {}

	-- VersionTitle
	ChiBar.Widgets.title = ChiBar:createTitle(ChiBar.opanel.content, ChiBar.VERSIONTEXT_1, "GameFontNormalLarge", "TOPLEFT", 16, -16)
	ChiBar.Widgets.title2 = ChiBar:createTitle(ChiBar.opanel.content, ChiBar.VERSIONTEXT_2, "GameFontHighlight", "TOPLEFT", 16, -35)
	
	-- MainSettingTitle
	ChiBar.Widgets.mainsettTitle = ChiBar:createTitle(ChiBar.opanel.content, ChiBarLocalization.OP_MAINTITLE, "GameFontNormalLarge", "TOPLEFT", 16, -70)
	
	-- EnableCheckBox
	ChiBar.Widgets.enableBox = ChiBar:createCheckbox(ChiBar.opanel.content, "EnableCheckBox",
		ChiBar.ValueChanged_Enable, "enable", ChiBarLocalization.OP_ENABLE,
		"TOPLEFT", ChiBar.Widgets.mainsettTitle, "BOTTOMLEFT", 0, -5)
	
	-- AutohideCheckBox
	ChiBar.Widgets.autohideBox = ChiBar:createCheckbox(ChiBar.opanel.content, "AutohideCheckBox",
		ChiBar.ValueChanged_Autohide, "autohide", ChiBarLocalization.OP_AUTOHIDE,
		"TOPLEFT", ChiBar.Widgets.enableBox.element, "BOTTOMLEFT", 0, -1)
	
	-- HideStandardChiBar
	ChiBar.Widgets.hideStandardBox = ChiBar:createCheckbox(ChiBar.opanel.content, "AutohideCheckBox",
		ChiBar.ValueChanged_HideStandard, "hideStandard", ChiBarLocalization.OP_HIDESTANDARD,
		"TOPLEFT", ChiBar.Widgets.autohideBox.element, "BOTTOMLEFT", 0, -1)
        
    -- HideManaBar
    ChiBar.Widgets.showManaBox = ChiBar:createCheckbox(ChiBar.opanel.content, "AutohideCheckBox",
		ChiBar.ValueChanged_HideManaBar, "showMana", ChiBarLocalization.OP_SHOWMANABAR,
		"TOPLEFT", ChiBar.Widgets.hideStandardBox.element, "BOTTOMLEFT", 0, -1)
                
    -- ChangeColorButton
	ChiBar.Widgets.colorButton = ChiBar:createButton(ChiBar.opanel.content, "ColorButton", ChiBarLocalization.OP_COLORBTN, ChiBar.OpenColorPicker,
		"TOPLEFT", ChiBar.Widgets.showManaBox.element, "BOTTOMLEFT", 0, -15)
	
	-- ResetColorButton
	ChiBar.Widgets.resetColorButton = ChiBar:createButton(ChiBar.opanel.content, "ResetColorButton", ChiBarLocalization.OP_RESETCOLORBTN, ChiBar.ResetColor,
		"TOPLEFT", ChiBar.Widgets.colorButton, "BOTTOMLEFT", 0, -5)
	
	-- LockButton
	ChiBar.Widgets.lockButton = ChiBar:createButton(ChiBar.opanel.content, "LockButton", ChiBarLocalization.OP_LOCKBTN1, ChiBar.UnlockFrame,
		"TOPLEFT", ChiBar.Widgets.colorButton, "TOPRIGHT", 5, 0)
	
	-- ResetButton
	ChiBar.Widgets.resetButton = ChiBar:createButton(ChiBar.opanel.content, "ResetButton", ChiBarLocalization.OP_RESET, ChiBar.ConfirmReset,
		"TOPLEFT", ChiBar.Widgets.lockButton, "BOTTOMLEFT", 0, -5)
                
	-- ScaleTitle
	ChiBar.Widgets.scaleTitle = ChiBar:createTitle(ChiBar.opanel.content, ChiBarLocalization.OP_SCALETITLE, "GameFontNormalLarge",
		"TOPLEFT", ChiBar.Widgets.resetColorButton, "BOTTOMLEFT", 0, -25)

	-- ScaleSlider
	ChiBar.Widgets.scaleSlider = ChiBar:createSlider(ChiBar.opanel.content, 'ChiBar_ScaleSlider', ChiBar.ValueChanged_Scale, "scale", 1000, 0.1, 2,
		"TOPLEFT", ChiBar.Widgets.scaleTitle, "BOTTOMLEFT", 0, -10, "GameFontHighlightSmall")
	
	-- OrientationTitle
	ChiBar.Widgets.orientationTitle = ChiBar:createTitle(ChiBar.opanel.content, ChiBarLocalization.OP_GROW_TITLE, "GameFontNormalLarge",
		"LEFT", ChiBar.Widgets.mainsettTitle, "RIGHT", 125, 0)
	
	-- OrientationBox1
	ChiBar.Widgets.verticalBox = ChiBar:createCheckbox(ChiBar.opanel.content, "AutohideCheckBox",
		ChiBar.ValueChanged_Growth1, "grow1", ChiBarLocalization.OP_GROW_VERTICAL,
		"TOPLEFT", ChiBar.Widgets.orientationTitle, "BOTTOMLEFT", 0, -5, true)
	
	-- OrientationBox2
	ChiBar.Widgets.horizontalBox = ChiBar:createCheckbox(ChiBar.opanel.content, "AutohideCheckBox",
		ChiBar.ValueChanged_Growth1, "grow1", ChiBarLocalization.OP_GROW_HORIZONTAL,
		"TOPLEFT", ChiBar.Widgets.verticalBox.element, "BOTTOMLEFT", 0, -1)
	
	-- OrientationBox3
	local text = ChiBarDB.grow1 and ChiBarLocalization.OP_GROW_RIGHT or ChiBarLocalization.OP_GROW_TOP
	ChiBar.Widgets.leftbottomBox = ChiBar:createCheckbox(ChiBar.opanel.content, "AutohideCheckBox",
		ChiBar.ValueChanged_Growth2, "grow2", text,
		"LEFT", ChiBar.Widgets.verticalBox.text, "RIGHT", 50, 0)
	
	-- OrientationBox4
	local text = ChiBarDB.grow1 and ChiBarLocalization.OP_GROW_LEFT or ChiBarLocalization.OP_GROW_BOTTOM
	ChiBar.Widgets.righttopBox = ChiBar:createCheckbox(ChiBar.opanel.content, "AutohideCheckBox",
		ChiBar.ValueChanged_Growth2, "grow2", text,
		"TOPLEFT", ChiBar.Widgets.leftbottomBox.element, "BOTTOMLEFT", 0, -1, true)
	
	--DropboxTitle
	ChiBar.Widgets.dropdownTitle = ChiBar:createTitle(ChiBar.opanel.content, ChiBarLocalization.OP_DROPBOXTITLE, "GameFontNormalLarge",
		"TOPLEFT", ChiBar.Widgets.scaleSlider, "BOTTOMLEFT", 0, -30)
	
	-- TextureDropDown
	local textureMenuItems = {}
	local index
	for index = 1, #ChiBar.TEXTURES do
		textureMenuItems[index] = ChiBar.TEXTURES[index][1]
	end
	ChiBar.Widgets.dropdownMenu = ChiBar:createDropdownMenu(ChiBar.opanel.content, "TextureMenu", ChiBar.ValueChange_SetTexture, textureMenuItems, "savedTexture",
		"TOPLEFT", ChiBar.Widgets.dropdownTitle, "BOTTOMLEFT", -10, -10)
	
	-- LayerTitle
	ChiBar.Widgets.layerTitle = ChiBar:createTitle(ChiBar.opanel.content, ChiBarLocalization.OP_LAYERTITLE, "GameFontNormalLarge",
		"TOPLEFT", ChiBar.Widgets.horizontalBox.element, "BOTTOMLEFT", 0, -10)
	
	-- StrataTitle
	ChiBar.Widgets.layerSubTitle1 = ChiBar:createTitle(ChiBar.opanel.content, ChiBarLocalization.OP_LAYERSUBTITLE1, "GameFontHighlight",
		"TOPLEFT", ChiBar.Widgets.layerTitle, "BOTTOMLEFT", 0, -10)
	
	-- StrataDropdown
	ChiBar.Widgets.strataMenu = ChiBar:createDropdownMenu(ChiBar.opanel.content, "StrataMenu", ChiBar.ValueChanged_LayerLevel, {"LOW", "MEDIUM", "HIGH", "DIALOG"}, "strata",
		"TOPLEFT", ChiBar.Widgets.layerSubTitle1, "BOTTOMLEFT", -15, -10)
	
	-- LayerTitle
	ChiBar.Widgets.layerSubTitle2 = ChiBar:createTitle(ChiBar.opanel.content, ChiBarLocalization.OP_LAYERSUBTITLE2, "GameFontHighlight",
		"LEFT", ChiBar.Widgets.layerSubTitle1, "RIGHT", 80, 0)
	
	-- LayerDropdown
	ChiBar.Widgets.mainLayerMenu = ChiBar:createDropdownMenu(ChiBar.opanel.content, "LayerMenu", ChiBar.ValueChanged_LayerLevel, {"BACKGROUND", "BORDER", "ARTWORK", "OVERLAY"}, "mainLayer",
		"TOPLEFT", ChiBar.Widgets.layerSubTitle2, "BOTTOMLEFT", -15, -10)
	

	-- OpacityTitle
	ChiBar.Widgets.opacityTitle = ChiBar:createTitle(ChiBar.opanel.content, ChiBarLocalization.OP_OPACITYTITLE, "GameFontNormalLarge",
		"TOPLEFT", ChiBar.Widgets.layerTitle, "BOTTOMLEFT", 0, -75)

    -- OpacitySubTitleMana
	ChiBar.Widgets.opacitySubTitleMana = ChiBar:createTitle(ChiBar.opanel.content, ChiBarLocalization.OP_OPACITYSUBTITLEMANA, "GameFontNormalMed3",
		"TOPLEFT", ChiBar.Widgets.opacityTitle, "BOTTOMLEFT", 5, -15)
	
	-- OpacitySliderMana
	ChiBar.Widgets.opacitySliderMana = ChiBar:createSlider(ChiBar.opanel.content, 'ChiBar_OpacitySliderMana', ChiBar.ValueChanged_ManaBarOpacity, "alphaMana", 1000, 0, 1,
		"TOPLEFT", ChiBar.Widgets.opacitySubTitleMana, "BOTTOMLEFT", 0, -10, "GameFontHighlightSmall")

	-- SeperateBox
	ChiBar.Widgets.seperateBox = ChiBar:createCheckbox(ChiBar.opanel.content, "SeperateCheckBox",
		ChiBar.ValueChanged_SeperateOpacity, ChiBarDB.seperate, ChiBarLocalization.OP_SEPERATE,
		"TOPLEFT", ChiBar.Widgets.opacitySliderMana, "BOTTOMLEFT", -5, -25)
	
	-- OpacitySubTitle1
	local text = ChiBarDB.seperate and ChiBarLocalization.OP_OPACITYSUBTITLE1_2 or ChiBarLocalization.OP_OPACITYSUBTITLE1_1
	ChiBar.Widgets.opacitySubTitle1 = ChiBar:createTitle(ChiBar.opanel.content, text, "GameFontNormalMed3",
		"TOPLEFT", ChiBar.Widgets.seperateBox.element, "BOTTOMLEFT", 5, -10)
	
	-- OpacitySlider1
	ChiBar.Widgets.opacitySlider1 = ChiBar:createSlider(ChiBar.opanel.content, 'ChiBar_OpacitySlider1', ChiBar.ValueChanged_ChiBarOpacity, "alpha1", 1000, 0, 1,
		"TOPLEFT", ChiBar.Widgets.opacitySubTitle1, "BOTTOMLEFT", 0, -10, "GameFontHighlightSmall")
	
	-- OpacitySubTitle2
	ChiBar.Widgets.opacitySubTitle2 = ChiBar:createTitle(ChiBar.opanel.content, ChiBarLocalization.OP_OPACITYSUBTITLE2, "GameFontNormalMed3",
		"TOPLEFT", ChiBar.Widgets.opacitySlider1, "BOTTOMLEFT", 0, -20)
	
	-- OpacitySlider2
	ChiBar.Widgets.opacitySlider2 = ChiBar:createSlider(ChiBar.opanel.content, 'ChiBar_', ChiBar.ValueChanged_ChiBarOpacity, "alpha2", 1000, 0, 1,
		"TOPLEFT", ChiBar.Widgets.opacitySubTitle2, "BOTTOMLEFT", 0, -10, "GameFontHighlightSmall")

        
	if not ChiBarDB.seperate then
		ChiBar.Widgets.opacitySubTitle2:Hide()
		ChiBar.Widgets.opacitySlider2:Hide()
	end
	
	-- OffsetTitle
	ChiBar.Widgets.offsetTitle = ChiBar:createTitle(ChiBar.opanel.content, ChiBarLocalization.OP_OFFSETTITLE, "GameFontNormalLarge",
		"TOPLEFT", ChiBar.Widgets.dropdownMenu.element, "BOTTOMLEFT", 10, -15)
	
	-- OffsetSlider
	ChiBar.Widgets.offsetSlider = ChiBar:createSlider(ChiBar.opanel.content, 'ChiBar_OffsetSlider', ChiBar.ValueChanged_Orientation, "offset", 1, 0, 100,
		"TOPLEFT", ChiBar.Widgets.offsetTitle, "BOTTOMLEFT", 0, -10, "GameFontHighlightSmall")
        
    -- ManaOverlappingTitle
	ChiBar.Widgets.manaOverlappingTitle = ChiBar:createTitle(ChiBar.opanel.content, ChiBarLocalization.OP_OVERLAPPINGMANABAR, "GameFontNormalLarge",
		"TOPLEFT", ChiBar.Widgets.offsetSlider, "BOTTOMLEFT", 0, -25)
	
	-- ManaOverlappingSlider
	ChiBar.Widgets.manaOverlappingSlider = ChiBar:createSlider(ChiBar.opanel.content, 'ChiBar_OverlappingSlider', ChiBar.ValueChanged_Orientation, "manaBarOverlapping", 1, 0, 100,
		"TOPLEFT", ChiBar.Widgets.manaOverlappingTitle, "BOTTOMLEFT", 0, -10, "GameFontHighlightSmall")

        
    if not ChiBarDB.showMana then
		ChiBar.Widgets.manaOverlappingTitle:Hide()
		ChiBar.Widgets.manaOverlappingSlider:Hide()
		ChiBar.Widgets.currmanaOverlappingText:Hide()
	end
end


------------------------------------------
--		PopUpHandling					--
------------------------------------------

-- PopUpHandling for Unlocking
StaticPopupDialogs["CHIBAR_UNLOCKFRAME"] = {
  text = ChiBarLocalization.OP_UNLOCKTEXT,
  button1 = ChiBarLocalization.OP_LOCKBTN2,
  OnAccept = function()
      ChiBar:LockFrame()
	  InterfaceOptionsFrame_OpenToCategory(ChiBar.opanel)
  end,
  OnCancel = function()
      ChiBar:LockFrame()
	  InterfaceOptionsFrame_OpenToCategory(ChiBar.opanel)
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

-- PopUpHandling for Resetting
StaticPopupDialogs["CHIBAR_RESETFRAME"] = {
  text = ChiBarLocalization.OP_RESETTEXT,
  button1 = YES,
  button2 = NO,
  OnAccept = function()
      ChiBar:Reset()
  end,
  OnCancel = function()
	  InterfaceOptionsFrame_OpenToCategory(ChiBar.opanel)
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}


------------------------------------------
--		End of Script					--
------------------------------------------