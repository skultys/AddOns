
local DF = _G ["DetailsFramework"]
if (not DF) then
	print ("|cFFFFAA00FlashTaskBar: framework not found, if you just installed or updated the addon, please restart your client.|r")
	return
end

local _

local L = LibStub ("AceLocale-3.0"):GetLocale ("FlashTaskbarLocales", true)
if (not L) then
	DF:ShowPanicWarning ("FlashTaskbar Locale failed to load, restart your game client to finish addon updates.")
	return
end

do
	local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
	SharedMedia:Register ("sound", "d_whip1", [[Interface\Addons\FlashTaskBar\sounds\sound_whip1.ogg]])
end

local default_config = {
	profile = {
		readycheck = true,
		arena_queue = true,
		group_queue = true,
		petbattle_queue = true,
		brawlers_queue = true,
		pull_timers = true,
		enter_combat = false,
		end_taxi = false,
		chat_scan = false,
		chat_scan_keywords = {},
		combat_log = false,
		combat_log_keywords = {},
		rare_scan = true,
		any_rare = true,
		rare_names = {},
		disconnect_logout = false,
		invite = true,
		invite_ignore_on_autoaccept = false,
		trade = true,
		bags_full = false,
		worldpvp = true,
		duel_request = true,
		summon = true,
		sound_enabled = {
			readycheck = {enabled = false, sound = "d_whip1"},
			arena_queue = {enabled = false, sound = "d_whip1"},
			group_queue = {enabled = false, sound = "d_whip1"},
			petbattle_queue = {enabled = false, sound = "d_whip1"},
			brawlers_queue = {enabled = false, sound = "d_whip1"},
			pull_timers = {enabled = false, sound = "d_whip1"},
			enter_combat = {enabled = false, sound = "d_whip1"},
			end_taxi = {enabled = false, sound = "d_whip1"},
			chat_scan = {enabled = false, sound = "d_whip1"},
			combat_log = {enabled = false, sound = "d_whip1"},
			rare_scan = {enabled = false, sound = "d_whip1"},
			disconnect_logout = {enabled = false, sound = "d_whip1"},
			invite = {enabled = false, sound = "d_whip1"},
			trade = {enabled = false, sound = "d_whip1"},
			bags_full = {enabled = false, sound = "d_whip1"},
			worldpvp = {enabled = false, sound = "d_whip1"},
			duel_request = {enabled = false, sound = "d_whip1"},
			summon = {enabled = false, sound = "d_whip1"},
		},
	}
}

local options_table = {
	name = "FlashTaskBar",
	type = "group",
	args = {

	}
}

local FlashTaskBar = DF:CreateAddOn ("FlashTaskBar", "FlashTaskbarDB", default_config, options_table)
local lower = string.lower

FlashTaskBar.last_flash = 0

function FlashTaskBar:DoFlash (config_key)
	if (FlashTaskBar.last_flash + 4 < GetTime()) then
		FlashClientIcon()
		local has_sound = FlashTaskBar.db.profile.sound_enabled
		if (has_sound and has_sound [config_key] and has_sound [config_key].enabled) then
			local file = LibStub:GetLibrary("LibSharedMedia-3.0"):Fetch ("sound", has_sound [config_key].sound)
			PlaySoundFile (file, "Master")
		end
		FlashTaskBar.last_flash = GetTime()
	end
end

--[[ debug
local a = function()
	FlashTaskBar:DoFlash ("trade")
end
C_Timer.After (5, a)
--]]

function FlashTaskBar.OnInit (self)

	--invite
	function FlashTaskBar:DelayInviteCheck()
		if (IsInGroup() or IsInRaid()) then
			return
		else
			FlashTaskBar:DoFlash("invite")
		end
	end
	function FlashTaskBar:PARTY_INVITE_REQUEST()
		if (FlashTaskBar.db.profile.invite) then
			if (FlashTaskBar.db.profile.invite_ignore_on_autoaccept) then
				FlashTaskBar:ScheduleTimer ("DelayInviteCheck", 1.5)
			else
				FlashTaskBar:DoFlash("invite")
			end
		end
	end
	FlashTaskBar:RegisterEvent ("PARTY_INVITE_REQUEST")
	
	--pet battle queue
	function FlashTaskBar:CheckPetBattleQueue()
		if (PetBattleQueueReadyFrame and PetBattleQueueReadyFrame:IsShown()) then
			FlashTaskBar:DoFlash("petbattle_queue")
		end
	end
	function FlashTaskBar:PET_BATTLE_QUEUE_STATUS (...)
		if (FlashTaskBar.db.profile.petbattle_queue) then
			FlashTaskBar:ScheduleTimer ("CheckPetBattleQueue", 1.5)
		end
	end
	FlashTaskBar:RegisterEvent ("PET_BATTLE_QUEUE_STATUS")

	--premade groups ready
	hooksecurefunc ("LFGListInviteDialog_Show", function()
		if (FlashTaskBar.db.profile.group_queue) then
			FlashTaskBar:DoFlash("group_queue")
			FlashTaskBar.last_flash = 0
		end
	end)
	
	--lfg lfpvp windows
	hooksecurefunc ("LFGDungeonReadyStatus_ResetReadyStates", function()
		if (FlashTaskBar.db.profile.group_queue) then
			FlashTaskBar:DoFlash("group_queue")
			FlashTaskBar.last_flash = 0
		end
	end)
	hooksecurefunc ("PVPReadyDialog_Display", function()
		if (FlashTaskBar.db.profile.arena_queue) then
			FlashTaskBar:DoFlash("arena_queue")
			FlashTaskBar.last_flash = 0
		end
	end)
	
	--game master
	hooksecurefunc ("HelpFrame_OnEvent", function (self, token)
		if (token == "GMRESPONSE_RECEIVED") then
			FlashTaskBar:DoFlash("")
		end
	end)
	--hooksecurefunc ("GMChatFrame_OnEvent", function (self, event, ...)
	--	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...;
	--	if (event == "CHAT_MSG_WHISPER" and arg6 == "GM") then
	--		FlashTaskBar:DoFlash("")
	--	end
	--end)
	
	--general alerts
	hooksecurefunc ("StaticPopup_Show", function (token, text_arg1, text_arg2, data, insertedFrame)
		if (token == "BFMGR_INVITED_TO_ENTER") then --> generic world pvp alert
			if (FlashTaskBar.db.profile.worldpvp) then
				FlashTaskBar:DoFlash("worldpvp")
			end
		
		elseif (token == "DUEL_REQUESTED" or token == "PET_BATTLE_PVP_DUEL_REQUESTED") then
			if (FlashTaskBar.db.profile.duel_request) then
				FlashTaskBar:DoFlash("duel_request")
			end
		
		elseif (token == "CONFIRM_SUMMON" or token == "CONFIRM_SUMMON_STARTING_AREA") then
			if (FlashTaskBar.db.profile.summon) then
				FlashTaskBar:DoFlash("summon")
			end
		
		elseif (token == "CHANNEL_INVITE" or token == "CHAT_CHANNEL_INVITE") then
			FlashTaskBar:DoFlash("")
		
		elseif (token == "PARTY_INVITE" or token == "PARTY_INVITE_XREALM") then
			if (not FlashTaskBar.db.profile.invite) then
				return
			end
			if (FlashTaskBar.db.profile.invite_ignore_on_autoaccept) then
				FlashTaskBar:ScheduleTimer ("DelayInviteCheck", 1.5)
			else
				FlashTaskBar:DoFlash("invite")
			end
		
		elseif (token == "TRADE_WITH_QUESTION") then
			if (FlashTaskBar.db.profile.trade) then
				FlashTaskBar:DoFlash("tarde")
			end
		end
		
	end)
	
	--brawlers guild
	function FlashTaskBar:CHAT_MSG_MONSTER_YELL (event, msg, source, _, _, player_name)
		if (player_name == UnitName ("player")) then
			if (FlashTaskBar.db.profile.brawlers_queue) then
				FlashTaskBar:DoFlash("brawlers_queue")
			end
		end
	end
	function FlashTaskBar:CheckForBrawlersGuild()
		local zoneName, zoneType, _, _, _, _, _, zoneMapID = GetInstanceInfo()
		if (zoneMapID == 369 or zoneMapID == 1043) then
			FlashTaskBar:RegisterEvent ("CHAT_MSG_MONSTER_YELL")
		else
			FlashTaskBar:UnregisterEvent ("CHAT_MSG_MONSTER_YELL")
		end
	end
	function FlashTaskBar:PLAYER_ENTERING_WORLD()
		FlashTaskBar:ScheduleTimer ("CheckForBrawlersGuild", 3)
	end
	function FlashTaskBar:ZONE_CHANGED_NEW_AREA()
		FlashTaskBar:ScheduleTimer ("CheckForBrawlersGuild", 3)
	end
	FlashTaskBar:RegisterEvent ("PLAYER_ENTERING_WORLD")
	FlashTaskBar:RegisterEvent ("ZONE_CHANGED_NEW_AREA")

	--pull timers
	function FlashTaskBar:CommReceived (_, prefix)
		if (not FlashTaskBar.db.profile.pull_timers) then
			return
		end
		if (prefix:find ("PT")) then
			FlashTaskBar:DoFlash("pull_timers")
		elseif (prefix:find ("BWPull")) then
			FlashTaskBar:DoFlash("pull_timers")
		end
	end
	FlashTaskBar:RegisterComm ("D4", "CommReceived")
	FlashTaskBar:RegisterComm ("BigWigs", "CommReceived")
	
	--readycheck
	function FlashTaskBar:READY_CHECK()
		if (FlashTaskBar.db.profile.readycheck) then
			FlashTaskBar:DoFlash("readycheck")
		end
	end
	FlashTaskBar:RegisterEvent ("READY_CHECK")
	
	--combat
	function FlashTaskBar:PLAYER_REGEN_DISABLED()
		if (FlashTaskBar.db.profile.enter_combat) then
			FlashTaskBar:DoFlash("enter_combat")
		end
	end
	FlashTaskBar:RegisterEvent ("PLAYER_REGEN_DISABLED")
	
	--taxy
	FlashTaskBar.on_taxi = false
	function FlashTaskBar:SPELL_FLYOUT_UPDATE()
		if (FlashTaskBar.on_taxi and not UnitOnTaxi ("player")) then
			if (FlashTaskBar.db.profile.end_taxi) then
				FlashTaskBar:DoFlash("end_taxi")
			end
		end
		FlashTaskBar.on_taxi = UnitOnTaxi ("player")
	end
	FlashTaskBar:RegisterEvent ("SPELL_FLYOUT_UPDATE")
	
	--disconenct
	GameMenuButtonLogout:HookScript ("OnClick", function() 
		FlashTaskBar.LogoutTolerance = GetTime()+30
	end)
	function FlashTaskBar:PLAYER_LOGOUT()
		if (FlashTaskBar.db.profile.disconnect_logout) then
			if (FlashTaskBar.LogoutTolerance and FlashTaskBar.LogoutTolerance > GetTime()) then
				return
			end
			FlashTaskBar:DoFlash("disconnect_logout")
		end
	end
	FlashTaskBar:RegisterEvent ("PLAYER_LOGOUT")
	
	--trade
	function FlashTaskBar:TRADE_SHOW()
		if (FlashTaskBar.db.profile.trade) then
			FlashTaskBar:DoFlash("trade")
		end
	end
	FlashTaskBar:RegisterEvent ("TRADE_SHOW")
	
	--bags full
	function FlashTaskBar:BAG_UPDATE()
		if (FlashTaskBar.db.profile.bags_full) then
			for backpack = 0, 4 do
				for slot = 1, GetContainerNumSlots (backpack) do
					local itemId = GetContainerItemID (backpack, slot)
					if (not itemId) then
						return
					end
				end
			end
			FlashTaskBar:DoFlash("bags_full")
		end
	end
	FlashTaskBar:RegisterEvent ("BAG_UPDATE")
	
--------> chat scan
	
	local player_name = UnitName ("player")
	
	local do_chat_scan = function (_, message)
		for _, keyword in ipairs (FlashTaskBar.db.profile.chat_scan_keywords) do
			if (lower (message):find (lower (keyword))) then
				FlashTaskBar:DoFlash("chat_scan")
			end
		end
		--if (message:find (player_name)) then
		--	FlashTaskBar:DoFlash("")
		--end
	end
	
	function FlashTaskBar:EnableChatScan()
		FlashTaskBar:RegisterEvent ("CHAT_MSG_EMOTE", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_MONSTER_EMOTE", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_MONSTER_SAY", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_MONSTER_WHISPER", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_MONSTER_YELL", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_RAID_BOSS_EMOTE", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_RAID_BOSS_WHISPER", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_SYSTEM", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_SAY", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_YELL", do_chat_scan)
		FlashTaskBar:RegisterEvent ("CHAT_MSG_CHANNEL", do_chat_scan)
	end	
	
	function FlashTaskBar:DisableChatScan()
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_EMOTE")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_MONSTER_EMOTE")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_MONSTER_SAY")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_MONSTER_WHISPER")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_MONSTER_YELL")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_RAID_BOSS_EMOTE")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_RAID_BOSS_WHISPER")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_SYSTEM")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_SAY")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_YELL")
		FlashTaskBar:UnregisterEvent ("CHAT_MSG_CHANNEL")
	end

--------> combat log scan

	local combat_log_keywords = {}
	local do_combat_log_scan = function (event, time, token, hidding, who_serial, who_name, who_flags, who_flags2, target_serial, target_name, target_flags, target_flags2, ...)
		if (target_name and combat_log_keywords [lower (target_name)]) then
			FlashTaskBar:DoFlash("combat_log")
		end
	end
	
	function FlashTaskBar:BuildCombatLogKeywordTable()
		wipe (combat_log_keywords)
		for _, keyword in ipairs (FlashTaskBar.db.profile.combat_log_keywords) do
			combat_log_keywords [lower (keyword)] = true
		end
	end
	
	function FlashTaskBar:EnableCombatLogScan()
		FlashTaskBar:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED", do_combat_log_scan)
		FlashTaskBar:BuildCombatLogKeywordTable()
	end
	
	function FlashTaskBar:DisableCombatLogScan()
		FlashTaskBar:UnregisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
	end
	
--------> rare mob scan

	local do_rare_mob_scan = function()
		for i = 1, C_Vignettes.GetNumVignettes() do
			local serial = C_Vignettes.GetVignetteGUID (i)
			if (serial) then
				local _, _, name, objectIcon = C_Vignettes.GetVignetteInfoFromInstanceID (serial)
				if (objectIcon and objectIcon == 41) then
					if (FlashTaskBar.db.profile.any_rare) then
						FlashTaskBar:DoFlash("rare_scan")
					elseif (name) then
						for _, npc_name in ipairs (FlashTaskBar.db.profile.rare_names) do
							npc_name = lower (npc_name)
							name = lower (name)
							if (npc_name == name) then
								FlashTaskBar:DoFlash("rare_scan")
							end
						end
					end
				end
			end
		end
	end
	
	function FlashTaskBar:EnableRareMobScan()
		FlashTaskBar:RegisterEvent ("VIGNETTE_ADDED", do_rare_mob_scan) --"VIGNETTE_REMOVED"
	end
	
	function FlashTaskBar:DisableRareMobScan()
		FlashTaskBar:UnregisterEvent ("VIGNETTE_ADDED")
	end

--> build options panel
	
	local options = {
		{
			type = "toggle",
			name = L["STRING_READYCHECK"],
			desc = L["STRING_READYCHECK_DESC"],
			order = 1,
			get = function() return FlashTaskBar.db.profile.readycheck end,
			set = function (self, val) 
				FlashTaskBar.db.profile.readycheck = not FlashTaskBar.db.profile.readycheck
			end,
		},
		{
			type = "toggle",
			name = L["STRING_PVPQUEUES"],
			desc = L["STRING_PVPQUEUES_DESC"],
			order = 2,
			get = function() return FlashTaskBar.db.profile.arena_queue end,
			set = function (self, val) 
				FlashTaskBar.db.profile.arena_queue = not FlashTaskBar.db.profile.arena_queue
			end,
		},
		{
			type = "toggle",
			name = L["STRING_FINDERQUEUES"],
			desc = L["STRING_FINDERQUEUES_DESC"],
			order = 3,
			get = function() return FlashTaskBar.db.profile.group_queue end,
			set = function (self, val) 
				FlashTaskBar.db.profile.group_queue = not FlashTaskBar.db.profile.group_queue
			end,
		},
		{
			type = "toggle",
			name = L["STRING_PETBATTLES"] ,
			desc = L["STRING_PETBATTLES_DESC"] ,
			order = 6,
			get = function() return FlashTaskBar.db.profile.petbattle_queue end,
			set = function (self, val) 
				FlashTaskBar.db.profile.petbattle_queue = not FlashTaskBar.db.profile.petbattle_queue
			end,
		},
		{
			type = "toggle",
			name = L["STRING_BRAWLERS"],
			desc = L["STRING_BRAWLERS_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.brawlers_queue end,
			set = function (self, val) 
				FlashTaskBar.db.profile.brawlers_queue = not FlashTaskBar.db.profile.brawlers_queue
			end,
		},		
		{
			type = "toggle",
			name = L["STRING_PULL"],
			desc = L["STRING_PULL_DESC"],
			order = 4,
			get = function() return FlashTaskBar.db.profile.pull_timers end,
			set = function (self, val) 
				FlashTaskBar.db.profile.pull_timers = not FlashTaskBar.db.profile.pull_timers
			end,
		},
		{
			type = "toggle",
			name = L["STRING_ENTERCOMBAT"],
			desc = L["STRING_ENTERCOMBAT_DESC"],
			order = 5,
			get = function() return FlashTaskBar.db.profile.enter_combat end,
			set = function (self, val) 
				FlashTaskBar.db.profile.enter_combat = not FlashTaskBar.db.profile.enter_combat
			end,
		},
		{
			type = "toggle",
			name = L["STRING_FLYPOINT"],
			desc = L["STRING_FLYPOINT_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.end_taxi end,
			set = function (self, val) 
				FlashTaskBar.db.profile.end_taxi = not FlashTaskBar.db.profile.end_taxi
			end,
		},
		{
			type = "toggle",
			name = L["STRING_DISCONNECT"],
			desc = L["STRING_DISCONNECT_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.disconnect_logout end,
			set = function (self, val) 
				FlashTaskBar.db.profile.disconnect_logout = not FlashTaskBar.db.profile.disconnect_logout
			end,
		},
		
		{
			type = "toggle",
			name = L["STRING_INVITES"],
			desc = L["STRING_INVITES_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.invite end,
			set = function (self, val) 
				FlashTaskBar.db.profile.invite = not FlashTaskBar.db.profile.invite
			end,
		},		
		{
			type = "toggle",
			name = L["STRING_INVITEIGNORE"],
			desc = L["STRING_INVITEIGNORE_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.invite_ignore_on_autoaccept end,
			set = function (self, val) 
				FlashTaskBar.db.profile.invite_ignore_on_autoaccept = not FlashTaskBar.db.profile.invite_ignore_on_autoaccept
			end,
		},
		
		{
			type = "toggle",
			name = L["STRING_TRADE"],
			desc = L["STRING_TRADE_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.trade end,
			set = function (self, val) 
				FlashTaskBar.db.profile.trade = not FlashTaskBar.db.profile.trade
			end,
		},
		{
			type = "toggle",
			name = L["STRING_BAGSFULL"],
			desc = L["STRING_BAGSFULL_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.bags_full end,
			set = function (self, val) 
				FlashTaskBar.db.profile.bags_full = not FlashTaskBar.db.profile.bags_full
			end,
		},
		{
			type = "toggle",
			name = L["STRING_WORLDPVP"],
			desc = L["STRING_WORLDPVP_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.worldpvp end,
			set = function (self, val) 
				FlashTaskBar.db.profile.worldpvp = not FlashTaskBar.db.profile.worldpvp
			end,
		},
		{
			type = "toggle",
			name = L["STRING_DUELREQUEST"] ,
			desc = L["STRING_DUELREQUEST_DESC"] ,
			order = 6,
			get = function() return FlashTaskBar.db.profile.duel_request end,
			set = function (self, val) 
				FlashTaskBar.db.profile.duel_request = not FlashTaskBar.db.profile.duel_request
			end,
		},		
		{
			type = "toggle",
			name = L["STRING_SUMMON"],
			desc = L["STRING_SUMMON_DESC"],
			order = 6,
			get = function() return FlashTaskBar.db.profile.summon end,
			set = function (self, val) 
				FlashTaskBar.db.profile.summon = not FlashTaskBar.db.profile.summon
			end,
		},
	}
	
	local options_text_template = FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
	local options_dropdown_template = FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
	local options_switch_template = FlashTaskBar:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
	local options_slider_template = FlashTaskBar:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
	local options_button_template = FlashTaskBar:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
	
	local general_text1 = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_GENERALSETTINGS"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
	general_text1:SetPoint ("topleft", main_frame, "topleft", 10, -50)
	FlashTaskBar:SetFontSize (general_text1, 16)
	
	local general_settings_frame = CreateFrame ("frame", "FlashTaskBarGeneralOptionsFrame", FlashTaskBar.OptionsFrame1)
	general_settings_frame:SetPoint ("topleft", 0, 0)
	general_settings_frame:SetSize (1, 1)
	
	FlashTaskBar:BuildMenu (general_settings_frame, options, 15, -77, 240, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
	
	local y_chat_scan = -210
	
	local camping_text1 = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_CAMPINGSETTINGS"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
	camping_text1:SetPoint ("topleft", main_frame, "topleft", 10, y_chat_scan)
	local sound_button_y = y_chat_scan
	FlashTaskBar:SetFontSize (camping_text1, 16)
	y_chat_scan = y_chat_scan - 30
	
	--> chat scan settings
	
	--> title label
	local blink_on_chat = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_CHATSCAN"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
	blink_on_chat:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan)	
	
	--> enabled
	local enable_chat_filter = function (_, _, value)
		FlashTaskBar.db.profile.chat_scan = value
		if (value) then
			FlashTaskBar:EnableChatScan()
		else
			FlashTaskBar:DisableChatScan()
		end
	end
	local chat_scan_switch, chat_scan_label = FlashTaskBar:CreateSwitch (FlashTaskBar.OptionsFrame1, enable_chat_filter, FlashTaskBar.db.profile.chat_scan, _, _, _, _, "switch_enable_chat_scan", _, _, _, _, L["STRING_CHATSCAN_ENABLED"] .. ":", FlashTaskBar:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	chat_scan_switch:SetAsCheckBox()
	chat_scan_switch.tooltip = L["STRING_CHATSCAN_ENABLED_DESC"]
	chat_scan_label:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-20)	
	
	--> key words
	--add
	local chat_scan_keyword, label_chat_scan_keyword = FlashTaskBar:CreateTextEntry (FlashTaskBar.OptionsFrame1, function()end, 120, 20, "entry_add_keyword", _, L["STRING_ADDKEYWORD"] .. ":", FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	label_chat_scan_keyword:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-40)	
	
	local add_key_word_func = function()
		local keyword = chat_scan_keyword.text
		if (keyword ~= "") then
			tinsert (FlashTaskBar.db.profile.chat_scan_keywords, keyword)
		end
		chat_scan_keyword.text = ""
		chat_scan_keyword:ClearFocus()
		FlashTaskBar.OptionsFrame1.dropdown_keyword_remove:Refresh()
		FlashTaskBar.OptionsFrame1.dropdown_keyword_remove:Select (1, true)
	end
	local button_add_keyword = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, add_key_word_func, 60, 18, L["STRING_ADD"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	button_add_keyword:SetPoint ("left", chat_scan_keyword, "right", 2, 0)
	
	--remove
	local dropdown_keyword_erase_fill = function()
		local t = {}
		for i, keyword in ipairs (FlashTaskBar.db.profile.chat_scan_keywords) do
			t [#t+1] = {value = i, label = keyword, onclick = empty_func}
		end
		return t
	end
	local label_keyword_remove = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_ERASEKEYWORD"] .. ": ", FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	local dropdown_keyword_remove = FlashTaskBar:CreateDropDown (FlashTaskBar.OptionsFrame1, dropdown_keyword_erase_fill, _, 160, 20, "dropdown_keyword_remove", _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	dropdown_keyword_remove:SetPoint ("left", label_keyword_remove, "right", 2, 0)

	local keyword_remove = function()
		local value = dropdown_keyword_remove.value
		tremove (FlashTaskBar.db.profile.chat_scan_keywords, value)
		dropdown_keyword_remove:Refresh()
		dropdown_keyword_remove:Select (1, true)
	end
	local button_keyword_remove = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, keyword_remove, 60, 18, L["STRING_REMOVE"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	button_keyword_remove:SetPoint ("left", dropdown_keyword_remove, "right", 2, 0)
	label_keyword_remove:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-60)
	
	if (FlashTaskBar.db.profile.chat_scan) then
		FlashTaskBar:EnableChatScan()
	end
	
	
	--> combat log scan settings
	
	--> title label
	local blink_on_combatlog = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_COMBATLOGSCAN"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
	blink_on_combatlog:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-90)		
	
	--> enabled
	local enable_combatlog_filter = function (_, _, value)
		FlashTaskBar.db.profile.combat_log = value
		if (value) then
			FlashTaskBar:EnableCombatLogScan()
		else
			FlashTaskBar:DisableCombatLogScan()
		end
	end
	local combatlog_scan_switch, combatlog_scan_label = FlashTaskBar:CreateSwitch (FlashTaskBar.OptionsFrame1, enable_combatlog_filter, FlashTaskBar.db.profile.combat_log, _, _, _, _, "switch_enable_combatlog_scan", _, _, _, _, L["STRING_COMBATLOGSCAN_ENABLED"]  .. ":", FlashTaskBar:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	combatlog_scan_switch.tooltip = L["STRING_COMBATLOGSCAN_ENABLED_DESC"] 
	combatlog_scan_switch:SetAsCheckBox()
	combatlog_scan_label:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-110)	
	
	--> key words
	--add
	local combatlog_scan_keyword, label_combatlog_scan_keyword = FlashTaskBar:CreateTextEntry (FlashTaskBar.OptionsFrame1, function()end, 120, 20, "entry_add_keyword", _, L["STRING_RARENPCSCAN_NPCNAME"] .. ":", FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	label_combatlog_scan_keyword:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-130)	
	
	local add_key_word_func = function()
		local keyword = combatlog_scan_keyword.text
		if (keyword ~= "") then
			tinsert (FlashTaskBar.db.profile.combat_log_keywords, keyword)
		end
		combatlog_scan_keyword.text = ""
		combatlog_scan_keyword:ClearFocus()
		FlashTaskBar.OptionsFrame1.dropdown_combatlog_keyword_remove:Refresh()
		FlashTaskBar.OptionsFrame1.dropdown_combatlog_keyword_remove:Select (1, true)
		FlashTaskBar:BuildCombatLogKeywordTable()
	end
	local button_add_keyword = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, add_key_word_func, 60, 18, L["STRING_ADD"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	button_add_keyword:SetPoint ("left", combatlog_scan_keyword, "right", 2, 0)
	
	--remove
	local dropdown_keyword_erase_fill = function()
		local t = {}
		for i, keyword in ipairs (FlashTaskBar.db.profile.combat_log_keywords) do
			t [#t+1] = {value = i, label = keyword, onclick = empty_func}
		end
		return t
	end
	local label_keyword_remove = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_REMOVE_TITLE"] .. ": ", FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	local dropdown_keyword_remove = FlashTaskBar:CreateDropDown (FlashTaskBar.OptionsFrame1, dropdown_keyword_erase_fill, _, 160, 20, "dropdown_combatlog_keyword_remove", _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	dropdown_keyword_remove:SetPoint ("left", label_keyword_remove, "right", 2, 0)

	local keyword_remove = function()
		local value = dropdown_keyword_remove.value
		tremove (FlashTaskBar.db.profile.combat_log_keywords, value)
		dropdown_keyword_remove:Refresh()
		dropdown_keyword_remove:Select (1, true)
		FlashTaskBar:BuildCombatLogKeywordTable()
	end
	local button_keyword_remove = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, keyword_remove, 60, 18, L["STRING_REMOVE"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	button_keyword_remove:SetPoint ("left", dropdown_keyword_remove, "right", 2, 0)
	label_keyword_remove:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-150)
	
	if (FlashTaskBar.db.profile.combat_log) then
		FlashTaskBar:EnableCombatLogScan()
	end
	
	
	--> rare mob scan settings
	
	--> title label
	local blink_on_raremob = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_RARENPCSCAN"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
	blink_on_raremob:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-180)		
	
	--> enabled
	local enable_raremob_filter = function (_, _, value)
		FlashTaskBar.db.profile.rare_scan = value
		if (value) then
			FlashTaskBar:EnableRareMobScan()
		else
			FlashTaskBar:DisableRareMobScan()
		end
	end
	local raremob_scan_switch, raremob_scan_label = FlashTaskBar:CreateSwitch (FlashTaskBar.OptionsFrame1, enable_raremob_filter, FlashTaskBar.db.profile.rare_scan, _, _, _, _, "switch_enable_raremob_scan", _, _, _, _, L["STRING_RARENPCSCAN_ENABLED"] .. ":", FlashTaskBar:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	raremob_scan_switch:SetAsCheckBox()
	raremob_scan_switch.tooltip = L["STRING_RARENPCSCAN_DESC"]
	raremob_scan_label:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-200)	
	
	--> all rares
	local enable_raremob_all_filter = function (_, _, value)
		FlashTaskBar.db.profile.any_rare = value
	end
	local raremob_all_scan_switch, raremob_all_scan_label = FlashTaskBar:CreateSwitch (FlashTaskBar.OptionsFrame1, enable_raremob_all_filter, FlashTaskBar.db.profile.any_rare, _, _, _, _, "switch_enable_raremob_all_scan", _, _, _, _, L["STRING_RARENPCSCAN_ANYNPC"] .. ":", FlashTaskBar:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	raremob_all_scan_switch:SetAsCheckBox()
	raremob_all_scan_label:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-220)	
	
	--> key words
	--add
	local raremob_scan_keyword, label_raremob_scan_keyword = FlashTaskBar:CreateTextEntry (FlashTaskBar.OptionsFrame1, function()end, 120, 20, "raremob_add_keyword", _, L["STRING_RARENPCSCAN_NPCNAME"] .. ":", FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	label_raremob_scan_keyword:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-240)	
	
	local add_key_word_func = function()
		local keyword = raremob_scan_keyword.text
		if (keyword ~= "") then
			tinsert (FlashTaskBar.db.profile.rare_names, keyword)
		end
		raremob_scan_keyword.text = ""
		raremob_scan_keyword:ClearFocus()
		FlashTaskBar.OptionsFrame1.dropdown_rare_keyword_remove:Refresh()
		FlashTaskBar.OptionsFrame1.dropdown_rare_keyword_remove:Select (1, true)
	end
	local button_add_keyword = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, add_key_word_func, 60, 18, L["STRING_ADD"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	button_add_keyword:SetPoint ("left", raremob_scan_keyword, "right", 2, 0)
	
	--remove
	local dropdown_keyword_erase_fill = function()
		local t = {}
		for i, keyword in ipairs (FlashTaskBar.db.profile.rare_names) do
			t [#t+1] = {value = i, label = keyword, onclick = empty_func}
		end
		return t
	end
	local label_keyword_remove = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_REMOVE_TITLE"] .. ": ", FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	local dropdown_keyword_remove = FlashTaskBar:CreateDropDown (FlashTaskBar.OptionsFrame1, dropdown_keyword_erase_fill, _, 160, 20, "dropdown_rare_keyword_remove", _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
	dropdown_keyword_remove:SetPoint ("left", label_keyword_remove, "right", 2, 0)

	local keyword_remove = function()
		local value = dropdown_keyword_remove.value
		tremove (FlashTaskBar.db.profile.rare_names, value)
		dropdown_keyword_remove:Refresh()
		dropdown_keyword_remove:Select (1, true)
	end
	local button_keyword_remove = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, keyword_remove, 60, 20, L["STRING_REMOVE"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	button_keyword_remove:SetPoint ("left", dropdown_keyword_remove, "right", 2, 0)
	label_keyword_remove:SetPoint ("topleft", FlashTaskBar.OptionsFrame1, "topleft", 10, y_chat_scan-260)
	
	
	if (FlashTaskBar.db.profile.rare_scan) then
		FlashTaskBar:EnableRareMobScan()
	end
	
	--> sound options
	
	local sound_x = 380
	local sound_text1 = FlashTaskBar:CreateLabel (FlashTaskBar.OptionsFrame1, L["STRING_SOUNDSETTINGS"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
	sound_text1:SetPoint ("topleft", main_frame, "topleft", sound_x, sound_button_y)
	FlashTaskBar:SetFontSize (sound_text1, 16)
	
	local open_sound_panel = function()
		if (_G.FlashTaskbarSoundSettings) then
			_G.FlashTaskbarSoundSettings:Show()
			return
		end
		
		local f = DF:Create1PxPanel (FlashTaskBar.OptionsFrame1, 450, 300, "", "FlashTaskbarSoundSettings", nil, nil, nil)
		f:SetPoint ("center", FlashTaskBar.OptionsFrame1, "center")
		f:SetSize (FlashTaskBar.OptionsFrame1:GetSize())
		f:SetFrameLevel (FlashTaskBar.OptionsFrame1:GetFrameLevel()+5)
		f:SetLocked (true)
		
		f:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], tile = true, tileSize = 64})
		f:SetBackdropColor (0, 0, 0, 1)
		
		local close_sound_settings = FlashTaskBar:CreateButton (f, function() f:Hide() end, 160, 20, L["STRING_CLOSESOUNDPANEL"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
		close_sound_settings:SetPoint ("topleft", f, "topleft", 10, -500)
		close_sound_settings:SetIcon ([[Interface\Scenarios\ScenarioIcon-Check]], 16, 16, "overlay", {0, 1, 0, 1}, nil, 6, nil, 1)
		
		local sound_title = FlashTaskBar:CreateLabel (f, L["STRING_SOUNDSETTINGS"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
		sound_title:SetPoint ("topleft", f, "topleft", 10, -50)
		FlashTaskBar:SetFontSize (sound_title, 16)
		local sound_title_desc = FlashTaskBar:CreateLabel (f, L["STRING_SOUNDSETTINGS_DESC"] .. ":", FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
		sound_title_desc:SetPoint ("topleft", f, "topleft", 10, -70)
		
		local localize_key = {
			readycheck = "READYCHECK",
			arena_queue = "PVPQUEUES",
			group_queue = "FINDERQUEUES",
			petbattle_queue = "PETBATTLES",
			brawlers_queue = "BRAWLERS",
			pull_timers = "PULL",
			enter_combat = "ENTERCOMBAT",
			end_taxi = "FLYPOINT",
			chat_scan = "CHATSCAN",
			combat_log = "COMBATLOGSCAN",
			rare_scan = "RARENPCSCAN",
			disconnect_logout = "DISCONNECT",
			invite = "INVITES",
			trade = "TRADE",
			bags_full = "BAGSFULL",
			worldpvp = "WORLDPVP",
			duel_request = "DUELREQUEST",
			summon = "SUMMON",
		}
		
		local settings = {
			"rare_scan",
			"arena_queue",
			"group_queue",
			"readycheck",
			"petbattle_queue",
			"brawlers_queue",
			"pull_timers",
			"enter_combat",
			"end_taxi",
			"chat_scan",
			"combat_log",
			--"disconnect_logout", -- the game client won't play sound during the logout process :(
			"invite",
			"trade",
			"bags_full",
			"worldpvp",
			"duel_request",
			"summon",
		}
		
		local sound_options = {}
		local y = -95
		local x = 10
		
		local checkbox_ontoggle = function (self, _, value)
			self.MyConfigTable.enabled = not self.MyConfigTable.enabled
		end
		local sound_dropdown_selected = function (self, _, value)
			self.MyConfigTable.sound = value
			PlaySoundFile (LibStub:GetLibrary("LibSharedMedia-3.0"):Fetch ("sound", value), "Master")
		end
		local SoundTable
		local sound_dropdown_fill = function (capsule)
			if (not SoundTable) then
				SoundTable = {}
				local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")
				for name, _ in pairs (SharedMedia:HashTable ("sound")) do 
					tinsert (SoundTable, {value = name, label = name, onclick = sound_dropdown_selected})
				end
			end
			return SoundTable 
		end
		
		local switch_name = 999
		for index, config_key in  ipairs (settings) do
			local name_locale = L["STRING_" .. localize_key [config_key]] .. ":"
			local desc_locale = L["STRING_" .. localize_key [config_key] .. "_DESC"]
			local config_table = FlashTaskBar.db.profile.sound_enabled [config_key]
		
			local label = FlashTaskBar:CreateLabel (f, name_locale, FlashTaskBar:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
			label.color = "yellow"
			label:SetPoint (x, y)
			
			--"FlashTaskbarSwitch" .. switch_name
			local checkbox = FlashTaskBar:CreateSwitch (f, checkbox_ontoggle, config_table.enabled, _, _, _, _, _, nil, _, _, _, _, FlashTaskBar:GetTemplate ("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"))
			checkbox:SetAsCheckBox()
			checkbox.tooltip = desc_locale
			checkbox.MyConfigTable = config_table
			checkbox:SetPoint (x + 120, y)
			
			local dropdown = FlashTaskBar:CreateDropDown (f, sound_dropdown_fill, config_table.sound, 160, 20, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
			dropdown.MyConfigTable = config_table
			dropdown:SetPoint (x + 180, y)
		
			y = y - 20
			
			switch_name = switch_name + 1
		end
	end
	
	local open_sound_settings = FlashTaskBar:CreateButton (FlashTaskBar.OptionsFrame1, open_sound_panel, 160, 18, L["STRING_OPENSOUNDPANEL"], _, _, _, _, _, _, FlashTaskBar:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"), FlashTaskBar:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	open_sound_settings:SetPoint ("topleft", main_frame, "topleft", sound_x-1, sound_button_y-30)
	open_sound_settings:SetIcon ([[Interface\Buttons\UI-GuildButton-MOTD-Up]], 16, 15, "overlay", {1, 0, 0, 1}, nil, 6, nil, 1)
	
	--> (debug) open the options panel on load
	--InterfaceOptionsFrame_OpenToCategory ("FlashTaskBar")
	--InterfaceOptionsFrame_OpenToCategory ("FlashTaskBar")
	
end
