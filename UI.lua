local addonName, ns = ...

------------------------------------------------------------------------
-- Frame
------------------------------------------------------------------------
local frame = CreateFrame("Frame", "WhereWeGoFrame", UIParent, "BackdropTemplate")
frame:SetSize(300, 60)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
frame:SetBackdrop({
    bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
frame:SetBackdropColor(0.05, 0.05, 0.1, 0.9)
frame:SetBackdropBorderColor(0.3, 0.6, 1.0, 0.8)
frame:SetFrameStrata("MEDIUM")
frame:SetClampedToScreen(true)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    if WhereWeGoDB then
        local point, _, relPoint, x, y = self:GetPoint()
        WhereWeGoDB.pos = { point = point, relPoint = relPoint, x = x, y = y }
    end
end)
frame:Hide()

local header = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
header:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -7)
header:SetText("|cff4499ffWhereWeGo|r")

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButtonNoScripts")
closeBtn:SetSize(18, 18)
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)
closeBtn:SetScript("OnClick", function() frame:Hide() end)

local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
label:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -3)
label:SetPoint("RIGHT", frame, "RIGHT", -28, 0)
label:SetJustifyH("LEFT")
label:SetWordWrap(true)

------------------------------------------------------------------------
-- Public API
------------------------------------------------------------------------
ns.frame = frame

function ns:Show(text)
    label:SetText(text or "")
    -- Resize frame to fit
    local tw = label:GetStringWidth() or 60
    local hw = header:GetStringWidth() or 60
    local w  = math.max(hw, tw) + 42
    local h  = (header:GetStringHeight() or 12) + (label:GetStringHeight() or 14) + 22
    frame:SetSize(math.max(120, w), math.max(50, h))
    -- Restore saved position
    if WhereWeGoDB and WhereWeGoDB.pos then
        local p = WhereWeGoDB.pos
        frame:ClearAllPoints()
        frame:SetPoint(p.point, UIParent, p.relPoint, p.x, p.y)
    end
    frame:Show()
end

function ns:Hide()
    label:SetText("")
    frame:Hide()
end

function ns:RestorePos()
    if WhereWeGoDB and WhereWeGoDB.pos then
        local p = WhereWeGoDB.pos
        frame:ClearAllPoints()
        frame:SetPoint(p.point, UIParent, p.relPoint, p.x, p.y)
    end
end
