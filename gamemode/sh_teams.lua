
GST_SNK.Teams = {
    ["Eldien"] = {
        id = 1,
        name = "Eldien",
        color = Color(95, 202, 109),
        spawn_name = "spawn_eldien",
        require_vip = false
    },
    ["Mahr"] = {
        id = 2,
        name = "Mahr",
        color = Color(101, 156, 224),
        spawn_name = "spawn_mahr",
        require_vip = false
    },
    ["Titan"] = {
        id = 3,
        name = "Titan",
        color = Color(175, 51, 51),
        require_vip = true
    },
    ["Primordial"] = {
        id = 4,
        name = "Primordial",
        color = Color(207, 164, 47),
        require_vip = true
    },
    ["Spectator"] = {
        id = 5,
        name = "Spectateur",
        color = Color(140,140,140),
        require_vip = false
    },
    ["NoTeam"] = {
        id = 6,
        name = "Sans équipe",
        color = Color(218,214,214),
        require_vip = false
    },
}


function GM:CreateTeams()
    for _, currentTeam in pairs(GST_SNK.Teams) do
        team.SetUp(currentTeam.id, currentTeam.name, currentTeam.color)
    end
end

function GM:PlayerSelectSpawn(ply, transition)
    local spawns = ents.FindByClass("info_player_start")
    if (ply:GetTeam() and ply:GetTeam().spawn_name) then
        spawns = ents.FindByName(ply:GetTeam().spawn_name)
    end
    return spawns[math.random(#spawns)]
end

function GST_SNK:InitTeamStats()
    if (not GST_SNK.Teams.Eldien.set_player_info) then
        GST_SNK.Teams.Eldien.set_player_info = function(ply)
            --ply:SetModel("models/player/odessa.mdl")
            ply:PickRandomModel()
            ply:GodDisable()
            ply:SetModelScale(1, 0)
            ply:SetPlayerColor(Vector(.9, .8, .7))
            ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 72))
            ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 36))
            ply:SetViewOffset(Vector(0, 0, 64))
            ply:SetViewOffsetDucked(Vector(0, 0, 32))
            ply:ResetHull()
        end
    end

    if (not GST_SNK.Teams.Mahr.set_player_info) then
        GST_SNK.Teams.Mahr.set_player_info = function(ply)
            --ply:SetModel("models/player/odessa.mdl")
            ply:PickRandomModel()
            ply:GodDisable()
            ply:SetModelScale(1, 0)
            ply:SetPlayerColor(Vector(.9, .8, .7))
            ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 72))
            ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 36))
            ply:SetViewOffset(Vector(0, 0, 64))
            ply:SetViewOffsetDucked(Vector(0, 0, 32))
            ply:ResetHull()
        end
    end

    if (not GST_SNK.Teams.Titan.set_player_info) then
        GST_SNK.Teams.Titan.set_player_info = function(ply)
            ply:GodDisable()
            --ply:SetModel( "models/olddeath/kyojin/kyojin.mdl" )
            ply:SetPlayerColor(Vector(1, .2, .2))
        end
    end

    if (not GST_SNK.Teams.Primordial.set_player_info) then
        GST_SNK.Teams.Primordial.set_player_info = function(ply)
            ply:GodDisable()
            --ply:SetModel( "models/olddeath/kyojin/kyojin.mdl" )
            ply:SetPlayerColor(Vector(1, .2, .2))
        end
    end

    if (not GST_SNK.Teams.Spectator.set_player_info) then
        GST_SNK.Teams.Spectator.set_player_info = function(ply)
            ply:SetHealth(100)
            ply:SetModelScale(1, 0)
            ply:SetPlayerColor(Vector(.9, .8, .7))
            ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 72))
            ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 36))
            ply:SetViewOffset(Vector(0, 0, 64))
            ply:SetViewOffsetDucked(Vector(0, 0, 32))
            ply:ResetHull()
            ply:GodEnable()

            if not ply:Alive() then
                ply:Spawn()
            end

            ply:SetMoveType(MOVETYPE_NOCLIP)
            ply:SetCollisionGroup(COLLISION_GROUP_WORLD)
        end
    end

    if (not GST_SNK.Teams.NoTeam.set_player_info) then
        GST_SNK.Teams.NoTeam.set_player_info = function(ply)
            ply:SetHealth(100)
            ply:GodEnable()
            ply:SetModel("models/crow.mdl")

            if not ply:Alive() then
                ply:Spawn()
            end
            ply:SetCollisionGroup(COLLISION_GROUP_WORLD)
        end
    end
end

function GST_SNK:RequestTeamSwitch(ply, newTeam, class)
    if (not ply:Alive() or ply.initialSpawn) then
        if (ply.initialSpawn) then
            ply.initialSpawn = false
            ply:Kill()
        end

        GST_SNK:SwitchTeam(ply, newTeam, class)
    else
        ply:ChatPrint("Changement d'équipe lors de votre prochaine réapparition (" .. newTeam.name .. " - " .. class.display_name .. ")")
        ply.requested_team = newTeam
        ply.requested_class = class
    end
end

function GST_SNK:SwitchTeam(ply, newTeam, class)
    ply:ChatPrint("Nouvelle équipe (" .. newTeam.name .. ")")

    ply:SetTeam(newTeam.id)

    if (class) then
        ply:SetClass(class)
    end
    ply:SetPlayerColor(Vector(newTeam.color.r / 255, newTeam.color.g / 255, newTeam.color.b / 255))

    if (not newTeam.set_player_info) then
        GST_SNK:InitTeamStats()
    end

    --ply:SetMaxHealth(class.health)
    --ply:SetHealth(class.health)
    --ply:SetRunSpeed(class.max_speed)
    --ply:SetWalkSpeed(class.speed)

    newTeam.set_player_info(ply)
end

function GST_SNK:GetTeam(id)
    for _, currentTeam in pairs(GST_SNK.Teams) do
        if (currentTeam.id == id) then
            return currentTeam
        end
    end
    return nil
end

local ply = FindMetaTable( "Player" )
function ply:GetTeam()
    return GST_SNK:GetTeam(self:Team())
end