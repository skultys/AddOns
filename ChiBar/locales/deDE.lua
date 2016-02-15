-- Addon:	ChiBar: german localization
-- Author:	Fushui(EU-Azshara)

if select(2, UnitClass("player")) ~= "MONK" then
    return
end

if GetLocale() == "deDE"  then
	ChiBarLocalization["AUTOHIDE_OFF"] = "|cff00FF96Automatisches Verstecken au\195\159rhalb eines Kampfes ist|cffff0000 deaktiviert."
	ChiBarLocalization["AUTOHIDE_ON"] = "|cff00FF96Automatisches Verstecken au\195\159erhalb eines Kampfes ist|cff00ff00 aktiviert."
	ChiBarLocalization["COLORRESET"] = "|cff00FF96Farbe wurde|cffffff00 zur\195\188ckgesetzt."
	ChiBarLocalization["GREETINGS"] = "|cff00FF96Gib |cffF2F2F2/cb |cff00FF96oder |cffF2F2F2/chibar |cff00FF96 f\195\188r die Options ein."
	ChiBarLocalization["HIDE"] = "|cff00FF96ChiBar ist jetzt|cffff0000 aus."
	ChiBarLocalization["LOCK"] = "|cff00FF96ChiBar ist jetzt|cff00ff00 gesperrt."
	ChiBarLocalization["OP_AUTOHIDE"] = "Autohide au\195\159erhalb des\nKampfes ein-/ausschalten"
	ChiBarLocalization["OP_COLORBTN"] = "Farbe \195\164ndern"
	ChiBarLocalization["OP_DROPBOXTITLE"] = "Textur ausw\195\164hlen"
	ChiBarLocalization["OP_ENABLE"] = "Enable/Disable ChiBar"
	ChiBarLocalization["OP_GROW_TITLE"] = "Orientierung"
	ChiBarLocalization["OP_GROW_VERTICAL"] = "Vertikal"
	ChiBarLocalization["OP_GROW_HORIZONTAL"] = "Horizontal"
	ChiBarLocalization["OP_GROW_RIGHT"] = "Rechts"
	ChiBarLocalization["OP_GROW_LEFT"] = "Links"
	ChiBarLocalization["OP_GROW_BOTTOM"] = "Unten"
	ChiBarLocalization["OP_GROW_TOP"] = "Oben"
	ChiBarLocalization["OP_HIDESTANDARD"] = "WoWs Standardanzeige\nf\195\188r Chi verstecken"
	ChiBarLocalization["OP_LAYERSUBTITLE1"] = "Strata-Level"
	ChiBarLocalization["OP_LAYERSUBTITLE2"] = "Layer-Level"
	ChiBarLocalization["OP_LAYERTITLE"] = "Passe dein strata-/layer-Level an"
	ChiBarLocalization["OP_LOCKBTN1"] = "Entsperren"
	ChiBarLocalization["OP_LOCKBTN2"] = "Sperren"
	ChiBarLocalization["OP_MAINTITLE"] = "Haupteinstellungen"
	ChiBarLocalization["OP_OFFSETTITLE"] = "Raum zwischen Orbs"
	ChiBarLocalization["OP_OPACITYTITLE"] = "Alphawert anpassen"
	ChiBarLocalization["OP_OPACITYSUBTITLE1_1"] = "Leere und volle Orbs"
	ChiBarLocalization["OP_OPACITYSUBTITLE1_2"] = "Volle orbs"
	ChiBarLocalization["OP_OPACITYSUBTITLE2"] = "Leere orbs"
    ChiBarLocalization["OP_OPACITYSUBTITLEMANA"] = "ManaBar"
    ChiBarLocalization["OP_OVERLAPPINGMANABAR"] = "Größe der ManaBar"
	ChiBarLocalization["OP_RESET"] = "Zur\195\188cksetzen"
	ChiBarLocalization["OP_RESETCOLORBTN"] = "Farbe resetten"
	ChiBarLocalization["OP_RESETTEXT"] = "M\195\182chtest du wirklich die\nEinstellungen zur\195\188cksetzen?"
	ChiBarLocalization["OP_SEPERATE"] = "Leere und volle Chiorbs seperat einstellen"
	ChiBarLocalization["OP_SCALETITLE"] = "Skaliere ChiBar"
    ChiBarLocalization["OP_SHOWMANABAR"] = "Zeige ManaBar"
	ChiBarLocalization["OP_UNLOCKTEXT"] = 'ChiBar ist jetzt ensperrt.\nDas hervorgehobene, wei\195\159e Quadrat dient als "Anker".'
    ChiBarLocalization["OPENINCOMBAT"] = "|cff00FF96Das Optionsmenü von ChiBar wird sich nach dem Kampf öffnen"
	ChiBarLocalization["RESET"] = "|cff00FF96Einstellungen wurden|cffffff00 zur\195\188ckgesetzt."
	ChiBarLocalization["SHOW"] = "|cff00FF96ChiBar ist jetzt|cff00ff00 an."
	ChiBarLocalization["UNLOCK"] = "|cff00FF96ChiBar ist jetzt|cffff0000 entsperrt."
end