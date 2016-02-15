-- Addon:	ChiBar: functional part
-- Author:	Fushui(EU-Azshara)
--
-- Using the Library:
-- NoTaint UIDropDownMenu by another@curse
-- http://wow.curseforge.com/addons/notaint-uidropdownmenu/
--

if select(2, UnitClass("player")) ~= "MONK" then
    return
end


------------------------------------------
--		Functions						--
------------------------------------------


-- Function for hiding/showing the Addon
function ChiBar:ValueChanged_Enable()
	if ChiBarDB.enable then
		ChiBar.mainFrame:Hide()
		ChiBarDB.enable = false
		print(ChiBarLocalization.HIDE:format())
		ChiBar:UnregisterEvents()
	else
		ChiBar:ShowMainFrame()
		ChiBarDB.enable = true
		print(ChiBarLocalization.SHOW:format())
		ChiBar:RegisterEvents()
	end
end


-- 
function ChiBar:ValueChanged_SeperateOpacity()
	if ChiBarDB.seperate then
		ChiBarDB.seperate = false
		ChiBar.Widgets.opacitySubTitle1:SetText(ChiBarLocalization.OP_OPACITYSUBTITLE1_1)
		ChiBar.Widgets.opacitySubTitle2:Hide()
		ChiBar.Widgets.opacitySlider2:Hide()
	else
		ChiBarDB.seperate = true
		ChiBar.Widgets.opacitySubTitle1:SetText(ChiBarLocalization.OP_OPACITYSUBTITLE1_2)
		ChiBar.Widgets.opacitySubTitle2:Show()
		ChiBar.Widgets.opacitySlider2:Show()
	end
	ChiBar.ChiBar:SetAlpha()
end


-- Function for showing mainFrame under conditions of autohide
function ChiBar:ShowMainFrame()
	if (ChiBarDB.autohide and not UnitAffectingCombat("player")) or UnitHasVehicleUI("player") then
		ChiBar.mainFrame:Hide()
	else
		ChiBar.mainFrame:Show()
	end
end


-- Function for setting the default parameters
function ChiBar:DefaultParameters()
	ChiBarDB = ChiBar.DBSTANDARDVALUES
end


-- Function for adding new saved Variables, if you're updating from a lower version of ChiBar
function ChiBar:VersionUpdate()
	for key, value in pairs(ChiBar.DBSTANDARDVALUES) do
        if ChiBarDB[key] == nil then
            ChiBarDB[key] = value
        end
    end
end


-- Funcion for confirming the data reset
function ChiBar:ConfirmReset()
	InterfaceOptionsFrame_Show()
	StaticPopup_Show("CHIBAR_RESETFRAME")
end


-- Funcion for the Colorpicker to open the ColorPicker
function ChiBar:OpenColorPicker()
	ColorPickerFrame:SetColorRGB(ChiBarDB.color[1], ChiBarDB.color[2], ChiBarDB.color[3], 1)
	ChiBar.oldColors = ChiBarDB.color
	ColorPickerFrame.hasOpacity = false
	ColorPickerFrame.previousValues = {ChiBarDB.color[1], ChiBarDB.color[2], ChiBarDB.color[3], 1}
	ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 
		ChiBar.ColorPickerSuccess, nil, ChiBar.ColorPickerCancel
	ColorPickerFrame:Hide()
	InterfaceOptionsFrame_Show()
	ColorPickerFrame:Show()
end


-- Funcion for the Colorpicker to save the chosen color
function ChiBar:ColorPickerSuccess()
	ChiBarDB.color[1], ChiBarDB.color[2], ChiBarDB.color[3] = ColorPickerFrame:GetColorRGB()
	ChiBar:ValueChanged_Color()
	if not ColorPickerFrame:IsShown() then InterfaceOptionsFrame_OpenToCategory(ChiBar.opanel) end
end


-- Funcion for the Colorpicker to pick the color
function ChiBar:ColorPickerCancel()
	local _
	ChiBarDB.color[1], ChiBarDB.color[2], ChiBarDB.color[3], _ = unpack(ColorPickerFrame.previousValues)
	ChiBar:ValueChanged_Color()
	InterfaceOptionsFrame_OpenToCategory(ChiBar.opanel)
end


--Funcion for the Colorpicker to change the color
function ChiBar:ValueChanged_Color()
	ChiBar.ChiBar:SetColor()
end


-- Funcion for the Colorpicker to reset the color
function ChiBar:ResetColor(sender)
	ChiBarDB.color = ChiBar.DBSTANDARDVALUES.color
	ChiBar:ValueChanged_Color()
	if sender then
		print(ChiBarLocalization.COLORRESET:format())
	end
end


-- Function for resetting the ChiBar
function ChiBar:Reset()
	ChiBar:DefaultParameters()
	ChiBar:RegisterEvents()
	ChiBar:ValueChange_SetTexture()
    ChiBar.mainFrame:ClearAllPoints()
	ChiBar.mainFrame:SetPoint(ChiBarDB.from, UIParent, ChiBarDB.to, ChiBarDB.x, ChiBarDB.y)
    ChiBar:ValueChanged_Orientation()
	ChiBar.mainFrame:SetScale(ChiBarDB.scale)
    ChiBar:ValueChanged_ChiBarOpacity()
    ChiBar:ValueChanged_ManaBarOpacity()
	ChiBar:ValueChanged_LayerLevel()
	ChiBar:ResetColor()
	ChiBar:ShowMainFrame()
	if ChiBarDB.hideStandard then
		MonkHarmonyBar:SetScript("OnShow", MonkHarmonyBar.Hide)
		MonkHarmonyBar:Hide()
	else
		MonkHarmonyBar:SetScript("OnShow", nil)
		MonkHarmonyBar:Show()
	end

    for key, value in pairs(ChiBar.Widgets) do
        if value.UpdateValue then
            value:UpdateValue()
        end
        ChiBar.Widgets.horizontalBox:UpdateValue(true)
        ChiBar.Widgets.righttopBox:UpdateValue(true)
    end
    
	if not ChiBarDB.seperate then
		ChiBar.Widgets.opacitySubTitle2:Hide()
		ChiBar.Widgets.opacitySlider2:Hide()
	end
    
    if not ChiBarDB.showMana then
		ChiBar.Widgets.manaOverlappingTitle:Hide()
		ChiBar.Widgets.manaOverlappingSlider:Hide()
	end

	print(ChiBarLocalization.RESET:format())
	InterfaceOptionsFrame_OpenToCategory(ChiBar.opanel)
end


-- Function for scaling the ChiBar
function ChiBar:ValueChanged_Scale()
	ChiBar.mainFrame:SetScale(ChiBarDB.scale)
end


-- Function for adjust the opacity of ChiBar
function ChiBar:ValueChanged_ChiBarOpacity()
	
	ChiBar.ChiBar:SetAlpha()
end


-- Set the orientation of ChiBar
function ChiBar:ValueChanged_Orientation()
	
    local maxChi = UnitPowerMax("player", ChiBar.CLASSPOWERID)
    
    ChiBar.ChiBar:StructureUpdate(ChiBar.mainFrame, maxChi, ChiBarDB.grow1, ChiBarDB.grow2, ChiBar.BUBBLEDIM+ChiBarDB.offset, (6-maxChi)*ChiBar.BUBBLEDIM/2)
    ChiBar.ManaBar:StructureUpdate(ChiBar.mainFrame, maxChi, ChiBarDB.grow1, ChiBarDB.grow2, ChiBar.BUBBLEDIM+ChiBarDB.offset, (6-maxChi)*ChiBar.BUBBLEDIM/2, ChiBarDB.manaBarOverlapping)
    ChiBar.BGTextures:StructureUpdate(ChiBar.mainFrame, ChiBarDB.grow1, ChiBarDB.grow2, ChiBarDB.offset)
end


-- Function for updating the layerlevel of ChiBar
function ChiBar:ValueChanged_LayerLevel()
	ChiBar.ChiBar:SetLayer(ChiBarDB.strata, ChiBarDB.mainLayer)
    ChiBar.ManaBar:SetLayer(ChiBarDB.strata, ChiBarDB.mainLayer)
    ChiBar.BGTextures:SetLayer(ChiBarDB.strata, ChiBarDB.mainLayer)
end


-- Function for update the GUI on Talentchange (Ascension)
function ChiBar:OnEvent_StructureUpdate()
	local maxChi = UnitPowerMax("player", ChiBar.CLASSPOWERID)
	ChiBar.ChiBar:SetMaxChi(maxChi)
	ChiBar.ChiBar:StructureUpdate(ChiBar.mainFrame, maxChi, ChiBarDB.grow1, ChiBarDB.grow2, ChiBar.BUBBLEDIM+ChiBarDB.offset, (6-maxChi)*ChiBar.BUBBLEDIM/2)
    ChiBar.ManaBar:StructureUpdate(ChiBar.mainFrame, maxChi, ChiBarDB.grow1, ChiBarDB.grow2, ChiBar.BUBBLEDIM+ChiBarDB.offset, (6-maxChi)*ChiBar.BUBBLEDIM/2, ChiBarDB.manaBarOverlapping)
end


-- Function for updating the horizontal/vertical orientation
function ChiBar:ValueChanged_Growth1()
	if ChiBarDB.grow1 then
		ChiBarDB.grow1 = false
		ChiBar.Widgets.leftbottomBox.text:SetText(ChiBarLocalization.OP_GROW_TOP)
		ChiBar.Widgets.righttopBox.text:SetText(ChiBarLocalization.OP_GROW_BOTTOM)
		ChiBar.Widgets.verticalBox:UpdateValue()
		ChiBar.Widgets.horizontalBox:UpdateValue()
	else
		ChiBarDB.grow1 = true
		ChiBar.Widgets.leftbottomBox.text:SetText(ChiBarLocalization.OP_GROW_RIGHT)
		ChiBar.Widgets.righttopBox.text:SetText(ChiBarLocalization.OP_GROW_LEFT)
		ChiBar.Widgets.verticalBox:UpdateValue()
		ChiBar.Widgets.horizontalBox:UpdateValue()
	end
	ChiBar:ValueChanged_Orientation()
end


-- Function for updating the grow direction
function ChiBar:ValueChanged_Growth2()
	if ChiBarDB.grow2 then
		ChiBarDB.grow2 = false
		ChiBar.Widgets.leftbottomBox.element:SetChecked(ChiBarDB.grow2)
		ChiBar.Widgets.righttopBox.element:SetChecked(not ChiBarDB.grow2)
	else
		ChiBarDB.grow2 = true
		ChiBar.Widgets.leftbottomBox.element:SetChecked(ChiBarDB.grow2)
		ChiBar.Widgets.righttopBox.element:SetChecked(not ChiBarDB.grow2)
	end
	ChiBar:ValueChanged_Orientation()
end


-- Function for toggle Autohide out of Combat
function ChiBar:ValueChanged_Autohide()
	if ChiBarDB.autohide then
		ChiBarDB.autohide = false
		ChiBar:ShowMainFrame()
		print(ChiBarLocalization.AUTOHIDE_OFF:format())
	else
		ChiBarDB.autohide = true
		ChiBar:ShowMainFrame()
		print(ChiBarLocalization.AUTOHIDE_ON:format())
	end
end


--
function ChiBar:ValueChanged_ManaBarOpacity()
    ChiBar.ManaBar:SetNewAlpha()
end


--
function ChiBar:ValueChange_SetTexture()
    ChiBar.ChiBar:SetTexture()
end


-- Function for enable Lock
function ChiBar:LockFrame()
	local _
	ChiBar.mainFrame:SetMovable(false)
	ChiBar.mainFrame:EnableMouse(false)
	ChiBarDB.from, _, ChiBarDB.to, ChiBarDB.x, ChiBarDB.y = ChiBar.mainFrame:GetPoint()
	ChiBar:ShowMainFrame()
	ChiBar.BGTextures:Hide()
	print(ChiBarLocalization.LOCK:format())
end


-- Function for disable Lock
function ChiBar:UnlockFrame()
	InterfaceOptionsFrame_Show() 
	ChiBar.mainFrame:SetMovable(true)
	ChiBar.mainFrame:EnableMouse(true)
	ChiBar.mainFrame:Show()
	StaticPopup_Show("CHIBAR_UNLOCKFRAME")
	ChiBar.BGTextures:Show()
	print(ChiBarLocalization.UNLOCK:format())
end


--Function for hiding the standard chibar
function ChiBar:ValueChanged_HideStandard()
	if ChiBarDB.hideStandard then
		ChiBarDB.hideStandard = false
		MonkHarmonyBar:SetScript("OnShow", nil)
		MonkHarmonyBar:Show()
	else
		ChiBarDB.hideStandard = true
		MonkHarmonyBar:SetScript("OnShow", MonkHarmonyBar.Hide)
		MonkHarmonyBar:Hide()
	end
end


--
function ChiBar:ValueChanged_HideManaBar()
    if ChiBarDB.showMana then
        ChiBarDB.showMana = false
        ChiBar.ManaBar:Hide()
    else
        ChiBarDB.showMana = true
        ChiBar.ManaBar:Show()
    end
end


-- Function for starting up the Addon
function ChiBar:InitialStartUp()
	if ChiBarDB == nil then
        print("Creating ChiBarDB")
        ChiBar:DefaultParameters()
    end
    
    ChiBar:VersionUpdate()
    ChiBar:CreateUI()
    ChiBar:CreateOptionsUI()
    
    print(ChiBar.VERSIONTEXT_1:format())
    print(ChiBarLocalization.GREETINGS:format())
    ChiBar.mainFrame:UnregisterEvent("ADDON_LOADED")
    ChiBar:ShowMainFrame()
    
    if not ChiBarDB.enable then
        ChiBar.mainFrame:Hide()
        ChiBar.UnregisterEvents()
    end
    
    if ChiBarDB.hideStandard then
        MonkHarmonyBar:Hide()
        MonkHarmonyBar:SetScript("OnShow", MonkHarmonyBar.Hide)
    end
    
    if ChiBarDB.showMana then
        ChiBar.ManaBar:Show()
    else
        ChiBar.ManaBar:Hide()
    end
end


------------------------------------------
--		EventHandling					--
------------------------------------------


function ChiBar_OnEvent(self, event, arg1, arg2, ...)
	-- Player entered Vehicle
	if event == "UNIT_ENTERED_VEHICLE" and arg1 == "player" then
		ChiBar:ShowMainFrame()
		
	-- Player exit Vehicle
	elseif event == "UNIT_EXITED_VEHICLE" and arg1 == "player" then
		ChiBar:ShowMainFrame()
		
	-- Player enter Combat while Autohide is on
	elseif event == "PLAYER_REGEN_DISABLED" then
		ChiBar:ShowMainFrame()
		
	-- Player exit Combat while Autohide is on
	elseif event == "PLAYER_REGEN_ENABLED" then
		ChiBar:ShowMainFrame()
        --if ChiBar.openAfterCombat then
        --    ChiBar.openAfterCombat = nil
        --    ChiBar:OpenOptionWindow()
        --end
		
	-- Player changed Talents
	elseif event == "UNIT_MAXPOWER" then
        ChiBar.ChiBar:Update()
        ChiBar:OnEvent_StructureUpdate()
		
	-- Player's Chi changed
	elseif event == "UNIT_POWER_FREQUENT" and arg1 == "player" and arg2 == "CHI" then
		ChiBar.ChiBar:Update()
    
    -- Player's Mana changed
	elseif event == "UNIT_POWER_FREQUENT" and arg1 == "player" and arg2 == "MANA" then
		ChiBar.ManaBar:Update()
        
    -- Player's Energy changed
	elseif event == "UNIT_POWER_FREQUENT" and arg1 == "player" and arg2 == "ENERGY" then
		ChiBar.ManaBar:Update()
		
	-- Player's main resource changed (e.g. if you change stance)
	elseif event == "UNIT_DISPLAYPOWER" and arg1 == "player" then
        ChiBar.ManaBar:SetPowerType()
        ChiBar.ManaBar:Update()
		ChiBar.ChiBar:Update()
		
	-- Player enters PetBattle
	elseif event == "PET_BATTLE_OPENING_START" then
		ChiBar.mainFrame:Hide()
		
	-- Player exits PetBattle
	elseif event == "PET_BATTLE_CLOSE" then
		ChiBar:ShowMainFrame()
		
	-- Player logging in - only used because UnitPowerMax() returns 0 after ADDON_LOADED
	elseif event == "PLAYER_LOGIN" then
		ChiBar.mainFrame:UnregisterEvent("PLAYER_LOGIN")
		ChiBar:OnEvent_StructureUpdate()
		ChiBar.ChiBar:Update()
        ChiBar.ManaBar:SetPowerType()
        ChiBar.ManaBar:Update()
		
	-- initial loading of the addon'S settings after loading the scriptfiles
	elseif event == "ADDON_LOADED" and arg1 == "ChiBar" then
		ChiBar:InitialStartUp()
	end
end


-- Function for registering Events
function ChiBar:UnregisterEvents()
    local index
	for index = 1, #ChiBar.EVENTS do
        ChiBar.mainFrame:UnregisterEvent(ChiBar.EVENTS[index])
    end
end


-- Function for unregistering Events
function ChiBar:RegisterEvents()
    local index
	for index = 1, #ChiBar.EVENTS do
        ChiBar.mainFrame:RegisterEvent(ChiBar.EVENTS[index])
    end
end


--
function ChiBar:OpenOptionWindow()
    if ChiBar.FIRST_SLASH_START == 0 then
        ChiBar.FIRST_SLASH_START = 1
        InterfaceOptionsFrame_OpenToCategory(ChiBar.opanel)
    end
    InterfaceOptionsFrame_OpenToCategory(ChiBar.opanel)
end

-- Registring Events the UI should react to -- Actually the fist executed code of the Addon!
ChiBar.mainFrame:RegisterEvent("ADDON_LOADED")
ChiBar.mainFrame:RegisterEvent("PLAYER_LOGIN")
ChiBar:RegisterEvents()
ChiBar.mainFrame:SetScript("OnEvent", ChiBar_OnEvent)
ChiBar.mainFrame:SetScript("OnDragStart", ChiBar.mainFrame.StartMoving)
ChiBar.mainFrame:SetScript("OnDragStop", ChiBar.mainFrame.StopMovingOrSizing)


------------------------------------------
--		SlashCommand					--
------------------------------------------

SLASH_CHIBAR1 = "/cb"
SLASH_CHIBAR2 = "/chibar"
SlashCmdList["CHIBAR"] = function(msg)
    --if not UnitAffectingCombat("player") then
        ChiBar:OpenOptionWindow()
    --else
    --    print(ChiBarLocalization.OPENINCOMBAT:format())
    --    ChiBar.OpenAfterCombat = 1
    --end
end


------------------------------------------
--		End of Script					--
------------------------------------------