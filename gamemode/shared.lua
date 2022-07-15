---------------------------Info-----------------------------------
GM.Name = "Attack On Titan - Arena"
GM.Author = "Sixefyle, Green, Azellio"
GM.Email = "N/A"
GM.Website = "https://discord.gg/peaCt8KYDG"
GM.TeamBased = true
DeriveGamemode("sandbox")
GM.PointsToWin = 720
GM.EldienPoints = 0
GM.MahrPoints = 0

-- 1 GSTc =>    55 points 
--  human =>     3 points (1 GSTc = 18.3 kills) v
--  titan =>     7 points (1 GSTc = 7.8  kills) v
--  primo =>    20 points (1 GSTc = 2.7  kills) v
--    npc =>     5 points (1 GSTc = 11   kills)
--   flag =>   100 points (1 GSTc = 0.55 flags)
--    win => 357.5 points (1 GSTc = 0.15 win)
--   lose => 137.5 points (1 GSTc = 0.4 lose)
GM.Rewards = {
    PlayerHumanKill = 3,
    PlayerTitanKill = 7,
    PlayerPrimordialKill = 20,
    NpcTitanKill = 5,
    CaptureFlag = 100,
    Win = 357.5,
    Lose = 137.5
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

    if not (self:HandlePlayerNoClipping(ply, velocity) or self:HandlePlayerDriving(ply) or self:HandlePlayerVaulting(ply, velocity) or self:HandlePlayerJumping(ply, velocity) or self:HandlePlayerSwimming(ply, velocity) or self:HandlePlayerDucking(ply, velocity)) then
        local len2d = velocity:Length2DSqr()

        if len2d > 22500 then
            ply.CalcIdeal = ACT_MP_RUN
        elseif len2d > 0.25 then
            ply.CalcIdeal = ACT_MP_WALK
        end
    end

    ply.m_bWasOnGround = ply:IsOnGround()
    ply.m_bWasNoclipping = ply:GetMoveType() == MOVETYPE_NOCLIP and not ply:InVehicle()

    if SERVER then
        if string.len(ply:GetNWString("doAnimation")) > 0 then
            ply.CalcSeqOverride = ply:LookupSequence(ply:GetNWString("doAnimation"))
        end
    end

    return ply.CalcIdeal, ply.CalcSeqOverride
end

if CLIENT then
    local function DoSkill(ply, skill)
        if IsFirstTimePredicted() and skill:CanPrimaryAttack() then
            local oldWeap = ply:GetActiveWeapon()
            input.SelectWeapon(skill)

            timer.Simple(2, function()
                net.Start("FireSkill")
                net.WriteEntity(skill)
                net.SendToServer()
                skill:PrimaryAttack()

                timer.Simple(2, function()
                    input.SelectWeapon(oldWeap)
                end)
            end)
        end
    end

    local function DoTitanSkill(ply, skillId)
        if IsFirstTimePredicted() and skillId then
            net.Start("FireTitanSkill")
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