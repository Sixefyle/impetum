GST_DB = GST_DB or {}

function GST_DB:DatabaseConnected()
    --print("Création des tables AOTA...")
    self:TryCreateTable("players", [[
        `steamid` VARCHAR(17) NOT NULL PRIMARY KEY, 
        `last_seen_name` TEXT NOT NULL,
        `first_connection` TIMESTAMP NOT NULL,
        `last_seen_date` TIMESTAMP NOT NULL
    ]])

    self:TryCreateTable("classes", [[
        `id` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT, 
        `team_name` VARCHAR(32) NOT NULL, 
        `class_name` VARCHAR(32) NOT NULL,
        `is_disabled` BOOLEAN NOT NULL DEFAULT false, 
        UNIQUE (team_name, class_name)
    ]], function(q, ok, data)
        self:InitClassTable()
    end)

    self:TryCreateTable("players_classes", [[
        `id_player` VARCHAR(17) NOT NULL,
        `id_class` INTEGER NOT NULL,
        `experience` INTEGER NOT NULL DEFAULT 0,
        `level` INTEGER NOT NULL DEFAULT 1,
        `unlocked_date` TIMESTAMP NOT NULL,
        PRIMARY KEY (id_player, id_class),
        FOREIGN KEY (id_player) REFERENCES players(steamid),
        FOREIGN KEY (id_class) REFERENCES classes(id)
    ]])

    self:TryCreateTable("players_stats", [[
        `id_player` VARCHAR(17) NOT NULL,
        `stat_name` VARCHAR(32) NOT NULL,
        `count` INTEGER NOT NULL,
        PRIMARY KEY (id_player, stat_name),
        FOREIGN KEY (id_player) REFERENCES players(steamid)
    ]])

    self:CheckDisabledClasses()
    GAMEMODE:SpawnLeaderboard()
end

function GST_DB:InitClassTable()
    for teamName, _ in pairs(GST_SNK.Classes) do
        for className, _ in pairs(GST_SNK.Classes[teamName]) do
            self:TryInsert("INSERT INTO classes (team_name, class_name) VALUES ('" .. teamName .. "','" .. className .. "')")
        end
    end
end

function GST_DB:InsertNewPlayer(ply)
    self:TryInsert("INSERT INTO players (steamid, last_seen_name) VALUES ('" .. ply:SteamID64() .. "','" .. ply:Nick() .. "')")
    self:InsertDefaultClass(ply)
end

function GST_DB:InsertDefaultClass(ply)
    for teamName, class in pairs(GST_SNK.FreeClass) do
        for _, className in pairs(GST_SNK.FreeClass[teamName]) do
            self:InsertUnlockedClass(ply, teamName, className)
        end
    end
end

function GST_DB:InsertUnlockedClass(ply, teamName, className)
    self:Query("SELECT id FROM classes WHERE team_name='" .. teamName .. "' AND class_name='" .. className .. "'", function(cq, ok, classData)
        if ok and classData[1] then
            self:TryInsert("INSERT INTO players_classes (id_player, id_class) VALUES ('" .. ply:SteamID64() .. "','" .. classData[1].id .. "')")
        end
    end)
end

function GST_DB:GetPlayerClassesData(ply, callback)
    if not IsValid(ply) then
        print("Impossible de récupérer les classe d'un joueur")
        print("Joueur non valide")
        return
    end

    callback = callback or function() end

    local classes = {
        Eldien = {},
        Mahr = {},
        Titan = {},
        Primordial = {}
    }
    local classExp = {}
    self:Query("SELECT team_name, class_name, experience, level FROM players_classes pc, classes c " ..
                "WHERE pc.id_player='" .. ply:SteamID64() .. "' AND pc.id_class=c.id",
                function(q, ok, classData)
                    if ok and classData[1] then
                        for _, class in pairs(classData) do
                            classExp = {
                                ["Experience"] = class.experience,
                                ["Level"] = class.level
                            }
                            classes[class.team_name][class.class_name] = classExp
                        end
                        callback(classes)
                    end
                end)



    -- self:Query("SELECT id_class, experience, level FROM players_classes WHERE id_player='" .. ply:SteamID64() .. "'", function(cq, ok, unlockedClassData)
    --     if ok and unlockedClassData[1] then
    --         for _, unlockedClass in pairs(unlockedClassData) do
    --             self:Query("SELECT team_name, class_name FROM classes WHERE id='" .. unlockedClass.id_class .. "'", function(cq, ok, classData)
    --                 if ok and classData[1] then
    --                     table.insert(classes[classData[1].team_name], classData[1].class_name)
    --                 end
    --             end)
    --         end

    --         timer.Simple(1, function()
    --             callback(classes)
    --         end)
    --     end
    -- end)
end

function GST_DB:CheckDisabledClasses()
    for teamName, classCategory in pairs(GST_SNK.Classes) do
        for className, classInfo in pairs(classCategory) do
            self:Query("SELECT is_disabled FROM classes WHERE team_name='" .. teamName .. "' AND class_name='" .. className .. "'", function(cq, ok, classData)
                if ok and classData[1] and classData[1].is_disabled == 1 then
                    classInfo.isDisabled = true
                end
            end)
        end
    end
end

function GST_DB:SwitchDisableClass(teamName, className, shouldDisable)
    self:Query("UPDATE classes SET is_disabled=" .. (shouldDisable and 1 or 0) .. " WHERE team_name='" .. teamName .. "' AND class_name='" .. className .. "'" , function(cq, ok, data)
        if not ok then
            print(data)
        end
    end)
end

function GST_DB:AddPlayerStats(ply, statName, count)
    self:TryInsert("INSERT INTO players_stats (id_player, stat_name, count) VALUES ('" .. ply:SteamID64() .. "','" .. statName .. "', 0)", {}, 
    function(q, ok, data)
        if ok then
            self:Query("UPDATE players_stats SET count=count+" .. count .. " WHERE stat_name='" .. statName .. "' AND id_player='" .. ply:SteamID64() .. "'")
        end
    end)
end

function GST_DB:UpdatePlayerClassExp(ply, teamName, className)
    self:Query("SELECT id FROM classes WHERE team_name='" .. teamName .. "' AND class_name='" .. className .. "'", function(q, ok, data)
        if ok then
            self:Query("UPDATE players_classes SET experience=experience+" .. ply:GetClassExperience(teamName, className) ..
            ", level=level+" .. ply:GetClassLevel(teamName, className) ..
            " WHERE id_class='" .. data[1].id .. "' AND id_player='" .. ply:SteamID64() .. "'")
        end
    end)
end

function GST_DB:GetTopStats(statName, amount, callback)
    amount = amount or 5
    callback = callback or function() end

    self:Query("SELECT last_seen_name, count FROM players_stats ps, players p WHERE p.steamid=ps.id_player AND stat_name='" .. statName .. "' ORDER BY count DESC LIMIT " .. amount, function(q, ok, data)
        if ok then
            callback(data)
        end
    end)
end

concommand.Add("ForceCreateTable", function()
    GST_DB:DatabaseConnected()
end)