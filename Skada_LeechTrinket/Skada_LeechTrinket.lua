
--- ########################### ---
local UnitGUID = UnitGUID
local GetNumGroupMembers = GetNumGroupMembers
local LibInspect = LibStub and LibStub:GetLibrary("LibInspect")
local Ticker = C_Timer.NewTimer

local GUID_LeechCache = {}	 -- {[GUID] = Leech} cache for scanned leech values
local GUIDsLastScan = {}  -- {[GUID] = GetTime()} 
local roster = {}		 -- {unitID = leech} contains only current group members, 'false' if leech is unknown
local GUIDtoUnitID = {}
local maxAge = 60*5		-- maximum leech scan age in seconds before rescanning
local tooltip -- = CreateFrame('GameTooltip', 'LeechScanTooltip', UIParent, 'GameTooltipTemplate')

local waitingForScan = false
local waitingForScanTimeOut = 5
local waitingForScanTimer
local function CancelWaitingForScan() 
	waitingForScan = false 
	if waitingForScanTimer then 
		waitingForScanTimer:Cancel() 
	end
end
local function WaitForScan()
	waitingForScan = true
	waitingForScanTimer = Ticker(waitingForScanTimeOut, CancelWaitingForScan, 1)
end

local function GroupChangedUpdateUnit(u)
	local GUID = UnitGUID(u)
	GUIDtoUnitID[GUID] = u
	local cached = GUID_LeechCache[GUID]
	if cached then
		roster[GUID] = cached
	else
		roster[GUID] = false
	end
end

local f = CreateFrame("frame")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_LOGIN")

f:SetScript("OnEvent", function(_, e, ...)
	if e == "GROUP_ROSTER_UPDATE" or e == "PLAYER_ENTERING_WORLD" then
		wipe(roster)
		wipe(GUIDtoUnitID)
		if IsInRaid() then
			for i=1, GetNumGroupMembers() do
				GroupChangedUpdateUnit("raid"..i)
			end
		else
			GroupChangedUpdateUnit("player")
			for i=1, GetNumGroupMembers()-1 do
				GroupChangedUpdateUnit("party"..i)
			end
		end
	elseif e == "PLAYER_LOGIN" then
		tooltip = CreateFrame('GameTooltip', 'LeechScanTooltip', nil, 'GameTooltipTemplate')
		tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	end
end)

local ItemLeechCache = {} -- [hyperlink] = leech
local leechCapture = "+(%d+) "..GetSpellInfo(143924) --leech in tooltips is localised
local function ScanItemTooltips(GUID, data, age)
	if data then
		local leechTotal = 0
		for k, v in pairs(data.items) do
			local leech = ItemLeechCache[v]
			if not leech then
				leech = 0
				tooltip:ClearLines()
				tooltip:SetHyperlink(v) -- example hyperlink with leech "|cffa335ee|Hitem:124244:0:0:0:0:0:0:0:100:270:0:5:2:41:566|h[Chestguard of Gnawing Desire]|h|r"
				for i=1, tooltip:NumLines() do
					leech = leech + (tonumber(_G["LeechScanTooltipTextLeft"..i]:GetText():match(leechCapture)) or 0) 
				end
				ItemLeechCache[v] = leech
			end
			leechTotal = leechTotal + leech
		end
		roster[GUID] = leechTotal
		GUID_LeechCache[GUID] = leechTotal
		GUIDsLastScan[GUID] = GetTime()

		--local count = 0
		--for _ in pairs(roster) do count = count + 1 end
		--print("["..UnitName(GUIDtoUnitID[GUID]).."] <"..count.."/"..GetNumGroupMembers().."> leechTotal: "..leechTotal)
	end
	CancelWaitingForScan()
end

if not LibInspect or not LibInspect:AddHook("Skada_LeechTrinket", "items", function(GUID, data, age) ScanItemTooltips(GUID, data, age) end) then
	error("Skada_LeechTrinket: Error loading LibInspect")
	return
else
	LibInspect:SetMaxAge(maxAge)
end

local function QueueUnitScan(GUID)
	local UnitID = GUIDtoUnitID[GUID]
	if not UnitIsVisible(UnitID) then 
		return false 
	end
	caninspect, unitfound, refreshing = LibInspect:RequestData("items", UnitID, false)
	local waiting = caninspect and unitfound and refreshing
	WaitForScan(waiting)
	return waiting
end

local scanTick = C_Timer.NewTicker(1, function()
	if InCombatLockdown() then return end
	if waitingForScan then
		return end
	for k, v in pairs(roster) do 
		if not v then 
			if QueueUnitScan(k) then
				return
			end
		end
	end
	local time = GetTime()
	for k, v in pairs(roster) do 
		if GUIDsLastScan[k] and GUIDsLastScan[k] + maxAge < time then 
			if QueueUnitScan(k) then
				return
			end
		end
	end
end)

local Skada = Skada
local mod = Skada:NewModule("Trinket Leech")
local leechedmod = Skada:NewModule("Trinket Leech targets")
local leech = {}

local function log_leech(set, leech)
	local player = Skada:get_player(set, leech.playerid, leech.playername)

	if player and leech then
		player.leech = player.leech + leech.amount
		set.leech = set.leech + leech.amount

		do
			if leech.dstName and leech.dstGUID then
				local leeched = player.leeched[leech.dstGUID]

				-- Create recipient if it does not exist.
				if not leeched then
					local _, className = UnitClass(leech.dstName)
                    local playerRole = UnitGroupRolesAssigned(leech.dstName)
					leeched = {name = leech.dstName, class = className, role = playerRole, amount = 0, shielding = 0}
					player.leeched[leech.dstGUID] = leeched
				end

				leeched.amount = leeched.amount + leech.amount
			end
		end
	end
end

local function OnHeal(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
	local spellId, spellName, spellSchool, amount, overhealing = ...

	if spellId == 143924 then
		local staticLeech = roster[dstGUID] or 0
		local totalLeech = staticLeech
		local trinketSources = {}

		if overhealing == amount then return end

		for i=1, 40 do
			local name, _, _, _, _, _, _, caster, _, _, spellID, _, _, _, leech = UnitAura(dstName, i)
			if not name then
				break
			end
			if spellID == 184671 then
				local data = {}
				data.name = UnitName(caster or "")
				data.guid = UnitGUID(caster or "")
				data.leech = leech
				trinketSources[data.guid or "UNKNOWN"] = data
				totalLeech = totalLeech + leech
			end
		end
		
		if overhealing > 0 then --assign maximum possible part of effective healing to static leech, the rest is divided normaly
			local passiveLeechFraction = staticLeech/totalLeech
			local effectiveHealing = amount-overhealing
			local passivePart = passiveLeechFraction <= overhealing/amount and passiveLeechFraction*effectiveHealing or effectiveHealing
			effectiveHealing = effectiveHealing - passivePart
			totalLeech = totalLeech - staticLeech
			if effectiveHealing > 0 then
				for k, v in pairs(trinketSources) do
					leech.dstName = dstName
					leech.dstGUID = dstGUID
					leech.playerid = v.guid
					leech.playername = v.name
					leech.amount = (v.leech/totalLeech)*effectiveHealing
					--print("totalLeech: "..totalLeech.." buff: "..v.leech)
					--print("effectiveHealing: "..effectiveHealing.." "..((v.leech/totalLeech)*100).."% -> "..leech.amount)
				
					log_leech(Skada.current, leech)
					log_leech(Skada.total, leech)
				end
			end
		else
			for k, v in pairs(trinketSources) do
				leech.dstName = dstName
				leech.dstGUID = dstGUID
				leech.playerid = v.guid
				leech.playername = v.name
				leech.amount = (v.leech/totalLeech)*amount
				--print("totalLeech: "..totalLeech.." buff: "..v.leech)
				--print("amount: "..amount.." "..((v.leech/totalLeech)*100).."% -> "..leech.amount)

				log_leech(Skada.current, leech)
				log_leech(Skada.total, leech)
			end
		end
	end
end

local function getHPS(set, player)
	local totaltime = Skada:PlayerActiveTime(set, player)

	return player.leech / math.max(1,totaltime)
end

-- ##### mod ##### --
function mod:Update(win, set)
	local nr = 1
	local max = 0

	for i, player in ipairs(set.players) do
		if player.leech > 0 then

			local d = win.dataset[nr] or {}
			win.dataset[nr] = d

			d.id = player.id
			d.label = player.name
			d.value = player.leech

			d.valuetext = Skada:FormatValueText(
											Skada:FormatNumber(player.leech), self.metadata.columns.Healing,
											Skada:FormatNumber(getHPS(set, player)), self.metadata.columns.HPS,
											string.format("%02.1f%%", player.leech / set.leech * 100), self.metadata.columns.Percent
										)
			d.class = player.class
			d.role = player.role

			if player.leech > max then
				max = player.leech
			end

			nr = nr + 1
		end
	end

	win.metadata.maxvalue = max
end

function mod:OnEnable()
	mod.metadata = {showspots = true, click1 = leechedmod, columns = {Healing = true, HPS = true, Percent = true}}
	leechedmod.metadata = {showspots = true, columns = {Healing = true, Percent = true}}

	Skada:RegisterForCL(OnHeal, 'SPELL_HEAL', {src_is_interesting_nopets = true})
	Skada:AddMode(self)
	Skada:AddMode(leechedmod)
end

function mod:OnDisable()
	Skada:RemoveMode(self)
	Skada:RemoveMode(leechedmod)
end

-- Called by Skada when a new player is added to a set.
function mod:AddPlayerAttributes(player)
	player.leeched = player.leeched or {}						-- Stored leech per recipient
	player.leech = player.leech or 0					-- Total leech
end

-- Called by Skada when a new set is created.
function mod:AddSetAttributes(set)
	set.leech = set.leech or 0
end

-- ##### leechedmod ##### --
function leechedmod:Enter(win, id, label)
		leechedmod.playerid = id
		leechedmod.title = "Leeched by".." "..label
end

function leechedmod:Update(win, set)
	local player = Skada:find_player(set, leechedmod.playerid)
	local nr = 1
	local max = 0

	if player then
		for dstGUID, leech in pairs(player.leeched) do
			if leech.amount > 0 then

				local d = win.dataset[nr] or {}
				win.dataset[nr] = d

				d.id = dstGUID
				d.label = leech.name or dstGUID -- second clause for legacy data upgrade
				d.value = leech.amount
				d.class = leech.class
                d.role = player.role
				d.valuetext = Skada:FormatValueText(
											Skada:FormatNumber(leech.amount), self.metadata.columns.Healing,
											string.format("%02.1f%%", leech.amount / player.leech * 100), self.metadata.columns.Percent
										)
				if leech.amount > max then
					max = leech.amount
				end

				nr = nr + 1
			end
		end
	end

	win.metadata.hasicon = true
	win.metadata.maxvalue = max
end

