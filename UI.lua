local addonName, ns = ...

------------------------------------------------------------------------
-- Main frame (draggable note)
------------------------------------------------------------------------
local frame = CreateFrame("Frame", "WhereWeGoFrame", UIParent, "BackdropTemplate")
frame:SetSize(280, 60)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
frame:SetBackdrop({
    bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile     = true,
    tileSize = 16,
    edgeSize = 16,
    insets   = { left = 4, right = 4, top = 4, bottom = 4 },
})
frame:SetBackdropColor(0.05, 0.05, 0.1, 0.9)
frame:SetBackdropBorderColor(0.3, 0.6, 1.0, 0.8)
frame:SetFrameStrata("MEDIUM")
frame:SetClampedToScreen(true)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:Hide()

frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, relPoint, x, y = self:GetPoint()
    if WhereWeGoDB then
        WhereWeGoDB.position = { point = point, relPoint = relPoint, x = x, y = y }
    end
end)

------------------------------------------------------------------------
-- Header label
------------------------------------------------------------------------
local header = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
header:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -7)
header:SetText("|cff4499ffWhereWeGo|r")

------------------------------------------------------------------------
-- Group title text
------------------------------------------------------------------------
local titleText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
titleText:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -3)
titleText:SetJustifyH("LEFT")

------------------------------------------------------------------------
-- Close button
------------------------------------------------------------------------
local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButtonNoScripts")
closeBtn:SetSize(18, 18)
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)
closeBtn:SetScript("OnClick", function()
    frame:Hide()
end)

------------------------------------------------------------------------
-- Auto-resize frame to fit content without wrapping any line
------------------------------------------------------------------------
local function ResizeFrame()
    -- titleText width is temporarily set to 2000 (unconstrained) so
    -- GetStringWidth() returns the true widest-line width, not wrapped width.
    local textWidth   = titleText:GetStringWidth() or 60
    local headerWidth = header:GetStringWidth() or 60
    local contentWidth = math.max(headerWidth, textWidth)

    -- Pin the FontString to exactly the measured width so it never wraps.
    titleText:SetWidth(contentWidth)

    local textHeight   = titleText:GetStringHeight() or 14
    local headerHeight = header:GetStringHeight() or 12
    local totalHeight  = headerHeight + textHeight + 22
    -- 8px left pad + 26px right (close button) + 8px extra
    local totalWidth   = contentWidth + 42

    frame:SetSize(math.max(120, totalWidth), math.max(50, totalHeight))
end

------------------------------------------------------------------------
-- Public API (shared via addon namespace)
------------------------------------------------------------------------
ns.frame = frame

function ns:ShowNote(text)
    -- Set width to unconstrained first so measurement in ResizeFrame
    -- reflects the true unwrapped line widths, not a pre-wrapped layout.
    titleText:SetWidth(2000)
    titleText:SetText(text or "")
    self:RestorePosition()
    frame:Show()
    C_Timer.After(0.05, ResizeFrame) -- defer one frame so text is laid out
end

function ns:HideNote()
    titleText:SetText("")
    frame:Hide()
end

function ns:RestorePosition()
    if WhereWeGoDB and WhereWeGoDB.position then
        local pos = WhereWeGoDB.position
        frame:ClearAllPoints()
        frame:SetPoint(pos.point, UIParent, pos.relPoint, pos.x, pos.y)
    end
end
