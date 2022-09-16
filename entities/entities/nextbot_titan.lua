AddCSLuaFile()
ENT.Base = "base_nextbot"
ENT.Spawnable = true
ENT.PrintName = "Titan"

ENT.Height = {5, 7, 10, 15}

ENT.HumanBaseHeight = 1.8
ENT.AttackSpeed = 1
ENT.SpeedIncrease = 1.4
ENT.Speed = 300

ENT.TitanModel = {
    "models/gst/titan_1.mdl",
    "models/gst/titan_2.mdl",
    "models/gst/titan_3.mdl",
    "models/gst/titan_4.mdl",
    "models/gst/titan_5.mdl",
    "models/gst/titan_6.mdl",
    "models/gst/titan_7.mdl",
}

function ENT:Initialize()
    if SERVER then
        self:SetName("Titan")
        self:SetMaxHealth(1000)
        self:SetHealth(self:GetMaxHealth())
    end

    self:SetModel(table.Random(self.TitanModel))
    self:SetBodygroup(1, math.random(0, 13))
    self:SetSkin(math.random(0, 5))
    local realSize = math.random(10, 20) / self.HumanBaseHeight
    self:SetModelScale(realSize, 1)
    self.Speed = self:GetModelScale() * 80 + (self:GetModelScale() * .1) * 1000
    self.LoseTargetDist = 4000 -- How far the enemy has to be before we lose them
    self.SearchRadius = 2500 -- How far to search for enemies
    self.isGrabbing = 0
end

function ENT:Think()
    if self:GetEnemy() and IsValid(self:GetEnemy()) then
        local enemyGroundRelationPos = self:GetEnemy():GetPos()
        enemyGroundRelationPos.z = 0
        local selfGroundRelationPos = self:GetPos()
        selfGroundRelationPos.z = 0
        local groundRelationDistance = (enemyGroundRelationPos - selfGroundRelationPos):Length()

        if groundRelationDistance <= 40 then
            self:StartActivity(ACT_IDLE)
        end
    end
end

----------------------------------------------------
-- ENT:Get/SetEnemy()
-- Simple functions used in keeping our enemy saved
----------------------------------------------------
function ENT:SetEnemy(ent)
    self.Enemy = ent
end

function ENT:GetEnemy()
    return self.Enemy
end

----------------------------------------------------
-- ENT:HaveEnemy()
-- Returns true if we have a enemy
----------------------------------------------------
function ENT:HaveEnemy()
    -- If our current enemy is valid
    if self:GetEnemy() and IsValid(self:GetEnemy()) then
        -- If the enemy is too far
        if self:GetRangeTo(self:GetEnemy():GetPos()) > self.LoseTargetDist then
            -- If the enemy is lost then call FindEnemy() to look for a new one
            -- FindEnemy() will return true if an enemy is found, making this function return true
            return self:FindEnemy()
        elseif self:GetEnemy():IsPlayer() and not table.HasValue({GST_SNK.Teams.Eldien, GST_SNK.Teams.Mahr}, self:GetEnemy():GetTeam()) and not self:GetEnemy():Alive() then
            -- If the enemy is dead( we have to check if its a player before we use Alive() )
            return self:FindEnemy() -- Return false if the search finds nothing
        end
        -- The enemy is neither too far nor too dead so we can return true

        return true
    else
        -- The enemy isn't valid so lets look for a new one
        return self:FindEnemy()
    end
end

----------------------------------------------------
-- ENT:FindEnemy()
-- Returns true and sets our enemy if we find one
----------------------------------------------------
function ENT:FindEnemy()
    -- Search around us for entities
    -- This can be done any way you want eg. ents.FindInCone() to replicate eyesight
    local _ents = ents.FindInSphere(self:GetPos(), self.SearchRadius)

    -- Here we loop through every entity the above search finds and see if it's the one we want
    for k, v in ipairs(_ents) do
        if v:IsPlayer() and not v:IsFlagSet(FL_NOTARGET) and string.match(v:GetModel(), "titan") ~= "titan" then
            -- We found one so lets set it as our enemy and return true
            self:SetEnemy(v)

            return true
        end
    end

    -- We found nothing so we will set our enemy as nil (nothing) and return false
    self:SetEnemy(nil)

    return false
end

----------------------------------------------------
-- ENT:RunBehaviour()
-- This is where the meat of our AI is
----------------------------------------------------
function ENT:RunBehaviour()
    -- This function is called when the entity is first spawned. It acts as a giant loop that will run as long as the NPC exists
    while true do
        self.loco:SetStepHeight(10 * self:GetModelScale())

        -- Lets use the above mentioned functions to see if we have/can find a enemy
        if self:HaveEnemy() then
            -- Now that we have an enemy, the code in this block will run
            self.loco:FaceTowards(self:GetEnemy():GetPos()) -- Face our enemy
            self:StartActivity(ACT_RUN) -- Set the animation
            self.loco:SetDesiredSpeed(self.Speed) -- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
            --self.loco:SetAcceleration(self.Speed * 1.2) -- We are going to run at the enemy quickly, so we want to accelerate really fast
            self:ChaseEnemy() -- The new function like MoveToPos.
            --self.loco:SetAcceleration(self.Speed) -- Set this back to its default since we are done chasing the enemy
            self:StartActivity(ACT_IDLE) --We are done so go back to idle
            -- Now once the above function is finished doing what it needs to do, the code will loop back to the start
            -- unless you put stuff after the if statement. Then that will be run before it loops
        else
            self:ManipulateBoneAngles(self:LookupBone("mixamorig:Spine"), Angle(0, 0, 0))
            -- Since we can't find an enemy, lets wander
            -- Its the same code used in Garry's test bot
            self:StartActivity(ACT_WALK) -- Walk anmimation
            self.loco:SetDesiredSpeed(self.Speed) -- Walk speed
            self:MoveToPos(self.ForceGotoPos and self.ForceGotoPos or self:GetPos() + Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0) * 400) -- Walk to a random place within about 400 units (yielding)
            self:StartActivity(ACT_IDLE)
        end

        -- At this point in the code the bot has stopped chasing the player or finished walking to a random spot
        -- Using this next function we are going to wait 2 seconds until we go ahead and repeat it 
        coroutine.wait(.001)
    end
end

----------------------------------------------------
-- ENT:ChaseEnemy()
-- Works similarly to Garry's MoveToPos function
--  except it will constantly follow the
--  position of the enemy until there no longer
--  is one.
----------------------------------------------------
function ENT:ChaseEnemy(options)
    local options = options or {}
    local path = Path("Follow")
    path:SetMinLookAheadDistance(options.lookahead or 300)
    path:SetGoalTolerance(options.tolerance or 40)
    path:Compute(self, self:GetEnemy():GetPos()) -- Compute the path towards the enemies position
    if not path:IsValid() then return "failed" end

    while path:IsValid() and self:HaveEnemy() do
        if self:GetNWString("DoAnimation") == "" then
            self.isGrabbing = 0
        end

        if self.isGrabbing ~= 0 then
            coroutine.yield()
            continue
        end

        self:ManipulateBoneAngles(self:LookupBone("mixamorig:Spine"), Angle(0, 0, (self:GetEnemy():GetPos() - self:EyePos()):Angle()[1] + (self:GetModelScale() * 3)))

        local tr = util.TraceLine({
            start = self:EyePos(),
            endpos = self:GetPos() + self:EyeAngles():Forward() * 200 + Vector(0, 0, 300),
            filter = function(ent) return ent:GetClass() == "func_breakable" end
        })

        if IsValid(tr.Entity) then
            self:DemolishBuild(tr.Entity)
        end

        local enemyDistance = self:GetEnemy():GetPos():Distance(self:EyePos())

        if not self.isAttacking and self:GetEnemy():IsPlayer() and self:GetEnemy():Alive() then
            if enemyDistance <= 60 * self:GetModelScale() then
                self:AttackEnemy()
            elseif enemyDistance <= 80 * self:GetModelScale() then
                self:GrabEnemy()
            end
        end

        -- Since we are following the player we have to constantly remake the path
        if path:GetAge() > 0.1 then
            path:Compute(self, self:GetEnemy():GetPos()) -- Compute the path towards the enemy's position again
        end

        path:Update(self) -- This function moves the bot along the path

        if options.draw then
            path:Draw()
        end

        -- If we're stuck, then call the HandleStuck function and abandon
        if self.loco:IsStuck() then
            self:HandleStuck()

            return "stuck"
        end

        coroutine.yield()
    end

    return "ok"
end

function ENT:AttackEnemy()
    self.isAttacking = true
    local enemyPos = self:GetEnemy():GetPos()
    local angle = (enemyPos - self:GetPos()):Angle()
    angle.x = 0
    self:SetAngles(angle)
    local distanceFromFeets = self:GetPos():Distance(enemyPos)

    if distanceFromFeets <= 50 * self:GetModelScale() then
        _, animTime = self:LookupSequence("kick")
        self:ApplyDamage("mixamorig:RightFoot", animTime, 1)
        self:PlaySequenceAndWait("kick", 1)
    else
        _, animTime = self:LookupSequence("punch1")
        self:ApplyDamage("mixamorig:RightHand", animTime, 1)
        self:PlaySequenceAndWait("punch1", 1)
    end

    self:StartActivity(ACT_IDLE)
    self.isAttacking = false
end

function ENT:GrabEnemy()
    if self.isGrabbing == 0 then
        local enemyPos = self:GetEnemy():GetPos()
        local angle = (enemyPos - self:GetPos()):Angle()
        angle.x = 0
        self:SetAngles(angle)
        self:SetAngles(self:LocalToWorldAngles(Angle(0, -30, 0)))
        self.isGrabbing = 1

        timer.Simple(.7, function()
            if not self.isAttacking then
                timer.Create("CheckGrabPlayer" .. self:EntIndex(), .1, 0, function()
                    if IsValid(self) and self.isGrabbing == 1 then
                        for _, ply in pairs(ents.FindInSphere(self:GetBonePosition(self:LookupBone("mixamorig:LeftHand")), self:GetModelScale() * 6)) do
                            if IsValid(ply) and ply:IsPlayer() and ply:Alive() and not ply.isGrabbed and table.HasValue({GST_SNK.Teams.Eldien, GST_SNK.Teams.Mahr}, ply:GetTeam()) then
                                ply.isGrabbed = true
                                self.isGrabbing = 2
                                self:EatEnemy(ply)
                                break
                            end
                        end
                    else
                        timer.Remove("CheckGrabPlayer" .. self:EntIndex())
                    end
                end)

                local time = self:PlaySequenceAndFreeze("grab_player", 1.2)

                timer.Simple(time, function()
                    if self:GetNWString("DoAnimation") == "grab_player" then
                        self.isGrabbing = 0
                    end
                end)
            end
        end)
    end
end

function ENT:EatEnemy(ply)
    timer.Create("SetPlayerPosToHand" .. self:EntIndex(), 0, 0, function()
        if IsValid(self) and IsValid(ply) and ply:Alive() then
            ply:Freeze(true)
            local handPos = self:GetBonePosition(self:LookupBone("mixamorig:LeftHandThumb2"))
            handPos = LerpVector(FrameTime() * 0.01, self:GetBonePosition(self:LookupBone("mixamorig:LeftHandThumb2")) + Vector(0, 0, -50), handPos)
            ply:SetPos(handPos)
        else
            timer.Remove("SetPlayerPosToHand" .. self:EntIndex())
        end
    end)

    local time = self:PlaySequenceAndFreeze("grab_player_manger", 1)

    timer.Simple(time * .7, function()
        if IsValid(self) then
            if self:GetNWString("DoAnimation") == "grab_player_manger" then
                ply:TakeDamage(9999, self, self)
                ply.isGrabbed = false
            end

            self.isGrabbing = 0
        end
        ply:Freeze(false)
    end)
end

function ENT:PlaySequenceAndFreeze(name, speed)
    self:SetNWString("DoAnimation", name)
    self.loco:SetDesiredSpeed(0)
    local len = self:SetSequence(name)
    speed = speed or 1
    self:ResetSequenceInfo()
    self:SetCycle(0)
    self:SetPlaybackRate(speed)

    timer.Simple(len / speed, function()
        if IsValid(self) then
            self.loco:SetDesiredSpeed(self.Speed)

            if self:GetNWString("DoAnimation") == name then
                self:SetNWString("DoAnimation", "")
                self:StartActivity(ACT_IDLE)
            end
        end
    end)

    return len / speed
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

function ENT:DemolishBuild(ent)
    if IsValid(ent) then
        self:PlaySequenceAndWait("punch1", 1.2)
        GST_SNK.Utils:BreakNextBuildState(ent:GetName())
    end
end

function ENT:OnKilled(dmgInfo)
    local ply = dmgInfo:GetAttacker()


    if (dmgInfo:IsBulletDamage()) then
        return
    end

    if IsValid(ply) and ply:IsPlayer() then
        ply:AddPoints(GAMEMODE.Rewards.NpcTitanKill)
        ply:AddPlayerStats(GST_SNK.AvailableStats.KilledTitan)
    end

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

list.Set("NPC", "nextbot_titan", {
    Name = "Titan Bot",
    Class = "nextbot_titan",
    Category = "Nextbot"
})

hook.Add("PostDrawTranslucentRenderables", "MySuper3DRenderingHook", function() end) -- for _, ent in pairs(ents.FindByClass("nextbot_titan")) do --     if (IsValid(ent)) then --         render.DrawLine(ent:EyePos(), ent:GetPos() + ent:EyeAngles():Forward() * 200 + Vector(0,0,300), Color(255,0,0) ) --     end -- end