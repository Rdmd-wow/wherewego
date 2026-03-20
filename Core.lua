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

-- File-level variable: leader captured at apply time, used for post-join validation
local pendingLeader = nil

------------------------------------------------------------------------
-- Event handler frame
------------------------------------------------------------------------
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("GROUP_JOINED")
eventFrame:RegisterEvent("GROUP_LEFT")
eventFrame:RegisterEvent("LFG_PROPOSAL_SHOW")
eventFrame:RegisterEvent("PARTY_LEADER_CHANGED")

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

local function CaptureListingInfo(searchResultID)
    if not C_LFGList or not C_LFGList.GetSearchResultInfo then return end

    local info = C_LFGList.GetSearchResultInfo(searchResultID)
    if not info then return end

    -- Guard: info.name may be a number (0) in some API versions
    local title = type(info.name) == "string" and strtrim(info.name) or ""
    -- Try activityID, fall back to first element of activityIDs if available
    local actID = info.activityID
    if (not actID or actID == 0) and info.activityIDs and #info.activityIDs > 0 then
        actID = info.activityIDs[1]
    end

    local actName = GetActivityName(actID)
    local enName = TranslateToEnglish(actName)
    local zone = GetDungeonZone(actName)
    pendingLeader = info.leaderName  -- saved separately; NOT embedded in the note body
    local parts = {}

    if actName ~= "" then
        table.insert(parts, "|cff00cc66" .. actName .. "|r")
    end
    if enName and enName ~= actName then
        table.insert(parts, "|cffcccccc" .. enName .. "|r")
    end
    if zone then
        table.insert(parts, "|cffddaa00[Location] " .. zone .. "|r")
    end

    -- Listing title (skip generic placeholders)
    if not IsPlaceholder(title) and title ~= actName then
        table.insert(parts, "|cffffffff[Title]|r " .. tostring(title))
    end

    -- Leader comment (guard: comment may be number 0 from API)
    if type(info.comment) == "string" and info.comment ~= "" then
        table.insert(parts, "|cffaaaaaa" .. info.comment .. "|r")
    end

    -- Fallback
    if #parts == 0 then
        table.insert(parts, title ~= "" and title or "Unknown Group")
    end

    -- Store as note BODY (leader will be appended live by BuildAndShowNote)
    WhereWeGoDB.pendingNoteBase = table.concat(parts, "\n")
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
-- Event dispatcher
------------------------------------------------------------------------
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        InitDB()
        ns:RestorePosition()

        -- Clean up legacy fields
        WhereWeGoDB.pendingNote = nil
        WhereWeGoDB.currentNote = nil

        if IsInGroup() or IsInRaid() then
            -- Show saved note immediately (may be stale — will be overwritten below)
            if WhereWeGoDB.noteBase then
                BuildAndShowNote()
            end
            -- After roster settles, always pull fresh data from the group's active listing
            C_Timer.After(2.0, function()
                if not (IsInGroup() or IsInRaid()) then return end

                local entryInfo = C_LFGList and C_LFGList.GetActiveEntryInfo and C_LFGList.GetActiveEntryInfo()
                if entryInfo and entryInfo.activityIDs and #entryInfo.activityIDs > 0 then
                    local actName = GetActivityName(entryInfo.activityIDs[1])
                    if actName and actName ~= "" then
                        local parts = {}
                        table.insert(parts, "|cff00cc66" .. actName .. "|r")
                        local enName = TranslateToEnglish(actName)
                        if enName and enName ~= actName then
                            table.insert(parts, "|cffcccccc" .. enName .. "|r")
                        end
                        local zone = GetDungeonZone(actName)
                        if zone then
                            table.insert(parts, "|cffddaa00[Location] " .. zone .. "|r")
                        end
                        WhereWeGoDB.noteBase = table.concat(parts, "\n")
                    end
                end

                local actualLeader = GetActualLeader()
                if actualLeader then
                    WhereWeGoDB.currentLeader = actualLeader
                end
                if WhereWeGoDB.noteBase then
                    BuildAndShowNote()
                end
            end)
        else
            -- Not in a group — clear everything
            WhereWeGoDB.noteBase = nil
            WhereWeGoDB.currentLeader = nil
            WhereWeGoDB.pendingNoteBase = nil
        end

    elseif event == "GROUP_JOINED" then
        -- Always wipe any stale note from a previous group first.
        -- This ensures a direct invite never inherits old SavedVars data.
        WhereWeGoDB.noteBase = nil
        WhereWeGoDB.currentLeader = nil

        if WhereWeGoDB.pendingNoteBase then
            -- Store as fallback but do NOT show yet — wait for the timer to confirm fresh data.
            WhereWeGoDB.noteBase = WhereWeGoDB.pendingNoteBase
            WhereWeGoDB.pendingNoteBase = nil
            WhereWeGoDB.currentLeader = pendingLeader
            pendingLeader = nil
        end

        -- Always run this timer: corrects leader + fills dungeon info for direct invites.
        -- If we already have noteBase from ApplyToGroup, keep it — only use GetActiveEntryInfo
        -- as a fallback for direct invites (where pendingNoteBase was nil).
        local hadPendingNote = WhereWeGoDB.noteBase ~= nil
        C_Timer.After(1.5, function()
            if not (IsInGroup() or IsInRaid()) then return end

            -- Only attempt dungeon lookup if we have no info yet (direct invite)
            if not hadPendingNote then
                local entryInfo = C_LFGList and C_LFGList.GetActiveEntryInfo and C_LFGList.GetActiveEntryInfo()
                if entryInfo and entryInfo.activityIDs and #entryInfo.activityIDs > 0 then
                    local actName = GetActivityName(entryInfo.activityIDs[1])
                    if actName and actName ~= "" then
                        local parts = {}
                        table.insert(parts, "|cff00cc66" .. actName .. "|r")
                        local enName = TranslateToEnglish(actName)
                        if enName and enName ~= actName then
                            table.insert(parts, "|cffcccccc" .. enName .. "|r")
                        end
                        local zone = GetDungeonZone(actName)
                        if zone then
                            table.insert(parts, "|cffddaa00[Location] " .. zone .. "|r")
                        end
                        WhereWeGoDB.noteBase = table.concat(parts, "\n")
                    end
                end
            end

            -- Always correct the leader after roster settles
            local actualLeader = GetActualLeader()
            if actualLeader then
                WhereWeGoDB.currentLeader = actualLeader
            end
            if WhereWeGoDB.noteBase then
                BuildAndShowNote()
            end
        end)

    elseif event == "PARTY_LEADER_CHANGED" then
        -- Keep the leader line current whenever leadership changes
        if WhereWeGoDB.noteBase and (IsInGroup() or IsInRaid()) then
            local actualLeader = GetActualLeader()
            if actualLeader then
                WhereWeGoDB.currentLeader = actualLeader
                BuildAndShowNote()
            end
        end

    elseif event == "GROUP_LEFT" then
        WhereWeGoDB.noteBase = nil
        WhereWeGoDB.currentLeader = nil
        WhereWeGoDB.currentNote = nil
        -- Don't clear pendingNoteBase here — avoids race with ApplyToGroup for next group
        ns:HideNote()

    elseif event == "LFG_PROPOSAL_SHOW" then
        -- Always clear stale premade pendingNoteBase first
        WhereWeGoDB.pendingNoteBase = nil
        pendingLeader = nil

        local dungeonName = nil
        local ok, proposalExists, id, typeID, subtypeID, pName = pcall(GetLFGProposal)
        if ok and proposalExists and type(pName) == "string" and pName ~= "" then
            dungeonName = pName
        end

        if dungeonName then
            local parts = {}
            table.insert(parts, "|cff4499ff[LFG]|r " .. dungeonName)
            local zone = GetDungeonZone(dungeonName)
                        if zone then
                            table.insert(parts, "|cffddaa00[Location] " .. zone .. "|r")
                        end
            WhereWeGoDB.pendingNoteBase = table.concat(parts, "\n")
            -- LFG has no leader concept; currentLeader will be set after GROUP_JOINED
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
        print("|cff4499ffWhereWeGo Debug:|r")
        print("  GetLFGActivityFullNameFromID: " .. tostring(GetLFGActivityFullNameFromID ~= nil))
        print("  GetActivityInfoTable: " .. tostring(C_LFGList and C_LFGList.GetActivityInfoTable ~= nil))
        print("  GetActivityInfo: " .. tostring(C_LFGList and C_LFGList.GetActivityInfo ~= nil))
        print("  GetActiveEntryInfo: " .. tostring(C_LFGList and C_LFGList.GetActiveEntryInfo ~= nil))
        print("  pendingNoteBase: " .. tostring(WhereWeGoDB and WhereWeGoDB.pendingNoteBase))
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
