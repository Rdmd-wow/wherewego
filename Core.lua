local addonName, ns = ...

------------------------------------------------------------------------
-- Korean → English dungeon/difficulty lookup
------------------------------------------------------------------------
local KO_EN = {
    -- Midnight
    ["윈드러너 첨탑"]       = "Windrunner Spire",
    ["마법학자의 정원"]     = "Magisters' Terrace",
    ["죽음의 골목"]         = "Death's Row",
    ["날로라크의 소굴"]     = "Nalorakk's Den",
    ["마이사라 동굴"]       = "Maisara Caverns",
    ["공결탑 제나스"]       = "Nexus-Point Xenas",
    ["공결탑 제니스"]       = "Nexus-Point Xenas",
    ["눈부신 골짜기"]       = "Shining Vale",
    ["공허흉터 투기장"]     = "Voidscar Arena",
    -- Legacy Season 1
    ["알게타르 대학"]       = "Algeth'ar Academy",
    ["알게타르 학원"]       = "Algeth'ar Academy",
    ["사론의 구덩이"]       = "Pit of Saron",
    ["삼두정의 권좌"]       = "Seat of the Triumvirate",
    ["삼두정의 옥좌"]       = "Seat of the Triumvirate",
    ["하늘탑"]              = "Skyreach",
    -- TWW
    ["아라카라, 메아리의 도시"] = "Ara-Kara, City of Echoes",
    ["착암기 광산"]         = "The Stonevault",
    ["시티 오브 스레드"]    = "City of Threads",
    ["어둠불꽃 거리"]       = "Darkflame Cleft",
    ["새벽인도자의 양조장"] = "The Dawnbreaker",
    ["아틀다자르 신전"]     = "Atal'Dazar",
    ["왕노릇의 대가"]       = "Siege of Boralus",
    ["하급 카라잔"]         = "Lower Karazhan",
    ["상급 카라잔"]         = "Upper Karazhan",
    -- Raids
    ["해방의 지하"]         = "Liberation of Undermine",
    ["네루바르 궁전"]       = "Nerub-ar Palace",
}

local KO_DIFF = {
    ["신화"] = "Mythic", ["영웅"] = "Heroic", ["일반"] = "Normal",
    ["쐐기"] = "M+",
}

local ZONE = {
    ["Windrunner Spire"]         = "Quel'Thalas",
    ["Magisters' Terrace"]       = "Quel'Thalas",
    ["Death's Row"]              = "Quel'Thalas",
    ["Nalorakk's Den"]           = "Quel'Thalas",
    ["Maisara Caverns"]          = "Quel'Thalas",
    ["Nexus-Point Xenas"]        = "Quel'Thalas",
    ["Shining Vale"]             = "Quel'Thalas",
    ["Voidscar Arena"]           = "Quel'Thalas",
    ["Algeth'ar Academy"]        = "The Azure Span",
    ["Pit of Saron"]             = "Icecrown",
    ["Seat of the Triumvirate"]  = "Argus",
    ["Skyreach"]                 = "Spires of Arak",
    ["Ara-Kara, City of Echoes"] = "Azj-Kahet",
    ["The Stonevault"]           = "The Ringing Deeps",
    ["City of Threads"]          = "Azj-Kahet",
    ["Darkflame Cleft"]          = "Hallowfall",
    ["The Dawnbreaker"]          = "Isle of Dorn",
    ["Atal'Dazar"]               = "Zuldazar",
    ["Siege of Boralus"]         = "Tiragarde Sound",
    ["Lower Karazhan"]           = "Deadwind Pass",
    ["Upper Karazhan"]           = "Deadwind Pass",
    ["Liberation of Undermine"]  = "Undermine",
    ["Nerub-ar Palace"]          = "Azj-Kahet",
}

------------------------------------------------------------------------
-- ALL STATE — declared before every function that uses them
------------------------------------------------------------------------
local pendingDungeon     = nil   -- set only when a specific group accepts us
local pendingTitle       = nil   -- set only when a specific group accepts us
local appliedGroups      = {}    -- [searchResultID] = {dungeon, title}
local shownForThisGroup  = false -- prevents duplicate popups per group
local wasInRealGroup     = false -- GetNumGroupMembers() > 0
local prevGroupSize      = -1   -- for OnUpdate watcher (-1 = not init)
local watcherTicks       = 0
local watcherElapsed     = 0
local debugMode          = false -- toggled by /wwg debug

local function dbg(msg)
    if debugMode then print("|cff888888" .. msg .. "|r") end
end

------------------------------------------------------------------------
-- Helpers
------------------------------------------------------------------------
local function Translate(name)
    if not name then return nil end
    return KO_EN[name]
end

local function GetZone(name)
    if not name then return nil end
    -- Direct match
    local en = KO_EN[name]
    if en and ZONE[en] then return ZONE[en] end
    if ZONE[name] then return ZONE[name] end
    -- Substring match against Korean keys
    for ko, enName in pairs(KO_EN) do
        if name:find(ko, 1, true) then
            if ZONE[enName] then return ZONE[enName] end
        end
    end
    -- Substring match against English keys
    for enName, zone in pairs(ZONE) do
        if name:find(enName, 1, true) then return zone end
    end
    return nil
end

local function GetLeader()
    if UnitIsGroupLeader("player") then
        local n, r = UnitName("player")
        return (r and r ~= "") and (n.."-"..r) or n
    end
    local max = IsInRaid() and 40 or 4
    local pre = IsInRaid() and "raid" or "party"
    for i = 1, max do
        local u = pre..i
        if UnitExists(u) and UnitIsGroupLeader(u) then
            local n, r = UnitName(u)
            return (r and r ~= "") and (n.."-"..r) or n
        end
    end
    if UnitExists("party1") then
        local n, r = UnitName("party1")
        if n and n ~= "" then
            return (r and r ~= "") and (n.."-"..r) or n
        end
    end
end

local function GetActivityName(actID)
    if not actID or actID == 0 then return nil end
    if GetLFGActivityFullNameFromID then
        local n = GetLFGActivityFullNameFromID(actID)
        if n and n ~= "" then return n end
    end
    if C_LFGList then
        if C_LFGList.GetActivityInfoTable then
            local ok, info = pcall(C_LFGList.GetActivityInfoTable, actID)
            if ok and info then
                return info.fullName or info.shortName
            end
        end
        if C_LFGList.GetActivityInfo then
            local ok, full = pcall(C_LFGList.GetActivityInfo, actID)
            if ok and full and full ~= "" then return full end
        end
    end
end

local function CaptureActiveEntry()
    if not (C_LFGList and C_LFGList.GetActiveEntryInfo) then return nil end
    local ok, info = pcall(C_LFGList.GetActiveEntryInfo)
    if not ok or not info then return nil end
    local ids = info.activityIDs
    local id  = (ids and #ids > 0) and ids[1] or info.activityID
    return GetActivityName(id)
end

local function BuildLines(dungeon, leader, title)
    local lines = {}
    if dungeon and dungeon ~= "" then
        lines[#lines+1] = "|cff00cc66" .. dungeon .. "|r"
        local en = Translate(dungeon)
        if en then lines[#lines+1] = "|cffcccccc" .. en .. "|r" end
        local zone = GetZone(dungeon)
        if zone then lines[#lines+1] = "|cffddaa00[Location] " .. zone .. "|r" end
    else
        lines[#lines+1] = "|cff888888(dungeon unknown)|r"
    end
    if title and title ~= "" then
        lines[#lines+1] = "|cffff9900[Title] " .. title .. "|r"
    end
    if leader and leader ~= "" then
        lines[#lines+1] = "|cff99bbff[Leader] " .. leader .. "|r"
    end
    return table.concat(lines, "\n")
end

------------------------------------------------------------------------
-- ShowNote — popup + chat message (guarded by shownForThisGroup)
------------------------------------------------------------------------
local function ShowNote(dungeon, leader, title)
    if shownForThisGroup then return end
    shownForThisGroup = true
    if not WhereWeGoDB then WhereWeGoDB = {} end
    local note = BuildLines(dungeon, leader, title)
    WhereWeGoDB.dungeon = dungeon
    WhereWeGoDB.leader  = leader
    WhereWeGoDB.title   = title
    WhereWeGoDB.note    = note
    ns:Show(note)
    local msg
    if dungeon and dungeon ~= "" then
        local en = Translate(dungeon)
        msg = dungeon .. (en and (" / " .. en) or "")
        local zone = GetZone(dungeon)
        if zone then msg = msg .. "  [" .. zone .. "]" end
    else
        msg = "(unknown dungeon)"
    end
    if title and title ~= "" then msg = msg .. "  [" .. title .. "]" end
    if leader then msg = msg .. "  [Leader] " .. leader end
    print("|cff4499ffWhereWeGo:|r " .. msg)
end

------------------------------------------------------------------------
-- OnGroupJoined — single entry point for all join triggers
------------------------------------------------------------------------
local function OnGroupJoined(source)
    dbg("WWG OnGroupJoined [" .. source .. "] pending=" .. tostring(pendingDungeon) .. " title=" .. tostring(pendingTitle) .. " shown=" .. tostring(shownForThisGroup))
    if shownForThisGroup then return end
    wasInRealGroup = true

    local title = pendingTitle

    -- Try 1: CaptureActiveEntry (the actual group we joined)
    local dungeon = CaptureActiveEntry()
    if dungeon and dungeon ~= "" then
        pendingDungeon = nil
        pendingTitle = nil
        ShowNote(dungeon, GetLeader(), title)
        return
    end

    -- Try 2: pendingDungeon (fallback from apply hook)
    dungeon = pendingDungeon
    pendingDungeon = nil
    pendingTitle = nil
    if dungeon and dungeon ~= "" then
        ShowNote(dungeon, GetLeader(), title)
        return
    end

    -- Try 3: instance info
    local iName, iType = GetInstanceInfo()
    if iName and iName ~= "" and iType ~= "none" then
        ShowNote(iName, GetLeader(), title)
        return
    end

    -- Try 4: retry after 2s (roster/API may not be ready)
    dbg("WWG no dungeon yet, retrying in 2s")
    C_Timer.After(2, function()
        local ok, err = pcall(function()
            if shownForThisGroup then return end
            local d = CaptureActiveEntry()
            if not d or d == "" then
                local n2, t2 = GetInstanceInfo()
                if n2 and n2 ~= "" and t2 ~= "none" then d = n2 end
            end
            if d and d ~= "" then
                ShowNote(d, GetLeader(), title)
            else
                -- Try 5: one more retry at 5s total
                C_Timer.After(3, function()
                    pcall(function()
                        if shownForThisGroup then return end
                        local d2 = CaptureActiveEntry()
                        if not d2 or d2 == "" then
                            local n3, t3 = GetInstanceInfo()
                            if n3 and n3 ~= "" and t3 ~= "none" then d2 = n3 end
                        end
                        ShowNote(d2, GetLeader(), title)
                    end)
                end)
            end
        end)
        if not ok then print("|cffff0000WWG retry err: " .. tostring(err) .. "|r") end
    end)
end

------------------------------------------------------------------------
-- OnGroupLeft — cleanup state
------------------------------------------------------------------------
local function OnGroupLeft(source)
    dbg("WWG OnGroupLeft [" .. source .. "]")
    shownForThisGroup = false
    wasInRealGroup    = false
    pendingDungeon    = nil
    pendingTitle      = nil
    appliedGroups     = {}
    if WhereWeGoDB then
        WhereWeGoDB.dungeon = nil
        WhereWeGoDB.leader  = nil
        WhereWeGoDB.title   = nil
        WhereWeGoDB.note    = nil
    end
    ns:Hide()
end

------------------------------------------------------------------------
-- WATCHER FRAME — OnUpdate fallback (separate named frame)
-- Polls GetNumGroupMembers() every 0.5s as a backup trigger.
-- Delays 3s to give event-based triggers priority.
------------------------------------------------------------------------
local watcher = CreateFrame("Frame", "WhereWeGoWatcher", UIParent)
watcher:Show()

watcher:SetScript("OnUpdate", function(self, dt)
    watcherElapsed = watcherElapsed + dt
    if watcherElapsed < 0.5 then return end
    watcherElapsed = 0
    watcherTicks = watcherTicks + 1

    if watcherTicks == 1 then
        dbg("WWG watcher active (tick 1)")
    end

    local ok, err = pcall(function()
        local n = GetNumGroupMembers()
        if prevGroupSize < 0 then
            prevGroupSize = n
            return
        end
        -- Stop processing once popup has been shown
        if shownForThisGroup then
            prevGroupSize = n
            return
        end
        if n > 0 and prevGroupSize == 0 then
            dbg("WWG watcher: join " .. prevGroupSize .. "->" .. n)
            C_Timer.After(3, function()
                pcall(function()
                    if not shownForThisGroup then
                        OnGroupJoined("watcher")
                    end
                end)
            end)
        end
        if n == 0 and prevGroupSize > 0 then
            OnGroupLeft("watcher")
        end
        prevGroupSize = n
    end)
    if not ok then print("|cffff0000WWG watcher err: " .. tostring(err) .. "|r") end
end)

------------------------------------------------------------------------
-- EVENT FRAME — group events + LFG hooks
------------------------------------------------------------------------
local ef = CreateFrame("Frame", "WhereWeGoEvents", UIParent)

-- Register events with pcall so one bad event name doesn't block the rest
local eventList = {
    "PLAYER_LOGIN",
    "GROUP_JOINED",
    "GROUP_ROSTER_UPDATE",
    "GROUP_LEFT",
    "PARTY_LEADER_CHANGED",
    "LFG_PROPOSAL_SHOW",
    "LFG_LIST_ACTIVE_ENTRY_UPDATED",
    "LFG_LIST_APPLICATION_STATUS_UPDATED",
    "ZONE_CHANGED_NEW_AREA",
}
for _, ev in ipairs(eventList) do
    pcall(ef.RegisterEvent, ef, ev)
end

ef:SetScript("OnEvent", function(self, event, a1, a2, a3)
    local ok, err = pcall(function()

        -- Skip all events once popup is shown (except leave/login)
        if shownForThisGroup and event ~= "GROUP_LEFT" and event ~= "PLAYER_LOGIN" then
            return
        end

        if event == "PLAYER_LOGIN" then
            if not WhereWeGoDB then WhereWeGoDB = {} end
            ns:RestorePos()
            local ver = (C_AddOns and C_AddOns.GetAddOnMetadata)
                        and C_AddOns.GetAddOnMetadata("WhereWeGo", "Version") or "?"
            dbg("WhereWeGo v" .. ver .. " loaded")

            -- Hook LFG apply functions to capture dungeon at apply time
            if C_LFGList then
                local function captureApply(id)
                    if not id then return end
                    if C_LFGList.GetSearchResultInfo then
                        local ok2, info = pcall(C_LFGList.GetSearchResultInfo, id)
                        if ok2 and info then
                            local actID = (info.activityIDs and #info.activityIDs > 0)
                                          and info.activityIDs[1] or info.activityID
                            local name = GetActivityName(actID)
                            local title = (info.name and info.name ~= "") and info.name or nil
                            appliedGroups[id] = { dungeon = name, title = title }
                            dbg("WWG stored apply #" .. id .. ": " .. tostring(name) .. " / " .. tostring(title))
                        end
                    end
                end
                for _, fn in ipairs({"ApplyToGroup", "SignUpForGroup", "RequestToJoin"}) do
                    if C_LFGList[fn] then
                        hooksecurefunc(C_LFGList, fn, captureApply)
                    end
                end
            end

            -- If already in group on login, restore note
            wasInRealGroup = GetNumGroupMembers() > 0
            prevGroupSize  = GetNumGroupMembers()
            if wasInRealGroup then
                shownForThisGroup = true
                if WhereWeGoDB.note then ns:Show(WhereWeGoDB.note) end
            end

        elseif event == "LFG_PROPOSAL_SHOW" then
            local ok2, exists, _, _, _, name = pcall(GetLFGProposal)
            if ok2 and exists and type(name) == "string" and name ~= "" then
                pendingDungeon = name
                dbg("WWG LFG proposal: " .. name)
            end

        elseif event == "LFG_LIST_APPLICATION_STATUS_UPDATED" then
            local appID, status = a1, a2
            dbg("WWG appStatus: id=" .. tostring(appID) .. " st=" .. tostring(status))

            -- Look up from our applied groups map first
            if appID and appliedGroups[appID] then
                local g = appliedGroups[appID]
                if g.dungeon and g.dungeon ~= "" then
                    pendingDungeon = g.dungeon
                end
                if g.title then
                    pendingTitle = g.title
                end
                dbg("WWG matched applied group #" .. appID .. ": " .. tostring(g.dungeon) .. " / " .. tostring(g.title))
            end

            -- Fallback: query the specific appID directly
            if not pendingDungeon and C_LFGList and appID and type(appID) == "number" then
                if C_LFGList.GetSearchResultInfo then
                    local ok2, info = pcall(C_LFGList.GetSearchResultInfo, appID)
                    if ok2 and info then
                        local actID = (info.activityIDs and #info.activityIDs > 0)
                                      and info.activityIDs[1] or info.activityID
                        if actID and actID ~= 0 then
                            local name = GetActivityName(actID)
                            if name and name ~= "" then
                                pendingDungeon = name
                                dbg("WWG captured via appStatus: " .. name)
                            end
                        end
                        if not pendingTitle and info.name and info.name ~= "" then
                            pendingTitle = info.name
                            dbg("WWG captured title via appStatus: " .. info.name)
                        end
                    end
                end
            end
            if not pendingDungeon then
                local ae = CaptureActiveEntry()
                if ae and ae ~= "" then
                    pendingDungeon = ae
                    dbg("WWG captured activeEntry at appStatus: " .. ae)
                end
            end

        elseif event == "LFG_LIST_ACTIVE_ENTRY_UPDATED" then
            -- Group creator path (listing updated = party filling up)
            if not (C_LFGList and C_LFGList.GetActiveEntryInfo) then return end
            local ok2, info = pcall(C_LFGList.GetActiveEntryInfo)
            if not ok2 or not info then return end
            local actIDs = info.activityIDs
            local actID  = (actIDs and #actIDs > 0) and actIDs[1] or info.activityID
            local name = GetActivityName(actID)
            if name and name ~= "" then
                pendingDungeon = name
            end

        elseif event == "GROUP_JOINED" then
            dbg("WWG EVENT: GROUP_JOINED members=" .. tostring(GetNumGroupMembers()) .. " pending=" .. tostring(pendingDungeon))
            OnGroupJoined("GROUP_JOINED")

        elseif event == "GROUP_ROSTER_UPDATE" then
            local n = GetNumGroupMembers()
            dbg("WWG EVENT: GROUP_ROSTER_UPDATE n=" .. n .. " was=" .. tostring(wasInRealGroup))
            if n > 0 and not wasInRealGroup then
                OnGroupJoined("GROUP_ROSTER_UPDATE")
            elseif n == 0 and wasInRealGroup then
                OnGroupLeft("GROUP_ROSTER_UPDATE")
            end

        elseif event == "GROUP_LEFT" then
            dbg("WWG EVENT: GROUP_LEFT")
            -- Reset state so the NEXT join is detected by all triggers.
            -- Don't clear pendingDungeon — Midnight fires GROUP_LEFT
            -- during personal→party transitions.
            shownForThisGroup = false
            wasInRealGroup    = false
            prevGroupSize     = 0
            ns:Hide()

        elseif event == "PARTY_LEADER_CHANGED" then
            if WhereWeGoDB and WhereWeGoDB.dungeon and GetNumGroupMembers() > 0 then
                local saved = shownForThisGroup
                shownForThisGroup = false
                ShowNote(WhereWeGoDB.dungeon, GetLeader(), WhereWeGoDB.title)
                if not WhereWeGoDB.dungeon then shownForThisGroup = saved end
            end

        elseif event == "ZONE_CHANGED_NEW_AREA" then
            if GetNumGroupMembers() <= 0 then return end
            if shownForThisGroup then return end
            local iName, iType = GetInstanceInfo()
            if iName and iName ~= "" and iType ~= "none" then
                ShowNote(iName, GetLeader())
            end
        end
    end)
    if not ok then
        print("|cffff0000WWG ERROR [" .. event .. "]: " .. tostring(err) .. "|r")
    end
end)

------------------------------------------------------------------------
-- Load message (Silvermoonmap pattern: dedicated frame + PLAYER_ENTERING_WORLD)
------------------------------------------------------------------------
local _wwgFirstLoad = true
local _wwgLoader = CreateFrame("Frame")
_wwgLoader:RegisterEvent("PLAYER_ENTERING_WORLD")
_wwgLoader:SetScript("OnEvent", function(self, event)
    if _wwgFirstLoad then
        _wwgFirstLoad = false
    end
end)

------------------------------------------------------------------------
-- Slash commands
------------------------------------------------------------------------
SLASH_WHEREWEGO1 = "/wwg"
SLASH_WHEREWEGO2 = "/wherewego"

SlashCmdList["WHEREWEGO"] = function(msg)
    msg = (msg or ""):lower():match("^%s*(.-)%s*$")

    if msg == "show" then
        if WhereWeGoDB and WhereWeGoDB.note then
            ns:Show(WhereWeGoDB.note)
        else
            print("|cff4499ffWhereWeGo:|r No active group note.")
        end
    elseif msg == "hide" then
        ns:Hide()
    elseif msg == "clear" then
        if WhereWeGoDB then
            WhereWeGoDB.dungeon = nil
            WhereWeGoDB.leader  = nil
            WhereWeGoDB.title   = nil
            WhereWeGoDB.note    = nil
        end
        ns:Hide()
        print("|cff4499ffWhereWeGo:|r Cleared.")
    elseif msg == "reset" then
        if WhereWeGoDB then WhereWeGoDB.pos = nil end
        ns.frame:ClearAllPoints()
        ns.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
        print("|cff4499ffWhereWeGo:|r Position reset.")
    elseif msg == "debug" then
        debugMode = not debugMode
        local ver = C_AddOns and C_AddOns.GetAddOnMetadata and
            C_AddOns.GetAddOnMetadata("WhereWeGo","Version") or "?"
        print("|cff4499ffWWG debug|r v"..ver .. " — debug " .. (debugMode and "ON" or "OFF"))
        print("  pendingDungeon=" .. tostring(pendingDungeon))
        print("  pendingTitle=" .. tostring(pendingTitle))
        print("  shownForThisGroup=" .. tostring(shownForThisGroup))
        print("  wasInRealGroup=" .. tostring(wasInRealGroup))
        print("  prevGroupSize=" .. tostring(prevGroupSize))
        print("  watcherTicks=" .. tostring(watcherTicks))
        print("  members=" .. tostring(GetNumGroupMembers()))
        print("  stored=" .. tostring(WhereWeGoDB and WhereWeGoDB.dungeon))
        print("  title=" .. tostring(WhereWeGoDB and WhereWeGoDB.title))
        print("  leader=" .. tostring(WhereWeGoDB and WhereWeGoDB.leader))
        if C_LFGList and C_LFGList.GetActiveEntryInfo then
            local ok, info = pcall(C_LFGList.GetActiveEntryInfo)
            if ok and info then
                local ids = info.activityIDs
                local id  = (ids and #ids > 0) and ids[1] or info.activityID
                print("  activeEntry=" .. tostring(GetActivityName(id)))
            else
                print("  activeEntry=nil")
            end
        end
        -- Show test popup
        ns:Show("|cff4499ffWWG test|r\nPopup works! v" .. ver)
    else
        local ver = C_AddOns and C_AddOns.GetAddOnMetadata and
            C_AddOns.GetAddOnMetadata("WhereWeGo","Version") or "?"
        print("|cff4499ffWhereWeGo|r v"..ver)
        print("  |cffffff00/wwg show|r  — show note")
        print("  |cffffff00/wwg hide|r  — hide frame")
        print("  |cffffff00/wwg clear|r — clear note")
        print("  |cffffff00/wwg reset|r — reset position")
        print("  |cffffff00/wwg debug|r — debug info")
    end
end
