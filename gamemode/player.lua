util.AddNetworkString("ForceHudRefresh")
util.AddNetworkString("ShowRepairBar")

local ply = FindMetaTable("Player") --Defines the local player

function ply:AddPoints(amount)
    self:SetNWInt("Points", self:GetNWInt("Points") + amount)
    -- Ajouter points PS ici
end

function ply:GiveGamemodeWeapons()
    if (self:GetCurrentClass()) then
        self:StripWeapons()
        for _, swep in pairs(self:GetCurrentClass().kit) do
            self:Give(swep)
            -- self:SetActiveWeapon(weap)
        end
    end
end

function ply:PickRandomModel()
    local GroupNumber = math.random(1, 3)
    local GenderNumber = math.random(1, 2)
    local Gender = {}
    Gender[1] = "Male_0"
    Gender[2] = "Female_0"
    local GenderClass = nil
    local ModelLocation = "models/player/Group0"

    if GenderNumber == 1 then
        GenderClass = math.random(1, 9)
    elseif GenderNumber == 2 then
        GenderClass = math.random(1, 6)
    end

    if GroupNumber == 1 or GroupNumber == 3 then
        self:SetModel(ModelLocation .. GroupNumber .. "/" .. Gender[GenderNumber] .. GenderClass .. ".mdl")
    else
        self:SetModel(ModelLocation .. 3 .. "/" .. Gender[GenderNumber] .. GenderClass .. ".mdl")
    end
end

function GM:PlayerDisconnected()
    if (IsValid(ply.PlacedCanon)) then
        ply.PlacedCanon:Remove()
    end
end

local function GetBuildState(name)
    if (name == nil or string.len(name) <= 0) then return end

    local build_1 = ents.FindByName(name .. "_1")[1]
    local build_2 = ents.FindByName(name .. "_2")[1]
    local build_3 = ents.FindByName(name .. "_3")[1]

    return build_3, build_2, build_1
end

local function StopRepair(ply)
    timer.Remove("BuildRepair" .. ply:EntIndex())
    net.Start("ShowRepairBar")
        net.WriteBool(false)
    net.Send(ply)
    ply:StopSound("gst/hammer_sound.wav")
end

local function tempRepairBuildFunc(name)
    local points = ents.FindByClass("point_template")
    local buildPoints = {}
    for _, point in pairs(points) do
        if (string.match(point:GetName(), name)) then
            table.insert(buildPoints, point)
        end
    end

    local state1, state2, state3 = GetBuildState(name)
    if (state1 == nil) then
        buildPoints[1]:Input("ForceSpawn")
    end
    if (state2 == nil) then
        buildPoints[2]:Input("ForceSpawn")
    end
    if (state3 == nil) then
        buildPoints[3]:Input("ForceSpawn")
    end
end

hook.Add("PlayerButtonDown", "ConstructionRebuild", function(ply, key)
    if (ply:IsAdmin() and key == KEY_END) then
        for _, buildName in pairs(GST_SNK.Maps[game.GetMap()].DestructibleBuild) do
            tempRepairBuildFunc(buildName)
        end
    end

    if (key == KEY_P and ply:GetCurrentClass().display_name == "Ingénieur") then
        local points = ents.FindByClass("point_template")
        local buildPoints = {}
        local buildName = GST_SNK.Utils:GetNearestDestructibleBuild(ply:GetPos())
        if (buildName == nil or string.len(buildName) <= 0) then return end

        ply:EmitSound("gst/hammer_sound.wav")

        local state1, state2, state3 = GetBuildState(buildName)

        for _, point in pairs(points) do
            if (string.match(point:GetName(), buildName)) then
                table.insert(buildPoints, point)
            end
        end
        table.sort(buildPoints, function(a, b) return a:GetName() > b:GetName() end)

        if (state3 == nil) then
            net.Start("ShowRepairBar")
                net.WriteBool(true)
            net.Send(ply)

            ply:SetNWFloat("RepairProgression", 0)
            if (state1) then
                ply:SetNWFloat("RepairProgression", 333)
                if (state2) then
                    ply:SetNWFloat("RepairProgression", 666)
                end
            end

            timer.Create("BuildRepair" .. ply:EntIndex(), 0, 0, function()
                state1, state2, state3 = GetBuildState(buildName)
                ply:SetNWFloat("RepairProgression", ply:GetNWFloat("RepairProgression") + 1)

                if (ply:GetVelocity():Length() > 10) then
                    StopRepair(ply)
                end

                if (ply:GetNWFloat("RepairProgression") == 1000) then
                    if (state3 == nil and state2 ~= nil and state1 ~= nil) then
                        buildPoints[3]:Input("ForceSpawn")
                    end
                    StopRepair(ply)
                elseif (ply:GetNWFloat("RepairProgression") == 666) then
                    if (state2 == nil and state1 ~= nil) then
                        buildPoints[2]:Input("ForceSpawn")
                    end
                elseif (ply:GetNWFloat("RepairProgression") == 333) then
                    if (state1 == nil) then
                        buildPoints[1]:Input("ForceSpawn")
                    end
                end
            end)
        end
    end
end)

--Team Selection 
-- Called when player picks a team, or when the game gives it one.
net.Receive("TeamSelect", function(length, ply)
    local newTeam = net.ReadString()
    local newClass = net.ReadString()

    if (GST_SNK.Teams[newTeam] and GST_SNK.Classes[newTeam][newClass] ) then
        GST_SNK:RequestTeamSwitch(ply, GST_SNK.Teams[newTeam], GST_SNK.Classes[newTeam][newClass])
        --ply:GiveGamemodeWeapons()
    else
        ply:ChatPrint("Une erreur s'est produite, veuillez recommencer...")
    end
end)