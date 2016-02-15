
local DF = _G ["DetailsFramework"]
if (not DF) then
	print ("|cFFFFAA00Please restart your client to finish update some AddOns.|c")
	return
end
 
local floor = floor
local min = min
local UnitExists = UnitExists
local GetPlayerMapPosition = GetPlayerMapPosition
local UnitHealth = UnitHealth
local GetNumGroupMembers = GetNumGroupMembers
local abs = abs
local GetPlayerFacing = GetPlayerFacing
local db
local _

--local f = CreateFrame ("frame", "Hansgar_And_Franzok_Assist", UIParent)
local f = DF:Create1PxPanel (_, 155, 166, "Hans & Franz", "Hansgar_And_Franzok_Assist", nil, "top", true)
f:SetFrameStrata ("DIALOG")
f.version = "v0.16d"

f.Close:SetScript ("OnClick", function (self)
	if (f.StampersPhase) then
		return f:StopTracking()
	end
	f:EndTrackPlayerPosition()
end)

f.Lock:SetScript ("OnClick", function (self)
	if (db.FRAME_LOCK) then
		f:SetLockState()
		print ("|cFFFFAA00Hansgar and Franzok Assist|r frame unlocked.")
		
		f.unlocked_frame = true
		f.player_pos_frame:Show()
		f.player_bar:Show()
		f.stop_casting_frame:Show()
	else
		f:SetLockState()
		print ("|cFFFFAA00Hansgar and Franzok Assist|r frame locked.")
		f.unlocked_frame = false
		f.stop_casting_frame:Hide()
	end
end)

local tframe = CreateFrame ("frame", "Hansgar_And_Franzok_Assist_PTrack", UIParent)

f:SetSize (155, 159)
f:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = -1, right = -1, top = -1, bottom = -1},
edgeFile = "Interface\\AddOns\\Hansgar_And_Franzok_Assist\\border_2", edgeSize = 8})
f:SetPoint ("center", UIParent, "center", 300, 200)
f:SetBackdropColor (0, 0, 0, 0)
f:SetBackdropBorderColor (0, 0, 0, 1)
f:SetMovable (true)
f:EnableMouse (true)
f.all_blocks = {}
f:Hide()

--local title = f:CreateFontString (nil, "overlay", "GameFontNormal")
--title:SetText ("Hansgar & Franzok Assist")
--title:SetPoint ("center", f, "center")
--title:SetPoint ("bottom", f, "top", 0, 2)

--
local frame_event = CreateFrame ("frame", "Hansgar_And_Franzok_AssistEvents", f)
frame_event:RegisterEvent ("ENCOUNTER_START")
frame_event:RegisterEvent ("ENCOUNTER_END")
frame_event:RegisterEvent ("ADDON_LOADED")

--
local player_bar = CreateFrame ("statusbar", "Hansgar_And_Franzok_PlayerAssistBar", UIParent)

--player_bar:SetPoint ("topleft", f, "bottomleft", 0, -3)
--player_bar:SetPoint ("topright", f, "bottomright", 0, -3)

player_bar:SetPoint ("center", UIParent, "center", 0, 300)
player_bar:SetSize (280, 16)

player_bar:SetMovable (true)
player_bar:EnableMouse (true)
player_bar:SetResizable (true)
player_bar:SetStatusBarColor (0, 0, 0, 0)
player_bar:SetMinMaxValues (0, 100)
player_bar:SetValue (0)
player_bar:SetMinResize (50, 15)
player_bar:SetMaxResize (500, 40)
player_bar:Hide()

local player_bar_backgroud = player_bar:CreateTexture (nil, "background")
player_bar_backgroud:SetTexture (0, 0, 0, 0.2)
player_bar_backgroud:SetAllPoints()

local icon = player_bar:CreateTexture (nil, "overlay")
icon:SetTexture ([[Interface\HELPFRAME\ReportLagIcon-Movement]])
icon:SetPoint ("left", player_bar, "left")
icon:SetDesaturated (true)
player_bar.icon = icon

local text = player_bar:CreateFontString (nil, "overlay", "GameFontNormal")
text:SetPoint ("right", player_bar, "right", -2, 0)
player_bar.text = text

player_bar:SetScript ("OnMouseDown", function (self)
	if (not self.isMoving) then
		self:StartMoving()
		self.isMoving = true
	end
end)
player_bar:SetScript ("OnMouseUp", function (self)
	if (self.isMoving) then
		self:StopMovingOrSizing()
		self.isMoving = false
	end
end)
player_bar:SetScript ("OnSizeChanged", function (self)
	self.icon:SetSize (self:GetHeight(), self:GetHeight())
	
end)
local grip = CreateFrame ("button", "Hansgar_And_Franzok_AssistPlayerBarButton", player_bar)
grip:SetPoint ("bottomright", player_bar, "bottomright")
grip:SetSize (16, 16)
grip:SetScript ("OnMouseDown", function (self, button)
	if (not player_bar.isMoving and button == "LeftButton") then
		player_bar:StartSizing ("bottomright")
		player_bar.isMoving = true
	end
end)
grip:SetScript ("OnMouseUp", function (self, button)
	if (player_bar.isMoving and button == "LeftButton") then
		player_bar:StopMovingOrSizing()
		player_bar.isMoving = false
	end
end)
grip:SetNormalTexture ([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Up]])
grip:SetHighlightTexture ([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Highlight]])
grip:SetPushedTexture ([[Interface\CHATFRAME\UI-ChatIM-SizeGrabber-Down]])

player_bar.grip = grip
f.player_bar = player_bar


player_bar.texture = player_bar:CreateTexture (nil, "overlay")
player_bar.texture:SetTexture ("Interface\\AddOns\\Hansgar_And_Franzok_Assist\\bar_skyline")
player_bar:SetStatusBarTexture (player_bar.texture)

--

local player_pos_frame = CreateFrame ("frame", "Hansgar_And_Franzok_Assist_BarDance", UIParent)
local player_pos_frame2 = CreateFrame ("frame", "Hansgar_And_Franzok_Assist_BarDance2", UIParent)

player_pos_frame:SetPoint ("center", UIParent, "center", 0, -75)
player_pos_frame2:SetPoint ("bottomleft", player_pos_frame, "bottomleft")

player_pos_frame2:SetSize (6, 155)
player_pos_frame:SetSize (155, 6)

local player_pos_frame_backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = -1, right = -1, top = -1, bottom = -1}}
player_pos_frame:SetBackdrop (player_pos_frame_backdrop)
player_pos_frame2:SetBackdrop (player_pos_frame_backdrop)
player_pos_frame:SetBackdropColor (0, 0, 0, 1)
player_pos_frame2:SetBackdropColor (0, 0, 0, 1)
player_pos_frame2:Hide()
player_pos_frame:SetMovable (true)
player_pos_frame:EnableMouse (true)
player_pos_frame:SetScript ("OnMouseDown", function (self)
	if (not self.isMoving) then
		self:StartMoving()
		self.isMoving = true
	end
end)
player_pos_frame:SetScript ("OnMouseUp", function (self)
	if (self.isMoving) then
		self:StopMovingOrSizing()
		self.isMoving = false
	end
end)
player_pos_frame:Hide()
f.player_pos_frame = player_pos_frame

--red
local t1 = player_pos_frame:CreateTexture (nil, "artwork")
t1:SetPoint ("left", player_pos_frame, "left")
t1:SetSize (player_pos_frame:GetWidth()*0.30, 6)
t1:SetTexture (1, 1, 1)
t1:SetVertexColor (1, 0.2, 0.2, 0.4)
--green
local t2 = player_pos_frame:CreateTexture (nil, "artwork")
t2:SetPoint ("left", t1, "right")
t2:SetSize (player_pos_frame:GetWidth()*0.15, 6)
t2:SetTexture (0.2, 1, 0.2, 0.4)
--red
local middle = player_pos_frame:CreateTexture (nil, "artwork")
middle:SetPoint ("left", t2, "right")
middle:SetSize (player_pos_frame:GetWidth()*0.10, 6)
middle:SetTexture (1, 1, 1)
middle:SetVertexColor (1, 0.2, 0.2, 0.4)
--green
local t3 = player_pos_frame:CreateTexture (nil, "artwork")
t3:SetPoint ("left", middle, "right")
t3:SetSize (player_pos_frame:GetWidth()*0.15, 6)
t3:SetTexture (0.2, 1, 0.2, 0.4)
--red
local t4 = player_pos_frame:CreateTexture (nil, "artwork")
t4:SetPoint ("left", t3, "right")
t4:SetSize (player_pos_frame:GetWidth()*0.30, 6)
t4:SetTexture (1, 1, 1)
t4:SetVertexColor (1, 0.2, 0.2, 0.4)

--red
local t1_2 = player_pos_frame:CreateTexture (nil, "artwork")
t1_2:SetPoint ("bottomleft", player_pos_frame, "bottomleft")
t1_2:SetSize (6, player_pos_frame:GetWidth()*0.30)
t1_2:SetTexture (1, 1, 1)
t1_2:SetVertexColor (1, 0.2, 0.2, 0.4)
--green
local t2_2 = player_pos_frame:CreateTexture (nil, "artwork")
t2_2:SetPoint ("bottom", t1_2, "top")
t2_2:SetSize (6, player_pos_frame:GetWidth()*0.15)
t2_2:SetTexture (0.2, 1, 0.2, 0.4)
--red
local middle_2 = player_pos_frame:CreateTexture (nil, "artwork")
middle_2:SetPoint ("bottom", t2_2, "top")
middle_2:SetSize (6, player_pos_frame:GetWidth()*0.10)
middle_2:SetTexture (1, 1, 1)
middle_2:SetVertexColor (1, 0.2, 0.2, 0.4)
--green
local t3_2 = player_pos_frame:CreateTexture (nil, "artwork")
t3_2:SetPoint ("bottom", middle_2, "top")
t3_2:SetSize (6, player_pos_frame:GetWidth()*0.15)
t3_2:SetTexture (0.2, 1, 0.2, 0.4)
--red
local t4_2 = player_pos_frame:CreateTexture (nil, "artwork")
t4_2:SetPoint ("bottom", t3_2, "top")
t4_2:SetSize (6, player_pos_frame:GetWidth()*0.30)
t4_2:SetTexture (1, 1, 1)
t4_2:SetVertexColor (1, 0.2, 0.2, 0.4)

t1_2:Hide()
t2_2:Hide()
t3_2:Hide()
t4_2:Hide()
middle_2:Hide()

local div = player_pos_frame:CreateTexture (nil, "overlay")
div:SetPoint ("left", player_pos_frame, "left", 0, 0)
div:SetTexture (1, 1, 1, 1)
div:SetSize (1, 16)
div:Hide()
--

local AceTimer = LibStub:GetLibrary ("AceTimer-3.0")
AceTimer:Embed (f)
local AceComm = LibStub:GetLibrary ("AceComm-3.0")
AceComm:Embed (f)

function f:CommReceived (_, data, _, source)
	if (data == "US") then
		f:SendCommMessage ("HAFR", UnitName ("player") .. " " .. f.version, "RAID")
	elseif (f.users) then
		f.users [data] = true
	end
end
function f:ShowUsers()
	
	local users_frame = Hansgar_And_Franzok_Assist_UsersPanel
	if (not users_frame) then
		users_frame = CreateFrame ("frame", "Hansgar_And_Franzok_Assist_UsersPanel", UIParent)
		users_frame:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = -1, right = -1, top = -1, bottom = -1},
		edgeFile = "Interface\\AddOns\\Hansgar_And_Franzok_Assist\\border_2", edgeSize = 8})
		users_frame:SetBackdropColor (0, 0, 0, 1)
		tinsert (UISpecialFrames, "Hansgar_And_Franzok_Assist_UsersPanel")
		users_frame:SetSize (200, 500)
		users_frame:SetPoint ("right", f, "left", -15, 0)
		users_frame.text = users_frame:CreateFontString (nil, "overlay", "GameFontHighlight")
		users_frame.text:SetPoint ("topleft", users_frame, "topleft", 10, -10)
		users_frame.text:SetJustifyH ("left")
		
		users_frame.title = users_frame:CreateFontString (nil, "overlay", "GameFontNormal")
		users_frame.title:SetText ("Hansgar & Franzok Assist: Users")
		users_frame.title:SetPoint ("center", users_frame, "center")
		users_frame.title:SetPoint ("bottom", users_frame, "top", 0, 2)
		
		local close = CreateFrame ("button", "Hansgar_And_Franzok_Assist_UsersPanel_CloseButton", users_frame, "UIPanelCloseButton")
		close:SetPoint ("topright", users_frame, "topright")
		users_frame.close_button = close
	end
	
	local s = ""
	
	for key, value in pairs (f.users) do
		s = s .. "|cFF33FF33" .. key .. "\n"
	end
	
	s = s .. "|r\n\n\n|cFFFFFFFFOut of Date or Not installed:|r\n\n"
	
	for i = 1, GetNumGroupMembers() do
		local name = UnitName ("raid" .. i)
		if (not s:find (name)) then
			s = s .. "|cFFFF3333" .. name .. "|r\n"
		end
	end
	
	users_frame.text:SetText (s)
	
	users_frame:Show()

	f.users = nil
	f.users_schedule = nil
	
end
f:RegisterComm ("HAFR", "CommReceived")

f.block_tracker = {}

frame_event:SetFrameStrata ("FULLSCREEN")

frame_event:SetScript ("OnEvent", function (self, event, ...)

	if (event == "ADDON_LOADED" and select (1, ...) == "Hansgar_And_Franzok_Assist") then
--/dump Hansgar_And_Franzok_DB.STAMPERS_DELAY
		db = Hansgar_And_Franzok_DB
		if (not db) then
			db = {}
			Hansgar_And_Franzok_DB = db
		end
		--
		db.STAMPERS_DELAY = db.STAMPERS_DELAY or 5
		if (db.CD_NUMBER == nil) then
			db.CD_NUMBER = false
		end
		if (db.SHOW_DANCE == nil) then
			db.SHOW_DANCE = true
		end
		if (db.FRAME_LOCK == nil) then
			db.FRAME_LOCK = false
		end
		if (db.AUTO_FACING == nil) then
			db.AUTO_FACING = true
		end
		if (db.FACING_SIDE == nil) then
			db.FACING_SIDE = 1
		end
		if (db.SHOW_MAIN_FRAME == nil) then
			db.SHOW_MAIN_FRAME = true
		end
		if (db.PLAY_SOUND == nil) then
			db.PLAY_SOUND = false
		end
		if (db.STOP_CAST == nil) then
			db.STOP_CAST = true
		end
		if (db.NO_VERTICAL == nil) then
			db.NO_VERTICAL = false
		end
		if (db.DANCE_SIZE == nil) then
			db.DANCE_SIZE = 6
		end
		--
		
		f:SetLockState (true)
		
	elseif (event == "ENCOUNTER_START" or event == "ENCOUNTER_END") then
	
		local encounterID, encounterName, difficultyID, raidSize = select (1, ...)
		
		if (encounterID == 1693) then
			if (f.unlocked_frame) then
				f.unlocked_frame = false
			end
		
			if (event == "ENCOUNTER_START") then
				f.on_encounter = true
				f:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
				
			elseif (event == "ENCOUNTER_END") then
				f.on_encounter = false
				f:UnregisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
			end
		end
		
		if (encounterID == 1693 and db.SHOW_DANCE) then
			if (event == "ENCOUNTER_START") then
				SetMapToCurrentZone()
				f:StartTrackPlayerPosition()
			elseif (event == "ENCOUNTER_END") then
				f:EndTrackPlayerPosition()
			end
		end
		
		if (encounterID == 1693 and difficultyID == 16) then
		
			if (event == "ENCOUNTER_START") then
				print ("|cFFFFAA00Hansgar and Franzok Assist|r: addon enabled, good look!")
			
				if (f.StampersPhase) then
					f:StopTracking()
				end
				
			elseif (event == "ENCOUNTER_END") then
				if (f.StampersPhase) then
					f:StopTracking()
				end
				
				f:EndTrackPlayerPosition()
			end
		end
	end

end)

SLASH_Hansgar_And_Franzok_Assist1, SLASH_Hansgar_And_Franzok_Assist2 = "/hansgar", "/franzok"
function SlashCmdList.Hansgar_And_Franzok_Assist (msg, editbox)

	local command, rest = msg:match ("^(%S*)%s*(.-)$")

	if (command == "users") then
		if (f.users_schedule) then
			print ("|cFFFFAA00Hansgar and Franzok Assist|r please wait 5 seconds...")
		elseif (IsInRaid()) then
			f.users = {}
			f:SendCommMessage ("HAFR", "US", "RAID")
			f.users_schedule = f:ScheduleTimer ("ShowUsers", 5)
			print ("|cFFFFAA00Hansgar and Franzok Assist|r please wait 5 seconds...")
		else
			print ("|cFFFFAA00Hansgar and Franzok Assist|r you aren't in a raid group.")
		end
	
	elseif (command == "st") then
		f.stop_casting_frame:Show()
		f.stop_casting_frame.alert.animOut:Stop()
		f.stop_casting_frame.alert.animIn:Play()
		f:ScheduleTimer ("HideStopSpellAlert", 1.2)
	
	elseif (command == "stopcast") then
		db.STOP_CAST = not db.STOP_CAST
		
		if (db.STOP_CAST) then
			print ("|cFFFFAA00Hansgar and Franzok Assist|r stop cast alert enabled.")
		else
			print ("|cFFFFAA00Hansgar and Franzok Assist|r stop cast alert disabled.")
		end
	
	elseif (command == "resetpos") then
		f:ClearAllPoints()
		f:SetPoint ("center", UIParent, "center")
		
		player_bar:ClearAllPoints()
		player_bar:SetPoint ("center", UIParent, "center")
		
		player_pos_frame:ClearAllPoints()
		player_pos_frame:SetPoint ("center", UIParent, "center")
		
		if (f.StampersPhase) then
			f:EndTrackPlayerPosition()
			f:StopTracking()
		end
		
		db.FRAME_LOCK = true
		f:SetLockState()
		
		f.unlocked_frame = true
		
		f:StartTracking()
		f:StartTrackPlayerPosition()
		
		print ("|cFFFFAA00Hansgar and Franzok Assist|r: position reseted.")
		print ("|cFFFFAA00Hansgar and Franzok Assist|r: move between the tracks to show the other frames.")
		print ("|cFFFFAA00Hansgar and Franzok Assist|r: type '/hansgar lock' to lock the frames.")
	
	elseif (command == "delay") then
		local t = tonumber (rest)
		if (t) then
			db.STAMPERS_DELAY = t
			print ("|cFFFFAA00Hansgar and Franzok Assist|r delay set to: ", t)
		else
			print ("|cFFFFAA00Hansgar and Franzok Assist|r invalid time.", t)
		end
		
	elseif (command == "test" or command == "show") then
		if (f.StampersPhase) then
			f:EndTrackPlayerPosition()
			return f:StopTracking()
		end
		
		f:StartTracking()
		f:StartTrackPlayerPosition()
		
	elseif (command == "hide") then
		if (f.StampersPhase) then
			return f:StopTracking()
		end
		f:EndTrackPlayerPosition()

	elseif (command == "unlock") then
		db.FRAME_LOCK = true
		f:SetLockState()
		print ("|cFFFFAA00Hansgar and Franzok Assist|r frame unlocked.")
		
		f.unlocked_frame = true
		player_pos_frame:Show()
		player_bar:Show()
		f.stop_casting_frame:Show()

	elseif (command == "lock") then
		f:SetLockState()
		
		if (db.FRAME_LOCK) then
			print ("|cFFFFAA00Hansgar and Franzok Assist|r frame locked.")
			f.unlocked_frame = false
			f.stop_casting_frame:Hide()
		else
			print ("|cFFFFAA00Hansgar and Franzok Assist|r frame unlocked.")
			
			f.unlocked_frame = true
			player_pos_frame:Show()
			player_bar:Show()
			f.stop_casting_frame:Show()
			
		end
	
	elseif (command == "facing") then
		if (rest == "1") then
			db.FACING_SIDE = 1
			tframe.facing = true
			print ("|cFFFFAA00Hansgar and Franzok Assist|r facing set to south.")
			
		elseif (rest == "2") then
			db.FACING_SIDE = 2
			tframe.facing = false
			print ("|cFFFFAA00Hansgar and Franzok Assist|r facing set to north.")
		
		elseif (rest == "auto") then
			db.AUTO_FACING = true
			print ("|cFFFFAA00Hansgar and Franzok Assist|r auto facing enabled.")
			
		else
			print ("|cFFFFFF00/hansgar facing|r: |cFF00FF001|r = south |cFF00FF002|r = north, use to set the dance bar when auto facing is disabled.")
		end
		
	elseif (command == "autofacing") then
		db.AUTO_FACING = not db.AUTO_FACING
		if (db.AUTO_FACING) then
			print ("|cFFFFAA00Hansgar and Franzok Assist|r auto facing enabled.")
		else
			print ("|cFFFFAA00Hansgar and Franzok Assist|r auto facing disabled.")
			tframe.facing = db.FACING_SIDE == 1
		end
	
	elseif (command == "dancesize") then
		local t = tonumber (rest)
		if (t) then
			db.DANCE_SIZE = t
			f:SetDanceBarSize()
			print ("|cFFFFAA00Hansgar and Franzok Assist|r dance bar size set to: ", t)
		else
			print ("|cFFFFAA00Hansgar and Franzok Assist|r invalid size, usage: /hansgar dancesize <width>.", t)
		end
		
		f:SetDanceBarSize()
	
	elseif (command == "dance") then
		db.SHOW_DANCE = not db.SHOW_DANCE
		if (db.SHOW_DANCE) then
			if (f.on_encounter) then
				f:StartTrackPlayerPosition()
			end
			print ("|cFFFFAA00Hansgar and Franzok Assist|r dance bars enabled.")
		else
			f:EndTrackPlayerPosition()
			print ("|cFFFFAA00Hansgar and Franzok Assist|r dance bars disabled.")
		end
	
	elseif (command == "cooldown") then
		db.CD_NUMBER = not db.CD_NUMBER
		f:RefreshCooldownSettings()
		
	else
	
		if (f.StampersPhase) then
			f:EndTrackPlayerPosition()
			return f:StopTracking()
		end
		
		f:StartTracking()
		f:StartTrackPlayerPosition()
	
		print ("|cFFFFAA00Hansgar and Franzok Assist|r |cFF00FF00" .. f.version .. "|r Commands:")
		print ("|cFFFFFF00/hansgar resetpos|r: reset the position of all frames.")
		print ("|cFFFFFF00/hansgar lock|r: toggle lock and unlock on the frame.")
		print ("|cFFFFFF00/hansgar test show hide|r: active the addon on test mode or hide it.")
		print ("|cFFFFFF00/hansgar delay <time>|r: time in seconds until the percentage goes from 0 to 100.")
		print ("|cFFFFFF00/hansgar dance|r: toggle dance bar (used to dodge regular stampers and searing plates).")
		print ("|cFFFFFF00/hansgar users|r: show who is using the addon in the raid.")
		print ("|cFFFFFF00/hansgar cooldown|r: show the countdown text for each stamper go back up to the ceiling.")
		print ("|cFFFFFF00/hansgar stopcast|r: show the alert to stop casting for Disrupting Roar.")
	end
end

--

local options_panel = {
	{
		type = "range",
		get = function() return db.STAMPERS_DELAY end,
		set = function (self, fixedparam, value) db.STAMPERS_DELAY = value end,
		min = 4,
		max = 8,
		step = 1,
		desc = "Time in seconds to move out from a heating up stamper.",
		name = "Stampers Delay",
	},
	{
		type = "range",
		get = function() return db.DANCE_SIZE end,
		set = function (self, fixedparam, value) f:SetDanceBarSize (value) end,
		min = 3,
		max = 25,
		step = 1,
		desc = "Set the dance bar size, the higher is the value, more thicker will be the bar.",
		name = "Dance Bar Size",
	},
	{
		type = "toggle",
		get = function() return db.FRAME_LOCK end,
		set = function (self, fixedparam, value) 
			db.FRAME_LOCK = not value;
			if (db.FRAME_LOCK) then
				f:SetLockState()
				print ("|cFFFFAA00Hansgar and Franzok Assist|r frame unlocked.")
				
				f.unlocked_frame = true
				f.player_pos_frame:Show()
				f.player_bar:Show()
				f.stop_casting_frame:Show()
			else
				f:SetLockState()
				print ("|cFFFFAA00Hansgar and Franzok Assist|r frame locked.")
				f.unlocked_frame = false
				f.stop_casting_frame:Hide()
			end			
		end,
		desc = "Lock or unlock the frames.",
		name = "Frame Locked"
	},
	{
		type = "toggle",
		get = function() return db.SHOW_DANCE end,
		set = function (self, fixedparam, value) 
			db.SHOW_DANCE = not db.SHOW_DANCE
			if (db.SHOW_DANCE) then
				if (f.on_encounter) then
					f:StartTrackPlayerPosition()
				end
			else
				f:EndTrackPlayerPosition()
			end		
		end,
		desc = "Enable or disable the dance bar.",
		name = "Dance Bar"
	},
	{
		type = "toggle",
		get = function() return db.NO_VERTICAL end,
		set = function (self, fixedparam, value) 
			db.NO_VERTICAL = not db.NO_VERTICAL
		end,
		desc = "When enabled, dance bar won't switch to vertical position when facing west and east.",
		name = "No Vertical Dance bar"
	},
	{
		type = "toggle",
		get = function() return db.CD_NUMBER end,
		set = function (self, fixedparam, value) 
			db.CD_NUMBER = not db.CD_NUMBER
			f:RefreshCooldownSettings()
		end,
		desc = "When enabled, shows the number countdown on each block.",
		name = "Show Cooldown Number"
	},
	{
		type = "toggle",
		get = function() return db.STOP_CAST end,
		set = function (self, fixedparam, value) 
			db.STOP_CAST = not db.STOP_CAST
		end,
		desc = "When enabled, shows an alert for Disrupting Roar.",
		name = "Stop Cast Alert"
	},
	{
		type = "execute",
		func = function() 
			if (f.StampersPhase) then
				f:EndTrackPlayerPosition()
				return f:StopTracking()
			end
			f:StartTracking()
			f:StartTrackPlayerPosition()
		end,
		desc = "Test the addon, run over the tracks in the room.",
		name = "Start Test Mode"
	},
	{
		type = "execute",
		func = function() 
			f:ClearAllPoints()
			f:SetPoint ("center", UIParent, "center")
			
			player_bar:ClearAllPoints()
			player_bar:SetPoint ("center", UIParent, "center")
			
			player_pos_frame:ClearAllPoints()
			player_pos_frame:SetPoint ("center", UIParent, "center")
			
			if (f.StampersPhase) then
				f:EndTrackPlayerPosition()
				f:StopTracking()
			end
			
			db.FRAME_LOCK = true
			f:SetLockState()
			
			f.unlocked_frame = true
			
			f:StartTracking()
			f:StartTrackPlayerPosition()
			
			print ("|cFFFFAA00Hansgar and Franzok Assist|r: position reseted and frames are unlocked.")
			print ("|cFFFFAA00Hansgar and Franzok Assist|r: move between the tracks to show the other frames.")
		end,
		desc = "Reset the position of all frames and start the test mode.",
		name = "Reset Position"
	},
	{
		type = "execute",
		func = function() 
			if (f.users_schedule) then
				print ("|cFFFFAA00Hansgar and Franzok Assist|r please wait 5 seconds...")
			elseif (IsInRaid()) then
				f.users = {}
				f:SendCommMessage ("HAFR", "US", "RAID")
				f.users_schedule = f:ScheduleTimer ("ShowUsers", 5)
				print ("|cFFFFAA00Hansgar and Franzok Assist|r please wait 5 seconds...")
			else
				print ("|cFFFFAA00Hansgar and Franzok Assist|r you aren't in a raid group.")
			end
		end,
		desc = "Show raid members which are also using this addon.",
		name = "Version Check"
	},
	{
		type = "execute",
		func = function() 
			f.feedback_func()
		end,
		desc = "Send a feedback for us on our Curse page or MMO-Champion forum Thread.",
		name = "Send Feedback"
	},
}

local build_options_panel = function()
	local options_frame = DF:CreateOptionsFrame ("HansgarFranzokAssistOptions", "Hans & Franz Assist", 1)
	options_frame:SetHeight (220)
	DF:BuildMenu (options_frame, options_panel, 15, -60, 220)
	options_frame:SetBackdropColor (0, 0, 0, .9)
end

f.OpenOptionsPanel = function()
	if (not HansgarFranzokAssistOptions) then
		build_options_panel()
	end
	HansgarFranzokAssistOptions:Show()
end

-- /run Hansgar_And_Franzok_Assist.OpenOptionsPanel()
local options = DF:CreateOptionsButton (f, f.OpenOptionsPanel, "Hansgar_And_Franzok_Assist_OPButton")
options:SetPoint ("right", f.Lock, "left", 1, 0)
f.Options = options

--
local feedback_func = function()
	local feedback1 = {icon = [[Interface\AddOns\Hansgar_And_Franzok_Assist\libs\DF\feedback_sites]], coords = DF.www_icons.mmoc, desc = "Post on our thread on MMO-Champion Forum.", link = [[http://www.mmo-champion.com/threads/1725970-Hans-gar-and-Franzok-Assist-(addon)]]}
	local feedback2 = {icon = [[Interface\AddOns\Hansgar_And_Franzok_Assist\libs\DF\feedback_sites]], coords = DF.www_icons.curse, desc = "Leave a comment on our page at Curse.com.", link = [[http://www.curse.com/addons/wow/hansgar_and_franzok_assist]]}
	
	local same1 = {name = "Details! Damage Meter", desc = "A Damage Meter with a lot of tools for raiders and leaders.", link = [[http://www.curse.com/addons/wow/details]], icon = [[Interface\AddOns\Hansgar_And_Franzok_Assist\libs\DF\all_addons]], coords = {0, 128/512, 0, 64/512}}
	local same2 = {name = "Gold Token Price", desc = "Adds the slash command '/gold'. This command tells you the current price of WoW Token.", link = [[http://www.curse.com/addons/wow/gold-token-price]], icon = [[Interface\AddOns\Hansgar_And_Franzok_Assist\libs\DF\all_addons]], coords = {128/512, 256/512, 0, 64/512}}
	local same3 = {name = "Salvage Yard Seller", desc = "Sells stuff gathered from salvage crates respecting item level limit.", link = [[http://www.curse.com/addons/wow/salvage-yard-seller]], icon = [[Interface\AddOns\Hansgar_And_Franzok_Assist\libs\DF\all_addons]], coords = {384/512, 512/512, 64/512, 128/512}}
	local same4 = {name = "AddOns CPU Usage", desc = "Measure the CPU usage by addons. Important to get rid of FPS drops during boss encounters.", link = [[http://www.curse.com/addons/wow/addons-cpu-usage]], icon = [[Interface\AddOns\Hansgar_And_Franzok_Assist\libs\DF\all_addons]], coords = {384/512, 512/512, 0, 64/512}}
	local same5 = {name = "Keep World Map Zoom", desc = "Because it's a pain having to re-zoom the world map after close and reopening in a short period of time.", link = [[http://www.curse.com/addons/wow/world-map-zoom]], icon = [[Interface\AddOns\Hansgar_And_Franzok_Assist\libs\DF\all_addons]], coords = {0/512, 128/512, 64/512, 128/512}}
	local same6 = {name = "PvPScan", desc = "Show a unit frame with enemy players near you.", link = [[http://www.wowace.com/addons/pvpscan/]], icon = [[Interface\AddOns\Hansgar_And_Franzok_Assist\libs\DF\all_addons]], coords = {128/512, 256/512, 64/512, 128/512}}
	local same7 = {name = "HotCorners", desc = "Show a hotcorner when poiting the mouse on the absolute top left of your screen (similar of those on Windows 8).", link = [[http://www.curse.com/addons/wow/hotcorners]], icon = [[Interface\AddOns\Hansgar_And_Franzok_Assist\libs\DF\all_addons]], coords = {256/512, 384/512, 64/512, 128/512}}
	
	DF:ShowFeedbackPanel ("Hans & Franz Assist", f.version, {feedback2, feedback1}, {same1, same2, same3, same4, same5, same6, same7})
end
f.feedback_func = feedback_func
local feedback_button = DF:CreateFeedbackButton (f, feedback_func, "Hansgar_And_Franzok_AssistFBButton")
feedback_button:SetPoint ("right", f.Options, "left", 0, -1)
--

local stop_casting_frame = CreateFrame ("frame", "Hansgar_And_Franzok_AssistStopCasting", UIParent)
stop_casting_frame:SetSize (200, 30)
stop_casting_frame:SetPoint ("center", UIParent, "center", 0, 75)
stop_casting_frame:SetFrameStrata ("FULLSCREEN")
f.stop_casting_frame = stop_casting_frame
stop_casting_frame:Hide()

stop_casting_frame:SetMovable (false)
stop_casting_frame:EnableMouse (false)

stop_casting_frame:SetScript ("OnMouseDown", function (self)
	if (not self.isMoving) then
		self:StartMoving()
		self.isMoving = true
	end
end)
stop_casting_frame:SetScript ("OnMouseUp", function (self)
	if (self.isMoving) then
		self:StopMovingOrSizing()
		self.isMoving = false
	end
end)

local alert = CreateFrame ("frame", "Hansgar_And_Franzok_AssistStopCastingAlert", stop_casting_frame, "ActionBarButtonSpellActivationAlert")
alert:SetPoint ("topleft", stop_casting_frame, "topleft", -10, 2)
alert:SetPoint ("bottomright", stop_casting_frame, "bottomright", 10, -2)
stop_casting_frame.alert = alert

local text = stop_casting_frame:CreateFontString (nil, "overlay", "GameFontNormal")
text:SetText ("STOP CASTING!")
text:SetPoint ("center", stop_casting_frame, "center")

stop_casting_frame:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
stop_casting_frame:SetBackdropColor (0, 0, 0, 0.3)

function f:HideStopSpellAlert2()
	stop_casting_frame.alert.animOut:Stop()
	stop_casting_frame:Hide()
end
function f:HideStopSpellAlert()
	stop_casting_frame.alert.animIn:Stop()
	stop_casting_frame.alert.animOut:Play()
	f:ScheduleTimer ("HideStopSpellAlert2", 0.3)
end

--3/22 13:44:48.995  SPELL_INTERRUPT,Vehicle-0-3132-1205-24243-76974-00000EF077,"Franzok",0x10a48,0x0,Player-00-063,"Grubdruid",0x514,0x0,160838,"Disrupting Roar",0x1,5185,"Healing Touch",8

f:SetScript ("OnEvent", function (self, event, time, token, _, who_serial, who_name, who_flags, _, target_serial, target_name, target_flags, _, spellid, spellname, spellschool, buff_type, buff_name)

	if (token == "SPELL_AURA_APPLIED" and spellid == 162124 and not f.StampersPhase) then
		f:StartTracking()
		f:EndTrackPlayerPosition()
		
	elseif (token == "SPELL_AURA_REMOVED" and spellid == 162124 and f.StampersPhase) then
		f:StopTracking()
		if (db.SHOW_DANCE) then
			f:StartTrackPlayerPosition()
		end
		
	elseif (token == "SPELL_CAST_START" and spellid == 160838 and db.STOP_CAST) then --Disrupting Roar
		f.stop_casting_frame:Show()
		f.stop_casting_frame.alert.animOut:Stop()
		f.stop_casting_frame.alert.animIn:Play()
		f:ScheduleTimer ("HideStopSpellAlert", 1.2)
		
	end
	
	if (token == "SPELL_INTERRUPT" and spellid == 160838 and db.STOP_CAST) then
		local link = GetSpellLink (buff_type)
		print ("Stop Cast Fail:", target_name, link)
	end
	
	--if (spellid == 160838) then
	--	print ("event:", token, 160838, db.STOP_CAST)
	--end

end)
--	/run Hansgar_And_Franzok_AssistStopCastingAlert.animIn:Play()

--Hansgar_And_Franzok_AssistStopCasting:Show(); Hansgar_And_Franzok_Assist:ScheduleTimer ("HideStopSpellAlert", 1)
--Hansgar_And_Franzok_Assist:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")

local frame_tracker = CreateFrame ("frame", "Hansgar_And_Franzok_AssistTracker", UIParent)
local on_update_tracker = function (self, elapsed)
	
	local raid_size = GetNumGroupMembers()
	
	for i = 1, raid_size do
		local x, y = GetPlayerMapPosition ("raid"..i)
		if (UnitExists ("raid"..i) and UnitHealth ("raid"..i) > 1 and x and y) then
			local block = f:WhichBlock (x, y)
			if (block) then
				if (not f.block_tracker [block]) then --> was a clear block
					f.block_tracker [block] = GetTime()
					f:Paint (f.all_blocks [block])
				end
			end
		end
	end
	
	local px, py = GetPlayerMapPosition ("player")
	local player_block = f:WhichBlock (px, py)
	if (player_block and f.block_tracker [player_block] and raid_size > 0) then
		
		local time_limit_at = f.block_tracker [player_block] + db.STAMPERS_DELAY
		local time_now = GetTime()
		
		local timeleft = time_limit_at - time_now
		f.player_bar:SetValue ((timeleft) / db.STAMPERS_DELAY * 100)
		if (timeleft > 0) then
			f.player_bar.text:SetText (format ("%.1f", timeleft))
		else
			f.player_bar.text:SetText ("Move!")
		end
		f.player_bar:Show()

		local block_frame = f.all_blocks [player_block]
		f.player_loc_box:SetPoint ("center", block_frame, "center")
		f.player_loc_box:Show()

	else
		if (f.unlocked_frame) then
			f.player_loc_box:Show()
			f.player_bar:Show()
			f.player_bar:SetValue (100)
		else
			f.player_loc_box:Hide()
			f.player_bar:Hide()
		end
	end
end

function f:StartTracking()

	print ("|cFFFFAA00Hansgar and Franzok Assist|r: Smart Stampers phase started.")

	f.StampersPhase = true

	if (not f.frames_built) then
		f:CreateWindow()
	end

	f:ResetBlocks()
	f.player_loc_box:Hide()

	f.block_tracker = f.block_tracker or {}
	table.wipe (f.block_tracker)

	SetMapToCurrentZone()

	frame_tracker:SetScript ("OnUpdate", on_update_tracker)
	f:Show()
	f.player_bar:Show()

end

function f:StopTracking()
	print ("|cFFFFAA00Hansgar and Franzok Assist|r: Smart Stampers phase ended.")

	f.StampersPhase = false
	frame_tracker:SetScript ("OnUpdate", nil)
	table.wipe (f.block_tracker)
	f.player_loc_box:Hide()
	f:Hide()
	f.player_bar:SetValue (0)
	f.player_bar:Hide()
end

local on_mouse_down = function (self)
	if (not self.isMoving and not db.FRAME_LOCK) then
		self.isMoving = true
		f:StartMoving()
	end
end
local on_mouse_up = function (self)
	if (self.isMoving) then
		self.isMoving = nil
		f:StopMovingOrSizing()
	end
end

local painting = function (self, elapsed)
	self.step = self.step + elapsed
	self.total_time = self.total_time + elapsed
	
	if (self.step > 0.2) then
		self.step = 0
		local percent = self.total_time / db.STAMPERS_DELAY * 100
		
		percent = min (percent, 100)
		
		local r, g, b = f:percent_color (percent, true)
		self:SetBackdropColor (r, g, b, 0.5)
		
		self.number:SetText (floor (percent) .. "%")
		self.number:SetTextColor (1, 1, 1, 1)
		
		if (percent == 100) then
			self:SetScript ("OnUpdate", nil)
			self.stamper_icon:Show()
			self.number:Hide()
			self.cooldown:Show()
			self.cooldown:SetCooldown (GetTime(), 37 - db.STAMPERS_DELAY, 0, 0)
		end
	end
end

function f:UnPaint (block)
	f:ResetBlock (block)
end
function f:Paint (block)
	block.step = 0
	block.total_time = 0
	block:SetScript ("OnUpdate", painting)
	local unpaint = f:ScheduleTimer ("UnPaint", 37, block)
	block.unpaint_process = unpaint
end

function f:ResetBlock (block)
	block:SetScript ("OnUpdate", nil)
	block:SetBackdropColor (.8, .8, .8, 0.5)
	block.number:SetText (block.id)
	block.number:SetTextColor (1, 1, 1, 0.5)
	block.number:Show()
	block.stamper_icon:Hide()
	block.cooldown:SetCooldown (0, 0, 0, 0)
	block.cooldown:Hide()
	
	f.block_tracker [block.id] = nil
	if (block.unpaint_process) then
		f:CancelTimer (block.unpaint_process)
		block.unpaint_process = nil
	end
end

function f:ResetBlocks()
	for _, block in ipairs (f.all_blocks) do
		f:ResetBlock (block)
	end
end

function f:RefreshCooldownSettings()
	for _, block in ipairs (f.all_blocks) do
		if (not db.CD_NUMBER) then
			block.cooldown:SetHideCountdownNumbers (true)
			block.cooldown:SetDrawEdge (false)
		else
			block.cooldown:SetHideCountdownNumbers (false)
			block.cooldown:SetDrawEdge (true)
		end
	end
end

function f:SetDanceBarSize (size)
	if (not size) then
		size = db.DANCE_SIZE
	end
	db.DANCE_SIZE = size
	
	t1:SetSize (player_pos_frame:GetWidth()*0.30, size)
	t2:SetSize (player_pos_frame:GetWidth()*0.15, size)
	middle:SetSize (player_pos_frame:GetWidth()*0.10, size)
	t3:SetSize (player_pos_frame:GetWidth()*0.15, size)
	t4:SetSize (player_pos_frame:GetWidth()*0.30, size)	
	
	t1_2:SetSize (size, player_pos_frame:GetWidth()*0.30)
	t2_2:SetSize (size, player_pos_frame:GetWidth()*0.15)
	middle_2:SetSize (size, player_pos_frame:GetWidth()*0.10)
	t3_2:SetSize (size, player_pos_frame:GetWidth()*0.15)
	t4_2:SetSize (size, player_pos_frame:GetWidth()*0.30)
	
	player_pos_frame2:SetSize (size, 155)
	player_pos_frame:SetSize (155, size)
end

function f:SetLockState (just_refresh)

	if (not just_refresh) then
		db.FRAME_LOCK = not db.FRAME_LOCK
	end
	
	if (db.FRAME_LOCK) then
		--locked
		f:EnableMouse (false)
		player_bar:EnableMouse (false)
		player_pos_frame:EnableMouse (false)
		stop_casting_frame:SetMovable (false)
		stop_casting_frame:EnableMouse (false)
		
		for _, block in ipairs (f.all_blocks) do
			block:EnableMouse (false)
		end
		
		if (f.StampersPhase and not just_refresh) then
			f:EndTrackPlayerPosition()
			f:StopTracking()
		end

	else
		--unlocked
		f:EnableMouse (true)
		player_bar:EnableMouse (true)
		player_pos_frame:EnableMouse (true)
		stop_casting_frame:SetMovable (true)
		stop_casting_frame:EnableMouse (true)
		
		for _, block in ipairs (f.all_blocks) do
			block:EnableMouse (true)
		end
		
		if (not f.StampersPhase and not just_refresh) then
			f:StartTracking()
			f:StartTrackPlayerPosition()
		end
		
	end
	
	if (not db.FRAME_LOCK) then
		player_bar.grip:Show()
	else
		player_bar.grip:Hide()
	end
end

function f:CreateWindow()
	local x = 0
	local y = 0
	
	f.player_loc_box = frame_event:CreateTexture (nil, "overlay")
	f.player_loc_box:SetSize (32, 40)
	f.player_loc_box:SetTexture ([[Interface\ContainerFrame\UI-Icon-QuestBorder]])
	f.player_loc_box:Hide()
	
	f.all_blocks = {}
	
	for i = 1, 20 do
		
		local block = CreateFrame ("frame", "Hansgar_And_Franzok_Assist_Block" .. i, f)
		block:SetSize (30, 38)
		block:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0},
		})
		block:SetBackdropBorderColor (0, 0, 0, 1)
		block:SetBackdropColor (.8, .8, .8, 0.5)
		block:SetPoint ("TopLeft", f, "TopLeft", x, y)
		
		block:SetScript ("OnMouseDown", on_mouse_down)
		block:SetScript ("OnMouseUp", on_mouse_up)
		
		local cooldown = CreateFrame ("cooldown", "Hansgar_And_Franzok_Assist_BlockCooldown" .. i, block, "CooldownFrameTemplate")
		cooldown:SetAllPoints()
		cooldown:SetFrameLevel (block:GetFrameLevel()+2)
		
		if (not db.CD_NUMBER) then
			cooldown:SetHideCountdownNumbers (true)
			cooldown:SetDrawEdge (false)
		end
		
		block.cooldown = cooldown
		
		block.id = i
		
		local number = block:CreateFontString (nil, "artwork", "GameFontHighlight")
		number:SetPoint ("center", block, "center")
		number:SetText (i)
		number:SetTextColor (1, 1, 1, 0.5)
		block.number = number
		
		local stamper_icon = block:CreateTexture (nil, "overlay")
		stamper_icon:SetTexture ([[Interface\ICONS\Warrior_talent_icon_LambsToTheSlaughter]])
		stamper_icon:SetTexCoord (5/64, 59/64, 5/64, 59/64)
		stamper_icon:SetSize (23, 23)
		stamper_icon:SetPoint ("center", block, "center")
		stamper_icon:Hide()
		block.stamper_icon = stamper_icon
		
		x = x + 31
		if (x >= 155) then
			x = 0
			y = y - 40
		end
		
		tinsert (f.all_blocks, block)
		
	end
	
	f:SetLockState (true)
	
	f.frames_built = true
	
	f:SetDanceBarSize()
end

local safe_track = {
	--space 1
	{
		block = {x1 = 0.50154542922974, x2 = 0.49563668874741},
		left = {x1 = 0.49963343143463, x2 = 0.49963343143463 - 0.000624573974608}, 
		right = {x1 = 0.49710285663605, x2 = 0.49710285663605 + 0.000992229919432}, 
		-- {x1 = 0.49963343143463, y1 = 0.73492467403412} -- {x1 = 0.49710285663605, y1 = 0.74445152282715}
	},
	--space 2
	{
		block = {x1 = 0.4858917593956, x2 = 0.48044270277023},
		left = {x1 = 0.48433673381805, x2 = 0.48433673381805 - 0.00091059207916}, 
		right = {x1 = 0.48206025362015, x2 = 0.48206025362015 + 0.00075059207916},
		-- {x1 = 0.48433673381805, y1 = 0.74292266368866} -- {x1 = 0.48206025362015, y1 = 0.78930181264877}
	},
	--space 3
	{
		block = {x1 = 0.47047740221024, x2 = 0.4648859500885},
		left = {x1 = 0.46893924474716, x2 = 0.46893924474716 - 0.000902948493956},
		right = {x1 = 0.46635687351227, x2 = 0.46635687351227 + 0.000970948493956},
		--{x1 = 0.46893924474716, y1 = 0.7981019616127} -- {x1 = 0.46635687351227, y1 = 0.73558133840561}
	},
	--space 4
	{
		block = {x1 = 0.45503282546997, x2 = 0.44976264238358},
		left = {x1 = 0.4533554315567, x2 = 0.4533554315567 - 0.000714573974608}, 
		right = {x1 = 0.45124399662018, x2 = 0.45124399662018 + 0.000770009999999},
		--{x1 = 0.4533554315567, y1 = 0.74078941345215} -- {x1 = 0.45124399662018, y1 = 0.74088287353516}
	}
}
Hansgar_safe_track = safe_track

--	/hansgar test
--	/run Hansgar_safe_track [4].left.x2 = 0.4533554315567 - 0.000714573974608

local red_alpha_disabled = 0.2
local red_alpha_enabled = 0.5

local green_alpha_disabled = 0.05
local green_alpha_enabled = 0.9

function f:ChangeDanceBar (facing)
	
	if (facing == 1 or facing == 2) then --> north or south
		t1_2:Hide()
		t2_2:Hide()
		t3_2:Hide()
		t4_2:Hide()
		middle_2:Hide()
		t1:Show()
		t2:Show()
		t3:Show()
		t4:Show()
		middle:Show()
		
		player_pos_frame2:Hide()
		player_pos_frame:SetBackdropColor (0, 0, 0, 1)
		
	elseif (facing == 3 or facing == 4) then --> west or east
		t1_2:Show()
		t2_2:Show()
		t3_2:Show()
		t4_2:Show()
		middle_2:Show()
		t1:Hide()
		t2:Hide()
		t3:Hide()
		t4:Hide()
		middle:Hide()
		
		player_pos_frame:SetBackdropColor (0, 0, 0, 0)
		player_pos_frame2:Show()
		
	end
	
end

local track_function = function (self, elapsed)

	local x, _ = GetPlayerMapPosition ("player")
	local block
	
	if (db.AUTO_FACING and x) then
	
		local facing = GetPlayerFacing()
		local current = self.facing
		
		if (db.NO_VERTICAL) then
			-- get 2 direction in radians
			if (current ~= 1 and (facing > 5.3 or facing < 1.053)) then --north -> south -- ~30º tolerance
				--print ("south")
				self.facing = 1
			elseif (current ~= 2 and (facing > 2.3 and facing < 4.3)) then
				--print ("north")
				self.facing = 2
			end
		else
			-- get 4 directions in radians
			if (facing < 0.7 or facing > 5.6) then --north
				--print ("north")
				self.facing = 1
			elseif (facing >= 0.7 and facing < 2.45) then --west
				--print ("west")
				self.facing = 3
			elseif (facing > 2.45 and facing < 3.85) then --south
				--print ("south")
				self.facing = 2
			elseif (facing >= 3.85 and facing <= 5.6) then --east
				--print ("east")
				self.facing = 4
			end
		end
		
		if (current ~= self.facing) then
			f:ChangeDanceBar (self.facing)
		end
		
	end

	if (x) then
		for i = 1, #safe_track do
			local loc = safe_track [i]
			if (x >= loc.block.x2 and x <= loc.block.x1) then
				block = i
				break
			end
		end
	end
	
	if (block and safe_track [block]) then
	
		player_pos_frame:Show()
		block = safe_track [block]
		
		if (self.facing == 3 or self.facing == 4) then --> west
			player_pos_frame2:Show()
		end
		
		if (x >= block.left.x2 and x <= block.left.x1) then
			if (self.facing == 2) then --> south
				t2:SetTexture (0.1, 1, 0.1, green_alpha_enabled)
				t3:SetTexture (0.2, 1, 0.2, green_alpha_disabled)
			elseif (self.facing == 1) then --> north
				t3:SetTexture (0.2, 232/255, 1, green_alpha_enabled)
				t2:SetTexture (0.2, 232/255, 1, green_alpha_disabled)
			elseif (self.facing == 3) then --> west
				t2_2:SetTexture (0.1, 1, 0.1, green_alpha_enabled)
				t3_2:SetTexture (0.2, 1, 0.2, green_alpha_disabled)
			elseif (self.facing == 4) then --> east
				t3_2:SetTexture (0.2, 232/255, 1, green_alpha_enabled)
				t2_2:SetTexture (0.2, 232/255, 1, green_alpha_disabled)
			end
			
			t1:SetVertexColor (1, 0.2, 0.2, red_alpha_disabled) --red
			t4:SetVertexColor (1, 0.2, 0.2, red_alpha_disabled) --red 
			middle:SetVertexColor (1, 0.2, 0.2, red_alpha_disabled) --red
			t1_2:SetVertexColor (1, 0.2, 0.2, red_alpha_disabled) --red
			t4_2:SetVertexColor (1, 0.2, 0.2, red_alpha_disabled) --red 
			middle_2:SetVertexColor (1, 0.2, 0.2, red_alpha_disabled) --red
			
		elseif (x <= block.right.x2 and x >= block.right.x1) then
			if (self.facing == 2) then --> south
				t3:SetTexture (0.1, 1, 0.1, green_alpha_enabled)
				t2:SetTexture (0.2, 1, 0.2, green_alpha_disabled)
			elseif (self.facing == 1) then --> north
				t2:SetTexture (0.2, 232/255, 1, green_alpha_enabled)
				t3:SetTexture (0.2, 232/255, 1, green_alpha_disabled)
			elseif (self.facing == 3) then --> west
				t3_2:SetTexture (0.1, 1, 0.1, green_alpha_enabled)
				t2_2:SetTexture (0.2, 1, 0.2, green_alpha_disabled)
			elseif (self.facing == 4) then --> east
				t2_2:SetTexture (0.2, 232/255, 1, green_alpha_enabled)
				t3_2:SetTexture (0.2, 232/255, 1, green_alpha_disabled)
			end
			
			t1:SetVertexColor (1, 0.2, 0.2, red_alpha_disabled) --red
			t4:SetVertexColor (1, 0.2, 0.2, red_alpha_disabled) --red 
			middle:SetVertexColor (1, 0.2, 0.2, red_alpha_disabled) --red
			t1_2:SetVertexColor (1, 0.2, 0.2, red_alpha_disabled) --red
			t4_2:SetVertexColor (1, 0.2, 0.2, red_alpha_disabled) --red 
			middle_2:SetVertexColor (1, 0.2, 0.2, red_alpha_disabled) --red
			
		else
			t1:SetVertexColor (1, 0.2, 0.2, red_alpha_enabled) --red
			t4:SetVertexColor (1, 0.2, 0.2, red_alpha_enabled) --red 
			middle:SetVertexColor (1, 0.2, 0.2, red_alpha_enabled) --red
			t1_2:SetVertexColor (1, 0.2, 0.2, red_alpha_enabled) --red
			t4_2:SetVertexColor (1, 0.2, 0.2, red_alpha_enabled) --red 
			middle_2:SetVertexColor (1, 0.2, 0.2, red_alpha_enabled) --red
			
			t2:SetTexture (0.2, 1, 0.2, green_alpha_disabled)
			t3:SetTexture (0.2, 1, 0.2, green_alpha_disabled)
			t2_2:SetTexture (0.2, 1, 0.2, green_alpha_disabled)
			t3_2:SetTexture (0.2, 1, 0.2, green_alpha_disabled)
			
		end
		
		--x = x - block.block.x2
		--local at = abs ((x / (block.block.x1 - block.block.x2) * 100) - 100)
		--div:SetPoint ("left", player_pos_frame, "left", self.width_pixel * at, 0)

	else
		if (f.unlocked_frame) then
			player_pos_frame:Show()
		else
			player_pos_frame:Hide()
			player_pos_frame2:Hide()
		end
	end
end

function f:StartTrackPlayerPosition()
	player_pos_frame:Show()
	tframe.width = player_pos_frame:GetWidth()
	tframe.width_pixel = tframe.width / 100
	tframe.facing = db.FACING_SIDE == 1
	tframe:SetScript ("OnUpdate", track_function)
end
function f:EndTrackPlayerPosition()
	player_pos_frame:Hide()
	player_pos_frame2:Hide()
	tframe:SetScript ("OnUpdate", nil)
end

local locs = {
	--block 1:
	{x1 = 0.51103663444519, y1 = 0.79726493358612, x2 = 0.50061076879501, y2 = 0.8241291642189},
	--block 2:
	{x1 = 0.49670505523682, y1 = 0.79692482948303, x2 = 0.48469054698944, y2 = 0.82489335536957},	
	--block 3:
	{x1 = 0.48130965232849, y1 = 0.79742962121964, x2 = 0.46962946653366, y2 = 0.82453238964081},
	--block 4:
	{x1 = 0.46575212478638, y1 = 0.79766929149628, x2 = 0.45400339365005, y2 = 0.82176661491394},	
	--block 5:
	{x1 = 0.45073217153549, y1 = 0.79751670360565, x2 = 0.43945103883743, y2 = 0.82504689693451},	

	--block 6
	{x1 = 0.51104211807251, y1 = 0.76532691717148, x2 = 0.50021582841873, y2 = 0.79546189308167},
	--block 7
	{x1 = 0.4964514374733, y1 = 0.76603573560715, x2 = 0.48449218273163, y2 = 0.79527854919434},	
	--block 8
	{x1 = 0.48101079463959, y1 = 0.76503103971481, x2 = 0.46944016218185, y2 = 0.79543298482895},
	--block 9
	{x1 = 0.46541726589203, y1 = 0.7654857635498, x2 = 0.45369201898575, y2 = 0.79529416561127},
	--block 10
	{x1 = 0.45051556825638, y1 = 0.76583826541901, x2 = 0.43931984901428, y2 = 0.79570162296295},
	

	--block 11
	{x1 = 0.51104187965393, y1 = 0.73422884941101, x2 = 0.49990028142929, y2 = 0.76343530416489},
	--block 12
	{x1 = 0.49673527479172, y1 = 0.73338270187378, x2 = 0.48483556509018, y2 = 0.76356953382492},
	--block 13
	{x1 = 0.48133307695389, y1 = 0.73373115062714, x2 = 0.46920585632324, y2 = 0.76366758346558},
	--block 14
	{x1 = 0.46568286418915, y1 = 0.73440700769424, x2 = 0.45381307601929, y2 = 0.76358675956726},
	--block 15
	{x1 = 0.45046973228455, y1 = 0.73361301422119, x2 = 0.43929302692413, y2 = 0.76388084888458},

	--block 16
	{x1 = 0.51104891300201, y1 = 0.70877063274384, x2 = 0.50024521350861, y2 = 0.73220580816269},
	--block 17
	{x1 = 0.49676024913788, y1 = 0.70914703607559, x2 = 0.48485481739044, y2 = 0.73210543394089},
	--block 18
	{x1 = 0.48142266273499, y1 = 0.70876735448837, x2 = 0.46925610303879, y2 = 0.73205661773682},
	--block 19
	{x1 = 0.46603119373322, y1 = 0.70929777622223, x2 = 0.45397216081619, y2 = 0.73167610168457},
	--block 20
	{x1 = 0.45079308748245, y1 = 0.70926278829575, x2 = 0.43927478790283, y2 = 0.73225915431976},
}

function f:WhichBlock (x, y)
	for i = 1, #locs do
		local loc = locs [i]
		if (x >= loc.x2 and x <= loc.x1 and y >= loc.y1 and y <= loc.y2) then
			return i
		end
	end
end

function f:percent_color (value, inverted)
	local r, g
	if (value < 50) then
		r = 255
	else
		r = floor ( 255 - (value * 2 - 100) * 255 / 100)
	end
	
	if (value > 50) then
		g = 255
	else
		g = floor ( (value * 2) * 255 / 100)
	end
	
	if (inverted) then
		return g/255, r/255, 0
	else
		return r/255, g/255, 0
	end
end
