local addonName, ns = ...

------------------------------------------------------------------------
-- Saved variable initialisation
------------------------------------------------------------------------
local function InitDB()
    if not WhereWeGoDB then
        WhereWeGoDB = {}
    end
end

------------------------------------------------------------------------
-- Korean → English name lookup tables
------------------------------------------------------------------------
local KO_TO_EN_DUNGEON = {
    -- Midnight new dungeons
    ["윈드러너 첨탑"]       = "Windrunner Spire",
    ["마법학자의 정원"]     = "Magisters' Terrace",
    ["죽음의 골목"]         = "Death's Row",
    ["날로라크의 소굴"]     = "Nalorakk's Den",
    ["마이사라 동굴"]       = "Maisara Caverns",
    ["공결탑 제나스"]       = "Nexus-Point Xenas",
    ["공결탑 제니스"]       = "Nexus-Point Xenas",
    ["눈부신 골짜기"]       = "Shining Vale",
    ["공허흉터 투기장"]     = "Voidscar Arena",
    -- Legacy rotation (Season 1)
    ["알게타르 대학"]       = "Algeth'ar Academy",
    ["알게타르 학원"]       = "Algeth'ar Academy",
    ["사론의 구덩이"]       = "Pit of Saron",
    ["삼두정의 권좌"]       = "Seat of the Triumvirate",
    ["삼두정의 옥좌"]       = "Seat of the Triumvirate",
    ["하늘탑"]             = "Skyreach",
    -- The War Within (TWW) dungeons
    ["아라카라, 메아리의 도시"] = "Ara-Kara, City of Echoes",
    ["착암기 광산"]         = "The Stonevault",
    ["시티 오브 스레드"]     = "City of Threads",
    ["어둠불꽃 거리"]       = "Darkflame Cleft",
    ["새벽인도자의 양조장"] = "The Dawnbreaker",
    ["아틀다자르 신전"]     = "Atal'Dazar",
    ["왕노릇의 대가"]       = "Siege of Boralus",
    ["하급 카라잔"]         = "Lower Karazhan",
    ["상급 카라잔"]         = "Upper Karazhan",
    -- TWW raids
    ["해방의 지하"]         = "Liberation of Undermine",
    ["네루바르 궁전"]       = "Nerub-ar Palace",
}

local KO_TO_EN_DIFFICULTY = {
    ["신화"]   = "Mythic",
    ["영웅"]   = "Heroic",
    ["일반"]   = "Normal",
    ["신화+"]  = "Mythic+",
    ["공격대 찾기"] = "LFR",
}

local DUNGEON_ZONE = {
    -- Midnight new dungeons (Korean keys)
    ["윈드러너 첨탑"]       = { "은빛소나무 숲", "Silverpine Forest" },
    ["마법학자의 정원"]     = { "은빛달 도시", "Silvermoon City" },
    ["죽음의 골목"]         = { "은빛달 도시", "Silvermoon City" },
    ["날로라크의 소굴"]     = { "줄아만", "Zul'Aman" },
    ["마이사라 동굴"]       = { "줄아만", "Zul'Aman" },
    ["공결탑 제나스"]       = { "공허폭풍", "Void Storm" },
    ["공결탑 제니스"]       = { "공허폭풍", "Void Storm" },
    ["눈부신 골짜기"]       = { "은빛소나무 숲", "Silverpine Forest" },
    ["공허흉터 투기장"]     = { "공허폭풍", "Void Storm" },
    -- Legacy season rotation (Korean keys)
    ["알게타르 대학"]       = { "탈드라서스", "Thaldraszus" },
    ["알게타르 학원"]       = { "탈드라서스", "Thaldraszus" },
    ["사론의 구덩이"]       = { "얼음왕관 성채", "Icecrown Citadel" },
    ["삼두정의 권좌"]       = { "아르거스", "Argus" },
    ["삼두정의 옥좌"]       = { "아르거스", "Argus" },
    ["하늘탑"]             = { "탈라도르", "Talador" },
    -- The War Within (Korean keys)
    ["아라카라, 메아리의 도시"] = { "아즈-카라즈", "Azj-Kahet" },
    ["착암기 광산"]         = { "켁나스", "Khaz Algar" },
    ["시티 오브 스레드"]     = { "아즈-카라즈", "Azj-Kahet" },
    ["어둠불꽃 거리"]       = { "울림 깊은 곳", "The Ringing Deeps" },
    ["새벽인도자의 양조장"] = { "아즈-카라즈", "Azj-Kahet" },
    ["아틀다자르 신전"]     = { "줄다자르", "Zuldazar" },
    ["왕노릇의 대가"]       = { "쿨 티라스", "Kul Tiras" },
    ["하급 카라잔"]         = { "카라잔", "Karazhan" },
    ["상급 카라잔"]         = { "카라잔", "Karazhan" },
    -- TWW raids (Korean keys)
    ["해방의 지하"]         = { "아제로스 지하", "Undermine" },
    ["네루바르 궁전"]       = { "아즈-카라즈", "Azj-Kahet" },
    -- English keys (for EN client users)
    ["Windrunner Spire"]        = { "Silverpine Forest", "Silverpine Forest" },
    ["Magisters' Terrace"]      = { "Silvermoon City", "Silvermoon City" },
    ["Death's Row"]             = { "Silvermoon City", "Silvermoon City" },
    ["Nalorakk's Den"]          = { "Zul'Aman", "Zul'Aman" },
    ["Maisara Caverns"]         = { "Zul'Aman", "Zul'Aman" },
    ["Nexus-Point Xenas"]       = { "Void Storm", "Void Storm" },
    ["Shining Vale"]            = { "Silverpine Forest", "Silverpine Forest" },
    ["Voidscar Arena"]          = { "Void Storm", "Void Storm" },
    ["Algeth'ar Academy"]       = { "Thaldraszus", "Thaldraszus" },
    ["Pit of Saron"]            = { "Icecrown Citadel", "Icecrown Citadel" },
    ["Seat of the Triumvirate"] = { "Argus", "Argus" },
    ["Skyreach"]                = { "Talador", "Talador" },
    ["Ara-Kara, City of Echoes"]= { "Azj-Kahet", "Azj-Kahet" },
    ["The Stonevault"]          = { "Khaz Algar", "Khaz Algar" },
    ["City of Threads"]         = { "Azj-Kahet", "Azj-Kahet" },
    ["Darkflame Cleft"]         = { "The Ringing Deeps", "The Ringing Deeps" },
    ["The Dawnbreaker"]         = { "Azj-Kahet", "Azj-Kahet" },
    ["Atal'Dazar"]              = { "Zuldazar", "Zuldazar" },
    ["Siege of Boralus"]        = { "Kul Tiras", "Kul Tiras" },
    ["Liberation of Undermine"] = { "Undermine", "Undermine" },
    ["Nerub-ar Palace"]         = { "Azj-Kahet", "Azj-Kahet" },
}

local CLIENT_LOCALE = GetLocale and GetLocale() or "enUS"

local function TranslateToEnglish(localizedName)
    -- No translation needed for English clients
    if CLIENT_LOCALE:match("^en") then return nil end
    if not localizedName or localizedName == "" then return nil end

    local baseName, diffKo = localizedName:match("^(.-)%s*%((.+)%)%s*$")
    if not baseName then baseName = localizedName end

    local enBase = KO_TO_EN_DUNGEON[strtrim(baseName)]
    if not enBase then return nil end

    if diffKo then
        local enDiff = KO_TO_EN_DIFFICULTY[strtrim(diffKo)]
        return enBase .. " (" .. (enDiff or diffKo) .. ")"
    end
    return enBase
end

local function GetDungeonZone(localizedName)
    if not localizedName or localizedName == "" then return nil end
    local baseName = localizedName:match("^(.-)%s*%(") or localizedName
    local entry = DUNGEON_ZONE[strtrim(baseName)]
    if not entry then return nil end
    -- For Korean clients show "koZone / enZone"; for others show just English zone
    if CLIENT_LOCALE == "koKR" and entry[1] ~= entry[2] then
        return entry[1] .. " / " .. entry[2]
    end
    return entry[2]
end

-- Returns realm-qualified name of the actual current group leader
local function GetActualLeader()
    if UnitIsGroupLeader("player") then
        local name, realm = UnitName("player")
        return (realm and realm ~= "") and (name .. "-" .. realm) or name
    end
    local maxMembers = IsInRaid() and 40 or 4
    local prefix = IsInRaid() and "raid" or "party"
    for i = 1, maxMembers do
        local unit = prefix .. i
        if UnitExists(unit) and UnitIsGroupLeader(unit) then
            local name, realm = UnitName(unit)
            return (realm and realm ~= "") and (name .. "-" .. realm) or name
        end
    end
    return nil
end

-- Captured at apply-time — all three sources feed pendingActName
local pendingTitle   = nil  -- human-written listing title
local pendingComment = nil  -- listing comment
local pendingLeader  = nil  -- leader name from the search result
local pendingActName = nil  -- dungeon name resolved while search result is still valid
local pendingSearchID = nil -- kept so we can re-query on invite acceptance

------------------------------------------------------------------------
-- Event handler frame
------------------------------------------------------------------------
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("GROUP_JOINED")
eventFrame:RegisterEvent("GROUP_LEFT")
eventFrame:RegisterEvent("LFG_PROPOSAL_SHOW")
eventFrame:RegisterEvent("PARTY_LEADER_CHANGED")
eventFrame:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED")

------------------------------------------------------------------------
-- Helper: resolve activity name from activityID using multiple fallbacks
------------------------------------------------------------------------
local function GetActivityName(activityID)
    if not activityID or activityID == 0 then return "" end

    -- Method 1: Blizzard's own global helper (defined in Blizzard_GroupFinder)
    if GetLFGActivityFullNameFromID then
        local name = GetLFGActivityFullNameFromID(activityID)
        if name and name ~= "" then return name end
    end

    -- Method 2: GetActivityInfoTable (returns a table)
    if C_LFGList.GetActivityInfoTable then
        local actInfo = C_LFGList.GetActivityInfoTable(activityID)
        if actInfo then
            if actInfo.fullName and actInfo.fullName ~= "" then return actInfo.fullName end
            if actInfo.shortName and actInfo.shortName ~= "" then return actInfo.shortName end
        end
    end

    -- Method 3: GetActivityInfo (returns multiple values: fullName, shortName, ...)
    if C_LFGList.GetActivityInfo then
        local fullName, shortName = C_LFGList.GetActivityInfo(activityID)
        if fullName and fullName ~= "" then return fullName end
        if shortName and shortName ~= "" then return shortName end
    end

    return ""
end

------------------------------------------------------------------------
-- Build the full display string from stored noteBase + currentLeader
-- Call this whenever noteBase or currentLeader changes.
------------------------------------------------------------------------
local function BuildAndShowNote()
    if not WhereWeGoDB.noteBase then return end
    local note = WhereWeGoDB.noteBase
    local leader = WhereWeGoDB.currentLeader
    if leader and leader ~= "" then
        note = note .. "\n|cff99bbff[Leader] " .. leader .. "|r"
    end
    WhereWeGoDB.currentNote = note
    ns:ShowNote(note)
end

------------------------------------------------------------------------
-- Shared capture helper — builds note body (WITHOUT leader) from a search result
------------------------------------------------------------------------
-- Placeholder group titles to filter out
local PLACEHOLDER_LIST = {
    -- Korean
    "무엇인가",
    -- English
    "something", "untitled", "m0", "m+",
    -- German
    "etwas",
    -- French
    "quelque chose",
    -- Chinese (Simplified/Traditional)
    "某事", "某些事情",
    -- Spanish/Portuguese
    "algo",
    -- Russian
    "что-то",
}
local function IsPlaceholder(title)
    if not title or title == "" then return true end
    -- Use tostring() to force kstring → real Lua string for reliable comparison
    local tl = tostring(title):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if tl == "" then return true end
    for _, p in ipairs(PLACEHOLDER_LIST) do
        if tl == p or tl:find(p, 1, true) then return true end
    end
    return false
end

-- Capture everything available from a search result entry.
-- Called at ApplyToGroup time AND again when the invite popup appears.
local function CaptureListingInfo(searchResultID)
    if not C_LFGList or not C_LFGList.GetSearchResultInfo then return end
    local info = C_LFGList.GetSearchResultInfo(searchResultID)
    if not info then return end

    pendingSearchID = searchResultID

    -- Raw title (kstring safe via tostring)
    local rawTitle = tostring(info.name or "")
    pendingTitle   = (not IsPlaceholder(rawTitle)) and strtrim(rawTitle) or nil
    pendingComment = (type(info.comment) == "string" and info.comment ~= "") and info.comment or nil
    pendingLeader  = info.leaderName

    -- Resolve dungeon name NOW while the search result is still in memory
    local actID = info.activityID
    if (not actID or actID == 0) and info.activityIDs and #info.activityIDs > 0 then
        actID = info.activityIDs[1]
    end
    local name = GetActivityName(actID)
    if name and name ~= "" then
        pendingActName = name
    end
end

------------------------------------------------------------------------
-- Hook ApplyToGroup & SignUpForGroup
------------------------------------------------------------------------
if C_LFGList then
    if C_LFGList.ApplyToGroup then
        hooksecurefunc(C_LFGList, "ApplyToGroup", function(searchResultID)
            CaptureListingInfo(searchResultID)
        end)
    end
    if C_LFGList.SignUpForGroup then
        hooksecurefunc(C_LFGList, "SignUpForGroup", function(searchResultID)
            CaptureListingInfo(searchResultID)
        end)
    end
end

------------------------------------------------------------------------
-- Shared helper: build note from the group's ACTIVE LFG entry.
-- Called after joining (with a short delay so the entry syncs).
------------------------------------------------------------------------
local function BuildNoteFromActiveEntry(savedActName, savedTitle, savedComment, savedLeader)
    if not (IsInGroup() or IsInRaid()) then return end

    local actName = savedActName  -- from apply-time capture (most reliable)

    -- Try GetActiveEntryInfo as a cross-check / fallback for direct invites
    local entryInfo = C_LFGList and C_LFGList.GetActiveEntryInfo and C_LFGList.GetActiveEntryInfo()
    if entryInfo then
        local actIDs = entryInfo.activityIDs
        if actIDs and #actIDs > 0 then
            local freshName = GetActivityName(actIDs[1])
            -- Only override apply-time name if we got something meaningful
            if freshName and freshName ~= "" then
                actName = freshName
            end
        end
    end

    local parts = {}
    if actName and actName ~= "" then
        table.insert(parts, "|cff00cc66" .. actName .. "|r")
        local enName = TranslateToEnglish(actName)
        if enName then
            table.insert(parts, "|cffcccccc" .. enName .. "|r")
        end
        local zone = GetDungeonZone(actName)
        if zone then
            table.insert(parts, "|cffddaa00[Location] " .. zone .. "|r")
        end
    end
    if savedTitle and savedTitle ~= actName then
        table.insert(parts, "|cffffffff[Title]|r " .. savedTitle)
    end
    if savedComment then
        table.insert(parts, "|cffaaaaaa" .. savedComment .. "|r")
    end

    if #parts > 0 then
        WhereWeGoDB.noteBase = table.concat(parts, "\n")
    end

    WhereWeGoDB.currentLeader = GetActualLeader() or savedLeader
    if WhereWeGoDB.noteBase then
        BuildAndShowNote()
    end
end
------------------------------------------------------------------------
-- Event dispatcher
------------------------------------------------------------------------
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        InitDB()
        ns:RestorePosition()

        -- Clean up legacy / old fields
        WhereWeGoDB.pendingNote    = nil
        WhereWeGoDB.currentNote    = nil
        WhereWeGoDB.pendingNoteBase = nil

        if IsInGroup() or IsInRaid() then
            if WhereWeGoDB.noteBase then BuildAndShowNote() end
            C_Timer.After(2.0, function()
                BuildNoteFromActiveEntry(nil, nil, nil, nil)
            end)
        else
            WhereWeGoDB.noteBase      = nil
            WhereWeGoDB.currentLeader = nil
        end

        -- Hook the invite confirmation dialog (the popup shown after leader accepts).
        -- It has the dungeon name visually — we grab it from the activity label.
        C_Timer.After(1.0, function()
            local dialog = LFGListInviteDialog or (_G and _G["LFGListInviteDialog"])
            if dialog then
                dialog:HookScript("OnShow", function(self)
                    -- Try reading activity text children (label order varies by locale)
                    if self.ActivityName and self.ActivityName.GetText then
                        local txt = strtrim(self.ActivityName:GetText() or "")
                        if txt ~= "" and not IsPlaceholder(txt) then
                            pendingActName = txt
                            return
                        end
                    end
                    -- Fallback: use GetApplications at show time (data is fresh)
                    if C_LFGList and C_LFGList.GetApplications then
                        local apps = C_LFGList.GetApplications()
                        for _, app in ipairs(apps or {}) do
                            local info = (type(app) == "table") and app or
                                         (C_LFGList.GetApplicationInfo and C_LFGList.GetApplicationInfo(app))
                            if info and info.activityID and info.activityID ~= 0 then
                                local name = GetActivityName(info.activityID)
                                if name and name ~= "" then
                                    pendingActName = name
                                    break
                                end
                            end
                        end
                    end
                end)
            end
        end)

    elseif event == "LFG_LIST_APPLICATION_STATUS_UPDATED" then
        -- Fires when leader accepts our application = the invite popup appears.
        -- GetApplications() gives us the activityID directly — most reliable source.
        if not C_LFGList or not C_LFGList.GetApplications then return end
        local apps = C_LFGList.GetApplications()
        if not apps then return end
        for _, app in ipairs(apps) do
            -- app may be a table (newer API) or an ID (older API)
            local appInfo = (type(app) == "table") and app or
                            (C_LFGList.GetApplicationInfo and C_LFGList.GetApplicationInfo(app))
            if appInfo then
                local status = appInfo.status or ""
                if status == "invited" or status == "inviteDeclined" or status == "invitePending" then
                    -- Prefer activityID from the application directly
                    local actID = appInfo.activityID
                    if actID and actID ~= 0 then
                        local name = GetActivityName(actID)
                        if name and name ~= "" then
                            pendingActName = name
                        end
                    end
                    -- Do NOT call CaptureListingInfo here — at invite time info.name
                    -- can return the locale placeholder (e.g. "무엇인가"), overwriting
                    -- the correct title captured at apply-time.
                    break
                end
            end
        end

    elseif event == "GROUP_JOINED" then
        -- Always start fresh
        WhereWeGoDB.noteBase      = nil
        WhereWeGoDB.currentLeader = nil

        -- Grab and immediately consume all apply-time captured data
        local an, t, c, l = pendingActName, pendingTitle, pendingComment, pendingLeader
        pendingActName = nil
        pendingTitle   = nil
        pendingComment = nil
        pendingLeader  = nil
        -- Keep pendingSearchID until GROUP_LEFT in case we need it

        -- Wait 2s for GetActiveEntryInfo to reflect the new group
        C_Timer.After(2.0, function()
            BuildNoteFromActiveEntry(an, t, c, l)
        end)

    elseif event == "PARTY_LEADER_CHANGED" then
        if WhereWeGoDB.noteBase and (IsInGroup() or IsInRaid()) then
            local leader = GetActualLeader()
            if leader then
                WhereWeGoDB.currentLeader = leader
                BuildAndShowNote()
            end
        end

    elseif event == "GROUP_LEFT" then
        -- Safe to clear everything
        WhereWeGoDB.noteBase      = nil
        WhereWeGoDB.currentLeader = nil
        WhereWeGoDB.currentNote   = nil
        pendingActName = nil
        pendingTitle   = nil
        pendingComment = nil
        pendingLeader  = nil
        pendingSearchID = nil
        ns:HideNote()

    elseif event == "LFG_PROPOSAL_SHOW" then
        -- Random LFG (dungeon finder): GetLFGProposal has the name
        local ok, proposalExists, id, typeID, subtypeID, pName = pcall(GetLFGProposal)
        if ok and proposalExists and type(pName) == "string" and pName ~= "" then
            local parts = {}
            table.insert(parts, "|cff4499ff[LFG]|r " .. pName)
            local zone = GetDungeonZone(pName)
            if zone then table.insert(parts, "|cffddaa00[Location] " .. zone .. "|r") end
            WhereWeGoDB.noteBase = table.concat(parts, "\n")
        end
    end
end)

------------------------------------------------------------------------
-- Slash commands
------------------------------------------------------------------------
SLASH_WHEREWEGO1 = "/wwg"
SLASH_WHEREWEGO2 = "/wherewego"

SlashCmdList["WHEREWEGO"] = function(msg)
    msg = strtrim(msg):lower()

    if msg == "show" then
        if WhereWeGoDB and WhereWeGoDB.noteBase then
            BuildAndShowNote()
        else
            print("|cff4499ffWhereWeGo:|r No active group note.")
        end

    elseif msg == "hide" then
        ns:HideNote()

    elseif msg == "clear" then
        WhereWeGoDB.noteBase = nil
        WhereWeGoDB.currentLeader = nil
        WhereWeGoDB.currentNote = nil
        ns:HideNote()
        print("|cff4499ffWhereWeGo:|r Note cleared.")

    elseif msg == "reset" then
        WhereWeGoDB.position = nil
        ns.frame:ClearAllPoints()
        ns.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
        print("|cff4499ffWhereWeGo:|r Frame position reset.")

    elseif msg == "debug" then
        local version = C_AddOns and C_AddOns.GetAddOnMetadata and
            C_AddOns.GetAddOnMetadata("WhereWeGo", "Version") or "unknown"
        print("|cff4499ffWhereWeGo Debug:|r  version=" .. tostring(version) .. "  locale=" .. tostring(CLIENT_LOCALE))
        print("  GetLFGActivityFullNameFromID: " .. tostring(GetLFGActivityFullNameFromID ~= nil))
        print("  GetActivityInfoTable: " .. tostring(C_LFGList and C_LFGList.GetActivityInfoTable ~= nil))
        print("  GetActivityInfo: " .. tostring(C_LFGList and C_LFGList.GetActivityInfo ~= nil))
        print("  GetActiveEntryInfo: " .. tostring(C_LFGList and C_LFGList.GetActiveEntryInfo ~= nil))
        print("  pendingTitle: " .. tostring(pendingTitle) .. "  pendingActName: " .. tostring(pendingActName))
        print("  noteBase: " .. tostring(WhereWeGoDB and WhereWeGoDB.noteBase))
        print("  currentLeader: " .. tostring(WhereWeGoDB and WhereWeGoDB.currentLeader))
        print("  InGroup: " .. tostring(IsInGroup()) .. "  InRaid: " .. tostring(IsInRaid()))
        print("  ActualLeader: " .. tostring(GetActualLeader()))
        local ok, proposalExists, id, typeID, subtypeID, pName = pcall(GetLFGProposal)
        print("  GetLFGProposal: ok=" .. tostring(ok) .. " exists=" .. tostring(proposalExists)
              .. " name=" .. tostring(pName))
        if C_LFGList.GetActivityInfoTable then
            local ok2, info = pcall(C_LFGList.GetActivityInfoTable, 1193)
            print("  Test actID 1193: ok=" .. tostring(ok2) .. " type=" .. type(info))
            if ok2 and type(info) == "table" then
                print("    fullName=" .. tostring(info.fullName))
            end
        end

    else
        print("|cff4499ffWhereWeGo|r v1.0.0")
        print("  |cffffff00/wwg show|r  — Show current group note")
        print("  |cffffff00/wwg hide|r  — Hide the note frame")
        print("  |cffffff00/wwg clear|r — Clear saved note (use when note is stale)")
        print("  |cffffff00/wwg reset|r — Reset frame position to centre")
        print("  |cffffff00/wwg debug|r — Show debug info")
    end
end
