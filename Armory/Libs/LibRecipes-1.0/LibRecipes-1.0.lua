local MAJOR = "LibRecipes-1.0"
local MINOR = 1 -- Should be manually increased
assert(LibStub, MAJOR .. " requires LibStub")

local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end -- No upgrade needed

local type = type
local tonumber = tonumber
local error = error
local select = select
local pairs = pairs

local recipes = lib.recipes or {}
local spells = lib.spells or {}
lib.recipes, lib.spells = recipes, spells

-- ----------------------------------------------------------------------------
-- Internals
-- ----------------------------------------------------------------------------

local function AsNumber(value)
    local valueType = type(value)
    if valueType == "number" then
        return value
    elseif valueType == "string" then
        return tonumber(value)
    end
end

local function Flatten(t, i)
    if t == nil then
        return nil
    elseif i == nil then
        i = 1
        local f = {}
        for k, v in pairs(t) do
            f[i] = k
            f[i+1] = v
            i = i + 2
        end
        return Flatten(f, 1)
    elseif i <= select("#", t) then
        return t[i], t[i+1] or nil, Flatten(t, i+2)
    end
end

-- ----------------------------------------------------------------------------
-- Public API
-- ----------------------------------------------------------------------------

--- Register a recipe
-- @param recipeId Id of the recipe
-- @param spellId Id of the spell learned
-- @param itemId Id of the item created by casting the spell
-- @usage -- item:37337  Formula: Enchant Bracer - Greater Stats <br/>
-- -- spell:44616 Greater Stats <br/>
-- -- item:38987  Enchant Bracer - Greater Stats <br/>
-- LibStub("LibRecipes-1.0"):AddRecipe(37337, 44616, 38987)
-- @return nil
function lib:AddRecipe(recipeId, spellId, itemId)
    recipeId = AsNumber(recipeId)
    if recipeId == nil then 
        error("invalid recipe id")
    end
    spellId = AsNumber(spellId)
    if spellId == nil then
        error("invalid spell id")
    end
    -- a craft spell usually creates an item
    itemId = AsNumber(itemId) or false
    
    -- recipe can provide multiple spells (e.g. "Plans: Balanced Trillium Ingot and Its Uses")
    local recipe = recipes[recipeId]
    if recipe == nil then
        recipes[recipeId] = {}
        recipe = recipes[recipeId]
    end
    recipe[spellId] = itemId
    
    -- multiple recipes can provide the same spell (e.g. "Design: Rigid Star of Elune")
    local spell = spells[spellId]
    if spell == nil then
        spells[spellId] = {}
        spell = spells[spellId]
    end
    spell[recipeId] = itemId
end

--- Retrieves the spell and item id related to the specified recipe; repeats in case of multiple spells (spell1, item1, spell2, item2, ...)
-- @param recipeId Id of the recipe
-- @return Id of the spell that is learned 
-- @usage local spellId, itemId = LibStub("LibRecipes-1.0"):GetRecipeInfo(37337) <br/>
-- -- spellId = 44616 <br/>
-- -- itemId = 38987 
-- @return Id of the item that is created by the spell or nil if not applicable
function lib:GetRecipeInfo(recipeId)
    recipeId = AsNumber(recipeId)
    if recipeId == nil then 
        error("invalid recipe id")
    end
    return Flatten(recipes[recipeId])
end

--- Retrieves the recipe and item id related to the specified spell; repeats in case of multiple recipes (recipe1, item1, recipe2, item2, ...)
-- @param spellId Id of the spell
-- @usage local recipeId, itemId = LibStub("LibRecipes-1.0"):GetSpellInfo(44616) <br/>
-- -- recipeId = 37337 <br/>
-- -- itemId = 38987 
-- @return Id of the recipe that learns the spell
-- @return Id of the item that is created by the spell or nil if not applicable
function lib:GetSpellInfo(spellId)
    spellId = AsNumber(spellId)
    if spellId == nil then
        error("invalid spell id")
    end
    return Flatten(spells[spellId])
end

--- Determines if a spell is taught by a recipe
-- @param spellId Id of the spell
-- @param recipeId Id of the recipe
-- @usage local thaughtBy = LibStub("LibRecipes-1.0"):ThaughtBy(44616, 37337) <br/>
-- -- thaughtBy = true
-- @return true if the recipe teaches the spell; otherwise false
function lib:ThaughtBy(spellId, recipeId)
    spellId = AsNumber(spellId)
    if spellId == nil then
        error("invalid spell id")
    end
    recipeId = AsNumber(recipeId)
    if recipeId == nil then 
        error("invalid recipe id")
    end
   return spells[spellId] and spells[spellId][recipeId] ~= nil or false
end

--- Determines if a recipe teaches a spell
-- @param recipeId Id of the recipe
-- @param spellId Id of the spell
-- @usage local teaches = LibStub("LibRecipes-1.0"):Teaches(37337, 44616) <br/>
-- -- teaches = true
-- @return true if the spell is taught by the recipe; otherwise false
function lib:Teaches(recipeId, spellId)
    recipeId = AsNumber(recipeId)
    if recipeId == nil then 
        error("invalid recipe id")
    end
    spellId = AsNumber(spellId)
    if spellId == nil then
        error("invalid spell id")
    end
    return recipes[recipeId] and recipes[recipeId][spellId] ~= nil or false
end

-- ----------------------------------------------------------------------------
-- Data (don't forget to increase MINOR when updated)
-- ----------------------------------------------------------------------------

-- Alchemy
lib:AddRecipe(3396, 2333, 3390) -- Elixir of Lesser Agility
lib:AddRecipe(2555, 2335, 2459) -- Swiftness Potion
lib:AddRecipe(3394, 3174, 3386) -- Potion of Curing
lib:AddRecipe(3395, 3175, 3387) -- Limited Invulnerability Potion
lib:AddRecipe(6211, 3188, 3391) -- Elixir of Ogre's Strength
lib:AddRecipe(2553, 3230, 2457) -- Elixir of Minor Agility
lib:AddRecipe(6068, 3449, 3824) -- Shadow Oil
lib:AddRecipe(3830, 3450, 3825) -- Elixir of Fortitude
lib:AddRecipe(3831, 3451, 3826) -- Major Troll's Blood Elixir
lib:AddRecipe(3832, 3453, 3828) -- Elixir of Detect Lesser Invisibility
lib:AddRecipe(14634, 3454, 3829) -- Frost Oil
lib:AddRecipe(4597, 4508, 4596) -- Discolored Healing Potion
lib:AddRecipe(4624, 4942, 4623) -- Lesser Stoneshield Potion
lib:AddRecipe(5640, 6617, 5631) -- Rage Potion
lib:AddRecipe(5643, 6618, 5633) -- Great Rage Potion
lib:AddRecipe(5642, 6624, 5634) -- Free Action Potion
lib:AddRecipe(6053, 7255, 6051) -- Holy Protection Potion
lib:AddRecipe(6054, 7256, 6048) -- Shadow Protection Potion
lib:AddRecipe(6055, 7257, 6049) -- Fire Protection Potion
lib:AddRecipe(6056, 7258, 6050) -- Frost Protection Potion
lib:AddRecipe(6057, 7259, 6052) -- Nature Protection Potion
lib:AddRecipe(6663, 8240, 6662) -- Elixir of Giant Growth
lib:AddRecipe(10644, 11456, 9061) -- Goblin Rocket Fuel
lib:AddRecipe(9294, 11458, 9144) -- Wildvine Potion
lib:AddRecipe(9303, 11459, 9149) -- Philosopher's Stone
lib:AddRecipe(9295, 11464, 9172) -- Invisibility Potion
lib:AddRecipe(9296, 11466, 9088) -- Gift of Arthas
lib:AddRecipe(9297, 11468, 9197) -- Elixir of Dream Vision
lib:AddRecipe(9298, 11472, 9206) -- Elixir of Giants
lib:AddRecipe(9302, 11473, 9210) -- Ghost Dye
lib:AddRecipe(9301, 11476, 9264) -- Elixir of Shadow Power
lib:AddRecipe(9300, 11477, 9224) -- Elixir of Demonslaying
lib:AddRecipe(9304, 11479, 3577) -- Transmute: Iron to Gold
lib:AddRecipe(9305, 11480, 6037) -- Transmute: Mithril to Truesilver
lib:AddRecipe(12958, 17187, 12360) -- Transmute: Arcanite
lib:AddRecipe(13476, 17552, 13442) -- Mighty Rage Potion
lib:AddRecipe(13477, 17553, 13443) -- Superior Mana Potion
lib:AddRecipe(13478, 17554, 13445) -- Elixir of Superior Defense
lib:AddRecipe(13479, 17555, 13447) -- Elixir of the Sages
lib:AddRecipe(13480, 17556, 13446) -- Major Healing Potion
lib:AddRecipe(13481, 17557, 13453) -- Elixir of Brute Force
lib:AddRecipe(13482, 17559, 7078) -- Transmute: Air to Fire
lib:AddRecipe(13483, 17560, 7076) -- Transmute: Fire to Earth
lib:AddRecipe(13484, 17561, 7080) -- Transmute: Earth to Water
lib:AddRecipe(13485, 17562, 7082) -- Transmute: Water to Air
lib:AddRecipe(13486, 17563, 7080) -- Transmute: Undeath to Water
lib:AddRecipe(13487, 17564, 12808) -- Transmute: Water to Undeath
lib:AddRecipe(13488, 17565, 7076) -- Transmute: Life to Earth
lib:AddRecipe(13489, 17566, 12803) -- Transmute: Earth to Life
lib:AddRecipe(13490, 17570, 13455) -- Greater Stoneshield Potion
lib:AddRecipe(13491, 17571, 13452) -- Elixir of the Mongoose
lib:AddRecipe(13492, 17572, 13462) -- Purification Potion
lib:AddRecipe(13493, 17573, 13454) -- Greater Arcane Elixir
lib:AddRecipe(13494, 17574, 13457) -- Greater Fire Protection Potion
lib:AddRecipe(13495, 17575, 13456) -- Greater Frost Protection Potion
lib:AddRecipe(13496, 17576, 13458) -- Greater Nature Protection Potion
lib:AddRecipe(13497, 17577, 13461) -- Greater Arcane Protection Potion
lib:AddRecipe(13499, 17578, 13459) -- Greater Shadow Protection Potion
lib:AddRecipe(13500, 17579, 13460) -- Greater Holy Protection Potion
lib:AddRecipe(13501, 17580, 13444) -- Major Mana Potion
lib:AddRecipe(13517, 17632, 13503) -- Alchemist Stone
lib:AddRecipe(13518, 17634, 13506) -- Potion of Petrification
lib:AddRecipe(13519, 17635, 13510) -- Flask of the Titans
lib:AddRecipe(31354, 17635, 13510) -- Flask of the Titans
lib:AddRecipe(13520, 17636, 13511) -- Flask of Distilled Wisdom
lib:AddRecipe(31356, 17636, 13511) -- Flask of Distilled Wisdom
lib:AddRecipe(13521, 17637, 13512) -- Flask of Supreme Power
lib:AddRecipe(31355, 17637, 13512) -- Flask of Supreme Power
lib:AddRecipe(17709, 21923, 17708) -- Elixir of Frost Power
lib:AddRecipe(18257, 22732, 18253) -- Major Rejuvenation Potion
lib:AddRecipe(20011, 24365, 20007) -- Mageblood Elixir
lib:AddRecipe(20012, 24366, 20002) -- Greater Dreamless Sleep Potion
lib:AddRecipe(20013, 24367, 20008) -- Living Action Potion
lib:AddRecipe(20014, 24368, 20004) -- Mighty Troll's Blood Elixir
lib:AddRecipe(20761, 25146, 7068) -- Transmute: Elemental Fire
lib:AddRecipe(21547, 26277, 21546) -- Elixir of Greater Firepower
lib:AddRecipe(22900, 28543, 22823) -- Elixir of Camouflage
lib:AddRecipe(22901, 28546, 22826) -- Sneaking Potion
lib:AddRecipe(22902, 28549, 22827) -- Elixir of Major Frost Power
lib:AddRecipe(22903, 28550, 22828) -- Insane Strength Potion
lib:AddRecipe(22904, 28552, 22830) -- Elixir of the Searching Eye
lib:AddRecipe(22905, 28553, 22831) -- Elixir of Major Agility
lib:AddRecipe(24001, 28553, 22831) -- Elixir of Major Agility
lib:AddRecipe(22906, 28554, 22871) -- Shrouding Potion
lib:AddRecipe(22907, 28555, 22832) -- Super Mana Potion
lib:AddRecipe(22908, 28556, 22833) -- Elixir of Major Firepower
lib:AddRecipe(22909, 28557, 22834) -- Elixir of Major Defense
lib:AddRecipe(22910, 28558, 22835) -- Elixir of Major Shadow Power
lib:AddRecipe(22911, 28562, 22836) -- Major Dreamless Sleep Potion
lib:AddRecipe(22912, 28563, 22837) -- Heroic Potion
lib:AddRecipe(22913, 28564, 22838) -- Haste Potion
lib:AddRecipe(35295, 28564, 22838) -- Haste Potion
lib:AddRecipe(22914, 28565, 22839) -- Destruction Potion
lib:AddRecipe(22915, 28566, 21884) -- Transmute: Primal Air to Fire
lib:AddRecipe(22916, 28567, 21885) -- Transmute: Primal Earth to Water
lib:AddRecipe(22917, 28568, 22452) -- Transmute: Primal Fire to Earth
lib:AddRecipe(30443, 28568, 22452) -- Transmute: Primal Fire to Earth
lib:AddRecipe(22918, 28569, 22451) -- Transmute: Primal Water to Air
lib:AddRecipe(22919, 28570, 22840) -- Elixir of Major Mageblood
lib:AddRecipe(22920, 28571, 22841) -- Major Fire Protection Potion
lib:AddRecipe(22921, 28572, 22842) -- Major Frost Protection Potion
lib:AddRecipe(22922, 28573, 22844) -- Major Nature Protection Potion
lib:AddRecipe(22923, 28575, 22845) -- Major Arcane Protection Potion
lib:AddRecipe(22924, 28576, 22846) -- Major Shadow Protection Potion
lib:AddRecipe(22925, 28577, 22847) -- Major Holy Protection Potion
lib:AddRecipe(22926, 28578, 22848) -- Elixir of Empowerment
lib:AddRecipe(35294, 28578, 22848) -- Elixir of Empowerment
lib:AddRecipe(22927, 28579, 22849) -- Ironshield Potion
lib:AddRecipe(23574, 29688, 23571) -- Transmute: Primal Might
lib:AddRecipe(25869, 32765, 25867) -- Transmute: Earthstorm Diamond
lib:AddRecipe(25870, 32766, 25868) -- Transmute: Skyfire Diamond
lib:AddRecipe(29232, 32766, 25868) -- Transmute: Skyfire Diamond
lib:AddRecipe(31680, 38960, 31679) -- Fel Strength Elixir
lib:AddRecipe(31682, 38961, 31677) -- Fel Mana Potion
lib:AddRecipe(31681, 38962, 31676) -- Fel Regeneration Potion
lib:AddRecipe(32070, 39637, 32063) -- Earthen Elixir
lib:AddRecipe(32071, 39639, 32068) -- Elixir of Ironskin
lib:AddRecipe(34481, 45061, 34440) -- Mad Alchemist's Potion
lib:AddRecipe(35752, 47046, 35748) -- Guardian's Alchemist Stone
lib:AddRecipe(35753, 47048, 35749) -- Sorcerer's Alchemist Stone
lib:AddRecipe(35754, 47049, 35750) -- Redeemer's Alchemist Stone
lib:AddRecipe(35755, 47050, 35751) -- Assassin's Alchemist Stone
lib:AddRecipe(44564, 53936, 40213) -- Mighty Arcane Protection Potion
lib:AddRecipe(44566, 53937, 40215) -- Mighty Frost Protection Potion
lib:AddRecipe(44568, 53938, 40217) -- Mighty Shadow Protection Potion
lib:AddRecipe(112022, 53938, 40217) -- Mighty Shadow Protection Potion
lib:AddRecipe(44565, 53939, 40214) -- Mighty Fire Protection Potion
lib:AddRecipe(44567, 53942, 40216) -- Mighty Nature Protection Potion
lib:AddRecipe(65435, 92643, 62288) -- Cauldron of Battle
lib:AddRecipe(65498, 92688, 65460) -- Big Cauldron of Battle
lib:AddRecipe(67538, 93328, 65891) -- Vial of the Sands
lib:AddRecipe(112023, 156560, 109262) -- Draenic Philosopher's Stone
lib:AddRecipe(112024, 156561, 109145) -- Draenic Agility Flask
lib:AddRecipe(112026, 156563, 109147) -- Draenic Intellect Flask
lib:AddRecipe(112027, 156564, 109148) -- Draenic Strength Flask
lib:AddRecipe(112029, 156567, 109151) -- Draenor Armor Flask
lib:AddRecipe(112030, 156568, 109152) -- Draenic Stamina Flask
lib:AddRecipe(112031, 156569, 109153) -- Greater Draenic Agility Flask
lib:AddRecipe(112033, 156571, 109155) -- Greater Draenic Intellect Flask
lib:AddRecipe(112034, 156572, 109156) -- Greater Draenic Strength Flask
lib:AddRecipe(112037, 156576, 109160) -- Greater Draenic Stamina Flask
lib:AddRecipe(112038, 156577, 109217) -- Draenic Agility Potion
lib:AddRecipe(112039, 156578, 109218) -- Draenic Intellect Potion
lib:AddRecipe(112040, 156579, 109219) -- Draenic Strength Potion
lib:AddRecipe(112041, 156580, 109220) -- Draenic Armor Potion
lib:AddRecipe(112042, 156581, 109221) -- Draenic Channeled Mana Potion
lib:AddRecipe(112043, 156582, 109222) -- Draenic Mana Potion
lib:AddRecipe(112045, 156584, 109226) -- Draenic Rejuvenation Potion
lib:AddRecipe(112046, 156585, 109123) -- Crescent Oil
lib:AddRecipe(112048, 156587, 108996) -- Alchemical Catalyst
lib:AddRecipe(112049, 156588, 108996) -- Alchemical Catalyst - Fireweed
lib:AddRecipe(112050, 156589, 108996) -- Alchemical Catalyst - Flytrap
lib:AddRecipe(112051, 156590, 108996) -- Alchemical Catalyst - Starflower
lib:AddRecipe(112052, 156591, 108996) -- Primal Alchemy
lib:AddRecipe(122710, 156591, 108996) -- Primal Alchemy
lib:AddRecipe(112053, 156592, 108996) -- Alchemical Catalyst - Orchid
lib:AddRecipe(112054, 156593, 108996) -- Alchemical Catalyst - Lotus
lib:AddRecipe(112047, 162403, 112090) -- Transmorphic Tincture
lib:AddRecipe(120132, 175880, 118700) -- Secrets of Draenor Alchemy
lib:AddRecipe(122600, 181643, 118472) -- Transmute: Savage Blood
lib:AddRecipe(128160, 188674, 128158) -- Wildswater
lib:AddRecipe(128161, 188676, 128159) -- Elemental Distillate
-- Blacksmithing
lib:AddRecipe(2881, 2667, 2864) -- Runed Copper Breastplate
lib:AddRecipe(5577, 2671, 2867) -- Rough Bronze Bracers
lib:AddRecipe(5578, 2673, 2869) -- Silvered Bronze Breastplate
lib:AddRecipe(2883, 3295, 3490) -- Deadly Bronze Poniard
lib:AddRecipe(3608, 3297, 3492) -- Mighty Iron Hammer
lib:AddRecipe(3609, 3321, 3471) -- Copper Chain Vest
lib:AddRecipe(3610, 3325, 3474) -- Gemmed Copper Gauntlets
lib:AddRecipe(2882, 3330, 3481) -- Silvered Bronze Shoulders
lib:AddRecipe(3611, 3334, 3484) -- Green Iron Boots
lib:AddRecipe(3612, 3336, 3485) -- Green Iron Gauntlets
lib:AddRecipe(12162, 3492, 3849) -- Hardened Iron Shortsword
lib:AddRecipe(3866, 3493, 3850) -- Jade Serpentblade
lib:AddRecipe(10858, 3494, 3851) -- Solid Iron Maul
lib:AddRecipe(3867, 3495, 3852) -- Golden Iron Destroyer
lib:AddRecipe(12163, 3496, 3853) -- Moonsteel Broadsword
lib:AddRecipe(3868, 3497, 3854) -- Frost Tiger Blade
lib:AddRecipe(12164, 3498, 3855) -- Massive Iron Axe
lib:AddRecipe(3869, 3500, 3856) -- Shadow Crescent Axe
lib:AddRecipe(6047, 3503, 3837) -- Golden Scale Coif
lib:AddRecipe(3870, 3504, 3840) -- Green Iron Shoulders
lib:AddRecipe(3871, 3505, 3841) -- Golden Scale Shoulders
lib:AddRecipe(3872, 3507, 3843) -- Golden Scale Leggings
lib:AddRecipe(3873, 3511, 3845) -- Golden Scale Cuirass
lib:AddRecipe(3874, 3513, 3846) -- Polished Steel Boots
lib:AddRecipe(3875, 3515, 3847) -- Golden Scale Boots
lib:AddRecipe(5543, 6518, 5541) -- Iridescent Hammer
lib:AddRecipe(6044, 7221, 6042) -- Iron Shield Spike
lib:AddRecipe(6045, 7222, 6043) -- Iron Counterweight
lib:AddRecipe(6046, 7224, 6041) -- Steel Weapon Chain
lib:AddRecipe(6734, 8366, 6730) -- Ironforge Chain
lib:AddRecipe(6735, 8367, 6731) -- Ironforge Breastplate
lib:AddRecipe(6736, 8368, 6733) -- Ironforge Gauntlets
lib:AddRecipe(7978, 9811, 7913) -- Barbaric Iron Shoulders
lib:AddRecipe(7979, 9813, 7914) -- Barbaric Iron Breastplate
lib:AddRecipe(7980, 9814, 7915) -- Barbaric Iron Helm
lib:AddRecipe(7981, 9818, 7916) -- Barbaric Iron Boots
lib:AddRecipe(7982, 9820, 7917) -- Barbaric Iron Gloves
lib:AddRecipe(7975, 9933, 7921) -- Heavy Mithril Pants
lib:AddRecipe(7995, 9937, 7924) -- Mithril Scale Bracers
lib:AddRecipe(7976, 9939, 7967) -- Mithril Shield Spike
lib:AddRecipe(7977, 9942, 7925) -- Mithril Scale Gloves
lib:AddRecipe(7983, 9945, 7926) -- Ornate Mithril Pants
lib:AddRecipe(7984, 9950, 7927) -- Ornate Mithril Gloves
lib:AddRecipe(7985, 9952, 7928) -- Ornate Mithril Shoulder
lib:AddRecipe(7994, 9957, 7929) -- Orcish War Leggings
lib:AddRecipe(7989, 9964, 7969) -- Mithril Spurs
lib:AddRecipe(7991, 9966, 7932) -- Mithril Scale Shoulders
lib:AddRecipe(7990, 9970, 7934) -- Heavy Mithril Helm
lib:AddRecipe(7986, 9972, 7935) -- Ornate Mithril Breastplate
lib:AddRecipe(7988, 9979, 7936) -- Ornate Mithril Boots
lib:AddRecipe(7987, 9980, 7937) -- Ornate Mithril Helm
lib:AddRecipe(7992, 9995, 7942) -- Blue Glittering Axe
lib:AddRecipe(8029, 9997, 7943) -- Wicked Mithril Blade
lib:AddRecipe(7993, 10005, 7944) -- Dazzling Mithril Rapier
lib:AddRecipe(74274, 10007, 7961) -- Phantom Blade
lib:AddRecipe(8028, 10009, 7946) -- Runed Mithril Hammer
lib:AddRecipe(8030, 10013, 7947) -- Ebon Shiv
lib:AddRecipe(10713, 11454, 9060) -- Inlaid Mithril Cylinder
lib:AddRecipe(9367, 11643, 9366) -- Golden Scale Gauntlets
lib:AddRecipe(10424, 12259, 10423) -- Silvered Bronze Leggings
lib:AddRecipe(11610, 15292, 11608) -- Dark Iron Pulverizer
lib:AddRecipe(11614, 15293, 11606) -- Dark Iron Mail
lib:AddRecipe(11611, 15294, 11607) -- Dark Iron Sunderer
lib:AddRecipe(11615, 15295, 11605) -- Dark Iron Shoulders
lib:AddRecipe(11612, 15296, 11604) -- Dark Iron Plate
lib:AddRecipe(12261, 15973, 12260) -- Searing Golden Blade
lib:AddRecipe(12682, 16642, 12405) -- Thorium Armor
lib:AddRecipe(12683, 16643, 12406) -- Thorium Belt
lib:AddRecipe(12684, 16644, 12408) -- Thorium Bracers
lib:AddRecipe(12685, 16645, 12416) -- Radiant Belt
lib:AddRecipe(12687, 16646, 12428) -- Imperial Plate Shoulders
lib:AddRecipe(12688, 16647, 12424) -- Imperial Plate Belt
lib:AddRecipe(12689, 16648, 12415) -- Radiant Breastplate
lib:AddRecipe(12690, 16649, 12425) -- Imperial Plate Bracers
lib:AddRecipe(12691, 16650, 12624) -- Wildthorn Mail
lib:AddRecipe(12692, 16651, 12645) -- Thorium Shield Spike
lib:AddRecipe(12693, 16652, 12409) -- Thorium Boots
lib:AddRecipe(12694, 16653, 12410) -- Thorium Helm
lib:AddRecipe(12695, 16654, 12418) -- Radiant Gloves
lib:AddRecipe(12699, 16655, 12631) -- Fiery Plate Gauntlets
lib:AddRecipe(12697, 16656, 12419) -- Radiant Boots
lib:AddRecipe(12700, 16657, 12426) -- Imperial Plate Boots
lib:AddRecipe(12701, 16658, 12427) -- Imperial Plate Helm
lib:AddRecipe(12702, 16659, 12417) -- Radiant Circlet
lib:AddRecipe(12698, 16660, 12625) -- Dawnbringer Shoulders
lib:AddRecipe(12703, 16661, 12632) -- Storm Gauntlets
lib:AddRecipe(12704, 16662, 12414) -- Thorium Leggings
lib:AddRecipe(12705, 16663, 12422) -- Imperial Plate Chest
lib:AddRecipe(12706, 16664, 12610) -- Runic Plate Shoulders
lib:AddRecipe(12707, 16665, 12611) -- Runic Plate Boots
lib:AddRecipe(12696, 16667, 12628) -- Demon Forged Breastplate
lib:AddRecipe(12711, 16724, 12633) -- Whitesoul Helm
lib:AddRecipe(12713, 16725, 12420) -- Radiant Leggings
lib:AddRecipe(12714, 16726, 12612) -- Runic Plate Helm
lib:AddRecipe(12716, 16728, 12636) -- Helm of the Great Chief
lib:AddRecipe(12717, 16729, 12640) -- Lionheart Helm
lib:AddRecipe(12715, 16730, 12429) -- Imperial Plate Leggings
lib:AddRecipe(12718, 16731, 12613) -- Runic Breastplate
lib:AddRecipe(12719, 16732, 12614) -- Runic Plate Leggings
lib:AddRecipe(12720, 16741, 12639) -- Stronghold Gauntlets
lib:AddRecipe(12725, 16742, 12620) -- Enchanted Thorium Helm
lib:AddRecipe(12726, 16744, 12619) -- Enchanted Thorium Leggings
lib:AddRecipe(12727, 16745, 12618) -- Enchanted Thorium Breastplate
lib:AddRecipe(12728, 16746, 12641) -- Invulnerable Mail
lib:AddRecipe(12816, 16960, 12764) -- Thorium Greatsword
lib:AddRecipe(12817, 16965, 12769) -- Bleakwood Hew
lib:AddRecipe(12818, 16967, 12772) -- Inlaid Thorium Hammer
lib:AddRecipe(12819, 16969, 12773) -- Ornate Thorium Handaxe
lib:AddRecipe(12821, 16970, 12774) -- Dawn's Edge
lib:AddRecipe(12823, 16971, 12775) -- Huge Thorium Battleaxe
lib:AddRecipe(12824, 16973, 12776) -- Enchanted Battlehammer
lib:AddRecipe(12825, 16978, 12777) -- Blazing Rapier
lib:AddRecipe(12826, 16980, 12779) -- Rune Edge
lib:AddRecipe(12827, 16983, 12781) -- Serenity
lib:AddRecipe(12828, 16984, 12792) -- Volcanic Hammer
lib:AddRecipe(12830, 16985, 12782) -- Corruption
lib:AddRecipe(12831, 16986, 12795) -- Blood Talon
lib:AddRecipe(12832, 16987, 12802) -- Darkspear
lib:AddRecipe(12833, 16988, 12796) -- Hammer of the Titans
lib:AddRecipe(12834, 16990, 12790) -- Arcanite Champion
lib:AddRecipe(12835, 16991, 12798) -- Annihilator
lib:AddRecipe(12836, 16992, 12797) -- Frostguard
lib:AddRecipe(12837, 16993, 12794) -- Masterwork Stormhammer
lib:AddRecipe(12838, 16994, 12784) -- Arcanite Reaper
lib:AddRecipe(12839, 16995, 12783) -- Heartseeker
lib:AddRecipe(17049, 20872, 16989) -- Fiery Chain Girdle
lib:AddRecipe(17053, 20873, 16988) -- Fiery Chain Shoulders
lib:AddRecipe(17051, 20874, 17014) -- Dark Iron Bracers
lib:AddRecipe(17052, 20876, 17013) -- Dark Iron Leggings
lib:AddRecipe(17059, 20890, 17015) -- Dark Iron Reaver
lib:AddRecipe(17060, 20897, 17016) -- Dark Iron Destroyer
lib:AddRecipe(18592, 21161, 17193) -- Sulfuron Hammer
lib:AddRecipe(17706, 21913, 17704) -- Edge of Winter
lib:AddRecipe(18264, 22757, 18262) -- Elemental Sharpening Stone
lib:AddRecipe(19202, 23628, 19043) -- Heavy Timbermaw Belt
lib:AddRecipe(19204, 23629, 19048) -- Heavy Timbermaw Boots
lib:AddRecipe(19203, 23632, 19051) -- Girdle of the Dawn
lib:AddRecipe(19205, 23633, 19057) -- Gloves of the Dawn
lib:AddRecipe(19206, 23636, 19148) -- Dark Iron Helm
lib:AddRecipe(19207, 23637, 19164) -- Dark Iron Gauntlets
lib:AddRecipe(19208, 23638, 19166) -- Black Amnesty
lib:AddRecipe(19209, 23639, 19167) -- Blackfury
lib:AddRecipe(19210, 23650, 19170) -- Ebon Hand
lib:AddRecipe(19211, 23652, 19168) -- Blackguard
lib:AddRecipe(19212, 23653, 19169) -- Nightfall
lib:AddRecipe(19776, 24136, 19690) -- Bloodsoul Breastplate
lib:AddRecipe(19777, 24137, 19691) -- Bloodsoul Shoulders
lib:AddRecipe(19778, 24138, 19692) -- Bloodsoul Gauntlets
lib:AddRecipe(19779, 24139, 19693) -- Darksoul Breastplate
lib:AddRecipe(19780, 24140, 19694) -- Darksoul Leggings
lib:AddRecipe(19781, 24141, 19695) -- Darksoul Shoulders
lib:AddRecipe(20040, 24399, 20039) -- Dark Iron Boots
lib:AddRecipe(20553, 24912, 20549) -- Darkrune Gauntlets
lib:AddRecipe(20555, 24913, 20551) -- Darkrune Helm
lib:AddRecipe(20554, 24914, 20550) -- Darkrune Breastplate
lib:AddRecipe(22209, 27585, 22197) -- Heavy Obsidian Belt
lib:AddRecipe(22219, 27586, 22198) -- Jagged Obsidian Shield
lib:AddRecipe(22222, 27587, 22196) -- Thick Obsidian Breastplate
lib:AddRecipe(22214, 27588, 22195) -- Light Obsidian Belt
lib:AddRecipe(22220, 27589, 22194) -- Black Grasp of the Destroyer
lib:AddRecipe(22221, 27590, 22191) -- Obsidian Mail Tunic
lib:AddRecipe(22388, 27829, 22385) -- Titanic Leggings
lib:AddRecipe(22390, 27830, 22384) -- Persuader
lib:AddRecipe(22389, 27832, 22383) -- Sageblade
lib:AddRecipe(22703, 28242, 22669) -- Icebane Breastplate
lib:AddRecipe(22704, 28243, 22670) -- Icebane Gauntlets
lib:AddRecipe(22705, 28244, 22671) -- Icebane Bracers
lib:AddRecipe(22766, 28461, 22762) -- Ironvine Breastplate
lib:AddRecipe(22767, 28462, 22763) -- Ironvine Gloves
lib:AddRecipe(22768, 28463, 22764) -- Ironvine Belt
lib:AddRecipe(23590, 29566, 23502) -- Adamantite Maul
lib:AddRecipe(23591, 29568, 23503) -- Adamantite Cleaver
lib:AddRecipe(23592, 29569, 23504) -- Adamantite Dagger
lib:AddRecipe(23593, 29571, 23505) -- Adamantite Rapier
lib:AddRecipe(23594, 29603, 23506) -- Adamantite Plate Bracers
lib:AddRecipe(23595, 29605, 23508) -- Adamantite Plate Gloves
lib:AddRecipe(23596, 29606, 23507) -- Adamantite Breastplate
lib:AddRecipe(23597, 29608, 23510) -- Enchanted Adamantite Belt
lib:AddRecipe(23599, 29610, 23509) -- Enchanted Adamantite Breastplate
lib:AddRecipe(23598, 29611, 23511) -- Enchanted Adamantite Boots
lib:AddRecipe(23600, 29613, 23512) -- Enchanted Adamantite Leggings
lib:AddRecipe(23601, 29614, 23515) -- Flamebane Bracers
lib:AddRecipe(23602, 29615, 23516) -- Flamebane Helm
lib:AddRecipe(23603, 29616, 23514) -- Flamebane Gloves
lib:AddRecipe(23604, 29617, 23513) -- Flamebane Breastplate
lib:AddRecipe(23605, 29619, 23517) -- Felsteel Gloves
lib:AddRecipe(23606, 29620, 23518) -- Felsteel Leggings
lib:AddRecipe(23607, 29621, 23519) -- Felsteel Helm
lib:AddRecipe(23621, 29622, 23532) -- Gauntlets of the Iron Tower
lib:AddRecipe(23608, 29628, 23524) -- Khorium Belt
lib:AddRecipe(23609, 29629, 23523) -- Khorium Pants
lib:AddRecipe(23610, 29630, 23525) -- Khorium Boots
lib:AddRecipe(23611, 29642, 23520) -- Ragesteel Gloves
lib:AddRecipe(23612, 29643, 23521) -- Ragesteel Helm
lib:AddRecipe(23613, 29645, 23522) -- Ragesteel Breastplate
lib:AddRecipe(23615, 29648, 23526) -- Swiftsteel Gloves
lib:AddRecipe(23617, 29649, 23527) -- Earthpeace Breastplate
lib:AddRecipe(23618, 29656, 23529) -- Adamantite Sharpening Stone
lib:AddRecipe(23619, 29657, 23530) -- Felsteel Shield Spike
lib:AddRecipe(24002, 29657, 23530) -- Felsteel Shield Spike
lib:AddRecipe(23620, 29658, 23531) -- Felfury Gauntlets
lib:AddRecipe(23622, 29662, 23533) -- Steelgrip Gauntlets
lib:AddRecipe(23623, 29663, 23534) -- Storm Helm
lib:AddRecipe(23624, 29664, 23535) -- Helm of the Stalwart Defender
lib:AddRecipe(23625, 29668, 23536) -- Oathkeeper's Helm
lib:AddRecipe(23626, 29669, 23537) -- Black Felsteel Bracers
lib:AddRecipe(23627, 29671, 23538) -- Bracers of the Green Fortress
lib:AddRecipe(23628, 29672, 23539) -- Blessed Bracers
lib:AddRecipe(23629, 29692, 23540) -- Felsteel Longblade
lib:AddRecipe(23630, 29693, 23541) -- Khorium Champion
lib:AddRecipe(23631, 29694, 23542) -- Fel Edged Battleaxe
lib:AddRecipe(23632, 29695, 23543) -- Felsteel Reaper
lib:AddRecipe(23633, 29696, 23544) -- Runic Hammer
lib:AddRecipe(23634, 29697, 23546) -- Fel Hardened Maul
lib:AddRecipe(23635, 29698, 23554) -- Eternium Runed Blade
lib:AddRecipe(23636, 29699, 23555) -- Dirge
lib:AddRecipe(23637, 29700, 23556) -- Hand of Eternity
lib:AddRecipe(23638, 29728, 23575) -- Lesser Ward of Shielding
lib:AddRecipe(23639, 29729, 23576) -- Greater Ward of Shielding
lib:AddRecipe(25526, 32285, 25521) -- Greater Rune of Warding
lib:AddRecipe(28632, 34608, 28421) -- Adamantite Weightstone
lib:AddRecipe(30321, 36389, 30034) -- Belt of the Guardian
lib:AddRecipe(30322, 36390, 30032) -- Red Belt of Battle
lib:AddRecipe(30323, 36391, 30033) -- Boots of the Protector
lib:AddRecipe(30324, 36392, 30031) -- Red Havoc Boots
lib:AddRecipe(31390, 38473, 31364) -- Wildguard Breastplate
lib:AddRecipe(31391, 38475, 31367) -- Wildguard Leggings
lib:AddRecipe(31392, 38476, 31368) -- Wildguard Helm
lib:AddRecipe(31393, 38477, 31369) -- Iceguard Breastplate
lib:AddRecipe(31394, 38478, 31370) -- Iceguard Leggings
lib:AddRecipe(31395, 38479, 31371) -- Iceguard Helm
lib:AddRecipe(32441, 40033, 32402) -- Shadesteel Sabots
lib:AddRecipe(32442, 40034, 32403) -- Shadesteel Bracers
lib:AddRecipe(32443, 40035, 32404) -- Shadesteel Greaves
lib:AddRecipe(32444, 40036, 32401) -- Shadesteel Girdle
lib:AddRecipe(32736, 41132, 32568) -- Swiftsteel Bracers
lib:AddRecipe(32737, 41133, 32570) -- Swiftsteel Shoulders
lib:AddRecipe(35532, 41133, 32570) -- Swiftsteel Shoulders
lib:AddRecipe(32738, 41134, 32571) -- Dawnsteel Bracers
lib:AddRecipe(32739, 41135, 32573) -- Dawnsteel Shoulders
lib:AddRecipe(35530, 41135, 32573) -- Dawnsteel Shoulders
lib:AddRecipe(33174, 42662, 33173) -- Ragesteel Shoulders
lib:AddRecipe(33186, 42688, 33185) -- Adamantite Weapon Chain
lib:AddRecipe(35296, 42688, 33185) -- Adamantite Weapon Chain
lib:AddRecipe(33792, 43549, 33791) -- Heavy Copper Longsword
lib:AddRecipe(33954, 43846, 32854) -- Hammer of Righteous Might
lib:AddRecipe(35208, 46140, 34380) -- Sunblessed Gauntlets
lib:AddRecipe(35209, 46141, 34378) -- Hard Khorium Battlefists
lib:AddRecipe(35210, 46142, 34379) -- Sunblessed Breastplate
lib:AddRecipe(35555, 46142, 34379) -- Sunblessed Breastplate
lib:AddRecipe(35211, 46144, 34377) -- Hard Khorium Battleplate
lib:AddRecipe(41124, 54978, 40956) -- Reinforced Cobalt Shoulders
lib:AddRecipe(41123, 54979, 40957) -- Reinforced Cobalt Helm
lib:AddRecipe(41120, 54980, 40958) -- Reinforced Cobalt Legplates
lib:AddRecipe(41122, 54981, 40959) -- Reinforced Cobalt Chestpiece
lib:AddRecipe(44937, 62202, 44936) -- Titanium Plating
lib:AddRecipe(44938, 62202, 44936) -- Titanium Plating
lib:AddRecipe(45088, 63187, 45550) -- Belt of the Titans
lib:AddRecipe(45089, 63188, 45559) -- Battlelord's Plate Boots
lib:AddRecipe(45090, 63189, 45552) -- Plate Girdle of Righteousness
lib:AddRecipe(45091, 63190, 45561) -- Treads of Destiny
lib:AddRecipe(45092, 63191, 45551) -- Indestructible Plate Girdle
lib:AddRecipe(45093, 63192, 45560) -- Spiked Deathdealers
lib:AddRecipe(47622, 67091, 47591) -- Breastplate of the White Knight
lib:AddRecipe(47623, 67092, 47570) -- Saronite Swordbreakers
lib:AddRecipe(47624, 67093, 47589) -- Titanium Razorplate
lib:AddRecipe(47625, 67094, 47572) -- Titanium Spikeguards
lib:AddRecipe(47626, 67095, 47593) -- Sunforged Breastplate
lib:AddRecipe(47627, 67096, 47574) -- Sunforged Bracers
lib:AddRecipe(47640, 67130, 47592) -- Breastplate of the White Knight
lib:AddRecipe(47641, 67131, 47571) -- Saronite Swordbreakers
lib:AddRecipe(47644, 67132, 47590) -- Titanium Razorplate
lib:AddRecipe(47645, 67133, 47573) -- Titanium Spikeguards
lib:AddRecipe(47643, 67134, 47594) -- Sunforged Breastplate
lib:AddRecipe(47642, 67135, 47575) -- Sunforged Bracers
lib:AddRecipe(49969, 70562, 49902) -- Puresteel Legplates
lib:AddRecipe(49970, 70563, 49905) -- Protectors of Life
lib:AddRecipe(49971, 70565, 49903) -- Legplates of Painful Death
lib:AddRecipe(49972, 70566, 49906) -- Hellfrozen Bonegrinders
lib:AddRecipe(49973, 70567, 49904) -- Pillars of Might
lib:AddRecipe(49974, 70568, 49907) -- Boots of Kingly Upheaval
lib:AddRecipe(66063, 76180, 54852) -- Hardened Obsidium Gauntlets
lib:AddRecipe(66062, 76181, 54853) -- Hardened Obsidium Belt
lib:AddRecipe(66064, 76181, 54853) -- Hardened Obsidium Belt
lib:AddRecipe(66065, 76182, 54854) -- Hardened Obsidium Boots
lib:AddRecipe(66066, 76258, 54876) -- Hardened Obsidium Shoulders
lib:AddRecipe(66068, 76259, 55022) -- Hardened Obsidium Legguards
lib:AddRecipe(66069, 76260, 55023) -- Hardened Obsidium Helm
lib:AddRecipe(66071, 76261, 55024) -- Hardened Obsidium Breastplate
lib:AddRecipe(66072, 76262, 55025) -- Redsteel Bracers
lib:AddRecipe(66074, 76263, 55026) -- Redsteel Gauntlets
lib:AddRecipe(66077, 76264, 55027) -- Redsteel Belt
lib:AddRecipe(66078, 76265, 55028) -- Redsteel Boots
lib:AddRecipe(66079, 76266, 55029) -- Redsteel Shoulders
lib:AddRecipe(66081, 76267, 55030) -- Redsteel Legguards
lib:AddRecipe(66082, 76269, 55031) -- Redsteel Helm
lib:AddRecipe(66083, 76270, 55032) -- Redsteel Breastplate
lib:AddRecipe(66084, 76280, 55033) -- Stormforged Bracers
lib:AddRecipe(66085, 76281, 55034) -- Stormforged Gauntlets
lib:AddRecipe(66086, 76283, 55035) -- Stormforged Belt
lib:AddRecipe(66087, 76285, 55036) -- Stormforged Boots
lib:AddRecipe(66088, 76286, 55037) -- Stormforged Shoulders
lib:AddRecipe(66089, 76287, 55038) -- Stormforged Legguards
lib:AddRecipe(66090, 76288, 55039) -- Stormforged Helm
lib:AddRecipe(66091, 76289, 55040) -- Stormforged Breastplate
lib:AddRecipe(66092, 76291, 55041) -- Hardened Obsidium Shield
lib:AddRecipe(66093, 76293, 55042) -- Stormforged Shield
lib:AddRecipe(66094, 76433, 55043) -- Decapitator's Razor
lib:AddRecipe(66095, 76434, 55044) -- Cold-Forged Shank
lib:AddRecipe(66096, 76435, 55045) -- Fire-Etched Dagger
lib:AddRecipe(66097, 76436, 55046) -- Lifeforce Hammer
lib:AddRecipe(66098, 76437, 55052) -- Obsidium Executioner
lib:AddRecipe(66099, 76438, 55053) -- Obsidium Skeleton Key
lib:AddRecipe(66100, 76439, 55054) -- Ebonsteel Belt Buckle
lib:AddRecipe(66101, 76440, 55056) -- Pyrium Shield Spike
lib:AddRecipe(66102, 76441, 55055) -- Elementium Shield Spike
lib:AddRecipe(66103, 76442, 55057) -- Pyrium Weapon Chain
lib:AddRecipe(66104, 76443, 55058) -- Hardened Elementium Hauberk
lib:AddRecipe(66105, 76444, 55059) -- Hardened Elementium Girdle
lib:AddRecipe(66106, 76445, 55060) -- Elementium Deathplate
lib:AddRecipe(66107, 76446, 55061) -- Elementium Girdle of Pain
lib:AddRecipe(66108, 76447, 55062) -- Light Elementium Chestguard
lib:AddRecipe(66109, 76448, 55063) -- Light Elementium Belt
lib:AddRecipe(66110, 76449, 55064) -- Elementium Spellblade
lib:AddRecipe(66111, 76450, 55065) -- Elementium Hammer
lib:AddRecipe(66112, 76451, 55066) -- Elementium Poleaxe
lib:AddRecipe(66113, 76452, 55067) -- Elementium Bonesplitter
lib:AddRecipe(66114, 76453, 55068) -- Elementium Shank
lib:AddRecipe(66115, 76454, 55069) -- Elementium Earthguard
lib:AddRecipe(66116, 76455, 55070) -- Elementium Stormshield
lib:AddRecipe(66117, 76456, 75124) -- Vicious Pyrium Bracers
lib:AddRecipe(66118, 76457, 75122) -- Vicious Pyrium Gauntlets
lib:AddRecipe(66119, 76458, 75123) -- Vicious Pyrium Belt
lib:AddRecipe(66120, 76459, 75120) -- Vicious Pyrium Boots
lib:AddRecipe(66121, 76461, 75119) -- Vicious Pyrium Shoulders
lib:AddRecipe(66122, 76462, 75136) -- Vicious Pyrium Legguards
lib:AddRecipe(66123, 76463, 75126) -- Vicious Pyrium Helm
lib:AddRecipe(66124, 76464, 75135) -- Vicious Pyrium Breastplate
lib:AddRecipe(66125, 76465, 75125) -- Vicious Ornate Pyrium Bracers
lib:AddRecipe(66126, 76466, 75121) -- Vicious Ornate Pyrium Gauntlets
lib:AddRecipe(66127, 76467, 75118) -- Vicious Ornate Pyrium Belt
lib:AddRecipe(66128, 76468, 75132) -- Vicious Ornate Pyrium Boots
lib:AddRecipe(66129, 76469, 75134) -- Vicious Ornate Pyrium Shoulders
lib:AddRecipe(66130, 76470, 75133) -- Vicious Ornate Pyrium Legguards
lib:AddRecipe(66131, 76471, 75129) -- Vicious Ornate Pyrium Helm
lib:AddRecipe(66132, 76472, 75128) -- Vicious Ornate Pyrium Breastplate
lib:AddRecipe(66133, 76474, 55246) -- Obsidium Bladespear
lib:AddRecipe(67603, 94718, 67602) -- Elementium Gutslicer
lib:AddRecipe(67606, 94732, 67605) -- Forged Elementium Mindcrusher
lib:AddRecipe(69957, 99439, 69936) -- Fists of Fury
lib:AddRecipe(69958, 99440, 69937) -- Eternal Elementium Handguards
lib:AddRecipe(69959, 99441, 69938) -- Holy Flame Gauntlets
lib:AddRecipe(69968, 99452, 69946) -- Warboots of Mighty Lords
lib:AddRecipe(69969, 99453, 69947) -- Mirrored Boots
lib:AddRecipe(69970, 99454, 69948) -- Emberforged Elementium Boots
lib:AddRecipe(70166, 99652, 70155) -- Brainsplinter
lib:AddRecipe(70167, 99653, 70156) -- Masterwork Elementium Spellblade
lib:AddRecipe(70168, 99654, 70157) -- Lightforged Elementium Hammer
lib:AddRecipe(70169, 99655, 70158) -- Elementium-Edged Scalper
lib:AddRecipe(70170, 99656, 70162) -- Pyrium Spellward
lib:AddRecipe(70171, 99657, 70163) -- Unbreakable Guardian
lib:AddRecipe(70172, 99658, 70164) -- Masterwork Elementium Deathblade
lib:AddRecipe(70173, 99660, 70165) -- Witch-Hunter's Harvester
lib:AddRecipe(72001, 101924, 71982) -- Pyrium Legplates of Purified Evil
lib:AddRecipe(72012, 101925, 71983) -- Unstoppable Destroyer's Legplates
lib:AddRecipe(72013, 101928, 71984) -- Foundations of Courage
lib:AddRecipe(72014, 101929, 71991) -- Soul Redeemer Bracers
lib:AddRecipe(72015, 101931, 71992) -- Bracers of Destructive Strength
lib:AddRecipe(72016, 101932, 71993) -- Titanguard Wristplates
lib:AddRecipe(84224, 122592, 82919) -- Masterwork Spiritguard Helm
lib:AddRecipe(84227, 122593, 82920) -- Masterwork Spiritguard Shoulders
lib:AddRecipe(84222, 122594, 82921) -- Masterwork Spiritguard Breastplate
lib:AddRecipe(84223, 122595, 82922) -- Masterwork Spiritguard Gauntlets
lib:AddRecipe(84225, 122596, 82923) -- Masterwork Spiritguard Legplates
lib:AddRecipe(84221, 122597, 82924) -- Masterwork Spiritguard Bracers
lib:AddRecipe(84220, 122598, 82925) -- Masterwork Spiritguard Boots
lib:AddRecipe(84219, 122599, 82926) -- Masterwork Spiritguard Belt
lib:AddRecipe(84163, 122616, 82943) -- Contender's Revenant Helm
lib:AddRecipe(84165, 122617, 82944) -- Contender's Revenant Shoulders
lib:AddRecipe(84161, 122618, 82945) -- Contender's Revenant Breastplate
lib:AddRecipe(84162, 122619, 82946) -- Contender's Revenant Gauntlets
lib:AddRecipe(84164, 122620, 82947) -- Contender's Revenant Legplates
lib:AddRecipe(84160, 122621, 82948) -- Contender's Revenant Bracers
lib:AddRecipe(84159, 122622, 82949) -- Contender's Revenant Boots
lib:AddRecipe(84158, 122623, 82950) -- Contender's Revenant Belt
lib:AddRecipe(84171, 122624, 82951) -- Contender's Spirit Helm
lib:AddRecipe(84173, 122625, 82952) -- Contender's Spirit Shoulders
lib:AddRecipe(84169, 122626, 82953) -- Contender's Spirit Breastplate
lib:AddRecipe(84170, 122627, 82954) -- Contender's Spirit Gauntlets
lib:AddRecipe(84172, 122628, 82955) -- Contender's Spirit Legplates
lib:AddRecipe(84168, 122629, 82956) -- Contender's Spirit Bracers
lib:AddRecipe(84167, 122630, 82957) -- Contender's Spirit Boots
lib:AddRecipe(84166, 122631, 82958) -- Contender's Spirit Belt
lib:AddRecipe(84196, 122632, 90046) -- Living Steel Belt Buckle
lib:AddRecipe(84208, 122642, 82968) -- Masterwork Lightsteel Shield
lib:AddRecipe(84226, 122643, 82969) -- Masterwork Spiritguard Shield
lib:AddRecipe(84197, 122644, 82970) -- Masterwork Forgewire Axe
lib:AddRecipe(84200, 122645, 82971) -- Masterwork Ghost-Forged Blade
lib:AddRecipe(84217, 122646, 82972) -- Masterwork Phantasmal Hammer
lib:AddRecipe(84218, 122647, 82973) -- Masterwork Spiritblade Decimator
lib:AddRecipe(84198, 122648, 82974) -- Masterwork Ghost Shard
lib:AddRecipe(83787, 122649, 82975) -- Ghost Reaver's Breastplate
lib:AddRecipe(83788, 122650, 82976) -- Ghost Reaver's Gauntlets
lib:AddRecipe(83789, 122651, 82977) -- Living Steel Breastplate
lib:AddRecipe(83790, 122652, 82978) -- Living Steel Gauntlets
lib:AddRecipe(83791, 122653, 82979) -- Breastplate of Ancient Steel
lib:AddRecipe(83792, 122654, 82980) -- Gauntlets of Ancient Steel
lib:AddRecipe(87408, 126850, 87405) -- Unyielding Bloodplate
lib:AddRecipe(87409, 126851, 87406) -- Gauntlets of Battle Command
lib:AddRecipe(87410, 126852, 87402) -- Ornate Battleplate of the Master
lib:AddRecipe(87411, 126853, 87407) -- Bloodforged Warfists
lib:AddRecipe(87412, 126854, 87403) -- Chestplate of Limitless Faith
lib:AddRecipe(87413, 126855, 87404) -- Gauntlets of Unbound Devotion
lib:AddRecipe(90531, 131928, 86599) -- Ghost Iron Shield Spike
lib:AddRecipe(90532, 131929, 86597) -- Living Steel Weapon Chain
lib:AddRecipe(94552, 138646, 94111) -- Lightning Steel Ingot
lib:AddRecipe(94570, 138876, 94575) -- The Planar Edge, Reborn
lib:AddRecipe(94569, 138877, 94576) -- Lunar Crescent, Reborn
lib:AddRecipe(94568, 138882, 94581) -- Drakefist Hammer, Reborn
lib:AddRecipe(94567, 138883, 94582) -- Thunder, Reborn
lib:AddRecipe(94572, 138888, 94587) -- Fireguard, Reborn
lib:AddRecipe(94571, 138889, 94588) -- Lionheart Blade, Reborn
lib:AddRecipe(116726, 171691, 116426) -- Smoldering Helm
lib:AddRecipe(116727, 171692, 116427) -- Smoldering Breastplate
lib:AddRecipe(116728, 171693, 116425) -- Smoldering Greaves
lib:AddRecipe(116729, 171694, 116453) -- Steelforged Greataxe
lib:AddRecipe(116730, 171695, 116454) -- Steelforged Saber
lib:AddRecipe(116731, 171696, 116644) -- Steelforged Dagger
lib:AddRecipe(116732, 171697, 116646) -- Steelforged Hammer
lib:AddRecipe(116733, 171698, 116647) -- Steelforged Shield
lib:AddRecipe(116734, 171699, 116654) -- Truesteel Grinder
lib:AddRecipe(116735, 171700, 114231) -- Truesteel Pauldrons
lib:AddRecipe(116736, 171701, 114230) -- Truesteel Helm
lib:AddRecipe(116737, 171702, 114234) -- Truesteel Greaves
lib:AddRecipe(116738, 171703, 114237) -- Truesteel Gauntlets
lib:AddRecipe(116739, 171704, 114232) -- Truesteel Breastplate
lib:AddRecipe(116740, 171705, 114236) -- Truesteel Armguards
lib:AddRecipe(116741, 171706, 114235) -- Truesteel Boots
lib:AddRecipe(116742, 171707, 114233) -- Truesteel Waistguard
lib:AddRecipe(116743, 171708, 128015) -- Truesteel Essence
lib:AddRecipe(116745, 171710, 128016) -- Steelforged Essence
lib:AddRecipe(118044, 173355, 116428) -- Truesteel Reshaper
lib:AddRecipe(120129, 176090, 118720) -- Secrets of Draenor Blacksmithing
lib:AddRecipe(119329, 177169, 119328) -- Soul of the Forge
lib:AddRecipe(120260, 178243, 120259) -- Steelforged Axe
lib:AddRecipe(120262, 178245, 120261) -- Steelforged Aegis
lib:AddRecipe(122705, 182116, 108257) -- Riddle of Truesteel
lib:AddRecipe(127725, 187490, 127713) -- Mighty Steelforged Essence
lib:AddRecipe(127727, 187491, 127714) -- Mighty Truesteel Essence
lib:AddRecipe(127743, 187514, 127731) -- Savage Steelforged Essence
lib:AddRecipe(127745, 187515, 127732) -- Savage Truesteel Essence
-- Cooking
lib:AddRecipe(2697, 2542, 724) -- Goretusk Liver Pie
lib:AddRecipe(728, 2543, 733) -- Westfall Stew
lib:AddRecipe(2698, 2545, 2682) -- Cooked Crab Claw
lib:AddRecipe(2699, 2547, 1082) -- Redridge Goulash
lib:AddRecipe(2700, 2548, 2685) -- Succulent Pork Ribs
lib:AddRecipe(2701, 2549, 1017) -- Seasoned Wolf Kabob
lib:AddRecipe(2889, 2795, 2888) -- Beer Basted Boar Ribs
lib:AddRecipe(3678, 3370, 3662) -- Crocolisk Steak
lib:AddRecipe(3679, 3371, 3220) -- Blood Sausage
lib:AddRecipe(3680, 3372, 3663) -- Murloc Fin Soup
lib:AddRecipe(3681, 3373, 3664) -- Crocolisk Gumbo
lib:AddRecipe(3682, 3376, 3665) -- Curiously Tasty Omelet
lib:AddRecipe(3683, 3377, 3666) -- Gooey Spider Cake
lib:AddRecipe(3734, 3397, 3726) -- Big Bear Steak
lib:AddRecipe(3735, 3398, 3727) -- Hot Lion Chops
lib:AddRecipe(3736, 3399, 3728) -- Tasty Lion Steak
lib:AddRecipe(3737, 3400, 3729) -- Soothing Turtle Bisque
lib:AddRecipe(4609, 4094, 4457) -- Barbecued Buzzard Wing
lib:AddRecipe(5482, 6412, 5472) -- Kaldorei Spider Kabob
lib:AddRecipe(5483, 6413, 5473) -- Scorpid Surprise
lib:AddRecipe(5484, 6414, 5474) -- Roasted Kodo Meat
lib:AddRecipe(5485, 6415, 5476) -- Fillet of Frenzy
lib:AddRecipe(5486, 6416, 5477) -- Strider Stew
lib:AddRecipe(78342, 6417, 5478) -- Dig Rat Stew
lib:AddRecipe(5488, 6418, 5479) -- Crispy Lizard Tail
lib:AddRecipe(5489, 6419, 5480) -- Lean Venison
lib:AddRecipe(5528, 6501, 5526) -- Clam Chowder
lib:AddRecipe(6039, 7213, 6038) -- Giant Clam Scorcho
lib:AddRecipe(6325, 7751, 6290) -- Brilliant Smallfish
lib:AddRecipe(6326, 7752, 787) -- Slitherskin Mackerel
lib:AddRecipe(6328, 7753, 4592) -- Longjaw Mud Snapper
lib:AddRecipe(6329, 7754, 6316) -- Loch Frenzy Delight
lib:AddRecipe(6330, 7755, 4593) -- Bristle Whisker Catfish
lib:AddRecipe(6368, 7827, 5095) -- Rainbow Fin Albacore
lib:AddRecipe(6369, 7828, 4594) -- Rockscale Cod
lib:AddRecipe(6661, 8238, 6657) -- Savory Deviate Delight
lib:AddRecipe(6891, 8604, 6888) -- Herb Baked Egg
lib:AddRecipe(6892, 8607, 6890) -- Smoked Bear Meat
lib:AddRecipe(18160, 9513, 7676) -- Thistle Tea
lib:AddRecipe(12227, 15853, 12209) -- Lean Wolf Steak
lib:AddRecipe(12228, 15855, 12210) -- Roast Raptor
lib:AddRecipe(12229, 15856, 13851) -- Hot Wolf Ribs
lib:AddRecipe(12231, 15861, 12212) -- Jungle Stew
lib:AddRecipe(12232, 15863, 12213) -- Carrion Surprise
lib:AddRecipe(12233, 15865, 12214) -- Mystery Stew
lib:AddRecipe(12239, 15906, 12217) -- Dragonbreath Chili
lib:AddRecipe(12240, 15910, 12215) -- Heavy Kodo Stew
lib:AddRecipe(16111, 15915, 12216) -- Spiced Chili Crab
lib:AddRecipe(16110, 15933, 12218) -- Monster Omelet
lib:AddRecipe(12226, 15935, 12224) -- Crispy Bat Wing
lib:AddRecipe(13939, 18238, 6887) -- Spotted Yellowtail
lib:AddRecipe(13940, 18239, 13927) -- Cooked Glossy Mightfish
lib:AddRecipe(13942, 18240, 13928) -- Grilled Squid
lib:AddRecipe(13941, 18241, 13930) -- Filet of Redgill
lib:AddRecipe(13943, 18242, 13929) -- Hot Smoked Bass
lib:AddRecipe(13945, 18243, 13931) -- Nightfin Soup
lib:AddRecipe(13946, 18244, 13932) -- Poached Sunscale Salmon
lib:AddRecipe(13947, 18245, 13933) -- Lobster Stew
lib:AddRecipe(13948, 18246, 13934) -- Mightfish Steak
lib:AddRecipe(13949, 18247, 13935) -- Baked Salmon
lib:AddRecipe(16767, 20626, 16766) -- Undermine Clam Chowder
lib:AddRecipe(17062, 20916, 8364) -- Mithril Head Trout
lib:AddRecipe(17200, 21143, 17197) -- Gingerbread Cookie
lib:AddRecipe(17201, 21144, 17198) -- Winter Veil Egg Nog
lib:AddRecipe(18046, 22480, 18045) -- Tender Wolf Steak
lib:AddRecipe(18267, 22761, 18254) -- Runn Tum Tuber Surprise
lib:AddRecipe(20075, 24418, 20074) -- Heavy Crocolisk Stew
lib:AddRecipe(21025, 25659, 21023) -- Dirge's Kickin' Chimaerok Chops
lib:AddRecipe(21099, 25704, 21072) -- Smoked Sagefish
lib:AddRecipe(21219, 25954, 21217) -- Sagefish Delight
lib:AddRecipe(22647, 28267, 22645) -- Crunchy Spider Surprise
lib:AddRecipe(27685, 33276, 27635) -- Lynx Steak
lib:AddRecipe(27686, 33277, 24105) -- Roasted Moongraze Tenderloin
lib:AddRecipe(27687, 33278, 27636) -- Bat Bites
lib:AddRecipe(27684, 33279, 27651) -- Buzzard Bites
lib:AddRecipe(27688, 33284, 27655) -- Ravager Dog
lib:AddRecipe(27690, 33286, 27657) -- Blackened Basilisk
lib:AddRecipe(27691, 33287, 27658) -- Roasted Clefthoof
lib:AddRecipe(27692, 33288, 27659) -- Warp Burger
lib:AddRecipe(27693, 33289, 27660) -- Talbuk Steak
lib:AddRecipe(27694, 33290, 27661) -- Blackened Trout
lib:AddRecipe(27695, 33291, 27662) -- Feltail Delight
lib:AddRecipe(27696, 33292, 27663) -- Blackened Sporefish
lib:AddRecipe(27697, 33293, 27664) -- Grilled Mudfish
lib:AddRecipe(27698, 33294, 27665) -- Poached Bluefish
lib:AddRecipe(27699, 33295, 27666) -- Golden Fish Sticks
lib:AddRecipe(27700, 33296, 27667) -- Spicy Crawdad
lib:AddRecipe(30156, 36210, 30155) -- Clam Bar
lib:AddRecipe(31675, 38867, 31672) -- Mok'Nathal Shortribs
lib:AddRecipe(31674, 38868, 31673) -- Crunchy Serpent
lib:AddRecipe(33870, 43707, 33825) -- Skullfish Soup
lib:AddRecipe(33871, 43758, 33866) -- Stormchops
lib:AddRecipe(33869, 43761, 33867) -- Broiled Bloodfin
lib:AddRecipe(33873, 43765, 33872) -- Spicy Hot Talbuk
lib:AddRecipe(33875, 43772, 33874) -- Kibler's Bits
lib:AddRecipe(33925, 43779, 33924) -- Delicious Chocolate Cake
lib:AddRecipe(34413, 45022, 34411) -- Hot Apple Cider
lib:AddRecipe(43018, 45555, 34754) -- Mega Mammoth Meal
lib:AddRecipe(43019, 45556, 34755) -- Tender Shoveltusk Steak
lib:AddRecipe(43020, 45557, 34756) -- Spiced Worm Burger
lib:AddRecipe(43021, 45558, 34757) -- Very Burnt Worg
lib:AddRecipe(43022, 45559, 34758) -- Mighty Rhino Dogs
lib:AddRecipe(43023, 45567, 34766) -- Poached Northern Sculpin
lib:AddRecipe(43024, 45568, 34767) -- Firecracker Salmon
lib:AddRecipe(43026, 45570, 34769) -- Imperial Manta Steak
lib:AddRecipe(43025, 45571, 34768) -- Spicy Blue Nettlefish
lib:AddRecipe(34834, 45695, 34832) -- Captain Rumsey's Lager
lib:AddRecipe(35564, 46684, 35563) -- Charred Bear Kabobs
lib:AddRecipe(35566, 46688, 35565) -- Juicy Bear Burger
lib:AddRecipe(39644, 53056, 39520) -- Kungaloosh
lib:AddRecipe(43017, 57423, 43015) -- Fish Feast
lib:AddRecipe(43027, 57433, 42993) -- Spicy Fried Herring
lib:AddRecipe(43028, 57434, 42994) -- Rhinolicious Wormsteak
lib:AddRecipe(43029, 57435, 43004) -- Critter Bites
lib:AddRecipe(43030, 57436, 42995) -- Hearty Rhino
lib:AddRecipe(43031, 57437, 42996) -- Snapper Extreme
lib:AddRecipe(43032, 57438, 42997) -- Blackened Worg Steak
lib:AddRecipe(43033, 57439, 42998) -- Cuttlesteak
lib:AddRecipe(43034, 57440, 43005) -- Spiced Mammoth Treats
lib:AddRecipe(43035, 57441, 42999) -- Blackened Dragonfin
lib:AddRecipe(43036, 57442, 43000) -- Dragonfin Filet
lib:AddRecipe(43037, 57443, 43001) -- Tracker Snacks
lib:AddRecipe(43507, 58512, 43490) -- Tasty Cupcake
lib:AddRecipe(43508, 58521, 43488) -- Last Week's Mammoth
lib:AddRecipe(43509, 58523, 43491) -- Bad Clams
lib:AddRecipe(43510, 58525, 43492) -- Haunted Herring
lib:AddRecipe(43505, 58527, 43478) -- Gigantic Feast
lib:AddRecipe(43506, 58528, 43480) -- Small Feast
lib:AddRecipe(44862, 62044, 44836) -- Pumpkin Pie
lib:AddRecipe(44861, 62045, 44838) -- Slow-Roasted Turkey
lib:AddRecipe(44858, 62049, 44840) -- Cranberry Chutney
lib:AddRecipe(44860, 62050, 44837) -- Spice Bread Stuffing
lib:AddRecipe(44859, 62051, 44839) -- Candied Sweet Potato
lib:AddRecipe(44954, 62350, 44953) -- Worg Tartare
lib:AddRecipe(46710, 65454, 46691) -- Bread of the Dead
lib:AddRecipe(46806, 66034, 44839) -- Candied Sweet Potato
lib:AddRecipe(46805, 66035, 44840) -- Cranberry Chutney
lib:AddRecipe(46804, 66036, 44836) -- Pumpkin Pie
lib:AddRecipe(46807, 66037, 44838) -- Slow-Roasted Turkey
lib:AddRecipe(46803, 66038, 44837) -- Spice Bread Stuffing
lib:AddRecipe(65426, 88003, 62661) -- Baked Rockfish
lib:AddRecipe(65427, 88004, 62665) -- Basilisk Liverdog
lib:AddRecipe(65429, 88005, 62670) -- Beer-Basted Crocolisk
lib:AddRecipe(62799, 88011, 62289) -- Broiled Dragon Feast
lib:AddRecipe(65411, 88012, 62655) -- Broiled Mountain Trout
lib:AddRecipe(65431, 88013, 62680) -- Chocolate Cookie
lib:AddRecipe(65430, 88014, 62664) -- Crocolisk Au Gratin
lib:AddRecipe(65422, 88016, 62666) -- Delicious Sagefish Tail
lib:AddRecipe(65408, 88017, 62673) -- Feathered Lure
lib:AddRecipe(65423, 88018, 62677) -- Fish Fry
lib:AddRecipe(65432, 88019, 62649) -- Fortune Cookie
lib:AddRecipe(65428, 88020, 62662) -- Grilled Dragon
lib:AddRecipe(65418, 88021, 62659) -- Hearty Seafood Soup
lib:AddRecipe(65415, 88022, 62674) -- Highland Spirits
lib:AddRecipe(65407, 88024, 62654) -- Lavascale Fillet
lib:AddRecipe(65409, 88025, 62663) -- Lavascale Minestrone
lib:AddRecipe(65412, 88028, 62651) -- Lightly Fried Lurker
lib:AddRecipe(65416, 88030, 62657) -- Lurker Lunch
lib:AddRecipe(65420, 88031, 62667) -- Mushroom Sauce Mudfish
lib:AddRecipe(65417, 88033, 62660) -- Pickled Guppy
lib:AddRecipe(65424, 88034, 62668) -- Blackbelly Sushi
lib:AddRecipe(65410, 88035, 62653) -- Salted Eye
lib:AddRecipe(62800, 88036, 62290) -- Seafood Magnifique Feast
lib:AddRecipe(65413, 88037, 62652) -- Seasoned Crab
lib:AddRecipe(65421, 88039, 62671) -- Severed Sagefish Head
lib:AddRecipe(65425, 88042, 62669) -- Skewered Eel
lib:AddRecipe(65433, 88044, 62672) -- South Island Iced Tea
lib:AddRecipe(65414, 88045, 62675) -- Starfire Espresso
lib:AddRecipe(65419, 88046, 62658) -- Tender Baked Turtle
lib:AddRecipe(65406, 88047, 62656) -- Whitecrest Gumbo
lib:AddRecipe(68688, 96133, 68687) -- Scalding Murglesnout
lib:AddRecipe(75013, 105190, 74919) -- Pandaren Banquet
lib:AddRecipe(75017, 105194, 75016) -- Great Pandaren Banquet
lib:AddRecipe(85502, 124029, 85501) -- Viseclaw Soup
lib:AddRecipe(85505, 124032, 85504) -- Krasarang Fritters
lib:AddRecipe(74657, 125120, 86073) -- Spicy Salmon
lib:AddRecipe(74658, 125123, 86074) -- Spicy Vegetable Chips
lib:AddRecipe(101631, 145038, 101630) -- Noodle Cart Kit
lib:AddRecipe(101664, 145061, 101661) -- Deluxe Noodle Cart Kit
lib:AddRecipe(101663, 145062, 101662) -- Pandaren Treasure Noodle Cart Kit
lib:AddRecipe(101728, 145167, 101727) -- Grand Noodle Cart Kit
lib:AddRecipe(101739, 145170, 101729) -- Grand Deluxe Noodle Cart Kit
lib:AddRecipe(101741, 145197, 101740) -- Grand Pandaren Treasure Noodle Cart Kit
lib:AddRecipe(101767, 145308, 101745) -- Mango Ice
lib:AddRecipe(118310, 160958, 111431) -- Hearty Elekk Steak
lib:AddRecipe(118311, 160962, 111433) -- Blackrock Ham
lib:AddRecipe(118312, 160966, 111434) -- Pan-Seared Talbuk
lib:AddRecipe(118313, 160968, 111436) -- Braised Riverbeast
lib:AddRecipe(118314, 160969, 111437) -- Rylak Crepes
lib:AddRecipe(118315, 160971, 111438) -- Clefthoof Sausages
lib:AddRecipe(118316, 160973, 111439) -- Steamed Scorpion
lib:AddRecipe(118317, 160978, 111441) -- Grilled Gulper
lib:AddRecipe(118318, 160979, 111442) -- Sturgeon Stew
lib:AddRecipe(118319, 160981, 111444) -- Fat Sleeper Cakes
lib:AddRecipe(118320, 160982, 111445) -- Fiery Calamari
lib:AddRecipe(118321, 160983, 111446) -- Skulker Chowder
lib:AddRecipe(118322, 160984, 111447) -- Talador Surf and Turf
lib:AddRecipe(118323, 160986, 111449) -- Blackrock Barbecue
lib:AddRecipe(118324, 160987, 111450) -- Frosty Stew
lib:AddRecipe(118325, 160989, 111452) -- Sleeper Surprise
lib:AddRecipe(118326, 160999, 111453) -- Calamari Crepes
lib:AddRecipe(118327, 161000, 111454) -- Gorgrond Chowder
lib:AddRecipe(118328, 173978, 111457) -- Feast of Blood
lib:AddRecipe(118329, 173979, 111458) -- Feast of the Waters
lib:AddRecipe(122559, 180757, 122344) -- Salty Squid Roll
lib:AddRecipe(122558, 180758, 122345) -- Pickled Eel
lib:AddRecipe(122557, 180759, 122346) -- Jumbo Sea Dog
lib:AddRecipe(122560, 180760, 122347) -- Whiptail Fillet
lib:AddRecipe(122556, 180761, 122348) -- Buttered Sturgeon
lib:AddRecipe(122555, 180762, 122343) -- Sleeper Sushi
lib:AddRecipe(126928, 185704, 126934) -- Lemon Herb Filet
lib:AddRecipe(126929, 185705, 126935) -- Fancy Darkmoon Feast
lib:AddRecipe(126927, 185708, 126936) -- Sugar-Crusted Fish Feast
lib:AddRecipe(128501, 190788, 128498) -- Fel Eggs and Ham
-- Enchanting
lib:AddRecipe(6342, 7443, 38769) -- Minor Mana
lib:AddRecipe(6344, 7766, 38774) -- Minor Spirit
lib:AddRecipe(6346, 7776, 38776) -- Lesser Mana
lib:AddRecipe(6347, 7782, 38778) -- Minor Strength
lib:AddRecipe(6348, 7786, 38779) -- Minor Beastslayer
lib:AddRecipe(6349, 7793, 38781) -- Lesser Intellect
lib:AddRecipe(6375, 7859, 38783) -- Lesser Spirit
lib:AddRecipe(6377, 7867, 38786) -- Minor Agility
lib:AddRecipe(11038, 13380, 38788) -- Lesser Spirit
lib:AddRecipe(11039, 13419, 38789) -- Minor Agility
lib:AddRecipe(11081, 13464, 38791) -- Lesser Protection
lib:AddRecipe(11101, 13536, 38797) -- Lesser Strength
lib:AddRecipe(11150, 13612, 38800) -- Mining
lib:AddRecipe(78343, 13617, 38801) -- Herbalism
lib:AddRecipe(11152, 13620, 38802) -- Fishing
lib:AddRecipe(11163, 13646, 38811) -- Lesser Dodge
lib:AddRecipe(11164, 13653, 38813) -- Lesser Beastslayer
lib:AddRecipe(11165, 13655, 38814) -- Lesser Elemental Slayer
lib:AddRecipe(11167, 13687, 38819) -- Lesser Spirit
lib:AddRecipe(11168, 13689, 38820) -- Lesser Parry
lib:AddRecipe(11166, 13698, 38823) -- Skinning
lib:AddRecipe(11202, 13817, 38828) -- Stamina
lib:AddRecipe(11203, 13841, 38831) -- Advanced Mining
lib:AddRecipe(11204, 13846, 38832) -- Greater Spirit
lib:AddRecipe(11205, 13868, 38834) -- Advanced Herbalism
lib:AddRecipe(71714, 13882, 38835) -- Lesser Agility
lib:AddRecipe(11207, 13898, 38838) -- Fiery Weapon
lib:AddRecipe(11208, 13915, 38840) -- Demonslaying
lib:AddRecipe(11223, 13931, 38842) -- Dodge
lib:AddRecipe(11225, 13945, 38849) -- Greater Stamina
lib:AddRecipe(11226, 13947, 38850) -- Riding Skill
lib:AddRecipe(11813, 15596, 11811) -- Smoking Heart of the Mountain
lib:AddRecipe(45050, 15596, 11811) -- Smoking Heart of the Mountain
lib:AddRecipe(16214, 20008, 38852) -- Greater Intellect
lib:AddRecipe(16218, 20009, 38853) -- Superior Spirit
lib:AddRecipe(16246, 20010, 38854) -- Superior Strength
lib:AddRecipe(16251, 20011, 38855) -- Superior Stamina
lib:AddRecipe(16219, 20012, 38856) -- Greater Agility
lib:AddRecipe(16244, 20013, 38857) -- Greater Strength
lib:AddRecipe(16224, 20015, 38859) -- Superior Defense
lib:AddRecipe(16222, 20016, 38860) -- Vitality
lib:AddRecipe(16217, 20017, 38861) -- Greater Stamina
lib:AddRecipe(16215, 20020, 38862) -- Greater Stamina
lib:AddRecipe(16245, 20023, 38863) -- Greater Agility
lib:AddRecipe(16220, 20024, 38864) -- Spirit
lib:AddRecipe(16253, 20025, 38865) -- Greater Stats
lib:AddRecipe(16221, 20026, 38866) -- Major Health
lib:AddRecipe(16242, 20028, 38867) -- Major Mana
lib:AddRecipe(16223, 20029, 38868) -- Icy Chill
lib:AddRecipe(16247, 20030, 38869) -- Superior Impact
lib:AddRecipe(16250, 20031, 38870) -- Superior Striking
lib:AddRecipe(16254, 20032, 38871) -- Lifestealing
lib:AddRecipe(16248, 20033, 38872) -- Unholy Weapon
lib:AddRecipe(16252, 20034, 38873) -- Crusader
lib:AddRecipe(16255, 20035, 38874) -- Major Spirit
lib:AddRecipe(17725, 21931, 38876) -- Winter's Might
lib:AddRecipe(18259, 22749, 38877) -- Spellpower
lib:AddRecipe(18260, 22750, 38878) -- Healing Power
lib:AddRecipe(19444, 23799, 38879) -- Strength
lib:AddRecipe(19445, 23800, 38880) -- Agility
lib:AddRecipe(19446, 23801, 38881) -- Mana Regeneration
lib:AddRecipe(19447, 23802, 38882) -- Healing Power
lib:AddRecipe(19448, 23803, 38883) -- Mighty Spirit
lib:AddRecipe(19449, 23804, 38884) -- Mighty Intellect
lib:AddRecipe(20726, 25072, 38885) -- Threat
lib:AddRecipe(33153, 25072, 38885) -- Threat
lib:AddRecipe(20727, 25073, 38886) -- Shadow Power
lib:AddRecipe(20728, 25074, 38887) -- Frost Power
lib:AddRecipe(20729, 25078, 38888) -- Fire Power
lib:AddRecipe(20730, 25079, 38889) -- Healing Power
lib:AddRecipe(20731, 25080, 38890) -- Superior Agility
lib:AddRecipe(33152, 25080, 38890) -- Superior Agility
lib:AddRecipe(20734, 25083, 38893) -- Stealth
lib:AddRecipe(33149, 25083, 38893) -- Stealth
lib:AddRecipe(20735, 25084, 38894) -- Subtlety
lib:AddRecipe(33150, 25084, 38894) -- Subtlety
lib:AddRecipe(33151, 25084, 38894) -- Subtlety
lib:AddRecipe(20736, 25086, 38895) -- Dodge
lib:AddRecipe(33148, 25086, 38895) -- Dodge
lib:AddRecipe(20758, 25124, 20744) -- Minor Wizard Oil
lib:AddRecipe(20752, 25125, 20745) -- Minor Mana Oil
lib:AddRecipe(20753, 25126, 20746) -- Lesser Wizard Oil
lib:AddRecipe(20754, 25127, 20747) -- Lesser Mana Oil
lib:AddRecipe(20755, 25128, 20750) -- Wizard Oil
lib:AddRecipe(20756, 25129, 20749) -- Brilliant Wizard Oil
lib:AddRecipe(20757, 25130, 20748) -- Brilliant Mana Oil
lib:AddRecipe(22392, 27837, 38896) -- Agility
lib:AddRecipe(22530, 27906, 38899) -- Greater Dodge
lib:AddRecipe(22531, 27911, 38900) -- Superior Healing
lib:AddRecipe(24000, 27911, 38900) -- Superior Healing
lib:AddRecipe(22532, 27913, 38901) -- Restore Mana Prime
lib:AddRecipe(22533, 27914, 38902) -- Fortitude
lib:AddRecipe(22534, 27917, 38903) -- Spellpower
lib:AddRecipe(22539, 27945, 38905) -- Intellect
lib:AddRecipe(22540, 27946, 38906) -- Parry
lib:AddRecipe(22542, 27948, 38908) -- Vitality
lib:AddRecipe(35298, 27948, 38908) -- Vitality
lib:AddRecipe(22543, 27950, 38909) -- Fortitude
lib:AddRecipe(22544, 27951, 37603) -- Dexterity
lib:AddRecipe(22545, 27954, 38910) -- Surefooted
lib:AddRecipe(22547, 27960, 38913) -- Exceptional Stats
lib:AddRecipe(24003, 27960, 38913) -- Exceptional Stats
lib:AddRecipe(22552, 27967, 38917) -- Major Striking
lib:AddRecipe(22551, 27968, 38918) -- Major Intellect
lib:AddRecipe(22554, 27971, 38919) -- Savagery
lib:AddRecipe(22553, 27972, 38920) -- Potency
lib:AddRecipe(22555, 27975, 38921) -- Major Spellpower
lib:AddRecipe(22556, 27977, 38922) -- Major Agility
lib:AddRecipe(22560, 27981, 38923) -- Sunfire
lib:AddRecipe(22561, 27982, 38924) -- Soulfrost
lib:AddRecipe(22559, 27984, 38925) -- Mongoose
lib:AddRecipe(22558, 28003, 38926) -- Spellsurge
lib:AddRecipe(22557, 28004, 38927) -- Battlemaster
lib:AddRecipe(22562, 28016, 22521) -- Superior Mana Oil
lib:AddRecipe(22563, 28019, 22522) -- Superior Wizard Oil
lib:AddRecipe(22564, 28021, 22445) -- Arcane Dust
lib:AddRecipe(22565, 28022, 22449) -- Large Prismatic Shard
lib:AddRecipe(28270, 33992, 38930) -- Major Resilience
lib:AddRecipe(28271, 33994, 38932) -- Precise Strikes
lib:AddRecipe(28272, 33997, 38935) -- Major Spellpower
lib:AddRecipe(28273, 33999, 38936) -- Major Healing
lib:AddRecipe(28274, 34003, 38939) -- PvP Power
lib:AddRecipe(28279, 34007, 38943) -- Cat's Swiftness
lib:AddRecipe(35299, 34007, 38943) -- Cat's Swiftness
lib:AddRecipe(28280, 34008, 38944) -- Boar's Speed
lib:AddRecipe(35297, 34008, 38944) -- Boar's Speed
lib:AddRecipe(28282, 34009, 38945) -- Major Stamina
lib:AddRecipe(28281, 34010, 38946) -- Major Healing
lib:AddRecipe(33165, 42620, 38947) -- Greater Agility
lib:AddRecipe(33307, 42974, 38948) -- Executioner
lib:AddRecipe(78348, 42974, 38948) -- Executioner
lib:AddRecipe(37335, 44500, 38959) -- Superior Agility
lib:AddRecipe(37329, 44510, 38963) -- Exceptional Spirit
lib:AddRecipe(37344, 44524, 38965) -- Icebreaker
lib:AddRecipe(44484, 44575, 44815) -- Greater Assault
lib:AddRecipe(44494, 44576, 38972) -- Lifeward
lib:AddRecipe(37340, 44588, 38975) -- Exceptional Resilience
lib:AddRecipe(37341, 44589, 38976) -- Superior Agility
lib:AddRecipe(37347, 44591, 38978) -- Superior Dodge
lib:AddRecipe(37326, 44593, 38980) -- Major Spirit
lib:AddRecipe(44473, 44595, 38981) -- Scourgebane
lib:AddRecipe(37346, 44598, 38984) -- Haste
lib:AddRecipe(37342, 44612, 38985) -- Greater Blasting
lib:AddRecipe(37337, 44616, 38987) -- Greater Stats
lib:AddRecipe(37339, 44621, 38988) -- Giant Slayer
lib:AddRecipe(44485, 44625, 38990) -- Armsman
lib:AddRecipe(37349, 44631, 38993) -- Shadow Armor
lib:AddRecipe(37343, 44633, 38995) -- Exceptional Agility
lib:AddRecipe(34872, 45765, 22449) -- Void Shatter
lib:AddRecipe(35498, 46578, 38998) -- Deathfrost
lib:AddRecipe(35500, 46594, 38999) -- Dodge
lib:AddRecipe(35756, 47051, 39000) -- Greater Dodge
lib:AddRecipe(44471, 47672, 39001) -- Mighty Stamina
lib:AddRecipe(37336, 47766, 39002) -- Greater Dodge
lib:AddRecipe(37348, 47898, 39003) -- Greater Speed
lib:AddRecipe(44472, 47898, 39003) -- Greater Speed
lib:AddRecipe(44488, 47899, 39004) -- Wisdom
lib:AddRecipe(44491, 47901, 39006) -- Tuskarr's Vitality
lib:AddRecipe(44496, 59619, 44497) -- Accuracy
lib:AddRecipe(44492, 59621, 44493) -- Berserking
lib:AddRecipe(44495, 59625, 43987) -- Black Magic
lib:AddRecipe(44483, 60691, 44463) -- Massacre
lib:AddRecipe(44489, 60692, 44465) -- Powerful Stats
lib:AddRecipe(44486, 60707, 44466) -- Superior Potency
lib:AddRecipe(44487, 60714, 44467) -- Mighty Spellpower
lib:AddRecipe(44490, 60763, 44469) -- Greater Assault
lib:AddRecipe(44498, 60767, 44470) -- Superior Spellpower
lib:AddRecipe(44944, 62256, 44947) -- Major Stamina
lib:AddRecipe(45059, 62948, 45056) -- Greater Spellpower
lib:AddRecipe(46027, 64441, 46026) -- Blade Ward
lib:AddRecipe(46348, 64579, 46098) -- Blood Draining
lib:AddRecipe(50406, 71692, 50816) -- Angler
lib:AddRecipe(52733, 74242, 52774) -- Power Torrent
lib:AddRecipe(52735, 74244, 52775) -- Windwalk
lib:AddRecipe(52736, 74246, 52776) -- Landslide
lib:AddRecipe(52737, 74247, 52777) -- Greater Critical Strike
lib:AddRecipe(52738, 74248, 52778) -- Greater Critical Strike
lib:AddRecipe(52739, 74250, 52779) -- Peerless Stats
lib:AddRecipe(52740, 74251, 52780) -- Greater Stamina
lib:AddRecipe(64411, 74252, 52781) -- Assassin's Step
lib:AddRecipe(64412, 74253, 52782) -- Lavawalker
lib:AddRecipe(64415, 74254, 52783) -- Mighty Strength
lib:AddRecipe(64414, 74255, 52784) -- Greater Mastery
lib:AddRecipe(64413, 74256, 52785) -- Greater Speed
lib:AddRecipe(67308, 93841, 67274) -- Enchanted Lantern
lib:AddRecipe(67312, 93843, 67275) -- Magic Lamp
lib:AddRecipe(68788, 96261, 68785) -- Major Strength
lib:AddRecipe(68789, 96262, 68786) -- Mighty Intellect
lib:AddRecipe(68787, 96264, 68784) -- Agility
lib:AddRecipe(84559, 104389, 74703) -- Super Intellect
lib:AddRecipe(84561, 104390, 74704) -- Exceptional Strength
lib:AddRecipe(84557, 104391, 74705) -- Greater Agility
lib:AddRecipe(84583, 104427, 74724) -- Jade Spirit
lib:AddRecipe(84584, 104434, 74726) -- Dancing Steel
lib:AddRecipe(84580, 104442, 74728) -- River's Song
lib:AddRecipe(118394, 158877, 110631) -- Breath of Critical Strike
lib:AddRecipe(118429, 158878, 110632) -- Breath of Haste
lib:AddRecipe(118430, 158879, 110633) -- Breath of Mastery
lib:AddRecipe(118431, 158880, 110634) -- Breath of Multistrike
lib:AddRecipe(118432, 158881, 110635) -- Breath of Versatility
lib:AddRecipe(118433, 158884, 110652) -- Gift of Critical Strike
lib:AddRecipe(118434, 158885, 110653) -- Gift of Haste
lib:AddRecipe(118435, 158886, 110654) -- Gift of Mastery
lib:AddRecipe(118436, 158887, 110655) -- Gift of Multistrike
lib:AddRecipe(118437, 158889, 110656) -- Gift of Versatility
lib:AddRecipe(118438, 158892, 110624) -- Breath of Critical Strike
lib:AddRecipe(118439, 158893, 110625) -- Breath of Haste
lib:AddRecipe(118440, 158894, 110626) -- Breath of Mastery
lib:AddRecipe(118441, 158895, 110627) -- Breath of Multistrike
lib:AddRecipe(118442, 158896, 110628) -- Breath of Versatility
lib:AddRecipe(118443, 158899, 110645) -- Gift of Critical Strike
lib:AddRecipe(118444, 158900, 110646) -- Gift of Haste
lib:AddRecipe(118445, 158901, 110647) -- Gift of Mastery
lib:AddRecipe(118446, 158902, 110648) -- Gift of Multistrike
lib:AddRecipe(118447, 158903, 110649) -- Gift of Versatility
lib:AddRecipe(118448, 158907, 110617) -- Breath of Critical Strike
lib:AddRecipe(118449, 158908, 110618) -- Breath of Haste
lib:AddRecipe(118450, 158909, 110619) -- Breath of Mastery
lib:AddRecipe(118451, 158910, 110620) -- Breath of Multistrike
lib:AddRecipe(118452, 158911, 110621) -- Breath of Versatility
lib:AddRecipe(118453, 158914, 110638) -- Gift of Critical Strike
lib:AddRecipe(118454, 158915, 110639) -- Gift of Haste
lib:AddRecipe(118455, 158916, 110640) -- Gift of Mastery
lib:AddRecipe(118456, 158917, 110641) -- Gift of Multistrike
lib:AddRecipe(118457, 158918, 110642) -- Gift of Versatility
lib:AddRecipe(118458, 159235, 110682) -- Mark of the Thunderlord
lib:AddRecipe(118459, 159236, 112093) -- Mark of the Shattered Hand
lib:AddRecipe(118460, 159671, 112164) -- Mark of Warsong
lib:AddRecipe(118461, 159672, 112165) -- Mark of the Frostwolf
lib:AddRecipe(118462, 159673, 112115) -- Mark of Shadowmoon
lib:AddRecipe(118463, 159674, 112160) -- Mark of Blackrock
lib:AddRecipe(118465, 169091, 111245) -- Luminous Shard
lib:AddRecipe(118466, 169092, 113588) -- Temporal Crystal
lib:AddRecipe(118467, 173323, 118015) -- Mark of Bleeding Hollow
lib:AddRecipe(119300, 177043, 119293) -- Secrets of Draenor Enchanting
lib:AddRecipe(120135, 177043, 119293) -- Secrets of Draenor Enchanting
lib:AddRecipe(122711, 182129, 115504) -- Temporal Binding
-- Engineering
lib:AddRecipe(4408, 3928, 4401) -- Mechanical Squirrel Box
lib:AddRecipe(4409, 3933, 4367) -- Small Seaforium Charge
lib:AddRecipe(13309, 3939, 4372) -- Lovingly Crafted Boomstick
lib:AddRecipe(4410, 3940, 4373) -- Shadow Goggles
lib:AddRecipe(4411, 3944, 4376) -- Flame Deflector
lib:AddRecipe(14639, 3952, 4381) -- Minor Recombobulator
lib:AddRecipe(4412, 3954, 4383) -- Moonsight Rifle
lib:AddRecipe(13308, 3957, 4386) -- Ice Deflector
lib:AddRecipe(4413, 3959, 4388) -- Discombobulator Ray
lib:AddRecipe(4414, 3960, 4403) -- Portable Bronze Mortar
lib:AddRecipe(4415, 3966, 4393) -- Craftsman's Monocle
lib:AddRecipe(4416, 3968, 4395) -- Goblin Land Mine
lib:AddRecipe(13311, 3969, 4396) -- Mechanical Dragonling
lib:AddRecipe(7742, 3971, 4397) -- Gnomish Cloaking Device
lib:AddRecipe(4417, 3972, 4398) -- Large Seaforium Charge
lib:AddRecipe(13310, 3979, 4407) -- Accurate Scope
lib:AddRecipe(6672, 8243, 4852) -- Flash Bomb
lib:AddRecipe(6716, 8339, 6714) -- EZ-Thro Dynamite
lib:AddRecipe(7560, 9269, 7506) -- Gnomish Universal Remote
lib:AddRecipe(7561, 9273, 7148) -- Goblin Jumper Cables
lib:AddRecipe(10601, 12587, 10499) -- Bright-Eye Goggles
lib:AddRecipe(10602, 12597, 10546) -- Deadly Scope
lib:AddRecipe(10603, 12607, 10501) -- Catseye Ultra Goggles
lib:AddRecipe(10604, 12614, 10510) -- Mithril Heavy-bore Rifle
lib:AddRecipe(10605, 12615, 10502) -- Spellpower Goggles Xtreme
lib:AddRecipe(10606, 12616, 10518) -- Parachute Cloak
lib:AddRecipe(10607, 12617, 10506) -- Deepdive Helmet
lib:AddRecipe(10608, 12620, 10548) -- Sniper Scope
lib:AddRecipe(10609, 12624, 10576) -- Mithril Mechanical Dragonling
lib:AddRecipe(11828, 15628, 11825) -- Pet Bombling
lib:AddRecipe(11827, 15633, 11826) -- Lil' Smoky
lib:AddRecipe(16041, 19790, 15993) -- Thorium Grenade
lib:AddRecipe(16042, 19791, 15994) -- Thorium Widget
lib:AddRecipe(16043, 19792, 15995) -- Thorium Rifle
lib:AddRecipe(16044, 19793, 15996) -- Lifelike Mechanical Toad
lib:AddRecipe(16045, 19794, 15999) -- Spellpower Goggles Xtreme Plus
lib:AddRecipe(16047, 19795, 16000) -- Thorium Tube
lib:AddRecipe(16048, 19796, 16004) -- Dark Iron Rifle
lib:AddRecipe(16049, 19799, 16005) -- Dark Iron Bomb
lib:AddRecipe(16046, 19814, 16023) -- Masterwork Target Dummy
lib:AddRecipe(16050, 19815, 16006) -- Delicate Arcanite Converter
lib:AddRecipe(16052, 19819, 16009) -- Voice Amplification Modulator
lib:AddRecipe(16053, 19825, 16008) -- Master Engineer's Goggles
lib:AddRecipe(16054, 19830, 16022) -- Arcanite Dragonling
lib:AddRecipe(16055, 19831, 16040) -- Arcane Bomb
lib:AddRecipe(16056, 19833, 16007) -- Flawless Arcanite Rifle
lib:AddRecipe(17720, 21940, 17716) -- Snowmaster 9000
lib:AddRecipe(18235, 22704, 18232) -- Field Repair Bot 74A
lib:AddRecipe(18290, 22793, 18283) -- Biznicks 247x128 Accurascope
lib:AddRecipe(18292, 22795, 18282) -- Core Marksman Rifle
lib:AddRecipe(18291, 22797, 18168) -- Force Reactive Disk
lib:AddRecipe(18647, 23066, 9318) -- Red Firework
lib:AddRecipe(18649, 23067, 9312) -- Blue Firework
lib:AddRecipe(18648, 23068, 9313) -- Green Firework
lib:AddRecipe(18650, 23069, 18588) -- EZ-Thro Dynamite II
lib:AddRecipe(18651, 23071, 18631) -- Truesilver Transformer
lib:AddRecipe(18652, 23077, 18634) -- Gyrofreeze Ice Reflector
lib:AddRecipe(18653, 23078, 18587) -- Goblin Jumper Cables XL
lib:AddRecipe(18655, 23079, 18637) -- Major Recombobulator
lib:AddRecipe(18656, 23080, 18594) -- Powerful Seaforium Charge
lib:AddRecipe(18657, 23081, 18638) -- Hyper-Radiant Flame Reflector
lib:AddRecipe(18658, 23082, 18639) -- Ultra-Flash Shadow Reflector
lib:AddRecipe(18654, 23096, 18645) -- Gnomish Alarm-o-Bot
lib:AddRecipe(18661, 23129, 18660) -- World Enlarger
lib:AddRecipe(19027, 23507, 19026) -- Snake Burst Firework
lib:AddRecipe(20000, 24356, 19999) -- Bloodvine Goggles
lib:AddRecipe(20001, 24357, 19998) -- Bloodvine Lens
lib:AddRecipe(21724, 26416, 21558) -- Small Blue Rocket
lib:AddRecipe(21725, 26417, 21559) -- Small Green Rocket
lib:AddRecipe(21726, 26418, 21557) -- Small Red Rocket
lib:AddRecipe(21727, 26420, 21589) -- Large Blue Rocket
lib:AddRecipe(21728, 26421, 21590) -- Large Green Rocket
lib:AddRecipe(21729, 26422, 21592) -- Large Red Rocket
lib:AddRecipe(21730, 26423, 21571) -- Blue Rocket Cluster
lib:AddRecipe(21731, 26424, 21574) -- Green Rocket Cluster
lib:AddRecipe(21732, 26425, 21576) -- Red Rocket Cluster
lib:AddRecipe(21733, 26426, 21714) -- Large Blue Rocket Cluster
lib:AddRecipe(21734, 26427, 21716) -- Large Green Rocket Cluster
lib:AddRecipe(21735, 26428, 21718) -- Large Red Rocket Cluster
lib:AddRecipe(21738, 26442, 21569) -- Firework Launcher
lib:AddRecipe(44919, 26442, 21569) -- Firework Launcher
lib:AddRecipe(21737, 26443, 21570) -- Cluster Launcher
lib:AddRecipe(44918, 26443, 21570) -- Cluster Launcher
lib:AddRecipe(22729, 28327, 22728) -- Steam Tonk Controller
lib:AddRecipe(23799, 30313, 23746) -- Adamantite Rifle
lib:AddRecipe(23800, 30314, 23747) -- Felsteel Boomstick
lib:AddRecipe(23802, 30315, 23748) -- Ornate Khorium Rifle
lib:AddRecipe(23803, 30316, 23758) -- Cogspinner Goggles
lib:AddRecipe(23804, 30317, 23761) -- Power Amplification Goggles
lib:AddRecipe(23805, 30318, 23762) -- Ultra-Spectropic Detection Goggles
lib:AddRecipe(23806, 30325, 23763) -- Hyper-Vision Goggles
lib:AddRecipe(23807, 30329, 23764) -- Adamantite Scope
lib:AddRecipe(23808, 30332, 23765) -- Khorium Scope
lib:AddRecipe(23809, 30334, 23766) -- Stabilized Eternium Scope
lib:AddRecipe(23810, 30337, 23767) -- Crashin' Thrashin' Robot
lib:AddRecipe(23811, 30341, 23768) -- White Smoke Flare
lib:AddRecipe(23812, 30342, 23769) -- Red Smoke Flare
lib:AddRecipe(23813, 30343, 23770) -- Blue Smoke Flare
lib:AddRecipe(23814, 30344, 23771) -- Green Smoke Flare
lib:AddRecipe(23816, 30348, 23774) -- Fel Iron Toolbox
lib:AddRecipe(23817, 30349, 23775) -- Titanium Toolbox
lib:AddRecipe(23874, 30547, 23819) -- Elemental Seaforium Charge
lib:AddRecipe(23888, 30548, 23821) -- Zapthrottle Mote Extractor
lib:AddRecipe(23883, 30551, 33092) -- Healing Potion Injector
lib:AddRecipe(35310, 30551, 33092) -- Healing Potion Injector
lib:AddRecipe(23884, 30552, 33093) -- Mana Potion Injector
lib:AddRecipe(35311, 30552, 33093) -- Mana Potion Injector
lib:AddRecipe(23887, 30556, 23824) -- Rocket Boots Xtreme
lib:AddRecipe(25887, 32814, 25886) -- Purple Smoke Flare
lib:AddRecipe(32381, 39895, 7191) -- Fused Wiring
lib:AddRecipe(34114, 44391, 34113) -- Field Repair Bot 110G
lib:AddRecipe(35191, 46106, 35183) -- Wonderheal XT68 Shades
lib:AddRecipe(35187, 46107, 35185) -- Justicebringer 3000 Specs
lib:AddRecipe(35189, 46108, 35181) -- Powerheal 9000 Lens
lib:AddRecipe(35190, 46109, 35182) -- Hyper-Magnified Moon Specs
lib:AddRecipe(35192, 46110, 35184) -- Primal-Attuned Goggles
lib:AddRecipe(35186, 46111, 34847) -- Annihilator Holo-Gogs
lib:AddRecipe(35193, 46112, 34355) -- Lightning Etched Specs
lib:AddRecipe(35194, 46113, 34356) -- Surestrike Goggles v3.0
lib:AddRecipe(35195, 46114, 34354) -- Mayhem Projection Goggles
lib:AddRecipe(35196, 46115, 34357) -- Hard Khorium Goggles
lib:AddRecipe(35197, 46116, 34353) -- Quad Deathblow X44 Goggles
lib:AddRecipe(35582, 46697, 35581) -- Rocket Boots Xtreme Lite
lib:AddRecipe(44502, 60866, 41508) -- Mechano-Hog
lib:AddRecipe(44503, 60867, 44413) -- Mekgineer's Chopper
lib:AddRecipe(49050, 68067, 49040) -- Jeeves
lib:AddRecipe(70177, 100587, 70139) -- Flintlocke's Woodchucker
lib:AddRecipe(71078, 100687, 71077) -- Extreme-Impact Hole Puncher
lib:AddRecipe(89994, 128260, 88493) -- Celestial Firework
lib:AddRecipe(89993, 128261, 88491) -- Grand Celebration Firework
lib:AddRecipe(89992, 128262, 87764) -- Serpent's Heart Firework
lib:AddRecipe(89996, 131256, 89893) -- Autumn Flower Firework
lib:AddRecipe(89997, 131258, 89888) -- Jade Blossom Firework
lib:AddRecipe(97230, 139176, 94113) -- Jard's Peculiar Energy Source
lib:AddRecipe(94880, 139192, 95416) -- Sky Golem
lib:AddRecipe(94893, 139196, 94903) -- Pierre
lib:AddRecipe(94894, 139197, 92747) -- Advanced Refrigeration Unit
lib:AddRecipe(100907, 143714, 100905) -- Rascal-Bot
lib:AddRecipe(118497, 162195, 109173) -- Cybergenetic Mechshades
lib:AddRecipe(118498, 162196, 109171) -- Night-Vision Mechshades
lib:AddRecipe(118499, 162197, 109172) -- Plasma Mechshades
lib:AddRecipe(118500, 162198, 109174) -- Razorguard Mechshades
lib:AddRecipe(118476, 162199, 109168) -- Shrediron's Shredder
lib:AddRecipe(118477, 162202, 109120) -- Oglethorpe's Missile Splitter
lib:AddRecipe(118478, 162203, 109122) -- Megawatt Filament
lib:AddRecipe(118479, 162204, 109076) -- Goblin Glider Kit
lib:AddRecipe(118480, 162205, 109167) -- Findle's Loot-a-Rang
lib:AddRecipe(118481, 162206, 109183) -- World Shrinker
lib:AddRecipe(118482, 162207, 109184) -- Stealthman 54
lib:AddRecipe(118483, 162208, 109253) -- Ultimate Gnomish Army Knife
lib:AddRecipe(118484, 162209, 111402) -- Mechanical Axebeak
lib:AddRecipe(118485, 162210, 112057) -- Lifelike Mechanical Frostboar
lib:AddRecipe(118487, 162214, 108745) -- Personal Hologram
lib:AddRecipe(118488, 162216, 112059) -- Wormhole Centrifuge
lib:AddRecipe(118489, 162217, 111820) -- Swapblaster
lib:AddRecipe(118490, 162218, 111821) -- Blingtron 5000
lib:AddRecipe(118491, 169076, 128011) -- Linkgrease Locksprocket
lib:AddRecipe(118493, 169078, 114056) -- Didi's Delicate Assembly
lib:AddRecipe(118494, 169080, 111366) -- Gearspring Parts
lib:AddRecipe(116142, 171072, 116147) -- Alliance Firework
lib:AddRecipe(116144, 171073, 116148) -- Horde Firework
lib:AddRecipe(116146, 171074, 116149) -- Snake Firework
lib:AddRecipe(118495, 173289, 118008) -- Hemet's Heartseeker
lib:AddRecipe(118496, 173308, 118007) -- Mecha-Blast Rocket
lib:AddRecipe(118510, 173309, 118006) -- Shieldtronic Shield
lib:AddRecipe(119177, 176732, 118741) -- Mechanical Scorpid
lib:AddRecipe(119302, 177054, 119299) -- Secrets of Draenor Engineering
lib:AddRecipe(120134, 177054, 119299) -- Secrets of Draenor Engineering
lib:AddRecipe(120268, 177363, 128017) -- True Iron Trigger
lib:AddRecipe(122712, 182120, 111366) -- Primal Welding
lib:AddRecipe(127729, 187496, 127719) -- Advanced Muzzlesprocket
lib:AddRecipe(127721, 187497, 127720) -- Bi-Directional Fizzle Reducer
lib:AddRecipe(127747, 187520, 127737) -- Taladite Firing Pin
lib:AddRecipe(127739, 187521, 127738) -- Infrablue-Blocker Lenses
-- First Aid
lib:AddRecipe(16112, 7929, 6451) -- Heavy Silk Bandage
lib:AddRecipe(16112, 7929, 6451) -- Heavy Silk Bandage
lib:AddRecipe(6454, 7935, 6453) -- Strong Anti-Venom
lib:AddRecipe(16113, 10840, 8544) -- Mageweave Bandage
lib:AddRecipe(16113, 10840, 8544) -- Mageweave Bandage
lib:AddRecipe(19442, 23787, 19440) -- Powerful Anti-Venom
lib:AddRecipe(21992, 27032, 21990) -- Netherweave Bandage
lib:AddRecipe(21993, 27033, 21991) -- Heavy Netherweave Bandage
lib:AddRecipe(39152, 45546, 34722) -- Heavy Frostweave Bandage
-- Inscription
lib:AddRecipe(46108, 64051, 45854) -- Rituals of the Moon
lib:AddRecipe(50166, 71101, 50045) -- Glyph of Counterspell
lib:AddRecipe(50168, 71102, 50077) -- Glyph of Eternal Resolve
lib:AddRecipe(65649, 86644, 62239) -- Origami Slime
lib:AddRecipe(65650, 86645, 62238) -- Origami Rock
lib:AddRecipe(65651, 86646, 63246) -- Origami Beetle
lib:AddRecipe(87829, 127475, 87817) -- Incarnadine Ink
lib:AddRecipe(102534, 146638, 102483) -- Crafted Malevolent Gladiator's Medallion of Tenacity
lib:AddRecipe(104197, 148255, 104046) -- Glyph of Swift Death
lib:AddRecipe(104210, 148257, 104048) -- Glyph of Regenerative Magic
lib:AddRecipe(104212, 148259, 104050) -- Glyph of Divine Shield
lib:AddRecipe(104213, 148260, 104051) -- Glyph of Hand of Sacrifice
lib:AddRecipe(104214, 148261, 104052) -- Glyph of Purging
lib:AddRecipe(104219, 148266, 104099) -- Glyph of the Skeleton
lib:AddRecipe(104221, 148268, 104102) -- Glyph of the Sprouting Mushroom
lib:AddRecipe(104222, 148269, 104103) -- Glyph of One with Nature
lib:AddRecipe(104223, 148270, 104104) -- Glyph of the Unbound Elemental
lib:AddRecipe(104224, 148271, 104105) -- Glyph of Evaporation
lib:AddRecipe(104225, 148272, 104106) -- Glyph of Condensation
lib:AddRecipe(104226, 148273, 104107) -- Glyph of the Exorcist
lib:AddRecipe(104227, 148274, 104108) -- Glyph of Pillar of Light
lib:AddRecipe(104228, 148275, 104109) -- Glyph of Angels
lib:AddRecipe(104229, 148276, 104120) -- Glyph of the Sha
lib:AddRecipe(104231, 148278, 104122) -- Glyph of Inspired Hymns
lib:AddRecipe(104232, 148279, 104123) -- Glyph of Headhunting
lib:AddRecipe(104233, 148280, 104124) -- Glyph of Improved Distraction
lib:AddRecipe(104234, 148281, 104126) -- Glyph of Spirit Raptors
lib:AddRecipe(104235, 148282, 104127) -- Glyph of Lingering Ancestors
lib:AddRecipe(104236, 148283, 104128) -- Glyph of Spirit Wolf
lib:AddRecipe(104237, 148284, 104129) -- Glyph of Flaming Serpent
lib:AddRecipe(104238, 148285, 104130) -- Glyph of the Compy
lib:AddRecipe(104239, 148286, 104131) -- Glyph of Elemental Familiars
lib:AddRecipe(104240, 148287, 104133) -- Glyph of Astral Fixation
lib:AddRecipe(104241, 148288, 104134) -- Glyph of Rain of Frogs
lib:AddRecipe(104242, 148289, 104135) -- Glyph of the Raging Whirlwind
lib:AddRecipe(104243, 148290, 104136) -- Glyph of the Subtle Defender
lib:AddRecipe(104244, 148291, 104137) -- Glyph of the Watchful Eye
lib:AddRecipe(104245, 148292, 104138) -- Glyph of the Weaponmaster
lib:AddRecipe(104279, 148487, 104270) -- Glyph of the Lean Pack
lib:AddRecipe(104281, 148489, 104276) -- Glyph of Enduring Deceit
lib:AddRecipe(118606, 163294, 112270) -- Darkmoon Card of Draenor
lib:AddRecipe(118615, 165804, 113131) -- Warmaster's Firestick
lib:AddRecipe(118605, 166356, 113134) -- Crystalfire Spellstaff
lib:AddRecipe(118607, 166359, 111526) -- Etched-Blade Warstaff
lib:AddRecipe(118613, 166363, 113270) -- Shadowtome
lib:AddRecipe(118610, 166366, 128010) -- Weapon Crystal
lib:AddRecipe(118614, 166432, 113289) -- Volatile Crystal
lib:AddRecipe(120136, 177045, 119297) -- Secrets of Draenor Inscription
lib:AddRecipe(120265, 178248, 128018) -- Ensorcelled Tarot
lib:AddRecipe(122713, 182125, 112377) -- The Spirit of War
lib:AddRecipe(127137, 186239, 127136) -- Glyph of Ascendance
lib:AddRecipe(127728, 187494, 127717) -- Mighty Weapon Crystal
lib:AddRecipe(127723, 187495, 127718) -- Mighty Ensorcelled Tarot
lib:AddRecipe(127746, 187518, 127735) -- Savage Weapon Crystal
lib:AddRecipe(127741, 187519, 127736) -- Savage Ensorcelled Tarot
lib:AddRecipe(128409, 190381, nil) -- Mass Mill Frostweed
lib:AddRecipe(128410, 190382, nil) -- Mass Mill Fireweed
lib:AddRecipe(128411, 190383, nil) -- Mass Mill Gorgrond Flytrap
lib:AddRecipe(128412, 190384, nil) -- Mass Mill Starflower
lib:AddRecipe(128413, 190385, nil) -- Mass Mill Nagrand Arrowbloom
lib:AddRecipe(128414, 190386, nil) -- Mass Mill Talador Orchid
-- Jewelcrafting
lib:AddRecipe(20856, 25320, 20831) -- Heavy Golden Necklace of Battle
lib:AddRecipe(20855, 25323, 20833) -- Wicked Moonstone Ring
lib:AddRecipe(20854, 25339, 20830) -- Amulet of the Moon
lib:AddRecipe(20970, 25610, 20950) -- Pendant of the Agate Shield
lib:AddRecipe(20971, 25612, 20954) -- Heavy Iron Knuckles
lib:AddRecipe(20973, 25617, 20958) -- Blazing Citrine Ring
lib:AddRecipe(20974, 25618, 20966) -- Jade Pendant of Blasting
lib:AddRecipe(20975, 25619, 20959) -- The Jade Eye
lib:AddRecipe(20976, 25622, 20967) -- Citrine Pendant of Golden Healing
lib:AddRecipe(21940, 26873, 21756) -- Figurine - Golden Hare
lib:AddRecipe(21941, 26875, 21758) -- Figurine - Black Pearl Panther
lib:AddRecipe(21942, 26878, 20969) -- Ruby Crown of Restoration
lib:AddRecipe(21943, 26881, 21760) -- Figurine - Truesilver Crab
lib:AddRecipe(21944, 26882, 21763) -- Figurine - Truesilver Boar
lib:AddRecipe(21945, 26887, 21754) -- The Aquamarine Ward
lib:AddRecipe(21947, 26896, 21753) -- Gem Studded Band
lib:AddRecipe(21948, 26897, 21766) -- Opal Necklace of Impact
lib:AddRecipe(21949, 26900, 21769) -- Figurine - Ruby Serpent
lib:AddRecipe(21952, 26906, 21774) -- Emerald Crown of Destruction
lib:AddRecipe(21953, 26909, 21777) -- Figurine - Emerald Owl
lib:AddRecipe(21954, 26910, 21778) -- Ring of Bitter Shadows
lib:AddRecipe(21955, 26912, 21784) -- Figurine - Black Diamond Crab
lib:AddRecipe(21956, 26914, 21789) -- Figurine - Dark Iron Scorpid
lib:AddRecipe(21957, 26915, 21792) -- Necklace of the Diamond Tower
lib:AddRecipe(23130, 28903, 23094) -- Brilliant Blood Garnet
lib:AddRecipe(23133, 28903, 23094) -- Brilliant Blood Garnet
lib:AddRecipe(23148, 28903, 23094) -- Brilliant Blood Garnet
lib:AddRecipe(23131, 28905, 23095) -- Bold Blood Garnet
lib:AddRecipe(23135, 28910, 23098) -- Inscribed Flame Spessarite
lib:AddRecipe(23136, 28912, 23099) -- Reckless Flame Spessarite
lib:AddRecipe(23137, 28914, 23100) -- Glinting Shadow Draenite
lib:AddRecipe(23138, 28915, 23101) -- Potent Flame Spessarite
lib:AddRecipe(23140, 28916, 23103) -- Radiant Deep Peridot
lib:AddRecipe(23141, 28917, 23104) -- Jagged Deep Peridot
lib:AddRecipe(23142, 28918, 23105) -- Regal Deep Peridot
lib:AddRecipe(31359, 28918, 23105) -- Regal Deep Peridot
lib:AddRecipe(23144, 28925, 23108) -- Timeless Shadow Draenite
lib:AddRecipe(23143, 28927, 23109) -- Purified Shadow Draenite
lib:AddRecipe(23145, 28927, 23109) -- Purified Shadow Draenite
lib:AddRecipe(23146, 28933, 23110) -- Shifting Shadow Draenite
lib:AddRecipe(31871, 28933, 23110) -- Shifting Shadow Draenite
lib:AddRecipe(31872, 28933, 23110) -- Shifting Shadow Draenite
lib:AddRecipe(23147, 28936, 23111) -- Sovereign Shadow Draenite
lib:AddRecipe(23149, 28944, 23114) -- Smooth Golden Draenite
lib:AddRecipe(28291, 28944, 23114) -- Smooth Golden Draenite
lib:AddRecipe(23150, 28947, 23115) -- Subtle Golden Draenite
lib:AddRecipe(23151, 28948, 23116) -- Rigid Azure Moonstone
lib:AddRecipe(31870, 28948, 23116) -- Rigid Azure Moonstone
lib:AddRecipe(23152, 28950, 23118) -- Solid Azure Moonstone
lib:AddRecipe(23153, 28953, 23119) -- Sparkling Azure Moonstone
lib:AddRecipe(23155, 28953, 23119) -- Sparkling Azure Moonstone
lib:AddRecipe(23154, 28955, 23120) -- Stormy Azure Moonstone
lib:AddRecipe(24158, 31053, 24079) -- Khorium Band of Shadows
lib:AddRecipe(24159, 31054, 24080) -- Khorium Band of Frost
lib:AddRecipe(24160, 31055, 24082) -- Khorium Inferno Band
lib:AddRecipe(24161, 31056, 24085) -- Khorium Band of Leaves
lib:AddRecipe(24162, 31057, 24086) -- Arcane Khorium Band
lib:AddRecipe(24163, 31058, 24087) -- Heavy Felsteel Ring
lib:AddRecipe(24164, 31060, 24088) -- Delicate Eternium Ring
lib:AddRecipe(24165, 31061, 24089) -- Blazing Eternium Band
lib:AddRecipe(24174, 31062, 24092) -- Pendant of Frozen Flame
lib:AddRecipe(24175, 31063, 24093) -- Pendant of Thawing
lib:AddRecipe(24176, 31064, 24095) -- Pendant of Withering
lib:AddRecipe(24177, 31065, 24097) -- Pendant of Shadow's End
lib:AddRecipe(24178, 31066, 24098) -- Pendant of the Null Rune
lib:AddRecipe(24166, 31067, 24106) -- Thick Felsteel Necklace
lib:AddRecipe(24167, 31068, 24110) -- Living Ruby Pendant
lib:AddRecipe(24168, 31070, 24114) -- Braided Eternium Chain
lib:AddRecipe(24169, 31071, 24116) -- Eye of the Night
lib:AddRecipe(24170, 31072, 24117) -- Embrace of the Dawn
lib:AddRecipe(24171, 31076, 24121) -- Chain of the Twilight Owl
lib:AddRecipe(24172, 31077, 24122) -- Coronet of Verdant Flame
lib:AddRecipe(24173, 31078, 24123) -- Circlet of Arcane Might
lib:AddRecipe(24179, 31079, 24124) -- Figurine - Felsteel Boar
lib:AddRecipe(24180, 31080, 24125) -- Figurine - Dawnstone Crab
lib:AddRecipe(31358, 31080, 24125) -- Figurine - Dawnstone Crab
lib:AddRecipe(24181, 31081, 24126) -- Figurine - Living Ruby Serpent
lib:AddRecipe(24182, 31082, 24127) -- Figurine - Talasite Owl
lib:AddRecipe(24183, 31083, 24128) -- Figurine - Nightseye Panther
lib:AddRecipe(24193, 31084, 24027) -- Bold Living Ruby
lib:AddRecipe(24192, 31085, 24028) -- Delicate Living Ruby
lib:AddRecipe(24194, 31085, 24028) -- Delicate Living Ruby
lib:AddRecipe(35306, 31085, 24028) -- Delicate Living Ruby
lib:AddRecipe(24195, 31088, 24030) -- Brilliant Living Ruby
lib:AddRecipe(24196, 31088, 24030) -- Brilliant Living Ruby
lib:AddRecipe(24203, 31088, 24030) -- Brilliant Living Ruby
lib:AddRecipe(35305, 31088, 24030) -- Brilliant Living Ruby
lib:AddRecipe(24197, 31090, 24032) -- Subtle Dawnstone
lib:AddRecipe(24207, 31090, 24032) -- Subtle Dawnstone
lib:AddRecipe(24198, 31091, 24036) -- Flashing Living Ruby
lib:AddRecipe(24199, 31092, 24033) -- Solid Star of Elune
lib:AddRecipe(35304, 31092, 24033) -- Solid Star of Elune
lib:AddRecipe(24202, 31095, 24039) -- Stormy Star of Elune
lib:AddRecipe(24204, 31097, 24048) -- Smooth Dawnstone
lib:AddRecipe(24206, 31097, 24048) -- Smooth Dawnstone
lib:AddRecipe(24205, 31098, 24051) -- Rigid Star of Elune
lib:AddRecipe(31875, 31098, 24051) -- Rigid Star of Elune
lib:AddRecipe(35307, 31098, 24051) -- Rigid Star of Elune
lib:AddRecipe(24208, 31101, 24053) -- Mystic Dawnstone
lib:AddRecipe(24209, 31102, 24054) -- Sovereign Nightseye
lib:AddRecipe(24210, 31103, 24055) -- Shifting Nightseye
lib:AddRecipe(31876, 31103, 24055) -- Shifting Nightseye
lib:AddRecipe(24211, 31104, 24056) -- Timeless Nightseye
lib:AddRecipe(24213, 31106, 24058) -- Inscribed Noble Topaz
lib:AddRecipe(24214, 31107, 24059) -- Potent Noble Topaz
lib:AddRecipe(24215, 31108, 24060) -- Reckless Noble Topaz
lib:AddRecipe(35323, 31108, 24060) -- Reckless Noble Topaz
lib:AddRecipe(24216, 31109, 24061) -- Glinting Nightseye
lib:AddRecipe(31877, 31109, 24061) -- Glinting Nightseye
lib:AddRecipe(24218, 31111, 24066) -- Radiant Talasite
lib:AddRecipe(24212, 31112, 24065) -- Purified Nightseye
lib:AddRecipe(24219, 31112, 24065) -- Purified Nightseye
lib:AddRecipe(24220, 31113, 24067) -- Jagged Talasite
lib:AddRecipe(24200, 31149, 24035) -- Sparkling Star of Elune
lib:AddRecipe(24201, 31149, 24035) -- Sparkling Star of Elune
lib:AddRecipe(25902, 32866, 25896) -- Powerful Earthstorm Diamond
lib:AddRecipe(25903, 32867, 25897) -- Bracing Earthstorm Diamond
lib:AddRecipe(25905, 32868, 25898) -- Tenacious Earthstorm Diamond
lib:AddRecipe(25906, 32869, 25899) -- Brutal Earthstorm Diamond
lib:AddRecipe(25904, 32870, 25901) -- Insightful Earthstorm Diamond
lib:AddRecipe(25907, 32871, 25890) -- Destructive Skyfire Diamond
lib:AddRecipe(25909, 32872, 25893) -- Mystical Skyfire Diamond
lib:AddRecipe(25908, 32873, 25894) -- Swift Skyfire Diamond
lib:AddRecipe(25910, 32874, 25895) -- Enigmatic Skyfire Diamond
lib:AddRecipe(23134, 34590, 28595) -- Delicate Blood Garnet
lib:AddRecipe(28596, 34590, 28595) -- Delicate Blood Garnet
lib:AddRecipe(30826, 37855, 30825) -- Ring of Arcane Shielding
lib:AddRecipe(31401, 38503, 31398) -- The Frozen Eye
lib:AddRecipe(31402, 38504, 31399) -- The Natural Ward
lib:AddRecipe(31873, 39466, 31866) -- Veiled Shadow Draenite
lib:AddRecipe(31874, 39467, 31869) -- Deadly Flame Spessarite
lib:AddRecipe(31878, 39470, 31867) -- Veiled Nightseye
lib:AddRecipe(31879, 39471, 31868) -- Deadly Noble Topaz
lib:AddRecipe(32274, 39705, 32193) -- Bold Crimson Spinel
lib:AddRecipe(35244, 39705, 32193) -- Bold Crimson Spinel
lib:AddRecipe(32277, 39706, 32194) -- Delicate Crimson Spinel
lib:AddRecipe(32283, 39706, 32194) -- Delicate Crimson Spinel
lib:AddRecipe(35245, 39706, 32194) -- Delicate Crimson Spinel
lib:AddRecipe(35246, 39706, 32194) -- Delicate Crimson Spinel
lib:AddRecipe(32281, 39711, 32196) -- Brilliant Crimson Spinel
lib:AddRecipe(32282, 39711, 32196) -- Brilliant Crimson Spinel
lib:AddRecipe(32290, 39711, 32196) -- Brilliant Crimson Spinel
lib:AddRecipe(35248, 39711, 32196) -- Brilliant Crimson Spinel
lib:AddRecipe(35250, 39711, 32196) -- Brilliant Crimson Spinel
lib:AddRecipe(35255, 39711, 32196) -- Brilliant Crimson Spinel
lib:AddRecipe(32284, 39713, 32198) -- Subtle Lionseye
lib:AddRecipe(32294, 39713, 32198) -- Subtle Lionseye
lib:AddRecipe(35249, 39713, 32198) -- Subtle Lionseye
lib:AddRecipe(35261, 39713, 32198) -- Subtle Lionseye
lib:AddRecipe(32285, 39714, 32199) -- Flashing Crimson Spinel
lib:AddRecipe(35247, 39714, 32199) -- Flashing Crimson Spinel
lib:AddRecipe(32286, 39715, 32200) -- Solid Empyrean Sapphire
lib:AddRecipe(35263, 39715, 32200) -- Solid Empyrean Sapphire
lib:AddRecipe(32287, 39716, 32201) -- Sparkling Empyrean Sapphire
lib:AddRecipe(32288, 39716, 32201) -- Sparkling Empyrean Sapphire
lib:AddRecipe(35262, 39716, 32201) -- Sparkling Empyrean Sapphire
lib:AddRecipe(35264, 39716, 32201) -- Sparkling Empyrean Sapphire
lib:AddRecipe(32289, 39718, 32203) -- Stormy Empyrean Sapphire
lib:AddRecipe(35265, 39718, 32203) -- Stormy Empyrean Sapphire
lib:AddRecipe(32291, 39720, 32205) -- Smooth Lionseye
lib:AddRecipe(32293, 39720, 32205) -- Smooth Lionseye
lib:AddRecipe(35256, 39720, 32205) -- Smooth Lionseye
lib:AddRecipe(35260, 39720, 32205) -- Smooth Lionseye
lib:AddRecipe(32292, 39721, 32206) -- Rigid Empyrean Sapphire
lib:AddRecipe(32296, 39721, 32206) -- Rigid Empyrean Sapphire
lib:AddRecipe(35257, 39721, 32206) -- Rigid Empyrean Sapphire
lib:AddRecipe(35259, 39721, 32206) -- Rigid Empyrean Sapphire
lib:AddRecipe(32295, 39724, 32209) -- Mystic Lionseye
lib:AddRecipe(35258, 39724, 32209) -- Mystic Lionseye
lib:AddRecipe(32297, 39727, 32211) -- Sovereign Shadowsong Amethyst
lib:AddRecipe(35243, 39727, 32211) -- Sovereign Shadowsong Amethyst
lib:AddRecipe(32298, 39728, 32212) -- Shifting Shadowsong Amethyst
lib:AddRecipe(32299, 39728, 32212) -- Shifting Shadowsong Amethyst
lib:AddRecipe(35238, 39728, 32212) -- Shifting Shadowsong Amethyst
lib:AddRecipe(35242, 39728, 32212) -- Shifting Shadowsong Amethyst
lib:AddRecipe(32301, 39731, 32215) -- Timeless Shadowsong Amethyst
lib:AddRecipe(35239, 39731, 32215) -- Timeless Shadowsong Amethyst
lib:AddRecipe(32303, 39733, 32217) -- Inscribed Pyrestone
lib:AddRecipe(35267, 39733, 32217) -- Inscribed Pyrestone
lib:AddRecipe(32304, 39734, 32218) -- Potent Pyrestone
lib:AddRecipe(35269, 39734, 32218) -- Potent Pyrestone
lib:AddRecipe(32300, 39736, 32220) -- Glinting Shadowsong Amethyst
lib:AddRecipe(32306, 39736, 32220) -- Glinting Shadowsong Amethyst
lib:AddRecipe(35240, 39736, 32220) -- Glinting Shadowsong Amethyst
lib:AddRecipe(35266, 39736, 32220) -- Glinting Shadowsong Amethyst
lib:AddRecipe(32307, 39737, 32221) -- Veiled Shadowsong Amethyst
lib:AddRecipe(35270, 39737, 32221) -- Veiled Shadowsong Amethyst
lib:AddRecipe(32308, 39738, 32222) -- Deadly Pyrestone
lib:AddRecipe(35271, 39738, 32222) -- Deadly Pyrestone
lib:AddRecipe(32309, 39739, 32223) -- Regal Seaspray Emerald
lib:AddRecipe(35252, 39739, 32223) -- Regal Seaspray Emerald
lib:AddRecipe(32310, 39740, 32224) -- Radiant Seaspray Emerald
lib:AddRecipe(35254, 39740, 32224) -- Radiant Seaspray Emerald
lib:AddRecipe(32302, 39741, 32225) -- Purified Shadowsong Amethyst
lib:AddRecipe(32311, 39741, 32225) -- Purified Shadowsong Amethyst
lib:AddRecipe(35241, 39741, 32225) -- Purified Shadowsong Amethyst
lib:AddRecipe(35251, 39741, 32225) -- Purified Shadowsong Amethyst
lib:AddRecipe(37504, 39741, 32225) -- Purified Shadowsong Amethyst
lib:AddRecipe(32312, 39742, 32226) -- Jagged Seaspray Emerald
lib:AddRecipe(35253, 39742, 32226) -- Jagged Seaspray Emerald
lib:AddRecipe(32412, 39961, 32409) -- Relentless Earthstorm Diamond
lib:AddRecipe(33622, 39961, 32409) -- Relentless Earthstorm Diamond
lib:AddRecipe(32411, 39963, 32410) -- Thundering Skyfire Diamond
lib:AddRecipe(33305, 42558, 33133) -- Don Julio's Heart
lib:AddRecipe(33155, 42588, 33134) -- Kailee's Rose
lib:AddRecipe(33156, 42589, 33131) -- Crimson Sun
lib:AddRecipe(33157, 42590, 33135) -- Falling Star
lib:AddRecipe(33158, 42591, 33143) -- Stone of Blades
lib:AddRecipe(33159, 42592, 33140) -- Blood of Amber
lib:AddRecipe(33160, 42593, 33144) -- Facet of Eternity
lib:AddRecipe(33783, 43493, 33782) -- Steady Talasite
lib:AddRecipe(34689, 44794, 34220) -- Chaotic Skyfire Diamond
lib:AddRecipe(35198, 46122, 34362) -- Loop of Forged Power
lib:AddRecipe(35199, 46123, 34363) -- Ring of Flowing Life
lib:AddRecipe(35200, 46124, 34361) -- Hard Khorium Band
lib:AddRecipe(35201, 46125, 34359) -- Pendant of Sunfire
lib:AddRecipe(35202, 46126, 34360) -- Amulet of Flowing Life
lib:AddRecipe(35203, 46127, 34358) -- Hard Khorium Choker
lib:AddRecipe(35322, 46403, 35315) -- Quick Dawnstone
lib:AddRecipe(35325, 46405, 35318) -- Forceful Talasite
lib:AddRecipe(35502, 46597, 35501) -- Eternal Earthstorm Diamond
lib:AddRecipe(35505, 46601, 35503) -- Ember Skyfire Diamond
lib:AddRecipe(35695, 46775, 35693) -- Figurine - Empyrean Tortoise
lib:AddRecipe(35696, 46776, 35694) -- Figurine - Khorium Boar
lib:AddRecipe(35697, 46777, 35700) -- Figurine - Crimson Serpent
lib:AddRecipe(35698, 46778, 35702) -- Figurine - Shadowsong Panther
lib:AddRecipe(35699, 46779, 35703) -- Figurine - Seaspray Albatross
lib:AddRecipe(24217, 46803, 35707) -- Regal Talasite
lib:AddRecipe(35708, 46803, 35707) -- Regal Talasite
lib:AddRecipe(35765, 47053, 35759) -- Forceful Seaspray Emerald
lib:AddRecipe(35769, 47053, 35759) -- Forceful Seaspray Emerald
lib:AddRecipe(35764, 47054, 35758) -- Steady Seaspray Emerald
lib:AddRecipe(35766, 47054, 35758) -- Steady Seaspray Emerald
lib:AddRecipe(32305, 47055, 35760) -- Reckless Pyrestone
lib:AddRecipe(35268, 47055, 35760) -- Reckless Pyrestone
lib:AddRecipe(35762, 47055, 35760) -- Reckless Pyrestone
lib:AddRecipe(35767, 47055, 35760) -- Reckless Pyrestone
lib:AddRecipe(35763, 47056, 35761) -- Quick Lionseye
lib:AddRecipe(35768, 47056, 35761) -- Quick Lionseye
lib:AddRecipe(41576, 53830, 39996) -- Bold Scarlet Ruby
lib:AddRecipe(41559, 53857, 39917) -- Mystic Sun Crystal
lib:AddRecipe(41575, 53865, 39945) -- Mysterious Shadow Crystal
lib:AddRecipe(41574, 53869, 39939) -- Defender's Shadow Crystal
lib:AddRecipe(41566, 53875, 39950) -- Resplendent Huge Citrine
lib:AddRecipe(41562, 53877, 39952) -- Deadly Huge Citrine
lib:AddRecipe(41564, 53879, 39954) -- Lucent Huge Citrine
lib:AddRecipe(41565, 53879, 39954) -- Lucent Huge Citrine
lib:AddRecipe(41563, 53884, 39958) -- Willful Huge Citrine
lib:AddRecipe(41561, 53885, 39959) -- Reckless Huge Citrine
lib:AddRecipe(41567, 53917, 39975) -- Nimble Dark Jade
lib:AddRecipe(41572, 53919, 39977) -- Steady Dark Jade
lib:AddRecipe(41568, 53921, 39979) -- Purified Shadow Crystal
lib:AddRecipe(41571, 53924, 39982) -- Turbid Dark Jade
lib:AddRecipe(41573, 53924, 39982) -- Turbid Dark Jade
lib:AddRecipe(41570, 53932, 39991) -- Radiant Dark Jade
lib:AddRecipe(41569, 53933, 39992) -- Shattered Dark Jade
lib:AddRecipe(41560, 53943, 39932) -- Stormy Chalcedony
lib:AddRecipe(41577, 53945, 39997) -- Delicate Scarlet Ruby
lib:AddRecipe(41718, 53946, 39998) -- Brilliant Scarlet Ruby
lib:AddRecipe(47011, 53946, 39998) -- Brilliant Scarlet Ruby
lib:AddRecipe(41719, 53948, 40000) -- Subtle Autumn's Glow
lib:AddRecipe(41791, 53948, 40000) -- Subtle Autumn's Glow
lib:AddRecipe(41578, 53949, 40001) -- Flashing Scarlet Ruby
lib:AddRecipe(41790, 53951, 40003) -- Precise Scarlet Ruby
lib:AddRecipe(42138, 53952, 40008) -- Solid Sky Sapphire
lib:AddRecipe(41581, 53954, 40010) -- Sparkling Sky Sapphire
lib:AddRecipe(41728, 53955, 40011) -- Stormy Sky Sapphire
lib:AddRecipe(41720, 53957, 40013) -- Smooth Autumn's Glow
lib:AddRecipe(41817, 53957, 40013) -- Smooth Autumn's Glow
lib:AddRecipe(41580, 53958, 40014) -- Rigid Sky Sapphire
lib:AddRecipe(41727, 53960, 40016) -- Mystic Autumn's Glow
lib:AddRecipe(41579, 53961, 40017) -- Quick Autumn's Glow
lib:AddRecipe(41784, 53962, 40022) -- Sovereign Twilight Opal
lib:AddRecipe(41747, 53963, 40023) -- Shifting Twilight Opal
lib:AddRecipe(41725, 53965, 40025) -- Timeless Twilight Opal
lib:AddRecipe(41795, 53965, 40025) -- Timeless Twilight Opal
lib:AddRecipe(41699, 53966, 40026) -- Purified Twilight Opal
lib:AddRecipe(41701, 53966, 40026) -- Purified Twilight Opal
lib:AddRecipe(41783, 53966, 40026) -- Purified Twilight Opal
lib:AddRecipe(41740, 53968, 40028) -- Mysterious Twilight Opal
lib:AddRecipe(41820, 53972, 40032) -- Defender's Twilight Opal
lib:AddRecipe(41726, 53974, 40034) -- Guardian's Twilight Opal
lib:AddRecipe(41789, 53975, 40037) -- Inscribed Monarch Topaz
lib:AddRecipe(41777, 53976, 40038) -- Etched Twilight Opal
lib:AddRecipe(41780, 53977, 40039) -- Champion's Monarch Topaz
lib:AddRecipe(41734, 53978, 40040) -- Resplendent Monarch Topaz
lib:AddRecipe(41582, 53980, 40044) -- Glinting Twilight Opal
lib:AddRecipe(41785, 53980, 40044) -- Glinting Twilight Opal
lib:AddRecipe(41796, 53980, 40044) -- Glinting Twilight Opal
lib:AddRecipe(41732, 53981, 40045) -- Lucent Monarch Topaz
lib:AddRecipe(41733, 53981, 40045) -- Lucent Monarch Topaz
lib:AddRecipe(46906, 53981, 40045) -- Lucent Monarch Topaz
lib:AddRecipe(41686, 53984, 40048) -- Potent Monarch Topaz
lib:AddRecipe(41688, 53985, 40049) -- Veiled Twilight Opal
lib:AddRecipe(41730, 53986, 40050) -- Willful Monarch Topaz
lib:AddRecipe(41689, 53987, 40051) -- Reckless Monarch Topaz
lib:AddRecipe(41690, 53987, 40051) -- Reckless Monarch Topaz
lib:AddRecipe(41721, 53988, 40052) -- Deadly Monarch Topaz
lib:AddRecipe(41794, 53988, 40052) -- Deadly Monarch Topaz
lib:AddRecipe(41687, 53991, 40055) -- Deft Monarch Topaz
lib:AddRecipe(41792, 53991, 40055) -- Deft Monarch Topaz
lib:AddRecipe(41722, 53993, 40057) -- Stalwart Monarch Topaz
lib:AddRecipe(41779, 53993, 40057) -- Stalwart Monarch Topaz
lib:AddRecipe(41818, 53994, 40058) -- Accurate Twilight Opal
lib:AddRecipe(41702, 53996, 40086) -- Jagged Forest Emerald
lib:AddRecipe(41723, 53996, 40086) -- Jagged Forest Emerald
lib:AddRecipe(41698, 53997, 40088) -- Nimble Forest Emerald
lib:AddRecipe(41697, 53998, 40089) -- Regal Forest Emerald
lib:AddRecipe(41703, 53998, 40089) -- Regal Forest Emerald
lib:AddRecipe(41738, 54000, 40090) -- Steady Forest Emerald
lib:AddRecipe(41693, 54001, 40091) -- Forceful Forest Emerald
lib:AddRecipe(41724, 54003, 40095) -- Misty Forest Emerald
lib:AddRecipe(41781, 54003, 40095) -- Misty Forest Emerald
lib:AddRecipe(41737, 54005, 40102) -- Turbid Forest Emerald
lib:AddRecipe(41739, 54005, 40102) -- Turbid Forest Emerald
lib:AddRecipe(41696, 54009, 40100) -- Lightning Forest Emerald
lib:AddRecipe(41782, 54009, 40100) -- Lightning Forest Emerald
lib:AddRecipe(41692, 54011, 40105) -- Energized Forest Emerald
lib:AddRecipe(41694, 54011, 40105) -- Energized Forest Emerald
lib:AddRecipe(41736, 54012, 40098) -- Radiant Forest Emerald
lib:AddRecipe(41819, 54012, 40098) -- Radiant Forest Emerald
lib:AddRecipe(41735, 54014, 40106) -- Shattered Forest Emerald
lib:AddRecipe(41793, 54019, 40041) -- Fierce Monarch Topaz
lib:AddRecipe(41778, 54023, 40059) -- Resolute Monarch Topaz
lib:AddRecipe(41414, 55384, 41377) -- Shielded Skyflare Diamond
lib:AddRecipe(41705, 55384, 41377) -- Shielded Skyflare Diamond
lib:AddRecipe(41415, 55386, 41375) -- Tireless Skyflare Diamond
lib:AddRecipe(41416, 55387, 41378) -- Forlorn Skyflare Diamond
lib:AddRecipe(41743, 55387, 41378) -- Forlorn Skyflare Diamond
lib:AddRecipe(41417, 55388, 41379) -- Impassive Skyflare Diamond
lib:AddRecipe(41744, 55388, 41379) -- Impassive Skyflare Diamond
lib:AddRecipe(41418, 55389, 41285) -- Chaotic Skyflare Diamond
lib:AddRecipe(41704, 55389, 41285) -- Chaotic Skyflare Diamond
lib:AddRecipe(41419, 55390, 41307) -- Destructive Skyflare Diamond
lib:AddRecipe(41786, 55390, 41307) -- Destructive Skyflare Diamond
lib:AddRecipe(41420, 55392, 41333) -- Ember Skyflare Diamond
lib:AddRecipe(41706, 55392, 41333) -- Ember Skyflare Diamond
lib:AddRecipe(41421, 55393, 41335) -- Enigmatic Skyflare Diamond
lib:AddRecipe(41742, 55393, 41335) -- Enigmatic Skyflare Diamond
lib:AddRecipe(41422, 55394, 41339) -- Swift Skyflare Diamond
lib:AddRecipe(41423, 55395, 41400) -- Thundering Skyflare Diamond
lib:AddRecipe(41787, 55395, 41400) -- Thundering Skyflare Diamond
lib:AddRecipe(41403, 55396, 41401) -- Insightful Earthsiege Diamond
lib:AddRecipe(41708, 55396, 41401) -- Insightful Earthsiege Diamond
lib:AddRecipe(41404, 55397, 41395) -- Bracing Earthsiege Diamond
lib:AddRecipe(41798, 55397, 41395) -- Bracing Earthsiege Diamond
lib:AddRecipe(41405, 55398, 41396) -- Eternal Earthsiege Diamond
lib:AddRecipe(41799, 55398, 41396) -- Eternal Earthsiege Diamond
lib:AddRecipe(41406, 55399, 41397) -- Powerful Earthsiege Diamond
lib:AddRecipe(41407, 55400, 41398) -- Relentless Earthsiege Diamond
lib:AddRecipe(41710, 55400, 41398) -- Relentless Earthsiege Diamond
lib:AddRecipe(41408, 55401, 41380) -- Austere Earthsiege Diamond
lib:AddRecipe(41797, 55401, 41380) -- Austere Earthsiege Diamond
lib:AddRecipe(41409, 55402, 41381) -- Persistent Earthsiege Diamond
lib:AddRecipe(41410, 55403, 41382) -- Trenchant Earthsiege Diamond
lib:AddRecipe(41711, 55403, 41382) -- Trenchant Earthsiege Diamond
lib:AddRecipe(41411, 55404, 41385) -- Invigorating Earthsiege Diamond
lib:AddRecipe(41709, 55404, 41385) -- Invigorating Earthsiege Diamond
lib:AddRecipe(41412, 55405, 41389) -- Beaming Earthsiege Diamond
lib:AddRecipe(41788, 55405, 41389) -- Beaming Earthsiege Diamond
lib:AddRecipe(41413, 55407, 41376) -- Revitalizing Skyflare Diamond
lib:AddRecipe(41707, 55407, 41376) -- Revitalizing Skyflare Diamond
lib:AddRecipe(42298, 56049, 42142) -- Bold Dragon's Eye
lib:AddRecipe(42299, 56052, 42143) -- Delicate Dragon's Eye
lib:AddRecipe(42301, 56052, 42143) -- Delicate Dragon's Eye
lib:AddRecipe(42300, 56053, 42144) -- Brilliant Dragon's Eye
lib:AddRecipe(42309, 56053, 42144) -- Brilliant Dragon's Eye
lib:AddRecipe(42314, 56055, 42151) -- Subtle Dragon's Eye
lib:AddRecipe(42315, 56055, 42151) -- Subtle Dragon's Eye
lib:AddRecipe(42302, 56056, 42152) -- Flashing Dragon's Eye
lib:AddRecipe(42305, 56079, 42158) -- Mystic Dragon's Eye
lib:AddRecipe(42306, 56081, 42154) -- Precise Dragon's Eye
lib:AddRecipe(42307, 56083, 42150) -- Quick Dragon's Eye
lib:AddRecipe(42308, 56084, 42156) -- Rigid Dragon's Eye
lib:AddRecipe(42303, 56085, 42149) -- Smooth Dragon's Eye
lib:AddRecipe(42310, 56085, 42149) -- Smooth Dragon's Eye
lib:AddRecipe(42311, 56086, 36767) -- Solid Dragon's Eye
lib:AddRecipe(42304, 56087, 42145) -- Sparkling Dragon's Eye
lib:AddRecipe(42312, 56087, 42145) -- Sparkling Dragon's Eye
lib:AddRecipe(42313, 56088, 42155) -- Stormy Dragon's Eye
lib:AddRecipe(42648, 56496, 42642) -- Titanium Impact Band
lib:AddRecipe(42649, 56497, 42643) -- Titanium Earthguard Ring
lib:AddRecipe(42650, 56498, 42644) -- Titanium Spellshock Ring
lib:AddRecipe(42651, 56499, 42645) -- Titanium Impact Choker
lib:AddRecipe(42652, 56500, 42646) -- Titanium Earthguard Chain
lib:AddRecipe(42653, 56501, 42647) -- Titanium Spellshock Necklace
lib:AddRecipe(43317, 58147, 43250) -- Ring of Earthen Might
lib:AddRecipe(43318, 58148, 43251) -- Ring of Scarlet Shadows
lib:AddRecipe(43319, 58149, 43252) -- Windfire Band
lib:AddRecipe(43320, 58150, 43253) -- Ring of Northern Tears
lib:AddRecipe(43485, 58492, 43482) -- Savage Titanium Ring
lib:AddRecipe(43497, 58507, 43498) -- Savage Titanium Band
lib:AddRecipe(43597, 58954, 43582) -- Titanium Frostguard Ring
lib:AddRecipe(46897, 66338, 40167) -- Regal Eye of Zul
lib:AddRecipe(46940, 66338, 40167) -- Regal Eye of Zul
lib:AddRecipe(46898, 66428, 40168) -- Steady Eye of Zul
lib:AddRecipe(46899, 66429, 40166) -- Nimble Eye of Zul
lib:AddRecipe(46901, 66431, 40165) -- Jagged Eye of Zul
lib:AddRecipe(46944, 66431, 40165) -- Jagged Eye of Zul
lib:AddRecipe(46902, 66432, 40164) -- Timeless Dreadstone
lib:AddRecipe(46936, 66432, 40164) -- Timeless Dreadstone
lib:AddRecipe(46904, 66434, 40169) -- Forceful Eye of Zul
lib:AddRecipe(46905, 66435, 40171) -- Misty Eye of Zul
lib:AddRecipe(46907, 66439, 40177) -- Lightning Eye of Zul
lib:AddRecipe(46909, 66439, 40177) -- Lightning Eye of Zul
lib:AddRecipe(46908, 66441, 40180) -- Radiant Eye of Zul
lib:AddRecipe(46911, 66441, 40180) -- Radiant Eye of Zul
lib:AddRecipe(46910, 66442, 40179) -- Energized Eye of Zul
lib:AddRecipe(46912, 66442, 40179) -- Energized Eye of Zul
lib:AddRecipe(46913, 66443, 40182) -- Shattered Eye of Zul
lib:AddRecipe(46914, 66445, 40173) -- Turbid Eye of Zul
lib:AddRecipe(46915, 66445, 40173) -- Turbid Eye of Zul
lib:AddRecipe(46916, 66446, 40113) -- Brilliant Cardinal Ruby
lib:AddRecipe(46930, 66446, 40113) -- Brilliant Cardinal Ruby
lib:AddRecipe(46917, 66447, 40111) -- Bold Cardinal Ruby
lib:AddRecipe(46918, 66448, 40112) -- Delicate Cardinal Ruby
lib:AddRecipe(46919, 66448, 40112) -- Delicate Cardinal Ruby
lib:AddRecipe(46920, 66450, 40118) -- Precise Cardinal Ruby
lib:AddRecipe(46922, 66452, 40115) -- Subtle King's Amber
lib:AddRecipe(46931, 66452, 40115) -- Subtle King's Amber
lib:AddRecipe(46923, 66453, 40116) -- Flashing Cardinal Ruby
lib:AddRecipe(46924, 66497, 40119) -- Solid Majestic Zircon
lib:AddRecipe(46925, 66498, 40120) -- Sparkling Majestic Zircon
lib:AddRecipe(46927, 66498, 40120) -- Sparkling Majestic Zircon
lib:AddRecipe(46926, 66499, 40122) -- Stormy Majestic Zircon
lib:AddRecipe(46928, 66501, 40125) -- Rigid Majestic Zircon
lib:AddRecipe(46921, 66502, 40124) -- Smooth King's Amber
lib:AddRecipe(46929, 66502, 40124) -- Smooth King's Amber
lib:AddRecipe(46932, 66505, 40127) -- Mystic King's Amber
lib:AddRecipe(46933, 66506, 40128) -- Quick King's Amber
lib:AddRecipe(46935, 66554, 40129) -- Sovereign Dreadstone
lib:AddRecipe(46900, 66556, 40133) -- Purified Dreadstone
lib:AddRecipe(46903, 66556, 40133) -- Purified Dreadstone
lib:AddRecipe(46937, 66556, 40133) -- Purified Dreadstone
lib:AddRecipe(46939, 66556, 40133) -- Purified Dreadstone
lib:AddRecipe(46947, 66556, 40133) -- Purified Dreadstone
lib:AddRecipe(46934, 66557, 40130) -- Shifting Dreadstone
lib:AddRecipe(46938, 66557, 40130) -- Shifting Dreadstone
lib:AddRecipe(46941, 66560, 40139) -- Defender's Dreadstone
lib:AddRecipe(46942, 66561, 40141) -- Guardian's Dreadstone
lib:AddRecipe(46943, 66562, 40135) -- Mysterious Dreadstone
lib:AddRecipe(46948, 66567, 40142) -- Inscribed Ametrine
lib:AddRecipe(46949, 66568, 40147) -- Deadly Ametrine
lib:AddRecipe(46950, 66569, 40152) -- Potent Ametrine
lib:AddRecipe(46951, 66570, 40153) -- Veiled Dreadstone
lib:AddRecipe(46952, 66571, 40154) -- Willful Ametrine
lib:AddRecipe(46953, 66572, 40143) -- Etched Dreadstone
lib:AddRecipe(46945, 66573, 40157) -- Glinting Dreadstone
lib:AddRecipe(46946, 66573, 40157) -- Glinting Dreadstone
lib:AddRecipe(46956, 66573, 40157) -- Glinting Dreadstone
lib:AddRecipe(47008, 66573, 40157) -- Glinting Dreadstone
lib:AddRecipe(47007, 66574, 40155) -- Reckless Ametrine
lib:AddRecipe(47010, 66576, 40162) -- Accurate Dreadstone
lib:AddRecipe(47015, 66579, 40144) -- Champion's Ametrine
lib:AddRecipe(47012, 66581, 40160) -- Stalwart Ametrine
lib:AddRecipe(47017, 66581, 40160) -- Stalwart Ametrine
lib:AddRecipe(47018, 66582, 40145) -- Resplendent Ametrine
lib:AddRecipe(47019, 66583, 40146) -- Fierce Ametrine
lib:AddRecipe(47020, 66584, 40150) -- Deft Ametrine
lib:AddRecipe(47023, 66584, 40150) -- Deft Ametrine
lib:AddRecipe(47016, 66585, 40149) -- Lucent Ametrine
lib:AddRecipe(47021, 66585, 40149) -- Lucent Ametrine
lib:AddRecipe(47022, 66586, 40163) -- Resolute Ametrine
lib:AddRecipe(49112, 68253, 49110) -- Nightmare Tear
lib:AddRecipe(52363, 73224, 52083) -- Flashing Carnelian
lib:AddRecipe(52364, 73229, 52088) -- Stormy Zephyrite
lib:AddRecipe(52365, 73231, 52090) -- Subtle Alicite
lib:AddRecipe(52366, 73242, 52097) -- Defender's Nightstone
lib:AddRecipe(52367, 73244, 52099) -- Guardian's Nightstone
lib:AddRecipe(52368, 73245, 52100) -- Purified Nightstone
lib:AddRecipe(52369, 73248, 52103) -- Retaliating Nightstone
lib:AddRecipe(52370, 73258, 52106) -- Polished Hessonite
lib:AddRecipe(52371, 73260, 52108) -- Inscribed Hessonite
lib:AddRecipe(52372, 73262, 52109) -- Deadly Hessonite
lib:AddRecipe(52373, 73263, 52110) -- Potent Hessonite
lib:AddRecipe(52374, 73264, 52111) -- Fierce Hessonite
lib:AddRecipe(52375, 73265, 52112) -- Deft Hessonite
lib:AddRecipe(69820, 73266, 52113) -- Reckless Hessonite
lib:AddRecipe(52376, 73269, 52116) -- Fine Hessonite
lib:AddRecipe(52377, 73271, 52118) -- Keen Hessonite
lib:AddRecipe(52378, 73272, 52119) -- Regal Jasper
lib:AddRecipe(52379, 73273, 52120) -- Nimble Jasper
lib:AddRecipe(52382, 73275, 52122) -- Piercing Jasper
lib:AddRecipe(52383, 73276, 52123) -- Steady Jasper
lib:AddRecipe(52385, 73277, 52124) -- Forceful Jasper
lib:AddRecipe(52386, 73278, 52125) -- Lightning Jasper
lib:AddRecipe(52388, 73280, 52127) -- Zen Jasper
lib:AddRecipe(52362, 73335, 52206) -- Bold Inferno Ruby
lib:AddRecipe(52380, 73336, 52212) -- Delicate Inferno Ruby
lib:AddRecipe(52384, 73337, 52216) -- Flashing Inferno Ruby
lib:AddRecipe(52387, 73338, 52207) -- Brilliant Inferno Ruby
lib:AddRecipe(52389, 73339, 52230) -- Precise Inferno Ruby
lib:AddRecipe(52390, 73340, 52242) -- Solid Ocean Sapphire
lib:AddRecipe(52391, 73341, 52244) -- Sparkling Ocean Sapphire
lib:AddRecipe(52392, 73343, 52246) -- Stormy Ocean Sapphire
lib:AddRecipe(52393, 73344, 52235) -- Rigid Ocean Sapphire
lib:AddRecipe(52394, 73345, 52247) -- Subtle Amberjewel
lib:AddRecipe(52395, 73346, 52241) -- Smooth Amberjewel
lib:AddRecipe(52396, 73347, 52226) -- Mystic Amberjewel
lib:AddRecipe(52397, 73348, 52232) -- Quick Amberjewel
lib:AddRecipe(52398, 73349, 52219) -- Fractured Amberjewel
lib:AddRecipe(52399, 73350, 52243) -- Sovereign Demonseye
lib:AddRecipe(52400, 73351, 52238) -- Shifting Demonseye
lib:AddRecipe(52401, 73352, 52210) -- Defender's Demonseye
lib:AddRecipe(52402, 73353, 52248) -- Timeless Demonseye
lib:AddRecipe(52403, 73354, 52221) -- Guardian's Demonseye
lib:AddRecipe(52404, 73355, 52236) -- Purified Demonseye
lib:AddRecipe(52405, 73356, 52213) -- Etched Demonseye
lib:AddRecipe(52406, 73357, 52220) -- Glinting Demonseye
lib:AddRecipe(52407, 73358, 52234) -- Retaliating Demonseye
lib:AddRecipe(52408, 73359, 52217) -- Veiled Demonseye
lib:AddRecipe(52409, 73360, 52203) -- Accurate Demonseye
lib:AddRecipe(52410, 73361, 52229) -- Polished Ember Topaz
lib:AddRecipe(52411, 73362, 52249) -- Resolute Ember Topaz
lib:AddRecipe(52412, 73364, 52222) -- Inscribed Ember Topaz
lib:AddRecipe(52413, 73365, 52209) -- Deadly Ember Topaz
lib:AddRecipe(52414, 73366, 52239) -- Potent Ember Topaz
lib:AddRecipe(52415, 73367, 52214) -- Fierce Ember Topaz
lib:AddRecipe(52416, 73368, 52211) -- Deft Ember Topaz
lib:AddRecipe(52417, 73369, 52208) -- Reckless Ember Topaz
lib:AddRecipe(52418, 73370, 52240) -- Skillful Ember Topaz
lib:AddRecipe(52419, 73371, 52204) -- Adept Ember Topaz
lib:AddRecipe(52420, 73372, 52215) -- Fine Ember Topaz
lib:AddRecipe(52421, 73373, 52205) -- Artful Ember Topaz
lib:AddRecipe(52422, 73374, 52224) -- Keen Ember Topaz
lib:AddRecipe(52423, 73375, 52233) -- Regal Dream Emerald
lib:AddRecipe(52424, 73376, 52227) -- Nimble Dream Emerald
lib:AddRecipe(52425, 73377, 52223) -- Jagged Dream Emerald
lib:AddRecipe(52426, 73378, 52228) -- Piercing Dream Emerald
lib:AddRecipe(52427, 73379, 52245) -- Steady Dream Emerald
lib:AddRecipe(52428, 73380, 52218) -- Forceful Dream Emerald
lib:AddRecipe(52429, 73381, 52225) -- Lightning Dream Emerald
lib:AddRecipe(52430, 73382, 52231) -- Puissant Dream Emerald
lib:AddRecipe(52431, 73383, 52250) -- Zen Dream Emerald
lib:AddRecipe(52432, 73384, 52237) -- Sensei's Dream Emerald
lib:AddRecipe(52381, 73396, 52255) -- Bold Chimera's Eye
lib:AddRecipe(52447, 73397, 52258) -- Delicate Chimera's Eye
lib:AddRecipe(52448, 73398, 52259) -- Flashing Chimera's Eye
lib:AddRecipe(52449, 73399, 52257) -- Brilliant Chimera's Eye
lib:AddRecipe(52450, 73400, 52260) -- Precise Chimera's Eye
lib:AddRecipe(52451, 73401, 52261) -- Solid Chimera's Eye
lib:AddRecipe(52452, 73402, 52262) -- Sparkling Chimera's Eye
lib:AddRecipe(52453, 73403, 52263) -- Stormy Chimera's Eye
lib:AddRecipe(52454, 73404, 52264) -- Rigid Chimera's Eye
lib:AddRecipe(52455, 73405, 52265) -- Subtle Chimera's Eye
lib:AddRecipe(52456, 73406, 52266) -- Smooth Chimera's Eye
lib:AddRecipe(52457, 73407, 52267) -- Mystic Chimera's Eye
lib:AddRecipe(52458, 73408, 52268) -- Quick Chimera's Eye
lib:AddRecipe(52459, 73409, 52269) -- Fractured Chimera's Eye
lib:AddRecipe(52433, 73464, 52289) -- Fleet Shadowspirit Diamond
lib:AddRecipe(52434, 73465, 52291) -- Chaotic Shadowspirit Diamond
lib:AddRecipe(52435, 73466, 52292) -- Bracing Shadowspirit Diamond
lib:AddRecipe(52436, 73467, 52293) -- Eternal Shadowspirit Diamond
lib:AddRecipe(52437, 73468, 52294) -- Austere Shadowspirit Diamond
lib:AddRecipe(52438, 73469, 52295) -- Effulgent Shadowspirit Diamond
lib:AddRecipe(52439, 73470, 52296) -- Ember Shadowspirit Diamond
lib:AddRecipe(52440, 73471, 52297) -- Revitalizing Shadowspirit Diamond
lib:AddRecipe(52441, 73472, 52298) -- Destructive Shadowspirit Diamond
lib:AddRecipe(52442, 73473, 52299) -- Powerful Shadowspirit Diamond
lib:AddRecipe(52443, 73474, 52300) -- Enigmatic Shadowspirit Diamond
lib:AddRecipe(52444, 73475, 52301) -- Impassive Shadowspirit Diamond
lib:AddRecipe(52445, 73476, 52302) -- Forlorn Shadowspirit Diamond
lib:AddRecipe(52461, 73498, 52318) -- Band of Blades
lib:AddRecipe(52462, 73502, 52319) -- Ring of Warring Elements
lib:AddRecipe(52463, 73503, 52320) -- Elementium Moebius Band
lib:AddRecipe(52465, 73504, 52321) -- Entwined Elementium Choker
lib:AddRecipe(52466, 73505, 52322) -- Eye of Many Deaths
lib:AddRecipe(52467, 73506, 52323) -- Elementium Guardian
lib:AddRecipe(52460, 73520, 52348) -- Elementium Destroyer's Ring
lib:AddRecipe(52464, 73521, 52350) -- Brazen Elementium Medallion
lib:AddRecipe(71965, 73623, 52489) -- Rhinestone Sunglasses
lib:AddRecipe(52494, 73625, 52485) -- Jeweler's Ruby Monocle
lib:AddRecipe(52495, 73626, 52486) -- Jeweler's Sapphire Monocle
lib:AddRecipe(52496, 73627, 52487) -- Jeweler's Amber Monocle
lib:AddRecipe(68359, 95754, 68356) -- Willful Ember Topaz
lib:AddRecipe(68360, 95755, 68357) -- Lucent Ember Topaz
lib:AddRecipe(68361, 95756, 68358) -- Resplendent Ember Topaz
lib:AddRecipe(68742, 96226, 68741) -- Vivid Dream Emerald
lib:AddRecipe(68781, 96255, 68778) -- Agile Shadowspirit Diamond
lib:AddRecipe(68782, 96256, 68779) -- Reverberating Shadowspirit Diamond
lib:AddRecipe(68783, 96257, 68780) -- Burning Shadowspirit Diamond
lib:AddRecipe(69853, 98921, 69852) -- Punisher's Band
lib:AddRecipe(71821, 101735, 71817) -- Rigid Deepholm Iolite
lib:AddRecipe(71884, 101740, 71818) -- Stormy Deepholm Iolite
lib:AddRecipe(71885, 101741, 71819) -- Sparkling Deepholm Iolite
lib:AddRecipe(71886, 101742, 71820) -- Solid Deepholm Iolite
lib:AddRecipe(71887, 101743, 71822) -- Misty Elven Peridot
lib:AddRecipe(71888, 101744, 71823) -- Piercing Elven Peridot
lib:AddRecipe(71889, 101745, 71824) -- Lightning Elven Peridot
lib:AddRecipe(71890, 101746, 71825) -- Sensei's Elven Peridot
lib:AddRecipe(71891, 101747, 71826) -- Infused Elven Peridot
lib:AddRecipe(71892, 101748, 71827) -- Zen Elven Peridot
lib:AddRecipe(71893, 101749, 71828) -- Balanced Elven Peridot
lib:AddRecipe(71894, 101750, 71829) -- Vivid Elven Peridot
lib:AddRecipe(71895, 101751, 71830) -- Turbid Elven Peridot
lib:AddRecipe(71896, 101752, 71831) -- Radiant Elven Peridot
lib:AddRecipe(71897, 101753, 71832) -- Shattered Elven Peridot
lib:AddRecipe(71898, 101754, 71833) -- Energized Elven Peridot
lib:AddRecipe(71899, 101755, 71834) -- Jagged Elven Peridot
lib:AddRecipe(71900, 101756, 71835) -- Regal Elven Peridot
lib:AddRecipe(71901, 101757, 71836) -- Forceful Elven Peridot
lib:AddRecipe(71902, 101758, 71837) -- Nimble Elven Peridot
lib:AddRecipe(71903, 101759, 71838) -- Puissant Elven Peridot
lib:AddRecipe(71904, 101760, 71839) -- Steady Elven Peridot
lib:AddRecipe(71905, 101761, 71840) -- Deadly Lava Coral
lib:AddRecipe(71906, 101762, 71841) -- Crafty Lava Coral
lib:AddRecipe(71907, 101763, 71842) -- Potent Lava Coral
lib:AddRecipe(71908, 101764, 71843) -- Inscribed Lava Coral
lib:AddRecipe(71909, 101765, 71844) -- Polished Lava Coral
lib:AddRecipe(71910, 101766, 71845) -- Resolute Lava Coral
lib:AddRecipe(71911, 101767, 71846) -- Stalwart Lava Coral
lib:AddRecipe(71912, 101768, 71847) -- Champion's Lava Coral
lib:AddRecipe(71913, 101769, 71848) -- Deft Lava Coral
lib:AddRecipe(71914, 101770, 71849) -- Wicked Lava Coral
lib:AddRecipe(71915, 101771, 71850) -- Reckless Lava Coral
lib:AddRecipe(71916, 101772, 71851) -- Fierce Lava Coral
lib:AddRecipe(71917, 101773, 71852) -- Adept Lava Coral
lib:AddRecipe(71918, 101774, 71853) -- Keen Lava Coral
lib:AddRecipe(71919, 101775, 71854) -- Artful Lava Coral
lib:AddRecipe(71920, 101776, 71855) -- Fine Lava Coral
lib:AddRecipe(71921, 101777, 71856) -- Skillful Lava Coral
lib:AddRecipe(71922, 101778, 71857) -- Lucent Lava Coral
lib:AddRecipe(71923, 101779, 71858) -- Tenuous Lava Coral
lib:AddRecipe(71924, 101780, 71859) -- Willful Lava Coral
lib:AddRecipe(71925, 101781, 71860) -- Splendid Lava Coral
lib:AddRecipe(71926, 101782, 71861) -- Resplendent Lava Coral
lib:AddRecipe(71927, 101783, 71862) -- Glinting Shadow Spinel
lib:AddRecipe(71928, 101784, 71863) -- Accurate Shadow Spinel
lib:AddRecipe(71929, 101785, 71864) -- Veiled Shadow Spinel
lib:AddRecipe(71930, 101786, 71865) -- Retaliating Shadow Spinel
lib:AddRecipe(71931, 101787, 71866) -- Etched Shadow Spinel
lib:AddRecipe(71932, 101788, 71867) -- Mysterious Shadow Spinel
lib:AddRecipe(71933, 101789, 71868) -- Purified Shadow Spinel
lib:AddRecipe(71934, 101790, 71869) -- Shifting Shadow Spinel
lib:AddRecipe(71935, 101791, 71870) -- Guardian's Shadow Spinel
lib:AddRecipe(71936, 101792, 71871) -- Timeless Shadow Spinel
lib:AddRecipe(71937, 101793, 71872) -- Defender's Shadow Spinel
lib:AddRecipe(71938, 101794, 71873) -- Sovereign Shadow Spinel
lib:AddRecipe(71939, 101795, 71879) -- Delicate Queen's Garnet
lib:AddRecipe(71940, 101796, 71880) -- Precise Queen's Garnet
lib:AddRecipe(71941, 101797, 71881) -- Brilliant Queen's Garnet
lib:AddRecipe(71942, 101798, 71882) -- Flashing Queen's Garnet
lib:AddRecipe(71943, 101799, 71883) -- Bold Queen's Garnet
lib:AddRecipe(71944, 101800, 71874) -- Smooth Lightstone
lib:AddRecipe(71945, 101801, 71875) -- Subtle Lightstone
lib:AddRecipe(71946, 101802, 71876) -- Quick Lightstone
lib:AddRecipe(71947, 101803, 71877) -- Fractured Lightstone
lib:AddRecipe(71948, 101804, 71878) -- Mystic Lightstone
lib:AddRecipe(83811, 107753, 76884) -- Agile Primal Diamond
lib:AddRecipe(83815, 107754, 76895) -- Austere Primal Diamond
lib:AddRecipe(83825, 107756, 76885) -- Burning Primal Diamond
lib:AddRecipe(83840, 107757, 76890) -- Destructive Primal Diamond
lib:AddRecipe(83842, 107758, 76897) -- Effulgent Primal Diamond
lib:AddRecipe(83844, 107759, 76879) -- Ember Primal Diamond
lib:AddRecipe(83848, 107760, 76892) -- Enigmatic Primal Diamond
lib:AddRecipe(83851, 107762, 76896) -- Eternal Primal Diamond
lib:AddRecipe(83859, 107763, 76887) -- Fleet Primal Diamond
lib:AddRecipe(83862, 107764, 76894) -- Forlorn Primal Diamond
lib:AddRecipe(83872, 107765, 76893) -- Impassive Primal Diamond
lib:AddRecipe(83901, 107766, 76891) -- Powerful Primal Diamond
lib:AddRecipe(83925, 107767, 76886) -- Reverberating Primal Diamond
lib:AddRecipe(83926, 107768, 76888) -- Revitalizing Primal Diamond
lib:AddRecipe(83877, 120045, 82453) -- Jeweled Onyx Panther
lib:AddRecipe(83931, 121841, 83087) -- Ruby Panther
lib:AddRecipe(83932, 121842, 83090) -- Sapphire Panther
lib:AddRecipe(83830, 121843, 83089) -- Sunstone Panther
lib:AddRecipe(83845, 121844, 83088) -- Jade Panther
lib:AddRecipe(90470, 131897, 82774) -- Jade Owl
lib:AddRecipe(90471, 131898, 82775) -- Sapphire Cub
lib:AddRecipe(95470, 140050, 95469) -- Serpent's Heart
lib:AddRecipe(95471, 140060, 76132) -- Primal Diamond
lib:AddRecipe(116078, 170701, 115526) -- Taladite Recrystalizer
lib:AddRecipe(116079, 170702, 128013) -- Taladite Amplifier
lib:AddRecipe(116081, 170704, 115987) -- Glowing Iron Band
lib:AddRecipe(116082, 170705, 115988) -- Shifting Iron Band
lib:AddRecipe(116083, 170706, 115989) -- Whispering Iron Band
lib:AddRecipe(116084, 170707, 115990) -- Glowing Iron Choker
lib:AddRecipe(116085, 170708, 115991) -- Shifting Iron Choker
lib:AddRecipe(116086, 170709, 115992) -- Whispering Iron Choker
lib:AddRecipe(116087, 170710, 115993) -- Glowing Blackrock Band
lib:AddRecipe(116088, 170711, 115994) -- Shifting Blackrock Band
lib:AddRecipe(116089, 170712, 115995) -- Whispering Blackrock Band
lib:AddRecipe(116090, 170713, 115794) -- Glowing Taladite Ring
lib:AddRecipe(116091, 170714, 115796) -- Shifting Taladite Ring
lib:AddRecipe(116092, 170715, 115798) -- Whispering Taladite Ring
lib:AddRecipe(116093, 170716, 115799) -- Glowing Taladite Pendant
lib:AddRecipe(116094, 170717, 115800) -- Shifting Taladite Pendant
lib:AddRecipe(116095, 170718, 115801) -- Whispering Taladite Pendant
lib:AddRecipe(116096, 170719, 115803) -- Critical Strike Taladite
lib:AddRecipe(116097, 170720, 115804) -- Haste Taladite
lib:AddRecipe(116098, 170721, 115805) -- Mastery Taladite
lib:AddRecipe(116099, 170722, 115806) -- Multistrike Taladite
lib:AddRecipe(116100, 170723, 115807) -- Versatility Taladite
lib:AddRecipe(116101, 170724, 115808) -- Stamina Taladite
lib:AddRecipe(116102, 170725, 115809) -- Greater Critical Strike Taladite
lib:AddRecipe(116103, 170726, 115811) -- Greater Haste Taladite
lib:AddRecipe(116104, 170727, 115812) -- Greater Mastery Taladite
lib:AddRecipe(116105, 170728, 115813) -- Greater Multistrike Taladite
lib:AddRecipe(116106, 170729, 115814) -- Greater Versatility Taladite
lib:AddRecipe(116107, 170730, 115815) -- Greater Stamina Taladite
lib:AddRecipe(116108, 170731, 112384) -- Reflecting Prism
lib:AddRecipe(116109, 170732, 112498) -- Prismatic Focusing Lens
lib:AddRecipe(120131, 176087, 118723) -- Secrets of Draenor Jewelcrafting
lib:AddRecipe(122714, 182127, 115524) -- Primal Gemcutting
lib:AddRecipe(127726, 187493, 127716) -- Mighty Taladite Amplifier
lib:AddRecipe(127744, 187517, 127734) -- Savage Taladite Amplifier
-- Leatherworking
lib:AddRecipe(2406, 2158, 2307) -- Fine Leather Boots
lib:AddRecipe(2407, 2163, 2311) -- White Leather Jerkin
lib:AddRecipe(2408, 2164, 2312) -- Fine Leather Gloves
lib:AddRecipe(2409, 2169, 2317) -- Dark Leather Tunic
lib:AddRecipe(4293, 3762, 4244) -- Hillman's Leather Vest
lib:AddRecipe(7360, 3765, 4248) -- Dark Leather Gloves
lib:AddRecipe(4294, 3767, 4250) -- Hillman's Belt
lib:AddRecipe(4296, 3769, 4252) -- Dark Leather Shoulders
lib:AddRecipe(4297, 3771, 4254) -- Barbaric Gloves
lib:AddRecipe(7613, 3772, 4255) -- Green Leather Armor
lib:AddRecipe(4299, 3773, 4256) -- Guardian Armor
lib:AddRecipe(4298, 3775, 4258) -- Guardian Belt
lib:AddRecipe(4300, 3777, 4260) -- Guardian Leather Bracers
lib:AddRecipe(14635, 3778, 4262) -- Gem-studded Leather Belt
lib:AddRecipe(4301, 3779, 4264) -- Barbaric Belt
lib:AddRecipe(13287, 4096, 4455) -- Raptor Hide Harness
lib:AddRecipe(13288, 4097, 4456) -- Raptor Hide Belt
lib:AddRecipe(5083, 5244, 5081) -- Kodo Hide Bag
lib:AddRecipe(5786, 6702, 5780) -- Murloc Scale Belt
lib:AddRecipe(5787, 6703, 5781) -- Murloc Scale Breastplate
lib:AddRecipe(5788, 6704, 5782) -- Thick Murloc Armor
lib:AddRecipe(5789, 6705, 5783) -- Murloc Scale Bracers
lib:AddRecipe(5972, 7133, 5958) -- Fine Leather Pants
lib:AddRecipe(5973, 7149, 5963) -- Barbaric Leggings
lib:AddRecipe(5974, 7153, 5965) -- Guardian Cloak
lib:AddRecipe(6474, 7953, 6466) -- Deviate Scale Cloak
lib:AddRecipe(6475, 7954, 6467) -- Deviate Scale Gloves
lib:AddRecipe(6476, 7955, 6468) -- Deviate Scale Belt
lib:AddRecipe(6710, 8322, 6709) -- Moonglow Vest
lib:AddRecipe(7288, 9064, 7280) -- Rugged Leather Pants
lib:AddRecipe(7289, 9070, 7283) -- Black Whelp Cloak
lib:AddRecipe(7290, 9072, 7284) -- Red Whelp Gloves
lib:AddRecipe(7361, 9146, 7349) -- Herbalist's Gloves
lib:AddRecipe(7362, 9147, 7352) -- Earthen Leather Shoulders
lib:AddRecipe(7363, 9148, 7358) -- Pilferer's Gloves
lib:AddRecipe(7364, 9149, 7359) -- Heavy Earthen Gloves
lib:AddRecipe(7449, 9195, 7373) -- Dusky Leather Leggings
lib:AddRecipe(7450, 9197, 7375) -- Green Whelp Armor
lib:AddRecipe(7451, 9202, 7386) -- Green Whelp Bracers
lib:AddRecipe(7452, 9207, 7390) -- Dusky Boots
lib:AddRecipe(7453, 9208, 7391) -- Swift Boots
lib:AddRecipe(8384, 10490, 8174) -- Comfortable Leather Hat
lib:AddRecipe(8385, 10509, 8187) -- Turtle Scale Gloves
lib:AddRecipe(8409, 10516, 8192) -- Nightscape Shoulders
lib:AddRecipe(8386, 10520, 8200) -- Big Voodoo Robe
lib:AddRecipe(8395, 10525, 8203) -- Tough Scorpid Breastplate
lib:AddRecipe(72029, 10525, 8203) -- Tough Scorpid Breastplate
lib:AddRecipe(8403, 10529, 8210) -- Wild Leather Shoulders
lib:AddRecipe(8387, 10531, 8201) -- Big Voodoo Mask
lib:AddRecipe(8397, 10533, 8205) -- Tough Scorpid Bracers
lib:AddRecipe(72026, 10533, 8205) -- Tough Scorpid Bracers
lib:AddRecipe(8398, 10542, 8204) -- Tough Scorpid Gloves
lib:AddRecipe(72025, 10542, 8204) -- Tough Scorpid Gloves
lib:AddRecipe(8404, 10544, 8211) -- Wild Leather Vest
lib:AddRecipe(8405, 10546, 8214) -- Wild Leather Helmet
lib:AddRecipe(8388, 10550, 8195) -- Nightscape Cloak
lib:AddRecipe(8399, 10554, 8209) -- Tough Scorpid Boots
lib:AddRecipe(72028, 10554, 8209) -- Tough Scorpid Boots
lib:AddRecipe(8389, 10560, 8202) -- Big Voodoo Pants
lib:AddRecipe(8390, 10562, 8216) -- Big Voodoo Cloak
lib:AddRecipe(8400, 10564, 8207) -- Tough Scorpid Shoulders
lib:AddRecipe(72027, 10564, 8207) -- Tough Scorpid Shoulders
lib:AddRecipe(8406, 10566, 8213) -- Wild Leather Boots
lib:AddRecipe(8401, 10568, 8206) -- Tough Scorpid Leggings
lib:AddRecipe(72030, 10568, 8206) -- Tough Scorpid Leggings
lib:AddRecipe(8402, 10570, 8208) -- Tough Scorpid Helm
lib:AddRecipe(72033, 10570, 8208) -- Tough Scorpid Helm
lib:AddRecipe(8407, 10572, 8212) -- Wild Leather Leggings
lib:AddRecipe(8408, 10574, 8215) -- Wild Leather Cloak
lib:AddRecipe(15724, 19048, 15077) -- Heavy Scorpid Bracers
lib:AddRecipe(15725, 19049, 15083) -- Wicked Leather Gauntlets
lib:AddRecipe(78346, 19050, 15045) -- Green Dragonscale Breastplate
lib:AddRecipe(15727, 19051, 15076) -- Heavy Scorpid Vest
lib:AddRecipe(15728, 19052, 15084) -- Wicked Leather Bracers
lib:AddRecipe(15729, 19053, 15074) -- Chimeric Gloves
lib:AddRecipe(15730, 19054, 15047) -- Red Dragonscale Breastplate
lib:AddRecipe(15731, 19055, 15091) -- Runic Leather Gauntlets
lib:AddRecipe(15732, 19059, 15054) -- Volcanic Leggings
lib:AddRecipe(78345, 19060, 15046) -- Green Dragonscale Leggings
lib:AddRecipe(15734, 19061, 15061) -- Living Shoulders
lib:AddRecipe(15735, 19062, 15067) -- Ironfeather Shoulders
lib:AddRecipe(15737, 19063, 15073) -- Chimeric Boots
lib:AddRecipe(15738, 19064, 15078) -- Heavy Scorpid Gauntlets
lib:AddRecipe(15739, 19065, 15092) -- Runic Leather Bracers
lib:AddRecipe(15740, 19066, 15071) -- Frostsaber Boots
lib:AddRecipe(15741, 19067, 15057) -- Stormshroud Pants
lib:AddRecipe(15742, 19068, 15064) -- Warbear Harness
lib:AddRecipe(20253, 19068, 15064) -- Warbear Harness
lib:AddRecipe(15743, 19070, 15082) -- Heavy Scorpid Belt
lib:AddRecipe(15744, 19071, 15086) -- Wicked Leather Headband
lib:AddRecipe(15745, 19072, 15093) -- Runic Leather Belt
lib:AddRecipe(15746, 19073, 15072) -- Chimeric Leggings
lib:AddRecipe(15747, 19074, 15069) -- Frostsaber Leggings
lib:AddRecipe(15748, 19075, 15079) -- Heavy Scorpid Leggings
lib:AddRecipe(15749, 19076, 15053) -- Volcanic Breastplate
lib:AddRecipe(15751, 19077, 15048) -- Blue Dragonscale Breastplate
lib:AddRecipe(15752, 19078, 15060) -- Living Leggings
lib:AddRecipe(15753, 19079, 15056) -- Stormshroud Armor
lib:AddRecipe(15754, 19080, 15065) -- Warbear Woolies
lib:AddRecipe(20254, 19080, 15065) -- Warbear Woolies
lib:AddRecipe(15755, 19081, 15075) -- Chimeric Vest
lib:AddRecipe(15756, 19082, 15094) -- Runic Leather Headband
lib:AddRecipe(15757, 19083, 15087) -- Wicked Leather Pants
lib:AddRecipe(15758, 19084, 15063) -- Devilsaur Gauntlets
lib:AddRecipe(15759, 19085, 15050) -- Black Dragonscale Breastplate
lib:AddRecipe(15760, 19086, 15066) -- Ironfeather Breastplate
lib:AddRecipe(15761, 19087, 15070) -- Frostsaber Gloves
lib:AddRecipe(15762, 19088, 15080) -- Heavy Scorpid Helm
lib:AddRecipe(15763, 19089, 15049) -- Blue Dragonscale Shoulders
lib:AddRecipe(15764, 19090, 15058) -- Stormshroud Shoulders
lib:AddRecipe(15765, 19091, 15095) -- Runic Leather Pants
lib:AddRecipe(15768, 19092, 15088) -- Wicked Leather Belt
lib:AddRecipe(15769, 19093, 15138) -- Onyxia Scale Cloak
lib:AddRecipe(15770, 19094, 15051) -- Black Dragonscale Shoulders
lib:AddRecipe(15771, 19095, 15059) -- Living Breastplate
lib:AddRecipe(15772, 19097, 15062) -- Devilsaur Leggings
lib:AddRecipe(15773, 19098, 15085) -- Wicked Leather Armor
lib:AddRecipe(15774, 19100, 15081) -- Heavy Scorpid Shoulders
lib:AddRecipe(15775, 19101, 15055) -- Volcanic Shoulders
lib:AddRecipe(15776, 19102, 15090) -- Runic Leather Armor
lib:AddRecipe(15777, 19103, 15096) -- Runic Leather Shoulders
lib:AddRecipe(15779, 19104, 15068) -- Frostsaber Tunic
lib:AddRecipe(15780, 19106, 15141) -- Onyxia Scale Breastplate
lib:AddRecipe(15781, 19107, 15052) -- Black Dragonscale Leggings
lib:AddRecipe(17022, 20853, 16982) -- Corehound Boots
lib:AddRecipe(17023, 20854, 16983) -- Molten Helm
lib:AddRecipe(17025, 20855, 16984) -- Black Dragonscale Boots
lib:AddRecipe(17722, 21943, 17721) -- Gloves of the Greatfather
lib:AddRecipe(18239, 22711, 18238) -- Shadowskin Gloves
lib:AddRecipe(18252, 22727, 18251) -- Core Armor Kit
lib:AddRecipe(18514, 22921, 18504) -- Girdle of Insight
lib:AddRecipe(18515, 22922, 18506) -- Mongoose Boots
lib:AddRecipe(18516, 22923, 18508) -- Swift Flight Bracers
lib:AddRecipe(18517, 22926, 18509) -- Chromatic Cloak
lib:AddRecipe(18518, 22927, 18510) -- Hide of the Wild
lib:AddRecipe(18519, 22928, 18511) -- Shifting Cloak
lib:AddRecipe(18731, 23190, 18662) -- Heavy Leather Ball
lib:AddRecipe(18949, 23399, 18948) -- Barbaric Bracers
lib:AddRecipe(19326, 23703, 19044) -- Might of the Timbermaw
lib:AddRecipe(19327, 23704, 19049) -- Timbermaw Brawlers
lib:AddRecipe(19328, 23705, 19052) -- Dawn Treaders
lib:AddRecipe(19329, 23706, 19058) -- Golden Mantle of the Dawn
lib:AddRecipe(19330, 23707, 19149) -- Lava Belt
lib:AddRecipe(19331, 23708, 19157) -- Chromatic Gauntlets
lib:AddRecipe(19332, 23709, 19162) -- Corehound Belt
lib:AddRecipe(19333, 23710, 19163) -- Molten Belt
lib:AddRecipe(19769, 24121, 19685) -- Primal Batskin Jerkin
lib:AddRecipe(19770, 24122, 19686) -- Primal Batskin Gloves
lib:AddRecipe(19771, 24123, 19687) -- Primal Batskin Bracers
lib:AddRecipe(19772, 24124, 19688) -- Blood Tiger Breastplate
lib:AddRecipe(19773, 24125, 19689) -- Blood Tiger Shoulders
lib:AddRecipe(20382, 24703, 20380) -- Dreamscale Breastplate
lib:AddRecipe(20506, 24846, 20481) -- Spitfire Bracers
lib:AddRecipe(20507, 24847, 20480) -- Spitfire Gauntlets
lib:AddRecipe(20508, 24848, 20479) -- Spitfire Breastplate
lib:AddRecipe(20509, 24849, 20476) -- Sandstalker Bracers
lib:AddRecipe(20510, 24850, 20477) -- Sandstalker Gauntlets
lib:AddRecipe(20511, 24851, 20478) -- Sandstalker Breastplate
lib:AddRecipe(20576, 24940, 20575) -- Black Whelp Tunic
lib:AddRecipe(21548, 26279, 21278) -- Stormshroud Gloves
lib:AddRecipe(22692, 28219, 22661) -- Polar Tunic
lib:AddRecipe(22694, 28220, 22662) -- Polar Gloves
lib:AddRecipe(22695, 28221, 22663) -- Polar Bracers
lib:AddRecipe(22696, 28222, 22664) -- Icy Scale Breastplate
lib:AddRecipe(22697, 28223, 22666) -- Icy Scale Gauntlets
lib:AddRecipe(22698, 28224, 22665) -- Icy Scale Bracers
lib:AddRecipe(22771, 28472, 22759) -- Bramblewood Helm
lib:AddRecipe(22770, 28473, 22760) -- Bramblewood Boots
lib:AddRecipe(22769, 28474, 22761) -- Bramblewood Belt
lib:AddRecipe(25720, 32455, 23793) -- Heavy Knothide Leather
lib:AddRecipe(25721, 32457, 25651) -- Vindicator's Armor Kit
lib:AddRecipe(25722, 32458, 25652) -- Magister's Armor Kit
lib:AddRecipe(25725, 32461, 25653) -- Riding Crop
lib:AddRecipe(25726, 32482, 25679) -- Comfortable Insoles
lib:AddRecipe(25728, 32485, 25680) -- Stylin' Purple Hat
lib:AddRecipe(25729, 32487, 25681) -- Stylin' Adventure Hat
lib:AddRecipe(25731, 32488, 25683) -- Stylin' Crimson Hat
lib:AddRecipe(25730, 32489, 25682) -- Stylin' Jungle Hat
lib:AddRecipe(25732, 32490, 25685) -- Fel Leather Gloves
lib:AddRecipe(25733, 32493, 25686) -- Fel Leather Boots
lib:AddRecipe(25734, 32494, 25687) -- Fel Leather Leggings
lib:AddRecipe(25735, 32495, 25689) -- Heavy Clefthoof Vest
lib:AddRecipe(25736, 32496, 25690) -- Heavy Clefthoof Leggings
lib:AddRecipe(25737, 32497, 25691) -- Heavy Clefthoof Boots
lib:AddRecipe(25738, 32498, 25695) -- Felstalker Belt
lib:AddRecipe(29213, 32498, 25695) -- Felstalker Belt
lib:AddRecipe(25739, 32499, 25697) -- Felstalker Bracers
lib:AddRecipe(29214, 32499, 25697) -- Felstalker Bracers
lib:AddRecipe(25740, 32500, 25696) -- Felstalker Breastplate
lib:AddRecipe(29215, 32500, 25696) -- Felstalker Breastplate
lib:AddRecipe(25741, 32501, 25694) -- Netherfury Belt
lib:AddRecipe(29217, 32501, 25694) -- Netherfury Belt
lib:AddRecipe(25742, 32502, 25692) -- Netherfury Leggings
lib:AddRecipe(29219, 32502, 25692) -- Netherfury Leggings
lib:AddRecipe(25743, 32503, 25693) -- Netherfury Boots
lib:AddRecipe(29218, 32503, 25693) -- Netherfury Boots
lib:AddRecipe(29677, 35525, 29489) -- Enchanted Felscale Leggings
lib:AddRecipe(29682, 35526, 29490) -- Enchanted Felscale Gloves
lib:AddRecipe(29684, 35527, 29491) -- Enchanted Felscale Boots
lib:AddRecipe(29691, 35528, 29493) -- Flamescale Boots
lib:AddRecipe(29689, 35529, 29492) -- Flamescale Leggings
lib:AddRecipe(29664, 35530, 29540) -- Reinforced Mining Bag
lib:AddRecipe(30444, 35530, 29540) -- Reinforced Mining Bag
lib:AddRecipe(29693, 35531, 29494) -- Flamescale Belt
lib:AddRecipe(29698, 35532, 29495) -- Enchanted Clefthoof Leggings
lib:AddRecipe(29700, 35533, 29496) -- Enchanted Clefthoof Gloves
lib:AddRecipe(29701, 35534, 29497) -- Enchanted Clefthoof Boots
lib:AddRecipe(29702, 35535, 29498) -- Blastguard Pants
lib:AddRecipe(29703, 35536, 29499) -- Blastguard Boots
lib:AddRecipe(29704, 35537, 29500) -- Blastguard Belt
lib:AddRecipe(29713, 35538, 29532) -- Drums of Panic
lib:AddRecipe(29714, 35539, 29531) -- Drums of Restoration
lib:AddRecipe(34174, 35539, 29531) -- Drums of Restoration
lib:AddRecipe(34175, 35539, 29531) -- Drums of Restoration
lib:AddRecipe(29717, 35543, 29529) -- Drums of Battle
lib:AddRecipe(29718, 35544, 29530) -- Drums of Speed
lib:AddRecipe(34172, 35544, 29530) -- Drums of Speed
lib:AddRecipe(34173, 35544, 29530) -- Drums of Speed
lib:AddRecipe(29719, 35549, 29533) -- Cobrahide Leg Armor
lib:AddRecipe(31361, 35549, 29533) -- Cobrahide Leg Armor
lib:AddRecipe(29722, 35554, 29535) -- Nethercobra Leg Armor
lib:AddRecipe(31362, 35554, 29535) -- Nethercobra Leg Armor
lib:AddRecipe(29720, 35555, 29534) -- Clefthide Leg Armor
lib:AddRecipe(29721, 35557, 29536) -- Nethercleft Leg Armor
lib:AddRecipe(29723, 35558, 29502) -- Cobrascale Hood
lib:AddRecipe(29724, 35559, 29503) -- Cobrascale Gloves
lib:AddRecipe(35302, 35559, 29503) -- Cobrascale Gloves
lib:AddRecipe(29725, 35560, 29504) -- Windscale Hood
lib:AddRecipe(29726, 35561, 29505) -- Hood of Primal Life
lib:AddRecipe(29727, 35562, 29506) -- Gloves of the Living Touch
lib:AddRecipe(35303, 35562, 29506) -- Gloves of the Living Touch
lib:AddRecipe(29728, 35563, 29507) -- Windslayer Wraps
lib:AddRecipe(29729, 35564, 29508) -- Living Dragonscale Helm
lib:AddRecipe(29730, 35567, 29512) -- Earthen Netherscale Boots
lib:AddRecipe(29731, 35568, 29509) -- Windstrike Gloves
lib:AddRecipe(35300, 35568, 29509) -- Windstrike Gloves
lib:AddRecipe(29732, 35572, 29510) -- Netherdrake Helm
lib:AddRecipe(29733, 35573, 29511) -- Netherdrake Gloves
lib:AddRecipe(35301, 35573, 29511) -- Netherdrake Gloves
lib:AddRecipe(29734, 35574, 29514) -- Thick Netherscale Breastplate
lib:AddRecipe(30301, 36349, 30042) -- Belt of Natural Power
lib:AddRecipe(30302, 36351, 30040) -- Belt of Deep Shadow
lib:AddRecipe(30303, 36352, 30046) -- Belt of the Black Eagle
lib:AddRecipe(30304, 36353, 30044) -- Monsoon Belt
lib:AddRecipe(30305, 36355, 30041) -- Boots of Natural Grace
lib:AddRecipe(30306, 36357, 30039) -- Boots of Utter Darkness
lib:AddRecipe(30307, 36358, 30045) -- Boots of the Crimson Hawk
lib:AddRecipe(30308, 36359, 30043) -- Hurricane Boots
lib:AddRecipe(32429, 39997, 32398) -- Boots of Shackled Souls
lib:AddRecipe(32431, 40001, 32400) -- Greaves of Shackled Souls
lib:AddRecipe(32432, 40002, 32397) -- Waistguard of Shackled Souls
lib:AddRecipe(32433, 40003, 32394) -- Redeemed Soul Moccasins
lib:AddRecipe(32434, 40004, 32395) -- Redeemed Soul Wristguards
lib:AddRecipe(32435, 40005, 32396) -- Redeemed Soul Legguards
lib:AddRecipe(32436, 40006, 32393) -- Redeemed Soul Cinch
lib:AddRecipe(32744, 41156, 32582) -- Bracers of Renewed Life
lib:AddRecipe(32745, 41157, 32583) -- Shoulderpads of Renewed Life
lib:AddRecipe(32746, 41158, 32580) -- Swiftstrike Bracers
lib:AddRecipe(32747, 41160, 32581) -- Swiftstrike Shoulders
lib:AddRecipe(35528, 41160, 32581) -- Swiftstrike Shoulders
lib:AddRecipe(32748, 41161, 32574) -- Bindings of Lightning Reflexes
lib:AddRecipe(32749, 41162, 32575) -- Shoulders of Lightning Reflexes
lib:AddRecipe(32750, 41163, 32577) -- Living Earth Bindings
lib:AddRecipe(32751, 41164, 32579) -- Living Earth Shoulders
lib:AddRecipe(33124, 42546, 33122) -- Cloak of Darkness
lib:AddRecipe(33205, 42731, 33204) -- Shadowprowler's Chestguard
lib:AddRecipe(34262, 44953, 34086) -- Winter Boots
lib:AddRecipe(34491, 45117, 34490) -- Bag of Many Hides
lib:AddRecipe(35212, 46132, 34372) -- Leather Gauntlets of the Sun
lib:AddRecipe(35213, 46133, 34374) -- Fletcher's Gloves of the Phoenix
lib:AddRecipe(35214, 46134, 34370) -- Gloves of Immortal Dusk
lib:AddRecipe(35215, 46135, 34376) -- Sun-Drenched Scale Gloves
lib:AddRecipe(35216, 46136, 34371) -- Leather Chestguard of the Sun
lib:AddRecipe(35217, 46137, 34373) -- Embrace of the Phoenix
lib:AddRecipe(35218, 46138, 34369) -- Carapace of Sun and Shadow
lib:AddRecipe(35219, 46139, 34375) -- Sun-Drenched Scale Chestguard
lib:AddRecipe(44509, 50970, 38399) -- Trapper's Traveling Pack
lib:AddRecipe(44510, 50971, 38347) -- Mammoth Mining Bag
lib:AddRecipe(38598, 51569, 38591) -- Dark Arctic Leggings
lib:AddRecipe(38599, 51570, 38592) -- Dark Arctic Chestpiece
lib:AddRecipe(32430, 52733, 32399) -- Bracers of Shackled Souls
lib:AddRecipe(44513, 60697, 43260) -- Eviscerator's Facemask
lib:AddRecipe(44514, 60702, 43433) -- Eviscerator's Shoulderpads
lib:AddRecipe(44515, 60703, 43434) -- Eviscerator's Chestguard
lib:AddRecipe(44516, 60704, 43435) -- Eviscerator's Bindings
lib:AddRecipe(44517, 60705, 43436) -- Eviscerator's Gauntlets
lib:AddRecipe(44518, 60706, 43437) -- Eviscerator's Waistguard
lib:AddRecipe(44519, 60711, 43438) -- Eviscerator's Legguards
lib:AddRecipe(44520, 60712, 43439) -- Eviscerator's Treads
lib:AddRecipe(44521, 60715, 43261) -- Overcast Headguard
lib:AddRecipe(44522, 60716, 43262) -- Overcast Spaulders
lib:AddRecipe(44523, 60718, 43263) -- Overcast Chestguard
lib:AddRecipe(44524, 60720, 43264) -- Overcast Bracers
lib:AddRecipe(44525, 60721, 43265) -- Overcast Handwraps
lib:AddRecipe(44526, 60723, 43266) -- Overcast Belt
lib:AddRecipe(44527, 60725, 43271) -- Overcast Leggings
lib:AddRecipe(44528, 60727, 43273) -- Overcast Boots
lib:AddRecipe(44530, 60728, 43447) -- Swiftarrow Helm
lib:AddRecipe(44531, 60729, 43449) -- Swiftarrow Shoulderguards
lib:AddRecipe(44532, 60730, 43445) -- Swiftarrow Hauberk
lib:AddRecipe(44533, 60731, 43444) -- Swiftarrow Bracers
lib:AddRecipe(44534, 60732, 43446) -- Swiftarrow Gauntlets
lib:AddRecipe(44535, 60734, 43442) -- Swiftarrow Belt
lib:AddRecipe(44536, 60735, 43448) -- Swiftarrow Leggings
lib:AddRecipe(44537, 60737, 43443) -- Swiftarrow Boots
lib:AddRecipe(44538, 60743, 43455) -- Stormhide Crown
lib:AddRecipe(44539, 60746, 43457) -- Stormhide Shoulders
lib:AddRecipe(44540, 60747, 43453) -- Stormhide Hauberk
lib:AddRecipe(44541, 60748, 43452) -- Stormhide Wristguards
lib:AddRecipe(44542, 60749, 43454) -- Stormhide Grips
lib:AddRecipe(44543, 60750, 43450) -- Stormhide Belt
lib:AddRecipe(44544, 60751, 43456) -- Stormhide Legguards
lib:AddRecipe(44545, 60752, 43451) -- Stormhide Stompers
lib:AddRecipe(44546, 60754, 43458) -- Giantmaim Legguards
lib:AddRecipe(44547, 60755, 43459) -- Giantmaim Bracers
lib:AddRecipe(44548, 60756, 43461) -- Revenant's Breastplate
lib:AddRecipe(44549, 60757, 43469) -- Revenant's Treads
lib:AddRecipe(44550, 60758, 43481) -- Trollwoven Spaulders
lib:AddRecipe(44551, 60759, 43484) -- Trollwoven Girdle
lib:AddRecipe(44552, 60760, 43495) -- Earthgiving Legguards
lib:AddRecipe(44553, 60761, 43502) -- Earthgiving Boots
lib:AddRecipe(44584, 60996, 43590) -- Polar Vest
lib:AddRecipe(44585, 60997, 43591) -- Polar Cord
lib:AddRecipe(44586, 60998, 43592) -- Polar Boots
lib:AddRecipe(44587, 60999, 43593) -- Icy Scale Chestguard
lib:AddRecipe(44588, 61000, 43594) -- Icy Scale Belt
lib:AddRecipe(44589, 61002, 43595) -- Icy Scale Boots
lib:AddRecipe(44932, 62176, 44930) -- Windripper Boots
lib:AddRecipe(44933, 62177, 44931) -- Windripper Leggings
lib:AddRecipe(45094, 63194, 45553) -- Belt of Dragons
lib:AddRecipe(45095, 63195, 45562) -- Boots of Living Scale
lib:AddRecipe(45096, 63196, 45554) -- Blue Belt of Chaos
lib:AddRecipe(45097, 63197, 45563) -- Lightning Grounded Boots
lib:AddRecipe(45098, 63198, 45555) -- Death-warmed Belt
lib:AddRecipe(45099, 63199, 45564) -- Footpads of Silence
lib:AddRecipe(45100, 63200, 45556) -- Belt of Arctic Life
lib:AddRecipe(45101, 63201, 45565) -- Boots of Wintry Endurance
lib:AddRecipe(47628, 67080, 47597) -- Ensorcelled Nerubian Breastplate
lib:AddRecipe(47629, 67081, 47579) -- Black Chitin Bracers
lib:AddRecipe(47630, 67082, 47595) -- Crusader's Dragonscale Breastplate
lib:AddRecipe(47631, 67083, 47576) -- Crusader's Dragonscale Bracers
lib:AddRecipe(47632, 67084, 47602) -- Lunar Eclipse Robes
lib:AddRecipe(47633, 67085, 47583) -- Moonshadow Armguards
lib:AddRecipe(47634, 67086, 47599) -- Knightbane Carapace
lib:AddRecipe(47635, 67087, 47581) -- Bracers of Swift Death
lib:AddRecipe(47650, 67136, 47598) -- Ensorcelled Nerubian Breastplate
lib:AddRecipe(47646, 67137, 47580) -- Black Chitin Bracers
lib:AddRecipe(47649, 67138, 47596) -- Crusader's Dragonscale Breastplate
lib:AddRecipe(47647, 67139, 47582) -- Bracers of Swift Death
lib:AddRecipe(47652, 67140, 47601) -- Lunar Eclipse Robes
lib:AddRecipe(47653, 67141, 47584) -- Moonshadow Armguards
lib:AddRecipe(47651, 67142, 47600) -- Knightbane Carapace
lib:AddRecipe(47648, 67143, 47577) -- Crusader's Dragonscale Bracers
lib:AddRecipe(49957, 70554, 49898) -- Legwraps of Unleashed Nature
lib:AddRecipe(49958, 70555, 49894) -- Blessed Cenarion Boots
lib:AddRecipe(49959, 70556, 49899) -- Bladeborn Leggings
lib:AddRecipe(49961, 70557, 49895) -- Footpads of Impending Death
lib:AddRecipe(49962, 70558, 49900) -- Lightning-Infused Leggings
lib:AddRecipe(49963, 70559, 49896) -- Earthsoul Boots
lib:AddRecipe(49965, 70560, 49901) -- Draconic Bonesplinter Legguards
lib:AddRecipe(49966, 70561, 49897) -- Rock-Steady Treads
lib:AddRecipe(66995, 78380, 56480) -- Savage Cloak
lib:AddRecipe(66996, 78388, 56481) -- Tsunami Bracers
lib:AddRecipe(66997, 78396, 56482) -- Tsunami Belt
lib:AddRecipe(66999, 78398, 56483) -- Darkbrand Bracers
lib:AddRecipe(67000, 78399, 56484) -- Darkbrand Gloves
lib:AddRecipe(67005, 78405, 56489) -- Hardened Scale Cloak
lib:AddRecipe(67006, 78406, 56490) -- Tsunami Gloves
lib:AddRecipe(67007, 78407, 56491) -- Darkbrand Boots
lib:AddRecipe(67010, 78410, 56494) -- Tsunami Boots
lib:AddRecipe(67011, 78411, 56495) -- Darkbrand Shoulders
lib:AddRecipe(67014, 78415, 56498) -- Tsunami Shoulders
lib:AddRecipe(67015, 78416, 56499) -- Darkbrand Belt
lib:AddRecipe(67018, 78419, 56502) -- Scorched Leg Armor
lib:AddRecipe(67019, 78420, 56503) -- Twilight Leg Armor
lib:AddRecipe(67020, 78423, 56504) -- Tsunami Chestguard
lib:AddRecipe(67021, 78424, 56505) -- Darkbrand Helm
lib:AddRecipe(67025, 78427, 56508) -- Tsunami Leggings
lib:AddRecipe(67026, 78428, 56509) -- Darkbrand Chestguard
lib:AddRecipe(67031, 78432, 56512) -- Tsunami Helm
lib:AddRecipe(67033, 78433, 56513) -- Darkbrand Leggings
lib:AddRecipe(67036, 78436, 56516) -- Heavy Savage Leather
lib:AddRecipe(67038, 78437, 56517) -- Heavy Savage Armor Kit
lib:AddRecipe(67039, 78438, 56518) -- Cloak of Beasts
lib:AddRecipe(67041, 78439, 56519) -- Cloak of War
lib:AddRecipe(67042, 78444, 75106) -- Vicious Wyrmhide Bracers
lib:AddRecipe(67044, 78445, 75117) -- Vicious Wyrmhide Belt
lib:AddRecipe(67046, 78446, 75131) -- Vicious Leather Bracers
lib:AddRecipe(67048, 78447, 75104) -- Vicious Leather Gloves
lib:AddRecipe(67049, 78448, 75094) -- Vicious Charscale Bracers
lib:AddRecipe(67053, 78449, 75085) -- Vicious Charscale Gloves
lib:AddRecipe(67054, 78450, 75114) -- Vicious Dragonscale Bracers
lib:AddRecipe(67055, 78451, 75116) -- Vicious Dragonscale Shoulders
lib:AddRecipe(67056, 78452, 75109) -- Vicious Wyrmhide Gloves
lib:AddRecipe(67058, 78453, 75101) -- Vicious Wyrmhide Boots
lib:AddRecipe(67060, 78454, 75130) -- Vicious Leather Boots
lib:AddRecipe(67062, 78455, 75113) -- Vicious Leather Shoulders
lib:AddRecipe(67063, 78456, 75092) -- Vicious Charscale Boots
lib:AddRecipe(67064, 78457, 75083) -- Vicious Charscale Belt
lib:AddRecipe(67065, 78458, 75110) -- Vicious Dragonscale Boots
lib:AddRecipe(67066, 78459, 75081) -- Vicious Dragonscale Gloves
lib:AddRecipe(67068, 78460, 56536) -- Lightning Lash
lib:AddRecipe(67070, 78461, 56537) -- Belt of Nefarious Whispers
lib:AddRecipe(67072, 78462, 56538) -- Stormleather Sash
lib:AddRecipe(67073, 78463, 56539) -- Corded Viper Belt
lib:AddRecipe(67074, 78464, 75099) -- Vicious Wyrmhide Shoulders
lib:AddRecipe(67075, 78467, 75107) -- Vicious Wyrmhide Chest
lib:AddRecipe(67076, 78468, 75127) -- Vicious Leather Belt
lib:AddRecipe(67077, 78469, 75105) -- Vicious Leather Helm
lib:AddRecipe(67078, 78470, 75061) -- Vicious Charscale Shoulders
lib:AddRecipe(67079, 78471, 75097) -- Vicious Charscale Legs
lib:AddRecipe(67080, 78473, 75100) -- Vicious Dragonscale Belt
lib:AddRecipe(67081, 78474, 75102) -- Vicious Dragonscale Helm
lib:AddRecipe(67082, 78475, 56548) -- Razor-Edged Cloak
lib:AddRecipe(67083, 78476, 56549) -- Twilight Dragonscale Cloak
lib:AddRecipe(68193, 78477, 56550) -- Dragonscale Leg Armor
lib:AddRecipe(67084, 78478, 56551) -- Charscale Leg Armor
lib:AddRecipe(67085, 78479, 75080) -- Vicious Wyrmhide Legs
lib:AddRecipe(67086, 78480, 75111) -- Vicious Wyrmhide Helm
lib:AddRecipe(67087, 78481, 75103) -- Vicious Leather Chest
lib:AddRecipe(67089, 78482, 75112) -- Vicious Leather Legs
lib:AddRecipe(67090, 78483, 75084) -- Vicious Charscale Chest
lib:AddRecipe(67091, 78484, 75090) -- Vicious Charscale Helm
lib:AddRecipe(67092, 78485, 75108) -- Vicious Dragonscale Legs
lib:AddRecipe(67093, 78486, 75115) -- Vicious Dragonscale Chest
lib:AddRecipe(67094, 78487, 56561) -- Chestguard of Nature's Fury
lib:AddRecipe(67095, 78488, 56562) -- Assassin's Chestplate
lib:AddRecipe(67096, 78489, 56563) -- Twilight Scale Chestguard
lib:AddRecipe(67100, 78490, 56564) -- Dragonkiller Tunic
lib:AddRecipe(69960, 99443, 69939) -- Dragonfire Gloves
lib:AddRecipe(69961, 99445, 69941) -- Gloves of Unforgiving Flame
lib:AddRecipe(69962, 99446, 69942) -- Clutches of Evil
lib:AddRecipe(69963, 99447, 69943) -- Heavenly Gloves of the Moon
lib:AddRecipe(69971, 99455, 69949) -- Earthen Scale Sabatons
lib:AddRecipe(69972, 99456, 69950) -- Footwraps of Quenched Fire
lib:AddRecipe(69973, 99457, 69951) -- Treads of the Craft
lib:AddRecipe(69974, 99458, 69952) -- Ethereal Footfalls
lib:AddRecipe(70174, 100583, 70136) -- Royal Scribe's Satchel
lib:AddRecipe(70175, 100586, 70137) -- Triple-Reinforced Mining Bag
lib:AddRecipe(71721, 101599, 71720) -- Drakehide Leg Armor
lib:AddRecipe(71999, 101933, 71986) -- Leggings of Nature's Champion
lib:AddRecipe(72005, 101934, 71988) -- Deathscale Leggings
lib:AddRecipe(72006, 101935, 71985) -- Bladeshadow Leggings
lib:AddRecipe(72007, 101936, 71987) -- Rended Earth Leggings
lib:AddRecipe(72008, 101937, 71995) -- Bracers of Flowing Serenity
lib:AddRecipe(72009, 101939, 71997) -- Thundering Deathscale Wristguards
lib:AddRecipe(72010, 101940, 71994) -- Bladeshadow Wristguards
lib:AddRecipe(72011, 101941, 71996) -- Bracers of the Hunter-Killer
lib:AddRecipe(86235, 124127, 83765) -- Angerhide Leg Armor
lib:AddRecipe(86276, 124128, 83763) -- Ironscale Leg Armor
lib:AddRecipe(86295, 124129, 83764) -- Shadowleather Leg Armor
lib:AddRecipe(86269, 124587, 85818) -- Contender's Wyrmhide Helm
lib:AddRecipe(86271, 124588, 85820) -- Contender's Wyrmhide Shoulders
lib:AddRecipe(86267, 124589, 85816) -- Contender's Wyrmhide Chestguard
lib:AddRecipe(86268, 124590, 85817) -- Contender's Wyrmhide Gloves
lib:AddRecipe(86270, 124591, 85819) -- Contender's Wyrmhide Leggings
lib:AddRecipe(86266, 124592, 85815) -- Contender's Wyrmhide Bracers
lib:AddRecipe(86265, 124593, 85814) -- Contender's Wyrmhide Boots
lib:AddRecipe(86264, 124594, 85813) -- Contender's Wyrmhide Belt
lib:AddRecipe(86261, 124595, 85810) -- Contender's Scale Helm
lib:AddRecipe(86263, 124596, 85812) -- Contender's Scale Shoulders
lib:AddRecipe(86259, 124597, 85808) -- Contender's Scale Chestguard
lib:AddRecipe(86260, 124598, 85809) -- Contender's Scale Gloves
lib:AddRecipe(86262, 124599, 85811) -- Contender's Scale Leggings
lib:AddRecipe(86258, 124600, 85807) -- Contender's Scale Bracers
lib:AddRecipe(86257, 124601, 85806) -- Contender's Scale Boots
lib:AddRecipe(86256, 124602, 85805) -- Contender's Scale Belt
lib:AddRecipe(86253, 124603, 85802) -- Contender's Leather Helm
lib:AddRecipe(86255, 124604, 85804) -- Contender's Leather Shoulders
lib:AddRecipe(86251, 124605, 85800) -- Contender's Leather Chestguard
lib:AddRecipe(86252, 124606, 85801) -- Contender's Leather Gloves
lib:AddRecipe(86254, 124607, 85803) -- Contender's Leather Leggings
lib:AddRecipe(86250, 124608, 85799) -- Contender's Leather Bracers
lib:AddRecipe(86249, 124609, 85798) -- Contender's Leather Boots
lib:AddRecipe(86248, 124610, 85797) -- Contender's Leather Belt
lib:AddRecipe(86245, 124611, 85794) -- Contender's Dragonscale Helm
lib:AddRecipe(86247, 124612, 85796) -- Contender's Dragonscale Shoulders
lib:AddRecipe(86243, 124613, 85792) -- Contender's Dragonscale Chestguard
lib:AddRecipe(86244, 124614, 85793) -- Contender's Dragonscale Gloves
lib:AddRecipe(86246, 124615, 85795) -- Contender's Dragonscale Leggings
lib:AddRecipe(86242, 124616, 85791) -- Contender's Dragonscale Bracers
lib:AddRecipe(86241, 124617, 85790) -- Contender's Dragonscale Boots
lib:AddRecipe(86240, 124618, 85789) -- Contender's Dragonscale Belt
lib:AddRecipe(86274, 124619, 85823) -- Greyshadow Chestguard
lib:AddRecipe(86275, 124620, 85824) -- Greyshadow Gloves
lib:AddRecipe(86309, 124621, 85850) -- Wildblood Vest
lib:AddRecipe(86308, 124622, 85849) -- Wildblood Gloves
lib:AddRecipe(86278, 124623, 85826) -- Lifekeeper's Robe
lib:AddRecipe(86277, 124624, 85825) -- Lifekeeper's Gloves
lib:AddRecipe(86237, 124625, 85787) -- Chestguard of Earthen Harmony
lib:AddRecipe(86273, 124626, 85822) -- Gloves of Earthen Harmony
lib:AddRecipe(86238, 124638, 85788) -- Chestguard of Nemeses
lib:AddRecipe(86280, 124639, 85828) -- Murderer's Gloves
lib:AddRecipe(86281, 124640, 85829) -- Nightfire Robe
lib:AddRecipe(86279, 124641, 85827) -- Liferuned Leather Gloves
lib:AddRecipe(86297, 124642, 85840) -- Stormbreaker Chestguard
lib:AddRecipe(86272, 124643, 85821) -- Fists of Lightning
lib:AddRecipe(86283, 124644, 85830) -- Raiment of Blood and Bone
lib:AddRecipe(86284, 124645, 85831) -- Raven Lord's Gloves
lib:AddRecipe(95467, 140040, 72163) -- Magnificence of Leather
lib:AddRecipe(95468, 140041, 72163) -- Magnificence of Scales
lib:AddRecipe(102513, 146613, 102351) -- Drums of Rage
lib:AddRecipe(116319, 171260, 116164) -- Journeying Helm
lib:AddRecipe(116320, 171261, 116165) -- Journeying Robes
lib:AddRecipe(116321, 171262, 116166) -- Journeying Slacks
lib:AddRecipe(116322, 171263, 116167) -- Traveling Helm
lib:AddRecipe(116323, 171264, 116168) -- Traveling Tunic
lib:AddRecipe(116324, 171265, 116169) -- Traveling Leggings
lib:AddRecipe(116325, 171266, 116170) -- Leather Refurbishing Kit
lib:AddRecipe(116326, 171267, 116171) -- Powerful Burnished Cloak
lib:AddRecipe(116327, 171268, 116174) -- Nimble Burnished Cloak
lib:AddRecipe(116328, 171269, 116175) -- Brilliant Burnished Cloak
lib:AddRecipe(116329, 171270, 116176) -- Supple Shoulderguards
lib:AddRecipe(116330, 171271, 116177) -- Supple Helm
lib:AddRecipe(116331, 171272, 116178) -- Supple Leggings
lib:AddRecipe(116332, 171273, 116179) -- Supple Gloves
lib:AddRecipe(116333, 171274, 116180) -- Supple Vest
lib:AddRecipe(116334, 171275, 116181) -- Supple Bracers
lib:AddRecipe(116335, 171276, 116182) -- Supple Boots
lib:AddRecipe(116336, 171277, 116183) -- Supple Waistguard
lib:AddRecipe(116337, 171278, 116187) -- Wayfaring Shoulderguards
lib:AddRecipe(116338, 171279, 116188) -- Wayfaring Helm
lib:AddRecipe(116339, 171280, 116189) -- Wayfaring Leggings
lib:AddRecipe(116340, 171281, 116190) -- Wayfaring Gloves
lib:AddRecipe(116341, 171282, 116191) -- Wayfaring Tunic
lib:AddRecipe(116342, 171283, 116192) -- Wayfaring Bracers
lib:AddRecipe(116343, 171284, 116193) -- Wayfaring Boots
lib:AddRecipe(116344, 171285, 116194) -- Wayfaring Belt
lib:AddRecipe(116345, 171286, 128014) -- Burnished Essence
lib:AddRecipe(116347, 171288, 116259) -- Burnished Leather Bag
lib:AddRecipe(116348, 171289, 116260) -- Burnished Mining Bag
lib:AddRecipe(116349, 171290, 116261) -- Burnished Inscription Bag
lib:AddRecipe(116350, 171291, 108883) -- Riding Harness
lib:AddRecipe(118097, 173416, 118049) -- Small Football
lib:AddRecipe(120130, 176089, 118721) -- Secrets of Draenor Leatherworking
lib:AddRecipe(120258, 178208, 120257) -- Drums of Fury
lib:AddRecipe(122715, 182121, 110611) -- Spiritual Leathercraft
lib:AddRecipe(127722, 187489, 127712) -- Mighty Burnished Essence
lib:AddRecipe(127740, 187513, 127730) -- Savage Burnished Essence
-- Mining
lib:AddRecipe(44956, 22967, 17771) -- Smelt Enchanted Elementium
lib:AddRecipe(35273, 46353, 35128) -- Smelt Hardened Khorium
-- Tailoring
lib:AddRecipe(2598, 2389, 2572) -- Red Linen Robe
lib:AddRecipe(2601, 2403, 2585) -- Gray Woolen Robe
lib:AddRecipe(4292, 3758, 4241) -- Green Woolen Bag
lib:AddRecipe(4346, 3844, 4311) -- Heavy Woolen Cloak
lib:AddRecipe(4345, 3847, 4313) -- Red Woolen Boots
lib:AddRecipe(4347, 3849, 4315) -- Reinforced Woolen Shoulders
lib:AddRecipe(4349, 3851, 4317) -- Phoenix Pants
lib:AddRecipe(7114, 3854, 4319) -- Azure Silk Gloves
lib:AddRecipe(4350, 3856, 4321) -- Spider Silk Slippers
lib:AddRecipe(14630, 3857, 4322) -- Enchanter's Cowl
lib:AddRecipe(4351, 3858, 4323) -- Shadow Hood
lib:AddRecipe(4352, 3860, 4325) -- Boots of the Enchanter
lib:AddRecipe(4355, 3862, 4327) -- Icy Cloak
lib:AddRecipe(4353, 3863, 4328) -- Spider Belt
lib:AddRecipe(4356, 3864, 4329) -- Star Belt
lib:AddRecipe(4348, 3868, 4331) -- Phoenix Gloves
lib:AddRecipe(14627, 3869, 4332) -- Bright Yellow Shirt
lib:AddRecipe(6401, 3870, 4333) -- Dark Silk Shirt
lib:AddRecipe(4354, 3872, 4335) -- Rich Purple Silk Shirt
lib:AddRecipe(10728, 3873, 4336) -- Black Swashbuckler's Shirt
lib:AddRecipe(5771, 6686, 5762) -- Red Linen Bag
lib:AddRecipe(5772, 6688, 5763) -- Red Woolen Bag
lib:AddRecipe(5773, 6692, 5770) -- Robes of Arcana
lib:AddRecipe(5774, 6693, 5764) -- Green Silk Pack
lib:AddRecipe(5775, 6695, 5765) -- Black Silk Pack
lib:AddRecipe(6271, 7629, 6239) -- Red Linen Vest
lib:AddRecipe(6270, 7630, 6240) -- Blue Linen Vest
lib:AddRecipe(6272, 7633, 6242) -- Blue Linen Robe
lib:AddRecipe(6273, 7636, 6243) -- Green Woolen Robe
lib:AddRecipe(6274, 7639, 6263) -- Blue Overalls
lib:AddRecipe(6275, 7643, 6264) -- Greater Adept's Robe
lib:AddRecipe(6390, 7892, 6384) -- Stylish Blue Shirt
lib:AddRecipe(6391, 7893, 6385) -- Stylish Green Shirt
lib:AddRecipe(7093, 8778, 7027) -- Boots of Darkness
lib:AddRecipe(7092, 8780, 7047) -- Hands of Darkness
lib:AddRecipe(7091, 8782, 7049) -- Truefaith Gloves
lib:AddRecipe(7090, 8784, 7065) -- Green Silk Armor
lib:AddRecipe(7089, 8786, 7053) -- Azure Silk Cloak
lib:AddRecipe(7087, 8789, 7056) -- Crimson Silk Cloak
lib:AddRecipe(7084, 8793, 7059) -- Crimson Silk Shoulders
lib:AddRecipe(7085, 8795, 7060) -- Azure Shoulders
lib:AddRecipe(7086, 8797, 7061) -- Earthen Silk Belt
lib:AddRecipe(7088, 8802, 7063) -- Crimson Silk Robe
lib:AddRecipe(10316, 12047, 10048) -- Colorful Kilt
lib:AddRecipe(10300, 12056, 10007) -- Red Mageweave Vest
lib:AddRecipe(10301, 12059, 10008) -- White Bandit Mask
lib:AddRecipe(10302, 12060, 10009) -- Red Mageweave Pants
lib:AddRecipe(10303, 12062, 10010) -- Stormcloth Pants
lib:AddRecipe(10304, 12063, 10011) -- Stormcloth Gloves
lib:AddRecipe(10311, 12064, 10052) -- Orange Martial Shirt
lib:AddRecipe(10312, 12066, 10018) -- Red Mageweave Gloves
lib:AddRecipe(10313, 12068, 10020) -- Stormcloth Vest
lib:AddRecipe(10314, 12075, 10054) -- Lavender Mageweave Shirt
lib:AddRecipe(10315, 12078, 10029) -- Red Mageweave Shoulders
lib:AddRecipe(10317, 12080, 10055) -- Pink Mageweave Shirt
lib:AddRecipe(10318, 12081, 10030) -- Admiral's Hat
lib:AddRecipe(10319, 12083, 10032) -- Stormcloth Headband
lib:AddRecipe(10320, 12084, 10033) -- Red Mageweave Headband
lib:AddRecipe(10321, 12085, 10034) -- Tuxedo Shirt
lib:AddRecipe(10463, 12086, 10025) -- Shadoweave Mask
lib:AddRecipe(10322, 12087, 10038) -- Stormcloth Shoulders
lib:AddRecipe(10323, 12089, 10035) -- Tuxedo Pants
lib:AddRecipe(10324, 12090, 10039) -- Stormcloth Boots
lib:AddRecipe(10325, 12091, 10040) -- White Wedding Dress
lib:AddRecipe(10326, 12093, 10036) -- Tuxedo Jacket
lib:AddRecipe(14466, 18403, 13869) -- Frostweave Tunic
lib:AddRecipe(14467, 18404, 13868) -- Frostweave Robe
lib:AddRecipe(14468, 18405, 14046) -- Runecloth Bag
lib:AddRecipe(14470, 18407, 13857) -- Runecloth Tunic
lib:AddRecipe(14471, 18408, 14042) -- Cindercloth Vest
lib:AddRecipe(14474, 18411, 13870) -- Frostweave Gloves
lib:AddRecipe(14476, 18412, 14043) -- Cindercloth Gloves
lib:AddRecipe(14482, 18418, 14044) -- Cindercloth Cloak
lib:AddRecipe(14483, 18419, 14107) -- Felcloth Pants
lib:AddRecipe(14486, 18422, 14134) -- Cloak of Fire
lib:AddRecipe(14488, 18423, 13864) -- Runecloth Boots
lib:AddRecipe(14489, 18424, 13871) -- Frostweave Pants
lib:AddRecipe(14490, 18434, 14045) -- Cindercloth Pants
lib:AddRecipe(14493, 18436, 14136) -- Robe of Winter Night
lib:AddRecipe(14492, 18437, 14108) -- Felcloth Boots
lib:AddRecipe(14494, 18439, 14104) -- Brightcloth Pants
lib:AddRecipe(14497, 18440, 14137) -- Mooncloth Leggings
lib:AddRecipe(14496, 18442, 14111) -- Felcloth Hood
lib:AddRecipe(14499, 18445, 14155) -- Mooncloth Bag
lib:AddRecipe(14501, 18447, 14138) -- Mooncloth Vest
lib:AddRecipe(14507, 18448, 14139) -- Mooncloth Shoulders
lib:AddRecipe(14506, 18451, 14106) -- Felcloth Robe
lib:AddRecipe(14509, 18452, 14140) -- Mooncloth Circlet
lib:AddRecipe(14508, 18453, 14112) -- Felcloth Shoulders
lib:AddRecipe(14511, 18454, 14146) -- Gloves of Spell Mastery
lib:AddRecipe(14510, 18455, 14156) -- Bottomless Bag
lib:AddRecipe(14512, 18456, 14154) -- Truefaith Vestments
lib:AddRecipe(29120, 18456, 14154) -- Truefaith Vestments
lib:AddRecipe(14513, 18457, 14152) -- Robe of the Archmage
lib:AddRecipe(14514, 18458, 14153) -- Robe of the Void
lib:AddRecipe(14526, 18560, 14342) -- Mooncloth
lib:AddRecipe(17017, 20848, 16980) -- Flarecore Mantle
lib:AddRecipe(17018, 20849, 16979) -- Flarecore Gloves
lib:AddRecipe(17724, 21945, 17723) -- Green Holiday Shirt
lib:AddRecipe(18265, 22759, 18263) -- Flarecore Wraps
lib:AddRecipe(18414, 22866, 18405) -- Belt of the Archmage
lib:AddRecipe(18415, 22867, 18407) -- Felcloth Gloves
lib:AddRecipe(18416, 22868, 18408) -- Inferno Gloves
lib:AddRecipe(18417, 22869, 18409) -- Mooncloth Gloves
lib:AddRecipe(18418, 22870, 18413) -- Cloak of Warding
lib:AddRecipe(18487, 22902, 18486) -- Mooncloth Robe
lib:AddRecipe(19215, 23662, 19047) -- Wisdom of the Timbermaw
lib:AddRecipe(19218, 23663, 19050) -- Mantle of the Timbermaw
lib:AddRecipe(19216, 23664, 19056) -- Argent Boots
lib:AddRecipe(19217, 23665, 19059) -- Argent Shoulders
lib:AddRecipe(19219, 23666, 19156) -- Flarecore Robe
lib:AddRecipe(19220, 23667, 19165) -- Flarecore Leggings
lib:AddRecipe(19764, 24091, 19682) -- Bloodvine Vest
lib:AddRecipe(19765, 24092, 19683) -- Bloodvine Leggings
lib:AddRecipe(19766, 24093, 19684) -- Bloodvine Boots
lib:AddRecipe(20546, 24901, 20538) -- Runed Stygian Leggings
lib:AddRecipe(20548, 24902, 20539) -- Runed Stygian Belt
lib:AddRecipe(20547, 24903, 20537) -- Runed Stygian Boots
lib:AddRecipe(21358, 26085, 21340) -- Soul Pouch
lib:AddRecipe(21369, 26086, 21341) -- Felcloth Bag
lib:AddRecipe(21371, 26087, 21342) -- Core Felcloth Bag
lib:AddRecipe(21722, 26403, 21154) -- Festival Dress
lib:AddRecipe(44916, 26403, 21154) -- Festival Dress
lib:AddRecipe(21723, 26407, 21542) -- Festival Suit
lib:AddRecipe(44917, 26407, 21542) -- Festival Suit
lib:AddRecipe(21892, 26747, 21842) -- Bolt of Imbued Netherweave
lib:AddRecipe(21893, 26749, 21843) -- Imbued Netherweave Bag
lib:AddRecipe(21894, 26750, 21844) -- Bolt of Soulcloth
lib:AddRecipe(21895, 26751, 21845) -- Primal Mooncloth
lib:AddRecipe(21908, 26752, 21846) -- Spellfire Belt
lib:AddRecipe(21909, 26753, 21847) -- Spellfire Gloves
lib:AddRecipe(21910, 26754, 21848) -- Spellfire Robe
lib:AddRecipe(21911, 26755, 21858) -- Spellfire Bag
lib:AddRecipe(21912, 26756, 21869) -- Frozen Shadoweave Shoulders
lib:AddRecipe(21914, 26757, 21870) -- Frozen Shadoweave Boots
lib:AddRecipe(21913, 26758, 21871) -- Frozen Shadoweave Robe
lib:AddRecipe(21915, 26759, 21872) -- Ebon Shadowbag
lib:AddRecipe(21916, 26760, 21873) -- Primal Mooncloth Belt
lib:AddRecipe(21918, 26761, 21874) -- Primal Mooncloth Shoulders
lib:AddRecipe(21917, 26762, 21875) -- Primal Mooncloth Robe
lib:AddRecipe(21919, 26763, 21876) -- Primal Mooncloth Bag
lib:AddRecipe(21896, 26773, 21854) -- Netherweave Robe
lib:AddRecipe(21897, 26774, 21855) -- Netherweave Tunic
lib:AddRecipe(21898, 26775, 21859) -- Imbued Netherweave Pants
lib:AddRecipe(21899, 26776, 21860) -- Imbued Netherweave Boots
lib:AddRecipe(21900, 26777, 21861) -- Imbued Netherweave Robe
lib:AddRecipe(21901, 26778, 21862) -- Imbued Netherweave Tunic
lib:AddRecipe(21902, 26779, 21863) -- Soulcloth Gloves
lib:AddRecipe(21903, 26780, 21864) -- Soulcloth Shoulders
lib:AddRecipe(21904, 26781, 21865) -- Soulcloth Vest
lib:AddRecipe(21905, 26782, 21866) -- Arcanoweave Bracers
lib:AddRecipe(21906, 26783, 21867) -- Arcanoweave Boots
lib:AddRecipe(21907, 26784, 21868) -- Arcanoweave Robe
lib:AddRecipe(22307, 27658, 22246) -- Enchanted Mageweave Pouch
lib:AddRecipe(22308, 27659, 22248) -- Enchanted Runecloth Bag
lib:AddRecipe(22309, 27660, 22249) -- Big Bag of Enchantment
lib:AddRecipe(22310, 27724, 22251) -- Cenarion Herb Bag
lib:AddRecipe(22312, 27725, 22252) -- Satchel of Cenarius
lib:AddRecipe(22684, 28205, 22654) -- Glacial Gloves
lib:AddRecipe(22686, 28207, 22652) -- Glacial Vest
lib:AddRecipe(22685, 28208, 22658) -- Glacial Cloak
lib:AddRecipe(22687, 28209, 22655) -- Glacial Wrists
lib:AddRecipe(22683, 28210, 22660) -- Gaea's Embrace
lib:AddRecipe(22774, 28480, 22756) -- Sylvan Vest
lib:AddRecipe(22773, 28481, 22757) -- Sylvan Crown
lib:AddRecipe(22772, 28482, 22758) -- Sylvan Shoulders
lib:AddRecipe(24316, 31373, 24271) -- Spellcloth
lib:AddRecipe(24292, 31430, 24273) -- Mystic Spellthread
lib:AddRecipe(24293, 31431, 24275) -- Silver Spellthread
lib:AddRecipe(24294, 31432, 24274) -- Runic Spellthread
lib:AddRecipe(24295, 31433, 24276) -- Golden Spellthread
lib:AddRecipe(24296, 31434, 24249) -- Unyielding Bracers
lib:AddRecipe(35308, 31434, 24249) -- Unyielding Bracers
lib:AddRecipe(24297, 31435, 24250) -- Bracers of Havok
lib:AddRecipe(24298, 31437, 24251) -- Blackstrike Bracers
lib:AddRecipe(24299, 31438, 24252) -- Cloak of the Black Void
lib:AddRecipe(24300, 31440, 24253) -- Cloak of Eternity
lib:AddRecipe(24301, 31441, 24254) -- White Remedy Cape
lib:AddRecipe(24302, 31442, 24255) -- Unyielding Girdle
lib:AddRecipe(35309, 31442, 24255) -- Unyielding Girdle
lib:AddRecipe(24303, 31443, 24256) -- Girdle of Ruination
lib:AddRecipe(24304, 31444, 24257) -- Black Belt of Knowledge
lib:AddRecipe(24305, 31448, 24258) -- Resolute Cape
lib:AddRecipe(24306, 31449, 24259) -- Vengeance Wrap
lib:AddRecipe(24307, 31450, 24260) -- Manaweave Cloak
lib:AddRecipe(24308, 31451, 24261) -- Whitemend Pants
lib:AddRecipe(24309, 31452, 24262) -- Spellstrike Pants
lib:AddRecipe(24310, 31453, 24263) -- Battlecast Pants
lib:AddRecipe(24311, 31454, 24264) -- Whitemend Hood
lib:AddRecipe(24312, 31455, 24266) -- Spellstrike Hood
lib:AddRecipe(24313, 31456, 24267) -- Battlecast Hood
lib:AddRecipe(24314, 31459, 24270) -- Bag of Jewels
lib:AddRecipe(24315, 31461, 24269) -- Heavy Netherweave Net
lib:AddRecipe(30280, 36315, 30038) -- Belt of Blasting
lib:AddRecipe(30281, 36316, 30036) -- Belt of the Long Road
lib:AddRecipe(30282, 36317, 30037) -- Boots of Blasting
lib:AddRecipe(30283, 36318, 30035) -- Boots of the Long Road
lib:AddRecipe(30483, 36686, 24272) -- Shadowcloth
lib:AddRecipe(30833, 37873, 30831) -- Cloak of Arcane Evasion
lib:AddRecipe(30842, 37882, 30837) -- Flameheart Bracers
lib:AddRecipe(30843, 37883, 30838) -- Flameheart Gloves
lib:AddRecipe(30844, 37884, 30839) -- Flameheart Vest
lib:AddRecipe(32437, 40020, 32391) -- Soulguard Slippers
lib:AddRecipe(32438, 40021, 32392) -- Soulguard Bracers
lib:AddRecipe(32439, 40023, 32389) -- Soulguard Leggings
lib:AddRecipe(32440, 40024, 32390) -- Soulguard Girdle
lib:AddRecipe(32447, 40060, 32420) -- Night's End
lib:AddRecipe(32754, 41205, 32586) -- Bracers of Nimble Thought
lib:AddRecipe(32755, 41206, 32587) -- Mantle of Nimble Thought
lib:AddRecipe(32752, 41207, 32584) -- Swiftheal Wraps
lib:AddRecipe(32753, 41208, 32585) -- Swiftheal Mantle
lib:AddRecipe(34261, 44950, 34087) -- Green Winter Clothes
lib:AddRecipe(34319, 44958, 34085) -- Red Winter Clothes
lib:AddRecipe(35204, 46128, 34366) -- Sunfire Handwraps
lib:AddRecipe(35205, 46129, 34367) -- Hands of Eternal Light
lib:AddRecipe(35206, 46130, 34364) -- Sunfire Robe
lib:AddRecipe(35207, 46131, 34365) -- Robe of Eternal Light
lib:AddRecipe(37915, 49677, 6836) -- Dress Shoes
lib:AddRecipe(38229, 50194, 38225) -- Mycah's Botanical Bag
lib:AddRecipe(38327, 50644, 38277) -- Haliscan Jacket
lib:AddRecipe(38328, 50647, 38278) -- Haliscan Pantaloons
lib:AddRecipe(42172, 55993, 41248) -- Red Lumberjack Shirt
lib:AddRecipe(42173, 55994, 41249) -- Blue Lumberjack Shirt
lib:AddRecipe(42174, 55995, 41251) -- Yellow Lumberjack Shirt
lib:AddRecipe(42175, 55996, 41250) -- Green Lumberjack Shirt
lib:AddRecipe(42177, 55997, 41252) -- Red Workman's Shirt
lib:AddRecipe(42176, 55998, 41253) -- Blue Workman's Shirt
lib:AddRecipe(42178, 55999, 41254) -- Rustic Workman's Shirt
lib:AddRecipe(42179, 56000, 41255) -- Green Workman's Shirt
lib:AddRecipe(42181, 56001, 41594) -- Moonshroud
lib:AddRecipe(42180, 56002, 41593) -- Ebonweave
lib:AddRecipe(42182, 56003, 41595) -- Spellweave
lib:AddRecipe(42183, 56004, 41597) -- Abyssal Bag
lib:AddRecipe(42184, 56005, 41600) -- Glacial Bag
lib:AddRecipe(42185, 56006, 41598) -- Mysterious Bag
lib:AddRecipe(42186, 56007, 41599) -- Frostweave Bag
lib:AddRecipe(42187, 56009, 41602) -- Brilliant Spellthread
lib:AddRecipe(42188, 56011, 41604) -- Sapphire Spellthread
lib:AddRecipe(42189, 56016, 41609) -- Wispcloak
lib:AddRecipe(42190, 56017, 41610) -- Deathchill Cloak
lib:AddRecipe(42191, 56018, 41984) -- Hat of Wintry Doom
lib:AddRecipe(42192, 56019, 41985) -- Silky Iceshard Boots
lib:AddRecipe(42194, 56021, 42093) -- Frostmoon Pants
lib:AddRecipe(42195, 56022, 42095) -- Light Blessed Mittens
lib:AddRecipe(42196, 56023, 42096) -- Aurora Slippers
lib:AddRecipe(42197, 56024, 42100) -- Moonshroud Robe
lib:AddRecipe(42198, 56025, 42103) -- Moonshroud Gloves
lib:AddRecipe(42199, 56026, 42101) -- Ebonweave Robe
lib:AddRecipe(42200, 56027, 42111) -- Ebonweave Gloves
lib:AddRecipe(42201, 56028, 42102) -- Spellweave Robe
lib:AddRecipe(42202, 56029, 42113) -- Spellweave Gloves
lib:AddRecipe(43876, 59390, nil) -- Cloth Scavenging
lib:AddRecipe(45102, 63203, 45557) -- Sash of Ancient Power
lib:AddRecipe(45103, 63204, 45566) -- Spellslinger's Slippers
lib:AddRecipe(45104, 63205, 45558) -- Cord of the White Dawn
lib:AddRecipe(45105, 63206, 45567) -- Savior's Slippers
lib:AddRecipe(45774, 63924, 45773) -- Emerald Bag
lib:AddRecipe(47657, 67064, 47605) -- Royal Moonshroud Robe
lib:AddRecipe(47656, 67065, 47587) -- Royal Moonshroud Bracers
lib:AddRecipe(47655, 67066, 47603) -- Merlin's Robe
lib:AddRecipe(47654, 67079, 47585) -- Bejeweled Wizard's Bracers
lib:AddRecipe(47636, 67144, 47606) -- Royal Moonshroud Robe
lib:AddRecipe(47639, 67145, 47586) -- Bejeweled Wizard's Bracers
lib:AddRecipe(47638, 67146, 47604) -- Merlin's Robe
lib:AddRecipe(47637, 67147, 47588) -- Royal Moonshroud Bracers
lib:AddRecipe(49953, 70550, 49891) -- Leggings of Woven Death
lib:AddRecipe(49954, 70551, 49890) -- Deathfrost Boots
lib:AddRecipe(49955, 70552, 49892) -- Lightweave Leggings
lib:AddRecipe(49956, 70553, 49893) -- Sandals of Consecration
lib:AddRecipe(68199, 75288, 54441) -- Black Embersilk Gown
lib:AddRecipe(67541, 75289, 54451) -- High Society Top Hat
lib:AddRecipe(54601, 75298, 54504) -- Belt of the Depths
lib:AddRecipe(54602, 75299, 54503) -- Dreamless Belt
lib:AddRecipe(54603, 75300, 54505) -- Breeches of Mended Nightmares
lib:AddRecipe(54604, 75301, 54506) -- Flame-Ascended Pantaloons
lib:AddRecipe(54597, 75302, 75082) -- Vicious Fireweave Pants
lib:AddRecipe(54598, 75303, 75088) -- Vicious Fireweave Robe
lib:AddRecipe(54596, 75304, 75062) -- Vicious Fireweave Cowl
lib:AddRecipe(54595, 75305, 75093) -- Vicious Embersilk Robe
lib:AddRecipe(54593, 75306, 75073) -- Vicious Embersilk Cowl
lib:AddRecipe(54594, 75307, 75072) -- Vicious Embersilk Pants
lib:AddRecipe(54605, 75308, 54444) -- Illusionary Bag
lib:AddRecipe(54599, 75309, 54448) -- Powerful Enchanted Spellthread
lib:AddRecipe(54600, 75310, 54450) -- Powerful Ghostly Spellthread
lib:AddRecipe(54798, 75597, 54797) -- Frosty Flying Carpet
lib:AddRecipe(69965, 99448, 69944) -- Grips of Altered Reality
lib:AddRecipe(69966, 99449, 69945) -- Don Tayo's Inferno Mittens
lib:AddRecipe(69975, 99459, 69953) -- Endless Dream Walkers
lib:AddRecipe(69976, 99460, 69954) -- Boots of the Black Flame
lib:AddRecipe(70176, 100585, 70138) -- Luxurious Silk Gem Bag
lib:AddRecipe(72000, 101920, 71981) -- World Mender's Pants
lib:AddRecipe(72002, 101921, 71980) -- Lavaquake Legwraps
lib:AddRecipe(72003, 101922, 71990) -- Dreamwraps of the Light
lib:AddRecipe(72004, 101923, 71989) -- Bracers of Unconquered Power
lib:AddRecipe(86352, 125531, 82421) -- Contender's Silk Cowl
lib:AddRecipe(86353, 125532, 82422) -- Contender's Silk Amice
lib:AddRecipe(86354, 125533, 82423) -- Contender's Silk Raiment
lib:AddRecipe(86355, 125534, 82424) -- Contender's Silk Handwraps
lib:AddRecipe(86356, 125535, 82425) -- Contender's Silk Pants
lib:AddRecipe(86357, 125536, 82426) -- Contender's Silk Cuffs
lib:AddRecipe(86358, 125537, 82427) -- Contender's Silk Footwraps
lib:AddRecipe(86359, 125538, 82428) -- Contender's Silk Belt
lib:AddRecipe(86360, 125539, 82429) -- Contender's Satin Cowl
lib:AddRecipe(86361, 125540, 82430) -- Contender's Satin Amice
lib:AddRecipe(86362, 125541, 82431) -- Contender's Satin Raiment
lib:AddRecipe(86363, 125542, 82432) -- Contender's Satin Handwraps
lib:AddRecipe(86364, 125543, 82433) -- Contender's Satin Pants
lib:AddRecipe(86365, 125544, 82434) -- Contender's Satin Cuffs
lib:AddRecipe(86366, 125545, 82435) -- Contender's Satin Footwraps
lib:AddRecipe(86367, 125546, 82436) -- Contender's Satin Belt
lib:AddRecipe(86368, 125547, 82437) -- Spelltwister's Grand Robe
lib:AddRecipe(86369, 125548, 82438) -- Spelltwister's Gloves
lib:AddRecipe(86370, 125549, 82439) -- Robes of Creation
lib:AddRecipe(86371, 125550, 82440) -- Gloves of Creation
lib:AddRecipe(86375, 125554, 82444) -- Greater Pearlescent Spellthread
lib:AddRecipe(86376, 125555, 82445) -- Greater Cerulean Spellthread
lib:AddRecipe(86377, 125556, 82446) -- Royal Satchel
lib:AddRecipe(86379, 125558, 86311) -- Robe of Eternal Rule
lib:AddRecipe(86380, 125559, 86313) -- Imperial Silk Gloves
lib:AddRecipe(86381, 125560, 86312) -- Legacy of the Emperor
lib:AddRecipe(86382, 125561, 86314) -- Touch of the Light
lib:AddRecipe(114851, 168835, 111556) -- Hexweave Cloth
lib:AddRecipe(114852, 168836, 114836) -- Hexweave Embroidery
lib:AddRecipe(114853, 168837, 114809) -- Hexweave Mantle
lib:AddRecipe(114854, 168838, 114810) -- Hexweave Cowl
lib:AddRecipe(114855, 168839, 114811) -- Hexweave Leggings
lib:AddRecipe(114856, 168840, 114812) -- Hexweave Gloves
lib:AddRecipe(114857, 168841, 114813) -- Hexweave Robe
lib:AddRecipe(114858, 168842, 114814) -- Hexweave Bracers
lib:AddRecipe(114859, 168843, 114815) -- Hexweave Slippers
lib:AddRecipe(114860, 168844, 114816) -- Hexweave Belt
lib:AddRecipe(114861, 168845, 114817) -- Powerful Hexweave Cloak
lib:AddRecipe(114862, 168846, 114818) -- Nimble Hexweave Cloak
lib:AddRecipe(114863, 168847, 114819) -- Brilliant Hexweave Cloak
lib:AddRecipe(114864, 168848, 114821) -- Hexweave Bag
lib:AddRecipe(114865, 168849, 113216) -- Elekk Plushie
lib:AddRecipe(114866, 168850, 115363) -- Creeping Carpet
lib:AddRecipe(114867, 168851, 114833) -- Miniature Flying Carpet
lib:AddRecipe(114868, 168852, 114828) -- Sumptuous Cowl
lib:AddRecipe(114869, 168853, 114829) -- Sumptuous Robes
lib:AddRecipe(114870, 168854, 114831) -- Sumptuous Leggings
lib:AddRecipe(114871, 168855, 128012) -- Hexweave Essence
lib:AddRecipe(118098, 173415, 118052) -- Murloc Chew Toy
lib:AddRecipe(120128, 176058, 118722) -- Secrets of Draenor Tailoring
lib:AddRecipe(122716, 182123, 111556) -- Primal Weaving
lib:AddRecipe(127724, 187492, 127715) -- Mighty Hexweave Essence
lib:AddRecipe(127742, 187516, 127733) -- Savage Hexweave Essence
