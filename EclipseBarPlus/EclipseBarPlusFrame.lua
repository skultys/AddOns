-- Load the Ace libraries --
EclipseBarPlus = LibStub("AceAddon-3.0"):NewAddon("EclipseBarPlus", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("EclipseBarPlus")

-- Create the default settings for this addon --
local defaults = { 
    profile =  {
    scale = 1,
    alpha = 1,
    font_size = 12,
    show_power = true,
    show_percentage = false,
    negative_power = false,
    locked = false,
    hide_blizzard_bar = true,
    hide_out_combat = false,
    only_boomkin = false,
    position = {
      POINT = "CENTER",
      RELATIVE = "CENTER",
      XCOORD = 0,
      YCOORD = 1
    },
    },
}

-- Create the options variable to use in the config screen --
local options = {
  name = "Eclipse Bar Plus",
  handler = EclipseBarPlus,
  type = "group",
  args = {
    locked = {
      type = "toggle",
      name = L["Lock"],
      desc = L["Locks the eclipse bar, preventing it from moving"],
      set = function(info, value)
        -- Save variable
        EclipseBarPlus.db.profile.locked = value
      
        -- Apply to frame
        if value then
          EclipseBarPlusFrame:EnableMouse(false)
        else
          EclipseBarPlusFrame:EnableMouse(true)
        end
      end,
      get = function(info)
        return EclipseBarPlus.db.profile.locked
      end,
      width = "full",
      order = 10,
    },
    hide_blizzard_bar = {
      type = "toggle",
      name = L["Hide Blizzard Eclipse Bar"],
      desc = L["Hides the original Eclipse Bar from Blizzard"],
      set = function(info, value)
        -- Save variable
        EclipseBarPlus.db.profile.hide_blizzard_bar = value
      
        -- Apply to frame
        if value then
          EclipseBarFrame:Hide();
        else
          EclipseBarFrame:Show();
        end
      end,
      get = function(info)
        return EclipseBarPlus.db.profile.hide_blizzard_bar
      end,
      width = "full",
      order = 20,
    },
    only_boomkin = {
      type = "toggle",
      name = L["Only show the Eclipse Bar when in Moonkin form"],
      desc = L["Enabling this hides the Eclipse Bar when shifting out of the Moonkin form"],
      set = function(info, value)
        -- Save variable
        EclipseBarPlus.db.profile.only_boomkin = value
        
        -- Apply to frame
        if UnitAffectingCombat('self') == false and EclipseBarPlus.db.profile.hide_out_combat == true then
          EclipseBarPlusFrame:Hide();
        elseif GetShapeshiftFormID() ~= MOONKIN_FORM and EclipseBarPlus.db.profile.only_boomkin == true then
          EclipseBarPlusFrame:Hide();
        elseif GetSpecialization() == 1 then
          EclipseBarPlusFrame:Show()
        end
      end,
      get = function(info)
        return EclipseBarPlus.db.profile.only_boomkin
      end,
      width = "full",
      order = 22,
    },
    hide_out_combat = {
      type = "toggle",
      name = L["Only show the Eclipse Bar in combat"],
      desc = L["Enabling this hides the Eclipse Bar when leaving combat and showing it again when you enter combat"],
      set = function(info, value)
        -- Save variable
        EclipseBarPlus.db.profile.hide_out_combat = value
        
        -- Apply to frame
        
        if UnitAffectingCombat('self') == false and EclipseBarPlus.db.profile.hide_out_combat == true then
          EclipseBarPlusFrame:Hide();
        elseif GetShapeshiftFormID() ~= MOONKIN_FORM and EclipseBarPlus.db.profile.only_boomkin == true then
          EclipseBarPlusFrame:Hide();
        elseif GetSpecialization() == 1 then
          EclipseBarPlusFrame:Show()
        end
      end,
      get = function(info)
        return EclipseBarPlus.db.profile.hide_out_combat
      end,
      width = "full",
      order = 25,
    },
    scale = {
      type = "range",
      name = L["Scale"],
      desc = L["Scale of the frame"],
      set = function(info, value)
        -- Save variable
        EclipseBarPlus.db.profile.scale = value
        
        -- Apply the new scale
        EclipseBarPlusFrame:SetScale(value)
      end,
      get = function(info)
        return EclipseBarPlus.db.profile.scale
      end,
      min = 0,
      max = 10,
      step = 0.1,
      order = 15,
      order = 30,
    },
    alpha = {
      type = "range",
      name = L["Opacity"],
      desc = L["Opacity of the frame"],
      set = function(info, value)
        -- Save variable
        EclipseBarPlus.db.profile.alpha = value
        
        -- Apply the new scale
        EclipseBarPlusFrame:SetAlpha(value)
      end,
      get = function(info)
        return EclipseBarPlus.db.profile.alpha
      end,
      min = 0,
      max = 1,
      step = 0.1,
      order = 15,
      order = 30,
    },
    power_group = {
      type = "group",
      name = L["Power text options"],
      inline = true,
      order = 50,
      args = {
        show_power = {
          type = "toggle",
          name = L["Show power text"],
          desc = L["Wether or not to display the power text on the eclipse bar"],
          set = function(info, value)
            -- Save variable
            EclipseBarPlus.db.profile.show_power = value
      
            -- Apply to the power text
            if value == true then
              EclipseBarPlusFrame.powerText:Show()
            else
              EclipseBarPlusFrame.powerText:Hide()
            end
          end,
          get = function(info)
            return EclipseBarPlus.db.profile.show_power
          end,
          width = "full",
          order = 10,
        },
        negative_power = {
          type = "toggle",
          name = L["Display Lunar power as a negative number"],
          desc = L["Display Lunar power as a negative number. So the power on the bar is negative when approaching lunar power and becomes positive when approaching solar power."],
          set = function(info, value)
            -- Save variable
            EclipseBarPlus.db.profile.negative_power = value
          end,
          get = function(info)
            return EclipseBarPlus.db.profile.negative_power
          end,
          width = "full",
          disabled = function() return not EclipseBarPlus.db.profile.show_power end,
          order = 20,
        },
        show_percentage = {
          type = "toggle",
          name = L["Show power text as percentage"],
          desc = L["Shows power text as a percentage instead of an absolute number."],
          set = function(info, value)
            -- Save variable
            EclipseBarPlus.db.profile.show_percentage = value
          end,
          get = function(info)
            return EclipseBarPlus.db.profile.show_percentage
          end,
          width = "full",
          disabled = function() return not EclipseBarPlus.db.profile.show_power end,
          order = 30,
        },
        font_size = {
          type = "range",
          name = L["Scale the size of the font"],
          desc = L["Change the font size of the power indicator."],
          set = function(info, value)
            -- Save variable
            EclipseBarPlus.db.profile.font_size = value
            
            -- Apply the new scale
            EclipseBarPlusFrame.powerText:SetTextHeight(value)
            EclipseBarPlusFrame.powerText:SetPoint("CENTER","EclipseBarPlusFrame",0,0)
          end,
          get = function(info)
            return EclipseBarPlus.db.profile.font_size
          end,
          min = 2,
          max = 40,
          step = 1,
          order = 40,
          disabled = function() return not EclipseBarPlus.db.profile.show_power end,
        },
      },
    },
  },
}

local options_2 = { name = "Eclipse Bar Plus", handler = EclipseBarPlus, type = "group", args = { not_druid = { type = "header", name = L["Character is not a Druid"], }, }, } 

EclipseBarPlus.ECLIPSE_MARKER_COORDS =  {};
EclipseBarPlus.ECLIPSE_MARKER_COORDS["none"]       = { 0.914, 1.0, 0.82, 1.0 }; 
EclipseBarPlus.ECLIPSE_MARKER_COORDS["sun"]        = { 0.914, 1.0, 0.641, 0.82 }; 
EclipseBarPlus.ECLIPSE_MARKER_COORDS["moon"]   = { 1.0, 0.914, 0.641, 0.82 };

function EclipseBarPlus:OnInitialize()
  -- Called when the addon is loaded
  self.db = LibStub("AceDB-3.0"):New("EclipseBarPlusDB", defaults, "Default")

  -- LibStub("AceConfig-3.0"):RegisterOptionsTable("EclipseBarPlusDB", options)
  if ( select(2, UnitClass("player")) == "DRUID" ) then LibStub("AceConfig-3.0"):RegisterOptionsTable("EclipseBarPlusDB", options) else LibStub("AceConfig-3.0"):RegisterOptionsTable("EclipseBarPlusDB", options_2) end
  
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("EclipseBarPlusDB", "Eclipse Bar Plus")
  self:RegisterChatCommand("ebp", "ChatCommand")
  self:RegisterChatCommand("eclipsebarplus", "ChatCommand")
  
  -- Set the position
  local pos = self.db.profile.position
  EclipseBarPlusFrame:SetMovable(true)
  EclipseBarPlusFrame:ClearAllPoints()
  EclipseBarPlusFrame:SetPoint(pos["POINT"], "UIParent", pos["RELATIVE"], pos["XCOORD"], pos["YCOORD"])
  
  -- Set the scale and opacity
  EclipseBarPlusFrame:SetScale(self.db.profile.scale)
  EclipseBarPlusFrame:SetAlpha(self.db.profile.alpha)
  
  -- Set the font scale
  EclipseBarPlusFrame.powerText:SetTextHeight(self.db.profile.font_size)
  
  -- Set the lock
  if self.db.profile.locked then
    EclipseBarPlusFrame:EnableMouse(false)
  else
    EclipseBarPlusFrame:EnableMouse(true)
  end
  
  if UnitAffectingCombat('self') == false and EclipseBarPlus.db.profile.hide_out_combat == true then
    EclipseBarPlusFrame:Hide();
  end
  
  if GetShapeshiftFormID() ~= MOONKIN_FORM and EclipseBarPlus.db.profile.only_boomkin == true then
    EclipseBarPlusFrame:Hide();
  end
    
end

function EclipseBarPlus:OnDragStart()
  -- Called when addon is moving
  EclipseBarPlusFrame:StartMoving()
end

function EclipseBarPlus:OnDragStop()
  -- Called when addon stops moving
  EclipseBarPlusFrame:StopMovingOrSizing()
  
  -- Save the current position
  local pos = {}
  pos["POINT"], _, pos["RELATIVE"], pos["XCOORD"], pos["YCOORD"] = EclipseBarPlusFrame:GetPoint()
  self.db.profile.position = pos
end

function EclipseBarPlus:ChatCommand(input)
  -- Open dialog if no parameters, else do something with the parameters
  if not input or input:trim() == "" then
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
  else
    LibStub("AceConfigCmd-3.0").HandleCommand(SpamageMeters, "ebp", "EclipseBarPlus", input)
  end
end

function EclipseBarPlus:UpdateShown(frame, event)
  if OverrideActionBar:IsShown() then
    return;
  end
  
  -- Disable rune frame if not a DRUID.
  local _, class = UnitClass("player");
  local form  = GetShapeshiftFormID();

  if class == "DRUID" and (form == MOONKIN_FORM or not form) then
    if GetSpecialization() == 1 then
      if self.db.profile.show_power then
        frame.powerText:Show();
        frame.lockShow = true;
      else
        frame.powerText:Hide();
        frame.lockShow = false;
      end

      if self.db.profile.hide_blizzard_bar then
        EclipseBarFrame:Hide(); -- Hide Blizzard Eclipse Bar
      end
      
      if GetShapeshiftFormID() ~= MOONKIN_FORM and self.db.profile.only_boomkin == true then
        frame:Hide();
      else
        if self.db.profile.hide_out_combat == true and event == "PLAYER_REGEN_ENABLED" then
          frame:Hide();
        elseif self.db.profile.hide_out_combat == true and event == "PLAYER_REGEN_DISABLED" then
          frame:Show();
        else
          frame:Show();
        end
      end
    else
      frame:Hide();
    end
  else
    frame:Hide();
  end
  
  PlayerFrame_AdjustAttachments();
end

function EclipseBarPlus:Update(frame)
  local power = UnitPower( PlayerFrame.unit, SPELL_POWER_ECLIPSE );
  local maxPower = UnitPowerMax( PlayerFrame.unit, SPELL_POWER_ECLIPSE );
  if maxPower == 0 then
    return;--catch divide by zero
  end
  
  if self.db.profile.show_percentage then
    if self.db.profile.negative_power then
      frame.powerText:SetText((power/maxPower*100).."%");
    else
      frame.powerText:SetText(abs(power/maxPower*100).."%");
    end
  else
    if self.db.profile.negative_power then
      frame.powerText:SetText(power);
    else
      frame.powerText:SetText(abs(power));
    end
  end

  local xpos =  ECLIPSE_BAR_TRAVEL*(power/maxPower)
  frame.marker:SetPoint("CENTER", xpos, 0);
end

function EclipseBarPlus:OnLoad(frame)
  -- Only load this addon is the character is a Druid
  if ( select(2, UnitClass("player")) ~= "DRUID" ) then return end

  -- Register the events we want to use
  frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
  frame:RegisterEvent("PLAYER_TALENT_UPDATE");  
--  frame:RegisterEvent("MASTERY_UPDATE");
  frame:RegisterEvent("CVAR_UPDATE"); 
  frame:RegisterEvent("UNIT_AURA");
  frame:RegisterEvent("ECLIPSE_DIRECTION_CHANGE");
  
  frame:RegisterEvent("PLAYER_REGEN_DISABLED");
  frame:RegisterEvent("PLAYER_REGEN_ENABLED");
  
  frame:RegisterForDrag("LeftButton");
  
--  frame.lockShow = false;

--  frame.sunBar:SetAlpha(0);
--  frame.moonBar:SetAlpha(0);
--  frame.darkSun:SetAlpha(0);
--  frame.darkMoon:SetAlpha(0);
--  frame.glow:SetAlpha(0);
end


function EclipseBarPlus:CheckBuffs (frame) 
  if not frame:IsShown() then
    return;
  end
  
  local hasLunarEclipse = false;
  local hasSolarEclipse = false;

  local unit = PlayerFrame.unit;
  local j = 1;
  local name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff(unit, j);
  while name do 
    if spellID == ECLIPSE_BAR_SOLAR_BUFF_ID then
      hasSolarEclipse = true;
    elseif spellID == ECLIPSE_BAR_LUNAR_BUFF_ID then
      hasLunarEclipse = true;
    end
    j=j+1;
    name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff(unit, j);
  end

  if hasLunarEclipse then
    frame.glow:ClearAllPoints();
    local glowInfo = ECLIPSE_ICONS["moon"].big;
    frame.glow:SetPoint("CENTER", frame.moon, "CENTER", 0, 0);
    frame.glow:SetWidth(glowInfo.x);
    frame.glow:SetHeight(glowInfo.y);
    frame.glow:SetTexCoord(glowInfo.left, glowInfo.right, glowInfo.top, glowInfo.bottom);

    if frame.moonDeactivate:IsPlaying() then
      frame.moonDeactivate:Stop();
    end

    if not frame.moonActivate:IsPlaying() and hasLunarEclipse ~= frame.hasLunarEclipse then
      frame.moonActivate:Play();
    end
  else
    if frame.moonActivate:IsPlaying() then
      frame.moonActivate:Stop();
    end

    if not frame.moonDeactivate:IsPlaying() and hasLunarEclipse ~= frame.hasLunarEclipse then
      frame.moonDeactivate:Play();
    end
  end
  
  if hasSolarEclipse then
    frame.glow:ClearAllPoints();
    local glowInfo = ECLIPSE_ICONS["sun"].big;
    frame.glow:SetPoint("CENTER", frame.sun, "CENTER", 0, 0);
    frame.glow:SetWidth(glowInfo.x);
    frame.glow:SetHeight(glowInfo.y);
    frame.glow:SetTexCoord(glowInfo.left, glowInfo.right, glowInfo.top, glowInfo.bottom);

    if frame.sunDeactivate:IsPlaying() then
      frame.sunDeactivate:Stop();
    end

    if not frame.sunActivate:IsPlaying() and hasSolarEclipse ~= frame.hasSolarEclipse then
      frame.sunActivate:Play();
    end
  else
    if frame.sunActivate:IsPlaying() then
      frame.sunActivate:Stop();
    end

    if not frame.sunDeactivate:IsPlaying() and hasSolarEclipse ~= frame.hasSolarEclipse then
      frame.sunDeactivate:Play();
    end
  end

  frame.hasLunarEclipse = hasLunarEclipse;
  frame.hasSolarEclipse = hasSolarEclipse;
end 

function EclipseBarPlus:OnShow(frame)

  local direction = GetEclipseDirection();
  if direction then
    frame.marker:SetTexCoord( unpack(EclipseBarPlus.ECLIPSE_MARKER_COORDS[direction]));
  end

  local hasLunarEclipse = false;
  local hasSolarEclipse = false;

  local unit = PlayerFrame.unit;
  local j = 1;
  local name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff(unit, j);
  while name do 
    if spellID == ECLIPSE_BAR_SOLAR_BUFF_ID then
      hasSolarEclipse = true;
    elseif spellID == ECLIPSE_BAR_LUNAR_BUFF_ID then
      hasLunarEclipse = true;
    end
    j=j+1;
    name, _, _, _, _, _, _, _, _, _, spellID = UnitBuff(unit, j);
  end

  if hasLunarEclipse then
    frame.glow:ClearAllPoints();
    local glowInfo = ECLIPSE_ICONS["moon"].big;
    frame.glow:SetPoint("CENTER", frame.moon, "CENTER", 0, 0);
    frame.glow:SetWidth(glowInfo.x);
    frame.glow:SetHeight(glowInfo.y);
    frame.glow:SetTexCoord(glowInfo.left, glowInfo.right, glowInfo.top, glowInfo.bottom);
    frame.sunBar:SetAlpha(0);
    frame.darkMoon:SetAlpha(0);
    frame.moonBar:SetAlpha(1);
    frame.darkSun:SetAlpha(1);
    frame.glow:SetAlpha(1);
    frame.glow.pulse:Play();  
  elseif hasSolarEclipse then
    frame.glow:ClearAllPoints();
    local glowInfo = ECLIPSE_ICONS["sun"].big;
    frame.glow:SetPoint("CENTER", frame.sun, "CENTER", 0, 0);
    frame.glow:SetWidth(glowInfo.x);
    frame.glow:SetHeight(glowInfo.y);
    frame.glow:SetTexCoord(glowInfo.left, glowInfo.right, glowInfo.top, glowInfo.bottom);
    frame.moonBar:SetAlpha(0);
    frame.darkSun:SetAlpha(0);
    frame.sunBar:SetAlpha(1);
    frame.darkMoon:SetAlpha(1);
    frame.glow:SetAlpha(1);
    frame.glow.pulse:Play();
  else
    frame.sunBar:SetAlpha(0);
    frame.moonBar:SetAlpha(0);
    frame.darkSun:SetAlpha(0);
    frame.darkMoon:SetAlpha(0);
    frame.glow:SetAlpha(0);
  end

  frame.hasLunarEclipse = hasLunarEclipse;
  frame.hasSolarEclipse = hasSolarEclipse;

  self:Update(frame);
end

function EclipseBarPlus:OnEvent (frame, event, ...)
  if event == "UNIT_AURA" then
    local arg1 = ...;
    if arg1 ==  PlayerFrame.unit then
      self:CheckBuffs(frame);
    end
  elseif event == "ECLIPSE_DIRECTION_CHANGE" then
    local status = ...;
    frame.marker:SetTexCoord(unpack(EclipseBarPlus.ECLIPSE_MARKER_COORDS[status]));
  else
    self:UpdateShown(frame, event);
  end
end



