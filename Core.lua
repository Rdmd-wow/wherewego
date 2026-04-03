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
-- Helpers
------------------------------------------------------------------------
local function Translate(name)
    if not name then return nil end
    return KO_EN[name]
end

local function GetZone(name)
    if not name then return nil end
    local en = KO_EN[name] or name
    return ZONE[en]
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
    -- Fallback: return party1 name (likely the inviter/leader)
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

local function BuildLines(dungeon, leader)
    local lines = {}
    if dungeon and dungeon ~= "" then
        lines[#lines+1] = "|cff00cc66" .. dungeon .. "|r"
        local en = Translate(dungeon)
        if en then lines[#lines+1] = "|cffcccccc" .. en .. "|r" end
        local zone = GetZone(dungeon)
        if zone then lines[#lines+1] = "|cffddaa00[위치] " .. zone .. "|r" end
    else
        lines[#lines+1] = "|cff888888(dungeon unknown)|r"
    end
    if leader and leader ~= "" then
        lines[#lines+1] = "|cff99bbff[파티장] " .. leader .. "|r"
    end
    return table.concat(lines, "\n")
end

local function ShowNote(dungeon, leader, printChat)
    if not WhereWeGoDB then return end
    local note = BuildLines(dungeon, leader)
    WhereWeGoDB.dungeon = dungeon
    WhereWeGoDB.leader  = leader
    WhereWeGoDB.note    = note
    ns:Show(note)
    if printChat and dungeon and dungeon ~= "" then
        local en = Translate(dungeon)
        local msg = dungeon .. (en and (" / " .. en) or "")
        if leader then msg = msg .. "  [파티장] " .. leader end
        print("|cff4499ffWhereWeGo:|r " .. msg)
    end
end

------------------------------------------------------------------------
-- Pending state  (MUST be declared before any function that references them)
------------------------------------------------------------------------
local pendingDungeon = nil
local pendingLFGNote = nil   -- from LFG_PROPOSAL_SHOW path
local wasInGroup     = false -- for GROUP_ROSTER_UPDATE dedup

-- Shared logic for GROUP_JOINED / GROUP_ROSTER_UPDATE
local function OnGroupJoined()
    local dungeon = pendingDungeon
    local lfgNote = pendingLFGNote
    pendingDungeon = nil
    pendingLFGNote = nil
    wasInGroup     = true

    local leader = GetLeader()

    if lfgNote then
        if WhereWeGoDB then
            WhereWeGoDB.note    = lfgNote
            WhereWeGoDB.leader  = leader
            WhereWeGoDB.dungeon = dungeon
        end
        ns:Show(lfgNote)
    elseif dungeon and dungeon ~= "" then
        ShowNote(dungeon, leader, true)
    else
        -- No LFG info — poll after a short delay
        C_Timer.After(2, function()
            if not (IsInGroup() or IsInRaid()) then return end
            local actName
            if C_LFGList and C_LFGList.GetActiveEntryInfo then
                local ok, info = pcall(C_LFGList.GetActiveEntryInfo)
                if ok and info then
                    local ids = info.activityIDs
                    local id  = (ids and #ids > 0) and ids[1] or info.activityID
                    actName = GetActivityName(id)
                end
            end
            if not actName or actName == "" then
                local iName, iType = GetInstanceInfo()
                if iName and iName ~= "" and iType ~= "none" then
                    actName = iName
                end
            end
            if actName and actName ~= "" then
                ShowNote(actName, GetLeader(), true)
            else
                -- Still unknown — show frame so user knows addon is active
                ShowNote(nil, GetLeader(), false)
            end
        end)
    end
end

------------------------------------------------------------------------
-- Slash commands  (registered at top of execution, cannot be blocked)
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
        local ver = C_AddOns and C_AddOns.GetAddOnMetadata and
            C_AddOns.GetAddOnMetadata("WhereWeGo","Version") or "?"
        print("|cff4499ffWWG debug|r v"..ver)
        print("  pendingDungeon=" .. tostring(pendingDungeon))
        print("  pendingLFGNote=" .. tostring(pendingLFGNote))
        print("  stored dungeon=" .. tostring(WhereWeGoDB and WhereWeGoDB.dungeon))
        print("  leader=" .. tostring(WhereWeGoDB and WhereWeGoDB.leader))
        print("  InGroup="..tostring(IsInGroup()).."  InRaid="..tostring(IsInRaid()))
        print("  GetLFGActivityFullNameFromID=" .. tostring(GetLFGActivityFullNameFromID ~= nil))
        if C_LFGList then
            print("  ApplyToGroup=" .. tostring(C_LFGList.ApplyToGroup ~= nil))
            print("  SignUpForGroup=" .. tostring(C_LFGList.SignUpForGroup ~= nil))
            print("  RequestToJoin=" .. tostring(C_LFGList.RequestToJoin ~= nil))
            print("  GetSearchResultInfo=" .. tostring(C_LFGList.GetSearchResultInfo ~= nil))
            print("  GetApplicationInfo=" .. tostring(C_LFGList.GetApplicationInfo ~= nil))
            print("  GetApplications=" .. tostring(C_LFGList.GetApplications ~= nil))
            print("  GetActivityInfoTable=" .. tostring(C_LFGList.GetActivityInfoTable ~= nil))
            print("  GetActiveEntryInfo=" .. tostring(C_LFGList.GetActiveEntryInfo ~= nil))
            -- Try active entry now
            if C_LFGList.GetActiveEntryInfo then
                local ok, info = pcall(C_LFGList.GetActiveEntryInfo)
                if ok and info then
                    local ids = info.activityIDs
                    local id  = (ids and #ids > 0) and ids[1] or info.activityID
                    print("  activeEntry actID=" .. tostring(id))
                    if id then print("  activeEntry name=" .. tostring(GetActivityName(id))) end
                else
                    print("  activeEntry=nil/error")
                end
            end
        end

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

------------------------------------------------------------------------
-- Event handler
------------------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("GROUP_JOINED")
f:RegisterEvent("GROUP_ROSTER_UPDATE")   -- backup: fires on any roster change
f:RegisterEvent("GROUP_LEFT")
f:RegisterEvent("PARTY_LEADER_CHANGED")
f:RegisterEvent("LFG_PROPOSAL_SHOW")
f:RegisterEvent("LFG_LIST_ACTIVE_ENTRY_UPDATED")
f:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")
f:RegisterEvent("PLAYER_ROLES_ASSIGNED")  -- fires after role check accepted
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")

f:SetScript("OnEvent", function(_, event, ...)

    if event == "PLAYER_LOGIN" then
        if not WhereWeGoDB then WhereWeGoDB = {} end
        ns:RestorePos()
        local ver = C_AddOns and C_AddOns.GetAddOnMetadata and
            C_AddOns.GetAddOnMetadata("WhereWeGo","Version") or "?"
        print("|cff4499ffWhereWeGo|r v"..ver.." By Rdmdp-Tichondrius  /wwg for help")
        -- Hook apply/signup now (safe inside event handler)
        if C_LFGList then
            local function captureFromSearchResult(id)
                if not id then return end
                if C_LFGList.GetSearchResultInfo then
                    local ok, info = pcall(C_LFGList.GetSearchResultInfo, id)
                    if ok and info then
                        local actID = (info.activityIDs and #info.activityIDs > 0)
                                      and info.activityIDs[1] or info.activityID
                        local name = GetActivityName(actID)
                        if name and name ~= "" then
                            pendingDungeon = name
                            print("|cff4499ffWWG:|r captured: " .. name)
                        end
                    end
                end
            end
            -- Hook whichever apply function exists
            for _, fn in ipairs({"ApplyToGroup","SignUpForGroup","RequestToJoin"}) do
                if C_LFGList[fn] then
                    hooksecurefunc(C_LFGList, fn, captureFromSearchResult)
                end
            end
        end
        -- If already in group on login, restore note
        wasInGroup = IsInGroup() or IsInRaid()
        if wasInGroup and WhereWeGoDB.note then
            ns:Show(WhereWeGoDB.note)
        end

    elseif event == "LFG_PROPOSAL_SHOW" then
        -- Random LFG queue path
        local ok, exists, _, _, _, name = pcall(GetLFGProposal)
        if ok and exists and type(name) == "string" and name ~= "" then
            pendingDungeon = name
            local leader = GetLeader()
            pendingLFGNote = BuildLines(name, leader)
            print("|cff4499ffWhereWeGo:|r " .. name)
        end

    elseif event == "LFG_LIST_APPLICATION_STATUS_UPDATED" then
        -- Args: applicationID, newStatus
        local appID, status = ...
        print("|cff888888WWG appStatus:|r appID=" .. tostring(appID) .. " status=" .. tostring(status))
        -- Try using the event's applicationID directly
        if C_LFGList and appID and type(appID) == "number" then
            if C_LFGList.GetApplicationInfo then
                local ok, info = pcall(C_LFGList.GetApplicationInfo, appID)
                if ok and info then
                    local actID = info.activityID or (info.activityIDs and info.activityIDs[1])
                    print("|cff888888WWG appInfo:|r actID=" .. tostring(actID))
                    if actID and actID ~= 0 then
                        local name = GetActivityName(actID)
                        if name and name ~= "" then
                            pendingDungeon = name
                            print("|cff4499ffWWG:|r captured via appInfo: " .. name)
                        end
                    end
                end
            end
            if not pendingDungeon and C_LFGList.GetSearchResultInfo then
                local ok, info = pcall(C_LFGList.GetSearchResultInfo, appID)
                if ok and info then
                    local actID = (info.activityIDs and #info.activityIDs > 0)
                                  and info.activityIDs[1] or info.activityID
                    if actID and actID ~= 0 then
                        local name = GetActivityName(actID)
                        if name and name ~= "" then
                            pendingDungeon = name
                            print("|cff4499ffWWG:|r captured via searchResult: " .. name)
                        end
                    end
                end
            end
        end
        if not pendingDungeon and C_LFGList and C_LFGList.GetApplications then
            local ok, apps = pcall(C_LFGList.GetApplications)
            if ok and apps then
                for _, app in ipairs(apps) do
                    local appInfo = (type(app) == "table") and app or
                        (C_LFGList.GetApplicationInfo and select(2, pcall(C_LFGList.GetApplicationInfo, app)))
                    if appInfo then
                        local actID = appInfo.activityID or (appInfo.activityIDs and appInfo.activityIDs[1])
                        if actID and actID ~= 0 then
                            local name = GetActivityName(actID)
                            if name and name ~= "" then
                                pendingDungeon = name
                                print("|cff4499ffWWG:|r captured via apps scan: " .. name)
                                break
                            end
                        end
                    end
                end
            end
        end

    elseif event == "PLAYER_ROLES_ASSIGNED" then
        -- Fires after role check is confirmed, right before GROUP_JOINED
        -- Good last chance to capture dungeon name
        if pendingDungeon then return end
        if C_LFGList and C_LFGList.GetActiveEntryInfo then
            local ok, info = pcall(C_LFGList.GetActiveEntryInfo)
            if ok and info then
                local ids = info.activityIDs
                local id  = (ids and #ids > 0) and ids[1] or info.activityID
                local name = GetActivityName(id)
                if name and name ~= "" then
                    pendingDungeon = name
                    print("|cff4499ffWWG:|r captured via roles assigned: " .. name)
                end
            end
        end

    elseif event == "LFG_LIST_ACTIVE_ENTRY_UPDATED" then
        -- Group creator path (never gets GROUP_JOINED)
        if not (C_LFGList and C_LFGList.GetActiveEntryInfo) then return end
        local ok, info = pcall(C_LFGList.GetActiveEntryInfo)
        if not ok or not info then return end
        local actIDs = info.activityIDs
        local actID  = (actIDs and #actIDs > 0) and actIDs[1] or info.activityID
        local name = GetActivityName(actID)
        if name and name ~= "" and WhereWeGoDB then
            ShowNote(name, GetLeader(), true)
        end

    elseif event == "GROUP_JOINED" then
        wasInGroup = true
        OnGroupJoined()

    elseif event == "GROUP_ROSTER_UPDATE" then
        local nowIn = IsInGroup() or IsInRaid()
        if nowIn and not wasInGroup then
            -- just joined — GROUP_JOINED may not have fired
            OnGroupJoined()
        elseif not nowIn and wasInGroup then
            wasInGroup = false
        end

    elseif event == "PARTY_LEADER_CHANGED" then
        if WhereWeGoDB and WhereWeGoDB.dungeon and (IsInGroup() or IsInRaid()) then
            ShowNote(WhereWeGoDB.dungeon, GetLeader(), false)
        end

    elseif event == "GROUP_LEFT" then
        pendingDungeon = nil
        pendingLFGNote = nil
        wasInGroup     = false
        if WhereWeGoDB then
            WhereWeGoDB.dungeon = nil
            WhereWeGoDB.leader  = nil
            WhereWeGoDB.note    = nil
        end
        ns:Hide()

    elseif event == "ZONE_CHANGED_NEW_AREA" then
        if not (IsInGroup() or IsInRaid()) then return end
        if not (WhereWeGoDB and WhereWeGoDB.note) then return end
        if not WhereWeGoDB.note:find("dungeon unknown", 1, true) then return end
        local iName, iType = GetInstanceInfo()
        if iName and iName ~= "" and iType ~= "none" then
            ShowNote(iName, GetLeader(), true)
        end
    end
end)
