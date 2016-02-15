-------------------------------------------------------------------------------
-- ElvUI Raid Markers Bar By Lockslap (US, Bleeding Hollow)
--------------------------------------------------------------------------------
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("ElvUI_RaidMarkers", "ruRU", false)
if not L then return end

L["Alt"] = true -- Needs review
L["Automatically hide the bar during a pet battle."] = "Automatically hide the bar during a pet battle." -- Requires localization
L["Automatically toggle the bar based on your target.\
\
|cff00ff00This only applies when you are solo.|r"] = "Automatically toggle the bar based on your target.\
\
|cff00ff00This only applies when you are solo.|r" -- Requires localization
L["Auto Show/Hide"] = "\208\161\208\186\209\128\209\139\209\130\209\140 \208\176\208\178\209\130\208\190\208\188\208\176\209\130\208\184\209\135\208\181\209\129\208\186\208\184 \208\184\208\187\208\184 \208\189\208\181\209\130 ?" -- Needs review
L["Choose the button modifier to use the world markers (flares)."] = "\208\146\209\139\208\177\208\181\209\128\208\184\209\130\208\181 \208\186\208\189\208\190\208\191\208\186\209\131 \208\186\208\187\208\176\208\178\208\184\208\176\209\130\209\131\209\128\209\139 \208\180\208\187\209\143 \208\184\209\129\208\191\208\190\208\187\209\140\208\183\208\190\208\178\208\176\208\189\208\184\209\143 \208\188\208\176\209\128\208\186\208\181\209\128\208\190\208\178 (\208\178\209\129\208\191\209\139\209\136\208\186\208\184)." -- Needs review
L["Choose the orientation of the raid markers bar."] = "Choose the orientation of the raid markers bar." -- Requires localization
L["Click to clear the mark."] = "\208\157\208\176\208\182\208\188\208\184\209\130\208\181, \209\135\209\130\208\190\208\177\209\139 \209\131\208\177\209\128\208\176\209\130\209\140 \208\188\208\181\209\130\208\186\209\131" -- Needs review
L["Click to clear the mark.\
%sClick to remove all flares."] = "Click to clear the mark.\
%sClick to remove all flares." -- Requires localization
L["Click to mark the target."] = "\208\157\208\176\208\182\208\188\208\184\209\130\208\181, \209\135\209\130\208\190\208\177\209\139 \208\191\208\190\208\188\208\181\209\130\208\184\209\130\209\140 \209\134\208\181\208\187\209\140" -- Needs review
L["Click to mark the target.\
%sClick to place a flare."] = "Click to mark the target.\
%sClick to place a flare." -- Requires localization
L["Control"] = true -- Needs review
L["ElvUI Raid Markers"] = "ElvUI Raid Markers" -- Requires localization
L["Hide in Pet Battle"] = "\208\161\208\186\209\128\209\139\209\130\209\140 \208\191\209\128\208\184 \208\145\208\184\209\130\208\178\208\181 \208\159\208\184\209\130\208\190\208\188\209\134\208\181\208\178" -- Needs review
L["Horizontal"] = "\208\147\208\190\209\128\208\184\208\183\208\190\208\189\209\130\208\176\208\187\209\140\208\189\208\190" -- Needs review
L["Orientation"] = "\208\158\209\128\208\184\208\181\208\189\209\130\208\176\209\134\208\184\209\143" -- Needs review
L["Plugins by |cff9382c9Lockslap|r"] = "Plugins by |cff9382c9Lockslap|r" -- Requires localization
L["Raid Markers"] = "\208\160\208\181\208\185\208\180 \208\188\208\176\209\128\208\186\208\181\209\128\209\139" -- Needs review
L["Raid Markers Bar"] = "\208\159\208\176\208\189\208\181\208\187\209\140 \208\188\208\181\209\130\208\190\208\186 \209\128\208\181\208\185\208\180\208\176" -- Needs review
L["Scale"] = "\208\156\208\176\209\129\209\136\209\130\208\176\208\177" -- Needs review
L["Set the frame scale."] = "Set the frame scale." -- Requires localization
L["Shift"] = true -- Needs review
L["Show Raid Markers Bar"] = "\208\159\208\190\208\186\208\176\208\183\208\176\209\130\209\140 \208\191\208\176\208\189\208\181\208\187\209\140 \"\208\160\208\181\208\185\208\180 \208\188\208\176\209\128\208\186\208\181\209\128\209\139\"" -- Needs review
L["Thanks for using and supporting my work!  -- |cff9382c9Lockslap|r\
\
|cffff0000If you find any bugs, or have any suggestions for any of my addons, please open a ticket at that particular addon's page on CurseForge."] = "Thanks for using and supporting my work!  -- |cff9382c9Lockslap|r\
\
|cffff0000If you find any bugs, or have any suggestions for any of my addons, please open a ticket at that particular addon's page on CurseForge." -- Requires localization
L["Toggle the raid markers bar."] = "\208\146\208\186\208\187\\\208\146\209\139\208\186\208\187 \208\176\208\180\208\180\208\190\208\189" -- Needs review
L["Vertical"] = "\208\146\208\181\209\128\209\130\208\184\208\186\208\176\208\187\209\140\208\189\208\190" -- Needs review
L["World Markers Modifier"] = "World Markers Modifier" -- Requires localization
