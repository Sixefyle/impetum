
GST_SNK.Teams = {
    ["Eldien"] = {
        id = 1,
        name = "Eldien",
        color = Color(95, 202, 109),
        spawn_name = "spawn_eldien",
        models = {
            "models/hydralis/kaouet/soldat_masculin/garnison/soldat_masculin_garnison_2.mdl",
            "models/hydralis/kaouet/soldat_masculin/brigade/soldat_masculin_brigade_2.mdl",
            "models/hydralis/kaouet/soldat_masculin/bataillon/soldat_masculin_bataillon_2.mdl",
            "models/hydralis/kaouet/soldat_feminin/garnison/soldat_feminin_garnison_2.mdl",
            "models/hydralis/kaouet/soldat_feminin/brigade/soldat_feminin_brigade_2.mdl",
            "models/hydralis/kaouet/soldat_feminin/bataillon/soldat_feminin_bataillon_2.mdl"
        },
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
        spawn_name = "spawn_titan",
        require_vip = false
    },
    ["Primordial"] = {
        id = 4,
        name = "Primordial",
        color = Color(207, 164, 47),
        spawn_name = "spawn_titan",
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

local plyMeta = FindMetaTable( "Player" )
function plyMeta:GetTeam()
    return GST_SNK:GetTeam(self:Team())
end

function GM:ShowTeam( ply )

end

function GM:CreateTeams()
    for _, currentTeam in pairs(GST_SNK.Teams) do
        team.SetUp(currentTeam.id, currentTeam.name, currentTeam.color)
    end
end

function GM:PlayerSelectSpawn(ply, transition)
    local spawns = ents.FindByClass("info_player_start")
    local playerTeam = ply:GetTeam()

    if (playerTeam and playerTeam.spawn_name) then
        spawns = ents.FindByName(ply.requested_team and ply.requested_team.spawn_name or playerTeam.spawn_name)
    end
    return spawns[math.random(#spawns)]
end


local function GetEquippedSkin(ply)
    for _, item in pairs(ply:SH_GetEquipped()) do
        if (string.match(item.class, "3dmg") == "3dmg") then
            ply.equiped3Dmg = item
            return true
        end
    end
    return false
end

local function Handle3Dmg(ply, shouldShow)
    local has = GetEquippedSkin(ply)

    if (not has) then
        has, ply.equiped3Dmg = ply:SH_HasItem("3dmg_first")
    end

    if (shouldShow) then
        if (not has) then
            ply.equiped3Dmg = SH_POINTSHOP:NewItemTable("3dmg_first")
            ply:SH_AddItem(ply.equiped3Dmg, true, true)
            ply:SH_TransmitPointshop()
            ply:SH_SavePointshop()
        end
        SH_POINTSHOP:EquipItem(ply, ply.equiped3Dmg.id, true, true)
    end

    ply:SH_TransmitEquipped(player.GetAll())
end

function GST_SNK:InitTeamStats()
    if (not GST_SNK.Teams.Eldien.set_player_info) then
        GST_SNK.Teams.Eldien.set_player_info = function(ply)
            Handle3Dmg(ply, true)
            ply:SetModel(table.Random(GST_SNK.Teams.Eldien.models))
            ply:GodDisable()
            ply:SetNoTarget(false)
            ply:SetModelScale(1, 0)
            --ply:SetPlayerColor(Vector(.9, .8, .7))
            --ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 72))
            --ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 36))
            ply:SetViewOffset(Vector(0, 0, 64))
            ply:SetViewOffsetDucked(Vector(0, 0, 32))
            ply:SetJumpPower(200)
            ply:SetJumpPower(200)
            --ply:ResetHull()
        end
    end

    if (not GST_SNK.Teams.Mahr.set_player_info) then
        GST_SNK.Teams.Mahr.set_player_info = function(ply)
            Handle3Dmg(ply, true)
            ply:SetModel("models/gst/playermodel/mahr_2.mdl")
            timer.Simple(.1, function()
                ply:SetBodygroup(11, math.random(1, 9))
            end)
            ply:GodDisable()
            ply:SetNoTarget(false)
            ply:SetModelScale(1, 0)
            --ply:SetPlayerColor(Vector(.9, .8, .7))
            --ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 72))
            --ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 36))
            ply:SetViewOffset(Vector(0, 0, 64))
            ply:SetViewOffsetDucked(Vector(0, 0, 32))
            ply:SetJumpPower(200)
            ply:SetJumpPower(200)
            --ply:ResetHull()
        end
    end

    if (not GST_SNK.Teams.Titan.set_player_info) then
        GST_SNK.Teams.Titan.set_player_info = function(ply)
            Handle3Dmg(ply, false)
            ply:GodDisable()
            ply:SetNoTarget(true)
            ply:SetJumpPower(0)
            ply:SetJumpPower(0)
        end
    end

    if (not GST_SNK.Teams.Primordial.set_player_info) then
        GST_SNK.Teams.Primordial.set_player_info = function(ply)
            Handle3Dmg(ply, false)
            ply:GodDisable()
            ply:SetNoTarget(true)
            ply:SetJumpPower(0)
            ply:SetJumpPower(0)
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
            ply:SetModel("models/gst/playermodel/mahr_2.mdl")

            if not ply:Alive() then
                ply:Spawn()
            end
            ply:SetCollisionGroup(COLLISION_GROUP_WORLD)
        end
    end
end

function GST_SNK:RequestTeamSwitch(ply, newTeam, class, className)
    if (class.isDisabled) then
        ply:ChatPrint("Cette classe est désactivé et ne peut pas être utilisé pour le moment !")
        return
    end

    if not (className == "Titan5") and
        (newTeam == GST_SNK.Teams.Primordial or
        newTeam == GST_SNK.Teams.Titan) and
        not table.HasValue({"vip", "moderator", "admin", "superadmin"}, ply:GetUserGroup()) then

        ply:ChatPrint("Vous devez être VIP pour pouvoir prendre un primordial ou un titan autre que 5 mètres !")
        return
    end

    if (not ply:Alive() or ply.initialSpawn) then
        if (ply.initialSpawn) then
            ply.initialSpawn = false
            ply:KillSilent()
        end


        GST_SNK:SwitchTeam(ply, newTeam, class, className)
    else
        ply:ChatPrint("Changement d'équipe lors de votre prochaine réapparition (" .. newTeam.name .. " - " .. className .. ")")
        ply.requested_team = newTeam
        ply.requested_class = class
        ply.requested_class_name = className
        ply.requested_class_name = className
    end
end

function GST_SNK:SwitchTeam(ply, newTeam, class, className)
    if (class and class.isDisabled) then
        ply:ChatPrint("La classe que vous aviez choisit est désactivé !")
        ply:ChatPrint("Veuillez choisir une autre classe.")
        return
    end

    ply:SetNoTarget(false)
    if (ply:GetTeam() ~= newTeam) then
        ply:SetTeam(newTeam.id)
        ply:SetNWInt("Points", 0)
    end

    if (class) then
        ply:SetClass(class, className)
        ply:ChatPrint("Nouvelle équipe (" .. newTeam.name .. " - " .. className .. ")")
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
    for teamName, currentTeam in pairs(GST_SNK.Teams) do
        if (currentTeam.id == id) then
            currentTeam.indexName = teamName
            currentTeam.indexName = teamName
            return currentTeam
        end
    end
    return {}
end