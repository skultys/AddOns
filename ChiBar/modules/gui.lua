-- Addon:	ChiBar: GUI-creating part
-- Author:	Fushui(EU-Azshara)


-- Disables Addons, if Character is no Monk
if select(2, UnitClass("player")) ~= "MONK" then
    return
end


------------------------------------------
--		GUI								--
------------------------------------------

function ChiBar:CreateChiBar(parentFrame)

    ------------------------
    -- internal variables --
    ------------------------
    
    local chibar = {}
    chibar.Orbs = {}
    chibar.Textures_empty = {}
	chibar.Textures_full = {}
    
    local index
	for index = 1, 6 do
		chibar.Orbs[index] = CreateFrame("Frame", "ChiBar_Orb" .. index, parentFrame)
	end
    
    for index = 1, 6 do
		chibar.Textures_empty[index] = chibar.Orbs[index]:CreateTexture("ChiBar_OrbTexture_empty" .. index)
		chibar.Textures_full[index] = chibar.Orbs[index]:CreateTexture("ChiBar_OrbTexture_full" .. index)
        chibar.Textures_empty[index]:SetAllPoints(chibar.Orbs[index])
		chibar.Textures_full[index]:SetAllPoints(chibar.Orbs[index])
	end
   
    ------------------------
    -- internal functions --
    ------------------------
    
    -- Dimension 
    chibar.SetDimensions = function (self, width, height)
    
        for index = 1, 6 do
            self.Orbs[index]:SetHeight(height)
            self.Orbs[index]:SetWidth(width)
        end
    end
    
    -- Alpha
    chibar.SetAlpha = function (self)
    
        if ChiBarDB.seperate then
            for index = 1, 6 do
                self.Textures_empty[index]:SetAlpha(ChiBarDB.alpha2)
                self.Textures_full[index]:SetAlpha(ChiBarDB.alpha1)
            end
        else
            for index = 1, 6 do
                self.Textures_empty[index]:SetAlpha(ChiBarDB.alpha1)
                self.Textures_full[index]:SetAlpha(ChiBarDB.alpha1)
            end
        end
    end
    
    -- SetTexture
    chibar.SetTexture = function (self)
    
        local index
        for index = 1, 6 do
            self.Textures_empty[index]:SetTexture(ChiBar.textures[((ChiBarDB.savedTexture*2)-1)])
            self.Textures_full[index]:SetTexture(ChiBar.textures[(ChiBarDB.savedTexture*2)])
        end
    end
    
    -- Update Chi
    chibar.Update = function (self, currChi, maxChi)
        if not (arg1 or arg2) then
            currChi, maxChi = UnitPower("player", ChiBar.CLASSPOWERID), UnitPowerMax("player", ChiBar.CLASSPOWERID)
        end
        
        local index
        for index = 1, currChi do
            self.Textures_full[index]:Show()
        end
        for index = (currChi+1), maxChi do
            self.Textures_full[index]:Hide()
        end
    end
    
    -- Update MaxChi
    chibar.SetMaxChi = function(self, maxChi)
    
        local index
        for index = 1, maxChi do
            self.Orbs[index]:Show()
        end
        for index = maxChi+1, 6 do
            self.Orbs[index]:Hide()
        end
    end
    
    -- StructureUpdate
    chibar.StructureUpdate = function (self, relativeFrame, maxChi, growX, growY, offset, addingFactor)

        local offsetX, offsetY
        local factorX, factorY
        local index
        
        if growX then
            if growY then
                offsetX = offset
                offsetY = 0
                addingFactorX = addingFactor
                addingFactorY = 0
            else
                offsetX = (-1)*offset
                offsetY = 0
                addingFactorX = (-1)*addingFactor
                addingFactorY = 0
            end
        else
            if growY then
                offsetX = 0
                offsetY = offset
                addingFactorX = 0
                addingFactorY = addingFactor
            else
                offsetX = 0
                offsetY = (-1)*offset
                addingFactorX = 0
                addingFactorY = (-1)*addingFactor
            end
        end
        
        for index = 0, 5 do
            self.Orbs[index+1]:ClearAllPoints()
            self.Orbs[index+1]:SetPoint("CENTER", relativeFrame, "CENTER", index*offsetX+addingFactorX, index*offsetY+addingFactorY)
        end
    end
    
    -- Color
    chibar.SetColor = function (self)
    
        local index
        for index = 1, 6 do
            self.Textures_empty[index]:SetVertexColor(ChiBarDB.color[1], ChiBarDB.color[2], ChiBarDB.color[3])
            self.Textures_full[index]:SetVertexColor(ChiBarDB.color[1], ChiBarDB.color[2], ChiBarDB.color[3])
        end
    end
    
    -- Layer
    chibar.SetLayer = function (self)
    
        local index
        local layernames = {"BACKGROUND", "BORDER", "ARTWORK", "OVERLAY"}
        local stratanames = {"LOW", "MEDIUM", "HIGH", "DIALOG"}
        for index = 1, 6 do
            self.Orbs[index]:SetFrameStrata(stratanames[ChiBarDB.strata])
            
            self.Textures_empty[index]:SetDrawLayer(layernames[ChiBarDB.mainLayer], 4)
            self.Textures_full[index]:SetDrawLayer(layernames[ChiBarDB.mainLayer], 5)
        end
    end
    
    
    ------------------------
    -- return value       --
    ------------------------
    
    return chibar
end

function ChiBar:CreateBackground(parentFrame)

    ------------------------
    -- internal variables --
    ------------------------
    
    local bgtextures = {}
    
    bgtextures = CreateFrame("Frame", "ChiBar_BGTextures", parentFrame)
    
    bgtextures:SetAllPoints(parentFrame)
    
    bgtextures.BGTexture1 = bgtextures:CreateTexture("ChiBar_BGTexture1")
    bgtextures.BGTexture1:SetTexture(220, 220, 220, 0.3)
    bgtextures.BGTexture1:SetPoint("CENTER", bgtextures, "CENTER")
    
	bgtextures.BGTexture2 = bgtextures:CreateTexture("ChiBar_BGTexture2")
    bgtextures.BGTexture2:SetTexture(250, 250, 250, 0.7)
    bgtextures.BGTexture2:SetAllPoints(bgtextures)

    bgtextures:Hide()
    
    ------------------------
    -- internal functions --
    ------------------------
    
    -- Dimension
    bgtextures.SetDimensions = function (self, width, height)
        self.BGTexture1:SetWidth(width)
        self.BGTexture1:SetHeight(height)
    end
    
    -- Layers
    bgtextures.SetLayer = function (self)
    
        local index
        local layernames = {"BACKGROUND", "BORDER", "ARTWORK", "OVERLAY"}
        local stratanames = {"LOW", "MEDIUM", "HIGH", "DIALOG"}
        
        self:SetFrameStrata(stratanames[ChiBarDB.strata])
        
        self.BGTexture1:SetDrawLayer(layernames[ChiBarDB.mainLayer], 6)
        self.BGTexture2:SetDrawLayer(layernames[ChiBarDB.mainLayer], 7)
    end
    
    -- Structure
    bgtextures.StructureUpdate = function (self, relativeFrame, growX, growY, offset)
    
        self.BGTexture1:ClearAllPoints()
        
        local width, height
        
        if growX then
            width, height = 6*ChiBar.BUBBLEDIM+5*offset, ChiBar.BUBBLEDIM
            if growY then
                self.BGTexture1:SetPoint("LEFT", relativeFrame, "LEFT")
            else
                self.BGTexture1:SetPoint("RIGHT", relativeFrame, "RIGHT")
            end
        else
            height, width = 6*ChiBar.BUBBLEDIM+5*offset, ChiBar.BUBBLEDIM
            if growY then
                self.BGTexture1:SetPoint("BOTTOM", relativeFrame, "BOTTOM")
            else
                self.BGTexture1:SetPoint("TOP", relativeFrame, "TOP")
            end  
        end
        
        self:SetDimensions(width, height)
    end
    
    ------------------------
    -- return value       --
    ------------------------
    
    return bgtextures
end

function ChiBar:CreateManaBar(parentFrame)

    ------------------------
    -- internal variables --
    ------------------------
    
    local manabar = {}
    
    manabar = CreateFrame("StatusBar", "ChiBar_ManaBar", parentFrame)
    manabar:SetMinMaxValues(0, 100)
    manabar:SetValue(0)
    
    manabar.ManaTexture = manabar:CreateTexture("ChiBar_ManaBarTexture")
    manabar.ManaTexture:SetAllPoints(manabar)
    manabar.ManaTexture:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
    manabar:SetStatusBarTexture(manabar.ManaTexture)
    
    manabar.Background = manabar:CreateTexture("ChiBar_ManaBarBackground")
    manabar.Background:SetAllPoints(manabar)
    
    ------------------------
    -- internal functions --
    ------------------------
    
    -- Dimension
    manabar.SetDimensions = function (self, width, height)
        self:SetWidth(width)
        self:SetHeight(height)
    end
    
    -- Update ResourceValue (Mana/Energy)
    manabar.Update = function (self)
        local resource, maxResource = UnitPower("player"), UnitPowerMax("player")
        self:SetValue(floor(resource/maxResource*100))
    end
    
    -- Alpha
    manabar.SetNewAlpha = function (self)
        self:SetAlpha(ChiBarDB.alphaMana)
    end
    
    -- Update PowerType
    manabar.SetPowerType = function (self)
        local _, powerType, _, _, _ = UnitPowerType("player")
        local r1, g1, b1, r2, g2, b2, a
    
        if powerType == nil then
            r1, g1, b1, r2, g2, b2, a = 255, 255, 0, 209, 209, 148, 0.3
        else
            if powerType == "ENERGY" then
                r1, g1, b1, r2, g2, b2, a = 255, 255, 0, 209, 209, 148, 0.3
            else
                r1, g1, b1, r2, g2, b2, a = 0, 0, 255, 148, 148, 209, 0.3
            end
        end
            
        self:SetStatusBarColor(r1, g1, b1)
        self.Background:SetTexture(r2, g2, b2, a)
    end
    
    -- Alpha
    --manabar.SetAlpha = function (self, alpha)
    --    self:SetAlpha(alpha)
    --end
    
    -- LayerUpdate
    manabar.SetLayer = function (self)
    
        local layernames = {"BACKGROUND", "BORDER", "ARTWORK", "OVERLAY"}
        local stratanames = {"LOW", "MEDIUM", "HIGH", "DIALOG"}
        
        self:SetFrameStrata(stratanames[ChiBarDB.strata])
    
        self.ManaTexture:SetDrawLayer(layernames[ChiBarDB.mainLayer], 3)
        self.Background:SetDrawLayer(layernames[ChiBarDB.mainLayer], 2)
    end
    
    -- StructureUpdate
    manabar.StructureUpdate = function (self, relativeFrame, maxChi, growX, growY, offset, addingFactor, overlapping)
        
        self:ClearAllPoints()
        
        local width, height
        
        if growX then
            self:SetOrientation("horizontal")
            self:SetReverseFill(not growY)
            width, height = maxChi*ChiBar.BUBBLEDIM+(maxChi-1)*ChiBarDB.offset+overlapping*2, ChiBar.BUBBLEDIM+overlapping*2
            if growY then
                self:SetPoint("LEFT", relativeFrame, "LEFT", (-1)*overlapping+addingFactor, 0)
            else
                self:SetPoint("RIGHT", relativeFrame, "RIGHT", overlapping-addingFactor, 0)
            end
        else
            self:SetOrientation("vertical")
            self:SetReverseFill(not growY)
            height, width = maxChi*ChiBar.BUBBLEDIM+(maxChi-1)*ChiBarDB.offset+overlapping*2, ChiBar.BUBBLEDIM+overlapping*2
            if growY then
                self:SetPoint("BOTTOM", relativeFrame, "BOTTOM", 0, (-1)*overlapping+addingFactor)
            else
                self:SetPoint("TOP", relativeFrame, "TOP", 0, overlapping-addingFactor)
            end  
        end
        
        self:SetDimensions(width, height)
    end
    
    
    ------------------------
    -- return value       --
    ------------------------
    
    return manabar
    
end

function ChiBar:CreateUI()

    ---------------------------------
    -- Proberties of the mainFrame --
    ---------------------------------
    
	ChiBar.mainFrame:SetWidth(ChiBar.BUBBLEDIM)
	ChiBar.mainFrame:SetHeight(ChiBar.BUBBLEDIM)
	ChiBar.mainFrame:SetPoint(ChiBarDB.from, UIParent, ChiBarDB.to, ChiBarDB.x, ChiBarDB.y)
	ChiBar.mainFrame:SetScale(ChiBarDB.scale)
    ChiBar.mainFrame:RegisterForDrag("LeftButton")
	ChiBar.mainFrame:SetMovable(false)

    ---------------------------------
	-- Creating SubFrames          --
    ---------------------------------
    
	ChiBar.ChiBar = ChiBar:CreateChiBar(ChiBar.mainFrame)
    ChiBar.ManaBar = ChiBar:CreateManaBar(ChiBar.mainFrame)
	ChiBar.BGTextures = ChiBar:CreateBackground(ChiBar.mainFrame)
    	
    
    ---------------------------------
    -- Initial SetUp               --
    ---------------------------------
    
    -- Dimensions
    ChiBar.ChiBar:SetDimensions(ChiBar.BUBBLEDIM, ChiBar.BUBBLEDIM)
        
    -- Structure
    local maxChi = UnitPowerMax("player", ChiBar.CLASSPOWERID)
    
    ChiBar.ChiBar:StructureUpdate(ChiBar.mainFrame, maxChi, ChiBarDB.grow1, ChiBarDB.grow2, ChiBar.BUBBLEDIM+ChiBarDB.offset, (6-maxChi)*ChiBar.BUBBLEDIM/2)
    ChiBar.ManaBar:StructureUpdate(ChiBar.mainFrame, maxChi, ChiBarDB.grow1, ChiBarDB.grow2, ChiBar.BUBBLEDIM+ChiBarDB.offset, (6-maxChi)*ChiBar.BUBBLEDIM/2, ChiBarDB.manaBarOverlapping)
    ChiBar.BGTextures:StructureUpdate(ChiBar.mainFrame, ChiBarDB.grow1, ChiBarDB.grow2, ChiBarDB.offset)
    
    -- Layer and Strata level
    ChiBar.ChiBar:SetLayer(ChiBarDB.strata, ChiBarDB.mainLayer)
    ChiBar.ManaBar:SetLayer(ChiBarDB.strata, ChiBarDB.mainLayer)
    ChiBar.BGTextures:SetLayer(ChiBarDB.strata, ChiBarDB.mainLayer)
    
    -- Textures/Colors
    
    ChiBar.ChiBar:SetTexture()
    ChiBar.ChiBar:SetColor()
    ChiBar.ManaBar:SetPowerType()
    
	-- Opacity
    if ChiBarDB.seperate then
        ChiBar.ChiBar:SetAlpha(ChiBarDB.alpha1, ChiBarDB.alpha2)
    else
        ChiBar.ChiBar:SetAlpha(ChiBarDB.alpha1)
    end
	ChiBar.ManaBar:SetAlpha(ChiBarDB.alphaMana)
	
	-- Hiding full Orbs
	ChiBar.ChiBar:Update(0, 6)
end


------------------------------------------
--		End of Script					--
------------------------------------------