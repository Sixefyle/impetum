---------------------------Info-----------------------------------
GM.Name = "Attack On Titan - Arena"
GM.Author = "Sixefyle, Green, Azellio"
GM.Email = "N/A"
GM.Website = "https://discord.gg/peaCt8KYDG"
GM.TeamBased = true
DeriveGamemode("sandbox")
GM.PointsToWin = 720 -- Max 4095
GM.EldienPoints = 0
GM.MahrPoints = 0

-- 1 GSTc =>    55 points 
--  human =>     3 points (1 GSTc = 18.3 kills)
--  titan =>     7 points (1 GSTc = 7.8  kills)
--  primo =>    20 points (1 GSTc = 2.7  kills) 
--    npc =>     5 points (1 GSTc = 11   kills)
--   flag =>   75 points (1 GSTc = 0.73 flags)
--    win => 357.5 points (1 GSTc = 0.15 win)
--   lose => 137.5 points (1 GSTc = 0.4 lose)
GM.Rewards = {
    PlayerHumanKill = 3,
    PlayerTitanKill = 7,
    PlayerPrimordialKill = 20,
    NpcTitanKill = 5,
    CaptureFlag = 75,
    RepairBuild = 5,
    Win = 357.5,
    Lose = 137.5,
    Egality = 247.5
}

------------------------------------------------------------------
function GM:Initialize()
    print("Lancement d'Impetum")
    self.BaseClass.Initialize(self)
end

--F1
function GM:ShowHelp(ply)
    ply:ConCommand("team_menu")
end

function GM:HandlePlayerJumping(ply, velocity)
    if string.match(ply:GetModel(), "titan") then return end
end

function GM:CalcMainActivity(ply, velocity)
    ply.CalcIdeal = ACT_MP_STAND_IDLE
    ply.CalcSeqOverride = -1
    self:HandlePlayerLanding(ply, velocity, ply.m_bWasOnGround)

    local playerTeam = ply:GetTeam()
    if not (self:HandlePlayerNoClipping(ply, velocity) or self:HandlePlayerDriving(ply) or self:HandlePlayerVaulting(ply, velocity) or self:HandlePlayerJumping(ply, velocity) or self:HandlePlayerSwimming(ply, velocity) or self:HandlePlayerDucking(ply, velocity)) then
        local len2d = velocity:Length2DSqr()

        if playerTeam == GST_SNK.Teams.Titan and len2d > math.pow(ply:GetWalkSpeed(), 2.01) or
        (playerTeam ~= GST_SNK.Teams.Titan and len2d > 22500) then
            ply.CalcIdeal = ply.RunAct ~= nil and ply.RunAct or ACT_MP_RUN
        elseif len2d > 0.25 then
            ply.CalcIdeal = ply.WalkAct ~= nil and ply.WalkAct or ACT_MP_WALK
        end
    end

    ply.m_bWasOnGround = ply:IsOnGround()
    ply.m_bWasNoclipping = ply:GetMoveType() == MOVETYPE_NOCLIP and not ply:InVehicle()

    if SERVER and string.len(ply:GetNWString("doAnimation")) > 0 then
        ply.CalcSeqOverride = ply:LookupSequence(ply:GetNWString("doAnimation"))
    end

    return ply.CalcIdeal, ply.CalcSeqOverride
end

if CLIENT then
    local function DoSkill(ply, skill)
        if IsFirstTimePredicted() and skill:CanPrimaryAttack() then
            local oldWeap = ply:GetActiveWeapon()
            input.SelectWeapon(skill)

            timer.Simple(1, function()
                if (skill == LocalPlayer():GetActiveWeapon()) then
                    net.Start("AOTA:TS:FireSkill")
                    net.WriteEntity(skill)
                    net.SendToServer()
                    skill:PrimaryAttack()

                    timer.Simple(1, function()
                        input.SelectWeapon(oldWeap)
                    end)
                end
            end)
        end
    end

    local function DoTitanSkill(ply, skillId)
        if IsFirstTimePredicted() and skillId then
            net.Start("AOTA:TS:FireTitanSkill")
            net.WriteUInt(skillId, 3)
            net.SendToServer()
        end
    end

    hook.Add("PlayerButtonDown", "DoPlayerSkill", function(ply, key)
        for i, skill in ipairs(ply:GetSkills()) do
            if ply.preference.skill_key[i] == key then
                if type(skill) == "Weapon" then
                    DoSkill(ply, skill)
                else
                    DoTitanSkill(ply, i)
                end
            end
        end
    end)
end