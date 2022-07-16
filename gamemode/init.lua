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
AddCSLuaFile("vgui/cl_winner_board.lua")
AddCSLuaFile("vgui/cl_preference.lua")

include("shared.lua")
include("sv_net.lua")
include("sh_resources.lua")
include("sh_teams.lua")
include("sh_class.lua")
include("player.lua")
include("spawn_replace.lua")
include("utils.lua")
include("sv_map_config.lua")

-- util.AddNetworkString("InitializePlayerPref")
-- util.AddNetworkString("SavePlayerPref")
util.AddNetworkString("ReceiveTeamPoints")
util.AddNetworkString("ShowWinnerPanel")
util.AddNetworkString("ReceiveServerClassInfo")

local function SpawnFlags()
    if (GST_SNK.Maps[game.GetMap()].CaptureFlags and not table.IsEmpty(GST_SNK.Maps[game.GetMap()].CaptureFlags)) then
        for _, flag in pairs(GST_SNK.Maps[game.GetMap()].CaptureFlags ) do
            if (IsValid(flag)) then
                flag:Remove()
            end
        end

        table.Empty(GST_SNK.Maps[game.GetMap()].CaptureFlags)
    end

    GST_SNK.Maps[game.GetMap()].CaptureFlags = {}
    for index, position in ipairs(GST_SNK.Maps[game.GetMap()].CaptureFlagsPosition) do
        GST_SNK.Maps[game.GetMap()].CaptureFlags[index] = GST_SNK.Utils:SpawnCaptureFlag(position, index)
    end
end

function GM:SendCapturesPointsInfo(ply)
    net.Start("ReceiveServerClassInfo")
        net.WriteUInt(GAMEMODE.EldienPoints, 8)
        net.WriteUInt(GAMEMODE.MahrPoints, 8)

        for _, flag in pairs(GST_SNK.Maps[game.GetMap()].CaptureFlags) do
            net.WriteColor(flag.OwnerTeam and flag.OwnerTeam.color or Color(100,100,100,100))
        end
    net.Send(ply)
end

function GM:SendServerClassInfo(ply)
    net.Start("ReceiveServerClassInfo")
        net.WriteTable(GST_SNK.Classes)
    net.Send(ply)
end

function GM:Initialize()
    timer.Simple(0.01, PlaceSpawns)
    RunConsoleCommand("sbox_godmode", "0")

    SpawnFlags()
    self.gameEnded = false

    timer.Create("AddTeamPoints", 5, 0, function()
        local _, err = pcall(function() self:AddTeamPoints() end)

        if (err) then
            print("Erreur lors de l'ajout des points aux équipes !")
            print(err)
            SpawnFlags()
        end
    end)
end

local function GetBestPlayers(winnerTeam)
    if (not winnerTeam) then return end
    local players = {}
    local index = 1
    for _, ply in pairs(player.GetAll()) do
        if (IsValid(ply) and ply:GetTeam() == winnerTeam) then
            players[index] = {}
            players[index]["name"] = ply:GetName()
            players[index]["points"] = ply:GetNWInt("Points")
            index = index + 1
        end
    end
    table.sort(players, function(a, b) return a.points > b.points end)

    return players
end

function GM:AddTeamPoints()
    if (self.gameEnded) then return end

    for _, flag in pairs(GST_SNK.Maps[game.GetMap()].CaptureFlags) do
        if (not flag.OwnerTeam) then continue end

        if (flag.OwnerTeam.name == "Eldien") then
            self.EldienPoints = self.EldienPoints + 1
        else
            self.MahrPoints = self.MahrPoints + 1
        end
    end

    net.Start("ReceiveTeamPoints")
        net.WriteUInt(self.EldienPoints, 8)
        net.WriteUInt(self.MahrPoints, 8)
    net.Broadcast()

    if (self.EldienPoints >= self.PointsToWin or self.MahrPoints >= self.PointsToWin) then
        self.gameEnded = true
        local winnerTeam = self.EldienPoints >= self.PointsToWin and GST_SNK.Teams.Eldien or GST_SNK.Teams.Mahr
        self:PauseGame()

        for _, ply in pairs(player.GetAll()) do
            if (ply:GetTeam() == winnerTeam) then
                ply:AddPoints(self.Rewards.Win)
            else
                ply:AddPoints(self.Rewards.Lose)
            end
        end

        timer.Simple(.1, function()
            net.Start("ShowWinnerPanel")
                local bestPlayers = GetBestPlayers(winnerTeam)
                net.WriteUInt(winnerTeam.id, 2)
                net.WriteTable(bestPlayers)
            net.Broadcast()
        end)

        timer.Simple(15, function()
            local nextMap = table.Random(table.GetKeys(GST_SNK.Maps))
            RunConsoleCommand("nextlevel", nextMap)
            game.LoadNextMap()
        end)
    end
end

function GM:PauseGame()
    for _, ent in pairs(ents.GetAll()) do
        if (IsValid(ent)) then
            ent:SetMoveType(MOVETYPE_NONE)
            if (ent:IsPlayer()) then
                ent:Freeze(true)
            end
        end
    end
end

function GM:PlayerConnect(name, ip)
    print(name .. " a rejoins la partie.")
end

function GM:PlayerInitialSpawn(ply)
    print("Player " .. ply:Nick() .. " has spawned.")

    timer.Simple(3, function()
        ply.unlocked_classes = ply:GetUnlockedClass()
        ply:SendUnlockedClasses()
        GST_SNK:SwitchTeam(ply, GST_SNK.Teams.NoTeam, nil)
        --ply:ConCommand("team_menu")

        if (not ply:GetNWInt("Points")) then
            ply:SetNWInt("Points", 0)
        end

        self:SendCapturesPointsInfo(ply)
        self:SendServerClassInfo(ply)
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
    if (ply:GetCurrentClass() and ply:GetCurrentClass().isDisabled) then
        ply:SetTeam(GST_SNK.Teams.NoTeam.id)
        --ply:SetClass(nil)
        ply:ChatPrint("Cette classe est désactivé !")
        ply:ChatPrint("Veuillez prendre une autre classe")
        ply:KillSilent()
    end

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

    -- if IsValid(attacker) and attacker:GetClass() == "trigger_hurt" then
    --     attacker = ply
    -- end

    -- if IsValid(attacker) and attacker:IsVehicle() and IsValid(attacker:GetDriver()) then
    --     attacker = attacker:GetDriver()
    -- end

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
    ply.canGoInSafeZone = true

    if attacker:IsValid() and attacker:IsPlayer() and attacker ~= ply then
        if (ply:GetTeam() == GST_SNK.Teams.Titan) then
            attacker:AddPoints(self.Rewards.PlayerTitanKill)
        elseif (ply:GetTeam() == GST_SNK.Teams.Primordial) then
            attacker:AddPoints(self.Rewards.PlayerPrimordialKill)
        else
            attacker:AddPoints(self.Rewards.PlayerHumanKill)
        end
        attacker:AddFrags(1)
    end
end

function GM:PlayerSilentDeath(ply)
    ply.canGoInSafeZone = true
end

function GM:PlayerAuthed(ply, steamID, uniqueID)
    print("Player: " .. ply:Nick() .. " has been authenticated.")
end

function GM:GetFallDamage(ply, speed)
    return 0
end

--Start Damage Modifiers
function GM:EntityTakeDamage(ent, dmginfo)
    local attacker = dmginfo:GetAttacker()
    if dmginfo ~= nil then
        if(ent:IsPlayer() and table.HasValue({GST_SNK.Teams.Primordial}, ent:GetTeam()) and ent:Health() - dmginfo:GetDamage() <= 0) then
            ent:SetHealth(1)
            ent:GodEnable()
            timer.Simple(GST_SNK.Utils:RunAnimation("death", ent, true) or 0, function()
                ent:GodDisable()
                self:DoPlayerDeath(ent, attacker, dmginfo)
                ent:Spawn()
            end)
        end
    end
end

function GM:PlayerShouldTakeDamage(victim, attacker)
    if cvars.Bool("sbox_godmode", false) then return false end
    --if not IsValid(victim:GetActiveWeapon()) then return true end

    if string.match(victim:GetModel(), "titan") then
        if attacker:IsNPC() then return true end
        if not attacker:IsPlayer() then return false end
        if not IsValid(attacker:GetActiveWeapon()) then return false end

        if attacker:GetActiveWeapon():GetClass() == "skill_musket" then
            return false
        end
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

function SetupMapLua()
    MapLua = ents.Create("lua_run")
    MapLua:SetName("triggerhook")
    MapLua:Spawn()

    for k, v in pairs(ents.FindByClass("trigger_multiple")) do
        if (v:GetName() == "trigger_eldien") then
            v:Fire("AddOutput", "OnStartTouch triggerhook:RunPassedCode:hook.Run( 'EldienEnterSpawn' ):0:-1")
            v:Fire("AddOutput", "OnEndTouch triggerhook:RunPassedCode:hook.Run( 'EldienExitSpawn' ):0:-1")
        end

        if (v:GetName() == "trigger_mahr") then
            v:Fire("AddOutput", "OnStartTouch triggerhook:RunPassedCode:hook.Run( 'MahrEnterSpawn' ):0:-1")
            v:Fire("AddOutput", "OnEndTouch triggerhook:RunPassedCode:hook.Run( 'MahrExitSpawn' ):0:-1")
        end
    end
end

hook.Add("InitPostEntity", "SetupMapLua", SetupMapLua)
hook.Add("PostCleanupMap", "SetupMapLua", SetupMapLua)

hook.Add("EldienEnterSpawn", "TestTeleportHook", function()
    local activator, caller = ACTIVATOR, CALLER

    if (IsValid(activator) and activator:IsPlayer() and activator:GetTeam() == GST_SNK.Teams.Eldien and activator.canGoInSafeZone) then
        activator:GodEnable()
    else
        local vel = activator:GetVelocity() * -4
        vel.z = vel.z * -1
        activator:SetVelocity(vel)
        activator:Freeze(true)

        timer.Simple(2, function()
            activator:Freeze(false)
        end)

        local weap = activator:GetActiveWeapon()
        if (IsValid(weap) and weap:GetClass() == "gst_3dmg") then
            weap:RemoveRopes()
        end
    end
end)

hook.Add("EldienExitSpawn", "TestTeleportHook", function()
    local activator, caller = ACTIVATOR, CALLER

    if (IsValid(activator) and activator:IsPlayer()) then
        activator:GodDisable()
        activator.canGoInSafeZone = false
    end
end)

hook.Add("MahrEnterSpawn", "TestTeleportHook", function()
    local activator, caller = ACTIVATOR, CALLER

    if (IsValid(activator) and activator:IsPlayer() and activator:GetTeam() == GST_SNK.Teams.Mahr and activator.canGoInSafeZone) then
        activator:GodEnable()
    else
        local vel = activator:GetVelocity() * -4
        vel.z = vel.z * -1
        activator:SetVelocity(vel)
        activator:Freeze(true)

        timer.Simple(2, function()
            activator:Freeze(false)
        end)

        local weap = activator:GetActiveWeapon()
        if (IsValid(weap) and weap:GetClass() == "gst_3dmg") then
            weap:RemoveRopes()
        end
    end
end)

hook.Add("MahrExitSpawn", "TestTeleportHook", function()
    local activator, caller = ACTIVATOR, CALLER

    if (IsValid(activator) and activator:IsPlayer()) then
        activator:GodDisable()
        activator.canGoInSafeZone = false
    end
end)

concommand.Add("reset_flags", function()
    SpawnFlags()
end)

concommand.Add("reset_teams_points", function()
    GAMEMODE.EldienPoints = 0
    GAMEMODE.MahrPoints = 0
    GAMEMODE.gameEnded = false
    print("Points des équipes remis à 0 !")
end)

concommand.Add("disable", function(ply, cmd, args)
    if (#args >= 2 and GST_SNK.Classes[args[1]][args[2]]) then -- TODO: changer cette fonction horrible
        if (GST_SNK.Classes[args[1]][args[2]].isDisabled) then
            GST_SNK.Classes[args[1]][args[2]].isDisabled = false
        else
            GST_SNK.Classes[args[1]][args[2]].isDisabled = true
        end

        net.Start("GetNewLockedClass")
            net.WriteString(args[1])
            net.WriteString(args[2])
            net.WriteBool(GST_SNK.Classes[args[1]][args[2]].isDisabled)
        net.Broadcast()

        local text = "La classe " .. args[2] .. " de l'équipe " .. args[1] .. " est maintenant " .. (GST_SNK.Classes[args[1]][args[2]].isDisabled and "désactivé" or "activé")
        if (IsValid(ply)) then
            ply:ChatPrint(text)
        end
        print(text .. (IsValid(ply) and " - " .. ply:GetName() or ""))

        if (args[3] and args[3] == "true") then
            for _, currentPly in pairs(player.GetAll()) do
                if (IsValid(currentPly) and
                currentPly:Alive() and
                currentPly:GetTeam() == GST_SNK.Teams[args[1]] and
                currentPly:GetCurrentClass().id == GST_SNK.Classes[args[1]][args[2]].id) then

                    currentPly:KillSilent()
                    currentPly:ChatPrint("Cette classe est désactivé et doit être changé tout de suite.")
                    currentPly:ChatPrint("Veuillez prendre une autre classe")
                end
            end
        end
    end
end)

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