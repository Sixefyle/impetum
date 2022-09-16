AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = {
    "models/gst/titan_1.mdl",
    "models/gst/titan_2.mdl",
    "models/gst/titan_3.mdl",
    "models/gst/titan_4.mdl",
    "models/gst/titan_5.mdl",
    "models/gst/titan_6.mdl",
    "models/gst/titan_7.mdl",
} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJ_IsHugeMonster = true
ENT.StartHealth = 1000 -- or you can use a convar: GetConVarNumber("vj_dum_dummy_h")
ENT.HumanBaseHeight = 1.8
ENT.DisableDefaultMeleeAttackCode = true
ENT.DisableDefaultMeleeAttackDamageCode = true
ENT.HasDeathRagdoll = false
ENT.DisableFootStepSoundTimer = false -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.FootStepTimeRun = 0.9 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1 -- Next foot step sound when it is walking
ENT.DisableFootStepOnRun = false -- It will not play the footstep sound when running
ENT.DisableFootStepOnWalk = false -- It will not play the footstep sound when walking
ENT.SoundTbl_FootStep = {"gst/titan_footstep.wav"}
ENT.FootStepSoundLevel = 90

//ENT.IdleAlwaysWander = false -- If set to true, it will make the SNPC always wander when idling
//ENT.DisableWandering = true -- Disables wandering when the SNPC is idle
//ENT.AnimTbl_IdleStand = {ACT_WALK}
//ENT.CurIdleStandMove = false
//ENT.NextWanderTime = 0
-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

function ENT:CustomOnInitialize()
    self:CapabilitiesAdd(bit.bor(CAP_MOVE_GROUND))
    self:SetBodygroup(1, math.random(0, 13))
    self:SetSkin(math.random(0, 5))
    local realSize = math.random(6,15) / self.HumanBaseHeight
    self:SetModelScale(realSize, 0)
    self.isGrabbing = 0
    self.isAttacking = 0
end

function ENT:CustomOnDeath_BeforeCorpseSpawned(dmginfo, hitgroup)
    local ply = dmginfo:GetAttacker()

    if (dmginfo:IsBulletDamage()) then
        return
    end

    if IsValid(ply) and ply:IsPlayer() then
        ply:AddPoints(GAMEMODE.Rewards.NpcTitanKill)
        ply:AddPlayerStats(GST_SNK.AvailableStats.KilledTitan)
    end
    self:EmitSound("gst/titan_death.wav", 511, 100, 1, CHAN_AUTO )
    self:Remove()
    local body = ents.Create("prop_dynamic")
    body:SetPos(self:GetPos())
    body:SetAngles(self:GetAngles())
    body:SetModel(self:GetModel())
    --body:SetVelocity(self:GetVelocity())
    body:SetCollisionGroup(COLLISION_GROUP_PLAYER)
    body:SetSkin(self:GetSkin())
    body:FrameAdvance()
    body:Spawn()
    body:SetModelScale(self:GetModelScale(), 0)
    body:SetBodygroup(1, self:GetBodygroup(1))
    body:ResetSequence("death")
    body:ResetSequenceInfo()
    body:Fire("Kill", nil, 5)
end

function ENT:CustomAttack()
    local target = self:GetEnemy()
    --local headPos = self:GetBonePosition(self:LookupBone("mixamorig:Head"))
    local distance = target:GetPos():Distance(self:GetPos())

    -- local tr = util.TraceLine({
    --     start = headPos, --headPos
    --     endpos = target:GetPos(),
    --     filter = function(ent) return ent:GetClass() == "func_breakable" end
    -- })

    -- if IsValid(tr.Entity) then
    --     self:DemolishBuild(tr.Entity)
    -- end

    if self.isAttacking == 0 and self.isGrabbing == 0
        and target:IsPlayer() and target:Alive() then
        if distance <= 60 * self:GetModelScale() then
            self:AttackEnemy()
        elseif distance <= 70 * self:GetModelScale() then
             self:GrabEnemy()
        end
    end
end


function ENT:AttackEnemy()
    self.isAttacking = 1

    local enemyPos = self:GetEnemy():GetPos()
    local angle = (enemyPos - self:GetPos()):Angle()
    angle.x = 0
    self:SetAngles(angle)

    local headPos = self:GetBonePosition(self:LookupBone("mixamorig:Head"))
    local distance = headPos:Distance(enemyPos)

    if distance >= 150 then
        _, animTime = self:LookupSequence("falling")
        self:ApplyHullDamage(1.7)
        self:VJ_ACT_PLAYACTIVITY("falling", true, 0, false, 0)
        timer.Simple(1.5,function() self:EmitSound("gst/titan_falling.wav", 511, 100, 1, CHAN_AUTO ) end)
    else
        _, animTime = self:LookupSequence("punch1")
        self:ApplyDamage("mixamorig:RightHand", animTime, 1)
        self:VJ_ACT_PLAYACTIVITY("punch1", true, 0, false, 0)
    end

    timer.Simple(animTime, function()
        self.isAttacking = 0
    end)
end

function ENT:GrabEnemy()
    local enemyPos = self:GetEnemy():GetPos()
    local angle = (enemyPos - self:GetPos()):Angle()
    angle.x = 0
    self:SetAngles(angle)
    self:SetAngles(self:LocalToWorldAngles(Angle(0, -15, 0)))

    self:ManipulateBoneAngles(self:LookupBone("mixamorig:Spine"), Angle(0, 0, self:WorldToLocal(enemyPos):Angle()[1] + 50))
    self.isGrabbing = 1

    self:VJ_ACT_PLAYACTIVITY("grab_player", true, 0, false, 0, {AlwaysUseSequence = true})
    local animSeed = self.CurAnimationSeed

    local entIndex = self:EntIndex()
    timer.Simple(.5, function()
        timer.Create("CheckGrabPlayer" .. entIndex, .1, 0, function()
            if IsValid(self) and self.isGrabbing == 1 then
                for _, ply in pairs(ents.FindInSphere(self:GetBonePosition(self:LookupBone("mixamorig:LeftHand")), self:GetModelScale() * 9)) do
                    if IsValid(ply) and ply:IsPlayer() and ply:Alive() and not ply.isGrabbed and table.HasValue({GST_SNK.Teams.Eldien, GST_SNK.Teams.Mahr}, ply:GetTeam()) then
                        ply.isGrabbed = true
                        self.isGrabbing = 2
                        self:EatEnemy(ply)
                        break
                    end
                end
            else
                timer.Remove("CheckGrabPlayer" .. entIndex)
            end
        end)
    end)

    local _, animTime = self:LookupSequence("grab_player")
    timer.Simple(animTime, function()
        if self.CurAnimationSeed == animSeed then
            self.isGrabbing = 0
            self:ManipulateBoneAngles(self:LookupBone("mixamorig:Spine"), Angle(0, 0, 0))
        end
    end)
end

function ENT:EatEnemy(ply)
    ply:Freeze(true)
    timer.Create("SetPlayerPosToHand" .. self:EntIndex(), 0, 0, function()
        if IsValid(self) and IsValid(ply) and ply:Alive() then
            local handPos = self:GetBonePosition(self:LookupBone("mixamorig:LeftHandThumb2"))
            handPos = LerpVector(FrameTime() * 0.01, self:GetBonePosition(self:LookupBone("mixamorig:LeftHandThumb2")) + Vector(0, 0, -50), handPos)
            ply:SetPos(handPos)
        else
            timer.Remove("SetPlayerPosToHand" .. self:EntIndex())
        end
    end)

    self:VJ_ACT_PLAYACTIVITY("grab_player_manger", true, 0, false, 0, {AlwaysUseSequence = true})

    local _, animTime = self:LookupSequence("grab_player_manger")
    timer.Simple(animTime * .7, function()
        if IsValid(self) then
            ply:TakeDamage(9999, self, self)
            self.isGrabbing = 0
            self:ManipulateBoneAngles(self:LookupBone("mixamorig:Spine"), Angle(0, 0, 0))
        end
        ply.isGrabbed = false
        ply:Freeze(false)
    end)
end

function ENT:ApplyDamage(bone, time, timeBeforeCheck)
    local damagedPlayers = {}
    local entIndex = self:EntIndex()

    timer.Simple(timeBeforeCheck, function()
        timer.Create("checkNearbyPlayer" .. entIndex, .1, (time * 10) - 30, function()
            if IsValid(self) then
                local bonePos = self:GetBonePosition(self:LookupBone(bone))

                for _, ply in pairs(ents.FindInSphere(bonePos, 80)) do
                    if IsValid(ply) and ply:IsPlayer() and not table.HasValue(damagedPlayers, ply) and ply ~= self and ply:Alive() and table.HasValue({GST_SNK.Teams.Eldien, GST_SNK.Teams.Mahr}, ply:GetTeam()) then
                        ply:TakeDamage(9999, self, self)
                        table.insert(damagedPlayers, ply)
                    end
                end
            else
                timer.Remove("checkNearbyPlayer" .. entIndex)
            end
        end)
    end)
end

function ENT:ApplyHullDamage(time)
    timer.Simple(time, function()
        local hullMin = self:LocalToWorld(Vector(self:GetModelScale() * 40, self:GetModelScale() * 15, -10))
        local hullMax = self:LocalToWorld(Vector(self:GetModelScale() * -30, self:GetModelScale() * -15, 40))

        for _, ent in pairs(ents.FindInBox(hullMin, hullMax)) do
            print(ent)
            if (ent:IsValid() and ent:IsPlayer()) then
                ent:TakeDamage(9999, self:GetOwner(), self)
            end
        end
    end)
end

function ENT:DemolishBuild(ent)
    if IsValid(ent) then
        self:PlaySequenceAndWait("punch1", 1.2)
        GST_SNK.Utils:BreakNextBuildState(ent:GetName())
    end
end