GM.NpcTitanSpawnName = "spawn_titan"
GM.MaxAliveTitan = 20
GM.TitanAlive = 0
GM.Titans = {}

hook.Add( "InitPostEntity", "SpawnNpcTitan", function()
    local spawns = ents.FindByName(GAMEMODE.NpcTitanSpawnName)
    local maxTries = 30
    local currentTrie = 0
    local titan, spawnPos, spawn
    local amount = 0
    timer.Create("TitanSpawnManager", 5, 0, function()
        --print("[DEBUG] Check spawn titan")
        amount = #ents.FindByClass("vj_titan")

        if amount < 20 then
            titan = ents.Create("vj_titan")
            spawn = table.Random(spawns)
            if (not IsValid(spawn)) then
                spawns = ents.FindByName(GAMEMODE.NpcTitanSpawnName)
                spawn = table.Random(spawns)
            end

            spawnPos = spawn:GetPos()

            --print("[DEBUG] Spawn", spawn)
            --print("[DEBUG] Recherche d'un spawn...", spawnPos)
            while GST_SNK.Utils:GetNearEntsAmount(spawnPos, 100, {"accroche"}) > 0 do
                spawnPos = spawnPos + Vector(math.random(-30, 30),math.random(-30, 30),0)
                currentTrie = currentTrie + 1
                if currentTrie >= maxTries then break end
            end
            --print("[DEBUG] Essaie " .. currentTrie .. "/" .. maxTries)

            if currentTrie < maxTries then
                titan:SetPos(spawnPos)
                titan:Spawn()
                --print("[DEBUG] Spawn de titan - " .. GAMEMODE.TitanAlive .. " titans")
            end

            currentTrie = 0
        end
    end)
end)

-- hook.Add("EntityRemoved", "OnTitanDie", function(ent)
--     if (IsValid(ent) and ent:GetModel() and string.match(ent:GetModel(), "titan") == "titan") then
--         GAMEMODE.TitanAlive = GAMEMODE.TitanAlive - 1
--     end
-- end)

-- hook.Add("PostCleanupMap", "ResetTitanAmount", function()
--     GAMEMODE.TitanAlive = 0
--     table.Empty(GAMEMODE.Titans)
-- end)