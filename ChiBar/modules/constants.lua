-- Addon:	ChiBar: constants and variables
-- Author:	Fushui(EU-Azshara)

if select(2, UnitClass("player")) ~= "MONK" then
    return
end

------------------------------------------
--		Creating Variables 				--
------------------------------------------

-- Creating MainArray for all da fun, mon!
ChiBar.VERSIONNUMBER = GetAddOnMetadata("ChiBar", "Version")

-- Some Constants
ChiBar.ICON = "|TInterface\\Addons\\ChiBar\\images\\MonkLightPower:15:15|t"
ChiBar.VERSIONTEXT_1 = ChiBar.ICON .. " |cff00FF96ChiBar Version " .. ChiBar.VERSIONNUMBER .. " " .. ChiBar.ICON
ChiBar.VERSIONTEXT_2 = "|cff00FF96Coding: Fushui (EU-Azshara)   Textures: Ayliara (EU-Azshara)"
ChiBar.BUBBLEDIM = 50
ChiBar.CLASSPOWER = {
	["MONK"] = 12,
	["PALADIN"] = 9,
	}
ChiBar.CLASSPOWERID = ChiBar.CLASSPOWER[select(2, UnitClass("player"))]
ChiBar.FIRST_SLASH_START = 0

-- Texture names
ChiBar.TEXTURES = {
	{"Chinese Dragon",		"chinese_dragon"},
	{"KittyFox",			"kittyfox"},
	{"Minimalistic 1",		"minimalistic_1"},
	{"Minimalistic 2",		"minimalistic_2"},
	{"Rhombus 1",			"rhombus_1"},
	{"Rhombus 2",			"rhombus_2"},
	{"Sphere Simple",		"sphere_simple"},
	{"Sphere Sun 1",		"sphere_sun_1"},
	{"Sphere Sun 2",		"sphere_sun_2"},
	{"Square Simple",		"square_simple"},
	{"Yin & Yang 1",		"yin_yang_1"},
	{"Yin & Yang 2",		"yin_yang_2"},
	{"Yin & Yang 3",		"yin_yang_3"},
}

ChiBar.DBSTANDARDVALUES = {
    ["x"] = 0,
	["y"] = 0,
	["from"] = "CENTER",
	["to"] = "CENTER",
	["scale"] = 1,
	["alpha1"] = 1,
	["alpha2"] = 1,
    ["alphaMana"] = 1,
	["seperate"] = false,
	["enable"] = true,
	["autohide"] = false,
	["savedTexture"] = 11,
	["grow1"] = true,
	["grow2"] = true,
	["color"] = {1, 1, 1},
	["hideStandard"] = false,
	["mainLayer"] = 3,
	["strata"] = 2,
	["offset"] = 0,
    ["showMana"] = true,
    ["manaBarOverlapping"] = 6,
}

-- 
ChiBar.EVENTS = {
    "UNIT_POWER_FREQUENT",
    "UNIT_POWER",
	"UNIT_ENTERED_VEHICLE",
	"UNIT_EXITED_VEHICLE",
	"UNIT_MAXPOWER",
	"PLAYER_REGEN_DISABLED",
	"PLAYER_REGEN_ENABLED",
	"PET_BATTLE_OPENING_START",
	"PET_BATTLE_CLOSE",
	"UNIT_DISPLAYPOWER",
	}

-- Creating the folderpath of the textures for the addon
ChiBar.textures = {}
local index
for index = 1, #ChiBar.TEXTURES do
	ChiBar.textures[((index*2)-1)] =
		"Interface\\Addons\\ChiBar\\images\\" .. ChiBar.TEXTURES[index][2] .. "_empty.tga"
	ChiBar.textures[(index*2)] =
		"Interface\\Addons\\ChiBar\\images\\" .. ChiBar.TEXTURES[index][2] .. "_glow.tga"
end


------------------------------------------
--		End of Script					--
------------------------------------------