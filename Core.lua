local addonName, ns = ...

------------------------------------------------------------------------
-- Korean → English dungeon/difficulty lookup
------------------------------------------------------------------------
------------------------------------------------------------------------
-- Localized name → English lookup (all non-English locales)
-- Keys: localized dungeon base names; Values: English names
------------------------------------------------------------------------
local LOCALE_EN = {
    -- Korean (koKR)
    ["윈드러너 첨탑"]       = "Windrunner Spire",
    ["마법학자의 정원"]     = "Magisters' Terrace",
    ["죽음의 골목"]         = "Death's Row",
    ["날로라크의 소굴"]     = "Nalorakk's Den",
    ["마이사라 동굴"]       = "Maisara Caverns",
    ["공결탑 제나스"]       = "Nexus-Point Xenas",
    ["공결탑 제니스"]       = "Nexus-Point Xenas",
    ["눈부신 골짜기"]       = "Shining Vale",
    ["공허흉터 투기장"]     = "Voidscar Arena",
    ["알게타르 대학"]       = "Algeth'ar Academy",
    ["알게타르 학원"]       = "Algeth'ar Academy",
    ["사론의 구덩이"]       = "Pit of Saron",
    ["삼두정의 권좌"]       = "Seat of the Triumvirate",
    ["삼두정의 옥좌"]       = "Seat of the Triumvirate",
    ["하늘탑"]              = "Skyreach",
    ["아라카라, 메아리의 도시"] = "Ara-Kara, City of Echoes",
    ["착암기 광산"]         = "The Stonevault",
    ["시티 오브 스레드"]    = "City of Threads",
    ["어둠불꽃 거리"]       = "Darkflame Cleft",
    ["새벽인도자의 양조장"] = "The Dawnbreaker",
    ["아틀다자르 신전"]     = "Atal'Dazar",
    ["왕노릇의 대가"]       = "Siege of Boralus",
    ["하급 카라잔"]         = "Lower Karazhan",
    ["상급 카라잔"]         = "Upper Karazhan",
    ["해방의 지하"]         = "Liberation of Undermine",
    ["네루바르 궁전"]       = "Nerub-ar Palace",
    -- German (deDE)
    ["Windläuferspitze"]    = "Windrunner Spire",
    ["Terrasse der Magister"] = "Magisters' Terrace",
    ["Todesstraße"]         = "Death's Row",
    ["Nalorakks Bau"]       = "Nalorakk's Den",
    ["Maisarahöhlen"]       = "Maisara Caverns",
    ["Nexuspunkt Xenas"]    = "Nexus-Point Xenas",
    ["Gleißendes Tal"]      = "Shining Vale",
    ["Leerennarben-Arena"]  = "Voidscar Arena",
    ["Akademie von Algeth'ar"] = "Algeth'ar Academy",
    ["Grube von Saron"]     = "Pit of Saron",
    ["Sitz des Triumvirats"] = "Seat of the Triumvirate",
    ["Himmelsnadel"]        = "Skyreach",
    ["Ara-Kara, Stadt der Echos"] = "Ara-Kara, City of Echoes",
    ["Der Steingewölbe"]    = "The Stonevault",
    ["Stadt der Fäden"]     = "City of Threads",
    ["Dunkelflammenspalt"]  = "Darkflame Cleft",
    ["Der Dämmerungsbrecher"] = "The Dawnbreaker",
    ["Atal'Dazar"]          = "Atal'Dazar",
    ["Belagerung von Boralus"] = "Siege of Boralus",
    ["Unteres Karazhan"]    = "Lower Karazhan",
    ["Oberes Karazhan"]     = "Upper Karazhan",
    ["Befreiung von Untermine"] = "Liberation of Undermine",
    ["Palast der Nerub'ar"] = "Nerub-ar Palace",
    -- French (frFR)
    ["Flèche des Coursevent"] = "Windrunner Spire",
    ["Terrasse des Magistères"] = "Magisters' Terrace",
    ["Allée de la mort"]    = "Death's Row",
    ["Repaire de Nalorakk"] = "Nalorakk's Den",
    ["Cavernes de Maisara"] = "Maisara Caverns",
    ["Nexus-Point Xenas"]   = "Nexus-Point Xenas",
    ["Val brillant"]        = "Shining Vale",
    ["Arène de Cicatrice-du-Vide"] = "Voidscar Arena",
    ["Académie d'Algeth'ar"] = "Algeth'ar Academy",
    ["Fosse de Saron"]      = "Pit of Saron",
    ["Siège du Triumvirat"] = "Seat of the Triumvirate",
    ["Cime du Ciel"]        = "Skyreach",
    ["Ara-Kara, cité des Échos"] = "Ara-Kara, City of Echoes",
    ["Le Caveau de Pierre"] = "The Stonevault",
    ["Cité des Fils"]       = "City of Threads",
    ["Faille Sombreflamme"] = "Darkflame Cleft",
    ["L'Aube-briseur"]      = "The Dawnbreaker",
    ["Atal'Dazar"]          = "Atal'Dazar",
    ["Siège de Boralus"]    = "Siege of Boralus",
    ["Karazhan inférieur"]  = "Lower Karazhan",
    ["Karazhan supérieur"]  = "Upper Karazhan",
    ["Libération de Mineverte"] = "Liberation of Undermine",
    ["Palais des Nérub'ar"] = "Nerub-ar Palace",
    -- Spanish (esES/esMX)
    ["Aguja de los Brisaveloz"] = "Windrunner Spire",
    ["Bancal de los Magistros"] = "Magisters' Terrace",
    ["Callejón de la Muerte"] = "Death's Row",
    ["Guarida de Nalorakk"] = "Nalorakk's Den",
    ["Cavernas Maisara"]    = "Maisara Caverns",
    ["Nexo-Punto Xenas"]    = "Nexus-Point Xenas",
    ["Valle Reluciente"]    = "Shining Vale",
    ["Arena Hojavacía"]     = "Voidscar Arena",
    ["Academia de Algeth'ar"] = "Algeth'ar Academy",
    ["Foso de Saron"]       = "Pit of Saron",
    ["Sede del Triunvirato"] = "Seat of the Triumvirate",
    ["Cumbre del Cielo"]    = "Skyreach",
    ["Ara-Kara, Ciudad de los Ecos"] = "Ara-Kara, City of Echoes",
    ["La Bóveda Pétrea"]    = "The Stonevault",
    ["Ciudad de los Hilos"] = "City of Threads",
    ["Grieta Llama Oscura"] = "Darkflame Cleft",
    ["El Rompealbas"]       = "The Dawnbreaker",
    ["Atal'Dazar"]          = "Atal'Dazar",
    ["Asedio de Boralus"]   = "Siege of Boralus",
    ["Karazhan inferior"]   = "Lower Karazhan",
    ["Karazhan superior"]   = "Upper Karazhan",
    ["Liberación de Minahonda"] = "Liberation of Undermine",
    ["Palacio Nerub-ar"]    = "Nerub-ar Palace",
    -- Italian (itIT)
    ["Guglia dei Tornavento"] = "Windrunner Spire",
    ["Terrazza dei Magistri"] = "Magisters' Terrace",
    ["Via dei Defunti"]     = "Death's Row",
    ["Covo di Nalorakk"]    = "Nalorakk's Den",
    ["Caverne di Maisara"]  = "Maisara Caverns",
    ["Nexus-Punto Xenas"]   = "Nexus-Point Xenas",
    ["Valle Lucente"]       = "Shining Vale",
    ["Arena Cicaluce"]      = "Voidscar Arena",
    ["Accademia di Algeth'ar"] = "Algeth'ar Academy",
    ["Fossa di Saron"]      = "Pit of Saron",
    ["Seggio del Triumvirato"] = "Seat of the Triumvirate",
    ["Pinnacolo del Cielo"] = "Skyreach",
    ["Ara-Kara, Città degli Echi"] = "Ara-Kara, City of Echoes",
    ["La Litocripta"]       = "The Stonevault",
    ["Città dei Fili"]      = "City of Threads",
    ["Faglia Fiammaoscura"] = "Darkflame Cleft",
    ["Lo Spezzalba"]        = "The Dawnbreaker",
    ["Atal'Dazar"]          = "Atal'Dazar",
    ["Assedio di Boralus"]  = "Siege of Boralus",
    ["Karazhan Inferiore"]  = "Lower Karazhan",
    ["Karazhan Superiore"]  = "Upper Karazhan",
    ["Liberazione di Sottomine"] = "Liberation of Undermine",
    ["Palazzo Nerub-ar"]    = "Nerub-ar Palace",
    -- Portuguese (ptBR)
    ["Pináculo dos Correventos"] = "Windrunner Spire",
    ["Terraço dos Magísteres"] = "Magisters' Terrace",
    ["Beco da Morte"]       = "Death's Row",
    ["Covil de Nalorakk"]   = "Nalorakk's Den",
    ["Cavernas Maisara"]    = "Maisara Caverns",
    ["Ponto-Nexus Xenas"]   = "Nexus-Point Xenas",
    ["Vale Brilhante"]      = "Shining Vale",
    ["Arena Cicastélica"]   = "Voidscar Arena",
    ["Academia de Algeth'ar"] = "Algeth'ar Academy",
    ["Poço de Saron"]       = "Pit of Saron",
    ["Assento do Triunvirato"] = "Seat of the Triumvirate",
    ["Alcance Celeste"]     = "Skyreach",
    ["Ara-Kara, Cidade dos Ecos"] = "Ara-Kara, City of Echoes",
    ["A Litocripta"]        = "The Stonevault",
    ["Cidade dos Fios"]     = "City of Threads",
    ["Fenda Flambnegra"]    = "Darkflame Cleft",
    ["O Quebra-Aurora"]     = "The Dawnbreaker",
    ["Atal'Dazar"]          = "Atal'Dazar",
    ["Cerco a Boralus"]     = "Siege of Boralus",
    ["Karazhan Inferior"]   = "Lower Karazhan",
    ["Karazhan Superior"]   = "Upper Karazhan",
    ["Libertação de Sotraminas"] = "Liberation of Undermine",
    ["Palácio Nerub-ar"]    = "Nerub-ar Palace",
    -- Russian (ruRU)
    ["Шпиль Ветрокрылых"]   = "Windrunner Spire",
    ["Терраса Магистров"]   = "Magisters' Terrace",
    ["Аллея Смерти"]        = "Death's Row",
    ["Логово Налоракка"]    = "Nalorakk's Den",
    ["Пещеры Майсары"]      = "Maisara Caverns",
    ["Точка Связи Ксенас"]  = "Nexus-Point Xenas",
    ["Сияющая долина"]      = "Shining Vale",
    ["Арена Шрама Пустоты"] = "Voidscar Arena",
    ["Академия Алгет'ар"]   = "Algeth'ar Academy",
    ["Яма Сарона"]          = "Pit of Saron",
    ["Престол Триумвирата"] = "Seat of the Triumvirate",
    ["Небесная Вершина"]    = "Skyreach",
    ["Ара-Кара, Город Эха"] = "Ara-Kara, City of Echoes",
    ["Каменный Свод"]       = "The Stonevault",
    ["Город Нитей"]         = "City of Threads",
    ["Темнопламенная расщелина"] = "Darkflame Cleft",
    ["Предвестник Рассвета"] = "The Dawnbreaker",
    ["Атал'Дазар"]          = "Atal'Dazar",
    ["Осада Боралуса"]      = "Siege of Boralus",
    ["Нижний Каражан"]      = "Lower Karazhan",
    ["Верхний Каражан"]     = "Upper Karazhan",
    ["Освобождение Подшахт"] = "Liberation of Undermine",
    ["Дворец Неруб-ар"]     = "Nerub-ar Palace",
    -- Simplified Chinese (zhCN)
    ["风行者尖塔"]          = "Windrunner Spire",
    ["魔导师平台"]          = "Magisters' Terrace",
    ["死亡小径"]            = "Death's Row",
    ["纳洛拉克的巢穴"]      = "Nalorakk's Den",
    ["麦萨拉洞穴"]          = "Maisara Caverns",
    ["节点塔泽纳斯"]        = "Nexus-Point Xenas",
    ["辉光谷"]              = "Shining Vale",
    ["虚痕竞技场"]          = "Voidscar Arena",
    ["艾杰斯亚学院"]        = "Algeth'ar Academy",
    ["萨隆矿坑"]            = "Pit of Saron",
    ["三魔之座"]            = "Seat of the Triumvirate",
    ["天穹"]                = "Skyreach",
    ["阿拉卡拉，回声之城"]  = "Ara-Kara, City of Echoes",
    ["石窟"]                = "The Stonevault",
    ["千丝之城"]            = "City of Threads",
    ["暗焰裂口"]            = "Darkflame Cleft",
    ["破晓号"]              = "The Dawnbreaker",
    ["阿塔达萨"]            = "Atal'Dazar",
    ["围攻伯拉勒斯"]        = "Siege of Boralus",
    ["下层卡拉赞"]          = "Lower Karazhan",
    ["上层卡拉赞"]          = "Upper Karazhan",
    ["地底城解放战"]        = "Liberation of Undermine",
    ["尼鲁巴尔王宫"]        = "Nerub-ar Palace",
    -- Traditional Chinese (zhTW)
    ["乘風者尖塔"]          = "Windrunner Spire",
    ["乘風者之塔"]          = "Windrunner Spire",
    ["乘风者尖塔"]          = "Windrunner Spire",
    ["乘风者之塔"]          = "Windrunner Spire",
    ["乘風者尖塔"]          = "Windrunner Spire",
    ["乘風者之塔"]          = "Windrunner Spire",
    ["乘风者尖塔"]          = "Windrunner Spire",
    ["乘风者之塔"]          = "Windrunner Spire",
    ["風行者之塔"]          = "Windrunner Spire",
    ["風行者尖塔"]          = "Windrunner Spire",
    ["乘风者尖塔"]          = "Windrunner Spire",
    ["魔導師平台"]          = "Magisters' Terrace",
    ["死亡小徑"]            = "Death's Row",
    ["乘風者尖塔"]          = "Windrunner Spire",
    ["納洛拉克的巢穴"]      = "Nalorakk's Den",
    ["麥薩拉洞穴"]          = "Maisara Caverns",
    ["節點塔乘納斯"]        = "Nexus-Point Xenas",
    ["輝光谷"]              = "Shining Vale",
    ["虛痕競技場"]          = "Voidscar Arena",
    ["乘杰斯亞學院"]        = "Algeth'ar Academy",
    ["艾杰斯亞學院"]        = "Algeth'ar Academy",
    ["乘隆礦坑"]            = "Pit of Saron",
    ["薩隆礦坑"]            = "Pit of Saron",
    ["三魔之座"]            = "Seat of the Triumvirate",
    ["天穹"]                = "Skyreach",
    ["阿拉卡拉，迴聲之城"]  = "Ara-Kara, City of Echoes",
    ["石窟"]                = "The Stonevault",
    ["千絲之城"]            = "City of Threads",
    ["暗焰裂口"]            = "Darkflame Cleft",
    ["破曉號"]              = "The Dawnbreaker",
    ["阿塔達薩"]            = "Atal'Dazar",
    ["圍攻乘拉勒斯"]        = "Siege of Boralus",
    ["圍攻伯拉勒斯"]        = "Siege of Boralus",
    ["下層卡拉乘"]          = "Lower Karazhan",
    ["下層卡拉贊"]          = "Lower Karazhan",
    ["上層卡拉乘"]          = "Upper Karazhan",
    ["上層卡拉贊"]          = "Upper Karazhan",
    ["地底城解放戰"]        = "Liberation of Undermine",
    ["尼魯巴爾王宮"]        = "Nerub-ar Palace",
}

-- Keep backward compat alias
local KO_EN = LOCALE_EN

local KO_DIFF = {
    ["신화"] = "Mythic", ["영웅"] = "Heroic", ["일반"] = "Normal",
    ["쐐기"] = "M+",
}

-- English dungeon names (used to detect if name is already English)
local EN_NAMES = {
    ["Windrunner Spire"] = true, ["Magisters' Terrace"] = true,
    ["Death's Row"] = true, ["Nalorakk's Den"] = true,
    ["Maisara Caverns"] = true, ["Nexus-Point Xenas"] = true,
    ["Shining Vale"] = true, ["Voidscar Arena"] = true,
    ["Algeth'ar Academy"] = true, ["Pit of Saron"] = true,
    ["Seat of the Triumvirate"] = true, ["Skyreach"] = true,
    ["Ara-Kara, City of Echoes"] = true, ["The Stonevault"] = true,
    ["City of Threads"] = true, ["Darkflame Cleft"] = true,
    ["The Dawnbreaker"] = true, ["Atal'Dazar"] = true,
    ["Siege of Boralus"] = true, ["Lower Karazhan"] = true,
    ["Upper Karazhan"] = true, ["Liberation of Undermine"] = true,
    ["Nerub-ar Palace"] = true,
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
    -- Already English? No translation needed
    if EN_NAMES[name] then return nil end
    for enName, _ in pairs(EN_NAMES) do
        if name:find(enName, 1, true) then return nil end
    end
    -- Direct match in locale table
    if LOCALE_EN[name] then return LOCALE_EN[name] end
    -- Substring match (activity names often include difficulty suffixes)
    for locName, en in pairs(LOCALE_EN) do
        if name:find(locName, 1, true) then return en end
    end
    return nil
end

local function GetZone(name)
    if not name then return nil end
    -- Direct match
    local en = LOCALE_EN[name]
    if en and ZONE[en] then return ZONE[en] end
    if ZONE[name] then return ZONE[name] end
    -- Substring match against localized keys
    for locName, enName in pairs(LOCALE_EN) do
        if name:find(locName, 1, true) then
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
        if en then lines[#lines+1] = "|cff88ddff(EN) " .. en .. "|r" end
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

    -- Try 1: pendingDungeon (from the specific group that accepted us)
    local dungeon = pendingDungeon
    pendingDungeon = nil
    pendingTitle = nil
    if dungeon and dungeon ~= "" then
        ShowNote(dungeon, GetLeader(), title)
        return
    end

    -- Try 2: instance info
    local iName, iType = GetInstanceInfo()
    if iName and iName ~= "" and iType ~= "none" then
        ShowNote(iName, GetLeader(), title)
        return
    end

    -- Try 3: CaptureActiveEntry (our own listing — last resort, may be wrong)
    dungeon = CaptureActiveEntry()
    if dungeon and dungeon ~= "" then
        ShowNote(dungeon, GetLeader(), title)
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
                            local title = (info.comment and info.comment ~= "") and info.comment or nil
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

            -- Only capture info when we are INVITED to the group
            local isInvited = (status == "invited" or status == "inviteaccepted"
                or status == "invitedeclined")
            if not isInvited then return end

            -- Look up from our applied groups map first
            if appID and appliedGroups[appID] then
                local g = appliedGroups[appID]
                if g.dungeon and g.dungeon ~= "" then
                    pendingDungeon = g.dungeon
                end
                if g.title then
                    pendingTitle = g.title
                end
                dbg("WWG invited from group #" .. appID .. ": " .. tostring(g.dungeon) .. " / " .. tostring(g.title))
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
                                dbg("WWG captured via invite: " .. name)
                            end
                        end
                        if not pendingTitle and info.comment and info.comment ~= "" then
                            pendingTitle = info.comment
                            dbg("WWG captured title via invite: " .. info.comment)
                        end
                    end
                end
            end
            if not pendingDungeon then
                local ae = CaptureActiveEntry()
                if ae and ae ~= "" then
                    pendingDungeon = ae
                    dbg("WWG captured activeEntry at invite: " .. ae)
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
        print("  locale=" .. tostring(GetLocale()))
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
    elseif msg == "scan" then
        -- Scan activity IDs to help discover translations for unknown dungeons
        if not (C_LFGList and C_LFGList.GetActivityInfoTable) then
            print("|cff4499ffWhereWeGo:|r Scan not available (API missing)")
            return
        end
        print("|cff4499ffWhereWeGo:|r Scanning activity IDs (dungeons/raids)...")
        local found = 0
        for id = 1, 2000 do
            local ok2, info = pcall(C_LFGList.GetActivityInfoTable, id)
            if ok2 and info and info.fullName and info.fullName ~= "" then
                local cat = info.categoryID or 0
                -- categoryID 2 = dungeons, 3 = raids
                if cat == 2 or cat == 3 then
                    local en = Translate(info.fullName)
                    local tag = en and ("|cff88ddff-> " .. en .. "|r") or "|cff888888(no translation)|r"
                    print("  ID=" .. id .. " |cff00cc66" .. info.fullName .. "|r " .. tag)
                    found = found + 1
                end
            end
        end
        print("|cff4499ffWhereWeGo:|r Found " .. found .. " activities. Report untranslated ones at github.com/Rdmd-wow/wherewego")
    else
        local ver = C_AddOns and C_AddOns.GetAddOnMetadata and
            C_AddOns.GetAddOnMetadata("WhereWeGo","Version") or "?"
        print("|cff4499ffWhereWeGo|r v"..ver)
        print("  |cffffff00/wwg show|r  — show note")
        print("  |cffffff00/wwg hide|r  — hide frame")
        print("  |cffffff00/wwg clear|r — clear note")
        print("  |cffffff00/wwg reset|r — reset position")
        print("  |cffffff00/wwg debug|r — debug info")
        print("  |cffffff00/wwg scan|r  — scan activity IDs")
    end
end
