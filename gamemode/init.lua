AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_resources.lua")
AddCSLuaFile("cl_preference.lua")
AddCSLuaFile("sh_teams.lua")
AddCSLuaFile("sh_class.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_menu.lua")
AddCSLuaFile("cl_net.lua")
AddCSLuaFile("utils.lua")
AddCSLuaFile("vgui/cl_hud.lua")
AddCSLuaFile("vgui/cl_scoreboard.lua")
AddCSLuaFile("vgui/cl_team_selection.lua")
AddCSLuaFile("vgui/cl_class_selection.lua")
AddCSLuaFile("vgui/cl_build_select.lua")
include("shared.lua")
include("sv_net.lua")
include("sh_resources.lua")
include("sh_teams.lua")
include("sh_class.lua")
include("player.lua")
include("spawn_replace.lua")
include("utils.lua")
include("sv_desctructible_build_config.lua")



-- util.AddNetworkString("InitializePlayerPref")
-- util.AddNetworkString("SavePlayerPref")

function GM:Initialize()
    timer.Simple(0.01, PlaceSpawns)
    RunConsoleCommand("sbox_godmode", "0")
end

function GM:PlayerConnect(name, ip)
    print(name .. " a rejoins la partie.")
end


function GM:PlayerInitialSpawn(ply)
    print("Player " .. ply:Nick() .. " has spawned.")

    timer.Simple(3, function()
        ply.unlocked_classes = ply:GetUnlockedClass()
        ply:SendUnlockedClasses()

        ply:ConCommand("team_menu")
    end)

    ply.initialSpawn = true
end

function GM:PlayerDisconnected(ply)
    ply:SaveUnlockedClass()
end

--End Team Configuration
-- Initializes all the commands, or networked vars
util.AddNetworkString("TeamSelect")
util.AddNetworkString("MutePlayer")
util.AddNetworkString("UnMutePlayer")

-- Ends Here
function GM:PlayerSpawn(ply)
    ply:SetArmor(100)
    local oldhands = ply:GetHands()

    if IsValid(oldhands) then
        oldhands:Remove()
    end

    local hands = ents.Create("gmod_hands")

    if IsValid(hands) then
        ply:SetHands(hands)
        hands:SetOwner(ply)
        -- Which hands should we use?
        local cl_playermodel = ply:GetInfo("cl_playermodel")
        local info = player_manager.TranslatePlayerHands(cl_playermodel)

        if info then
            hands:SetModel(info.model)
            hands:SetSkin(info.skin)
            hands:SetBodyGroups(info.body)
        end

        -- Attach them to the viewmodel
        local vm = ply:GetViewModel(0)
        hands:AttachToViewmodel(vm)
        vm:DeleteOnRemove(hands)
        ply:DeleteOnRemove(hands)
        hands:Spawn()
    end

    if (ply.requested_team and ply.requested_class) then
        GST_SNK:SwitchTeam(ply, ply.requested_team, ply.requested_class)
        ply.requested_team = nil
        ply.requested_class = nil
    end
    ply:GiveGamemodeWeapons()

    timer.Simple(.05, function()
        net.Start("ForceHudRefresh")
        net.Send(ply)
    end)

    if (ply:GetCurrentClass() ~= nil and ply:GetCurrentClass().health) then
        local playerClass = ply:GetCurrentClass()
        ply:SetMaxHealth(playerClass.health)
        ply:SetHealth(playerClass.health)

        if (playerClass.speed and playerClass.max_speed) then
            ply:SetRunSpeed(playerClass.max_speed)
            ply:SetWalkSpeed(playerClass.speed)
        end
    end
end

function GM:PlayerDeath(ply, inflictor, attacker)
    -- Don't spawn for at least 2 seconds
    ply.NextSpawnTime = CurTime() + 2
    ply.DeathTime = CurTime()

    if IsValid(attacker) and attacker:GetClass() == "trigger_hurt" then
        attacker = ply
    end

    if IsValid(attacker) and attacker:IsVehicle() and IsValid(attacker:GetDriver()) then
        attacker = attacker:GetDriver()
    end

    if not IsValid(inflictor) and IsValid(attacker) then
        inflictor = attacker
    end

    -- Convert the inflictor to the weapon that they're holding if we can.
    -- This can be right or wrong with NPCs since combine can be holding a 
    -- pistol but kill you by hitting you with their arm.
    if IsValid(inflictor) and inflictor == attacker and (inflictor:IsPlayer() or inflictor:IsNPC()) then
        inflictor = inflictor:GetActiveWeapon()

        if not IsValid(inflictor) then
            inflictor = attacker
        end
    end

    if attacker == ply then
        net.Start("PlayerKilledSelf")
			net.WriteEntity(ply)
			net.Broadcast()
        MsgAll(attacker:Nick() .. " s'est suicidé!\n")

        return
    end

    if attacker:IsPlayer() then
        net.Start("PlayerKilledByPlayer")
			net.WriteEntity(ply)
			net.WriteString(inflictor:GetClass())
			net.WriteEntity(attacker)
        net.Broadcast()
        MsgAll(attacker:Nick() .. " a tué " .. ply:Nick() .. " avec " .. inflictor:GetClass() .. "\n")

        return
    end

    net.Start("PlayerKilled")
		net.WriteEntity(ply)
		net.WriteString(inflictor:GetClass())
		net.WriteString(attacker:GetClass())
    net.Broadcast()
    MsgAll(ply:Nick() .. " a été tué par " .. attacker:GetClass() .. "\n")
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
    ply:CreateRagdoll()
    ply:AddDeaths(1)

    if attacker:IsValid() and attacker:IsPlayer() then
        if attacker == ply then
            attacker:AddFrags(-1)
        else
            attacker:AddFrags(1)
        end
    end
end

-- function GM:PlayerSelectSpawn(ply)
--     local default = ents.FindByClass("info_player_start")
--     local titan = ents.FindByClass("info_player_titan")
--     local corp = ents.FindByClass("info_player_corps")
--     local spectator = ents.FindByClass("info_player_spectator")
--     local mapIsAOT = string.find(string.lower(game.GetMap()), "aot_")
--     local et = ents.AOTSPAWNS
--     local import = et.CanImportEntities(game.GetMap())
--     local random_default = math.random(#default)
--     local random_titan = math.random(#titan)
--     local random_corp = math.random(#corp)
--     local random_spectator = math.random(#spectator)

--     if mapIsAOT or import then
--         if ply:Team() == TEAM_TITAN_N then
--             return titan[random_titan]
--         elseif ply:Team() == TEAM_CORP_N then
--             return corp[random_corp]
--         elseif ply:Team() == TEAM_SPEC_N then
--             return spectator[random_spectator]
--         end
--     else
--         return default[random_default]
--     end
-- end

function GM:PlayerAuthed(ply, steamID, uniqueID)
    print("Player: " .. ply:Nick() .. " has been authenticated.")
end

function GM:GetFallDamage(ply, speed)
    return 0
end

--Start Damage Modifiers
function GM:EntityTakeDamage(ent, dmginfo)
    local attacker = dmginfo:GetAttacker()

    --end
    if dmginfo ~= nil then
        if  dmginfo:IsFallDamage() then
            dmginfo:ScaleDamage(0)
        end

        if attacker:IsPlayer() then
            if attacker:GetStepSize() == 170 and ent:GetName() == "AOT_Breakable_Wall_Titan" then
                dmginfo:ScaleDamage(0.2)
                attacker:PrintMessage(HUD_PRINTCONSOLE, "The wall's HP is at " .. tostring(ent:Health() - 100) .. " HP")
                -- the wall hp is at ???????? il se fout de ma gueule en plus ce con, d'ou on donne les hp d'un mur..........................

                if ent:Health() - 100 == 0 then
                    for k, v in pairs(player.GetAll()) do
                        v:PrintMessage(HUD_PRINTTALK, attacker:GetName() .. " has destroyed a wall")
                    end
                end
            elseif ent:GetName() == "AOT_Breakable_Wall_Titan" then
                dmginfo:ScaleDamage(0)
                attacker:PrintMessage(HUD_PRINTCONSOLE, "You cannot break this wall.")
            end
        elseif ent:GetName() == "AOT_Breakable_Wall_Titan" then
            dmginfo:ScaleDamage(0)
        end
    end
end

function GM:PlayerShouldTakeDamage(victim, attacker)
    if cvars.Bool("sbox_godmode", false) then return false end
    if not IsValid(victim:GetActiveWeapon()) then return true end

    if victim:GetStepSize() == 170 then
        if attacker:IsNPC() then return false end
        if not attacker:IsPlayer() then return false end
        if not IsValid(attacker:GetActiveWeapon()) then return false end

        if attacker:GetActiveWeapon():GetClass() == "gst_3dmg" or attacker:GetActiveWeapon():GetClass() == "3d_maneuver_gear_expert_c" then
            return true
        else
            return false
        end
    else
        return true
    end

    return true
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
    local attacker = dmginfo:GetAttacker()

    if attacker:IsPlayer() and attacker:GetActiveWeapon():IsValid() and
    attacker:Team() == GST_SNK.Teams.Eldien.id or attacker:Team() == GST_SNK.Teams.Mahr.id then
        if ply:GetStepSize() == 170 and hitgroup == 1 then
            dmginfo:SetDamage(ply:Health())
        elseif ply:GetStepSize() == 170 then
            dmginfo:SetDamage(0)
        end
    end
end

--End Damage Modifiers
hook.Add("PlayerSay", "MutePlayers", function(ply, text, public)
    cvar = string.Explode(" ", text)

    if (cvar[1] == "/mute") and cvar[2] ~= nil then
        for k, v in pairs(player.GetAll()) do
            if v ~= ply and string.match(string.lower(v:GetName()), string.lower(cvar[2])) then
                net.Start("MutePlayer")
                net.WriteEntity(v)
                net.Send(ply)

                return false
            elseif string.match(string.lower(ply:GetName()), string.lower(cvar[2])) then
                ply:ChatPrint("You are trying to mute yourself.")

                return false
            end
        end

        ply:ChatPrint("The player with the nickname " .. cvar[2] .. " was not found.")

        return false
    elseif (cvar[1] == "/unmute") and cvar[2] ~= nil then
        for k, v in pairs(player.GetAll()) do
            if v ~= ply and string.match(string.lower(v:GetName()), string.lower(cvar[2])) then
                net.Start("UnMutePlayer")
                net.WriteEntity(v)
                net.Send(ply)

                return false
            elseif string.match(string.lower(ply:GetName()), string.lower(cvar[2])) then
                ply:ChatPrint("You are trying to unmute yourself.")

                return false
            end
        end

        ply:ChatPrint("The player with the nickname " .. cvar[2] .. " was not found.")

        return false
    elseif cvar[2] == nil and (cvar[1] == "/mute") then
        ply:ChatPrint("Please add a name after /mute.")

        return false
    elseif cvar[2] == nil and (cvar[1] == "/unmute") then
        ply:ChatPrint("Please add a name after /unmute.")

        return false
    elseif cvar[1] == "/kill" then
        umsg.Start("PlayerSuicideAOT", ply)
        umsg.End()

        return false
    end
end)