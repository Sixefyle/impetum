AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

util.AddNetworkString("UpdatePlayerHudGas")

function SWEP:Initialize()
    self:SetHoldType( self.HoldType )
end

function SWEP:Deploy()
    self:SetNWInt("AttractSpeed", self:GetOwner():GetCurrentClass().attract_speed and self:GetOwner():GetCurrentClass().attract_speed or self.BaseAttractSpeed)
    self:SetNWInt("MaxGas", self:GetOwner():GetCurrentClass().max_gas and self:GetOwner():GetCurrentClass().max_gas or self.BaseMaxGas)
    self:SetNWInt("Range", self:GetOwner():GetCurrentClass().max_range and self:GetOwner():GetCurrentClass().max_range or self.BaseRange)

    self:SetNWFloat("Gas", self:GetNWInt("MaxGas"))
    self.MaxGasRegen = self:GetNWInt("MaxGas") * (self.RegenMaxPerc / 100)
    self:InitGasHandler()
    self:SetSkin(self.Skin)
    self:GetOwner():GetViewModel():SetSkin(self.Skin)
end

function SWEP:Holster()
    self:RemoveRopes()
    return true
end

function SWEP:SecondaryAttack()

end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire( CurTime() + 1 )
    self:SetWeaponHoldType( "melee" )
    self:EmitSound( "weapons/iceaxe/iceaxe_swing1.wav" )
    self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
    self:PrimarySlash()
    timer.Simple(.45, function() self:SetWeaponHoldType( "gizer_idle" ) end)
end

function SWEP:PrimarySlash()
    local owner = self:GetOwner()
    self:SendWeaponAnim(ACT_VM_HITCENTER)
    pos = owner:GetShootPos()
    ang = owner:GetAimVector()

    if IsValid(owner) and owner:Alive() then
        --self:TraceTest()
        local slash = {}
        slash.start = pos
        slash.endpos = pos + (ang * 100)
        slash.filter = self:GetOwner()
        slash.mins = Vector(5, -40, -10)
        slash.maxs = Vector(40, 40, 10)
        local slashtrace = util.TraceHull(slash)

        if slashtrace.Hit then
            targ = slashtrace.Entity

            if (string.match(targ:GetModel(), "titan") == "titan") then
                local tr = util.TraceLine({
                    start = owner:EyePos(),
                    endpos = owner:EyePos() + owner:EyeAngles():Forward() * 400,
                    filter = owner
                })

                if (tr.HitBox == 4) then
                    targ:TakeDamage(1100, self:GetOwner(), self)
                    GST_SNK.Utils:PlaySoundToPlayer(table.Random(GST_SNK.Sounds.HIT_SWORD), owner)
                end
            elseif targ:IsPlayer() or targ:IsNPC() then
                targ:TakeDamage(100, self:GetOwner(), self)
                GST_SNK.Utils:PlaySoundToPlayer(table.Random(GST_SNK.Sounds.HIT_SWORD), owner)
            else
                targ:TakeDamage(1, self, self)
                GST_SNK.Utils:PlaySoundToPlayer(table.Random(GST_SNK.Sounds.HIT_SWORD), owner)
            end
        end
    end
end

function SWEP:DoGrab(ply)

    local targetEntity = ply:GetEyeTraceNoCursor().Entity

    self.hasGrabTitan = false
    if (IsValid(targetEntity)) then
        self.hasGrabTitan = string.match(targetEntity:GetModel(), "titan") ~= nil and ply:GetPos():Distance(targetEntity:EyePos()) < 6000 -- faire ca mais avec une verification sur le début du nom du model (ex. titan_...)
    end

    if (IsValid(self)) then
        if self.hasGrabTitan then
            self:RemoveRopes()
            local neckPos = targetEntity:GetBonePosition(targetEntity:LookupBone("mixamorig:Neck"))
            self:ThrowGrappinToPos(targetEntity:GetPos() + Vector(0,0, targetEntity:GetModelScale() * 40), neckPos, true)
            timer.Create("UpdateRopes" .. ply:EntIndex(), .1, 0, function()
                if (not self.hasGrabTitan) then 
                    timer.Remove("UpdateRopes" .. ply:EntIndex())
                    return
                end

                if (IsValid(self.rope1)) then
                    self.rope1:SetDestination(targetEntity:GetPos() + Vector(0,0, targetEntity:GetModelScale() * 40))
                end
                if (IsValid(self.rope2)) then
                    neckPos = targetEntity:GetBonePosition(targetEntity:LookupBone("mixamorig:Neck"))
                    self.rope2:SetDestination(neckPos)
                end
            end)
        else
            self:RemoveRopes()
            local nearestEnts = self:GetNearestEnts(ply)
            self:ThrowGrappin(nearestEnts[1] and nearestEnts[1].ent or nil, nearestEnts[2] and nearestEnts[2].ent or nil)
        end
    end
end

function SWEP:GetRopesDistance()
    local ply = self:GetOwner()
    local firstRopeDistance = -1
    local secondRopeDistance = -1
    if IsValid(self.rope1) then
        firstRopeDistance = self.rope1:GetDestination():Distance(ply:GetPos())
    end

    if IsValid(self.rope2) then
        secondRopeDistance = self.rope2:GetDestination():Distance(ply:GetPos())
    end
    return firstRopeDistance, secondRopeDistance
end

hook.Add("PlayerButtonDown", "3DMG:OnButtonDown", function(ply, button)
    local swep = ply:GetActiveWeapon()

    if not IsValid(swep)
        or (IsValid(swep)
        and (swep:GetClass() ~= "gst_3dmg"
        and baseclass.Get(swep:GetClass()).Base ~= "gst_3dmg" )) then
            return
    end

    if button == ply.preference.server_only_sc.use_3dmg and swep:GetGas() > 0 then
        swep:SetNWBool("use_grab", true)
        swep:DoGrab(ply)
        timer.Create("autoGrab" .. ply:EntIndex(), .1, 0, function()
            if (swep:GetGas() > 0 and swep:GetNWBool("use_grab")) then
                local firstRopeDistance, secondRopeDistance = swep:GetRopesDistance()

                if (firstRopeDistance > swep.MaxRopeRange * .9 and secondRopeDistance > swep.MaxRopeRange * .9) or
                (firstRopeDistance < 0 and secondRopeDistance < 0) and not ply:IsFrozen() then
                    swep:DoGrab(ply)
                end
            end
        end)

        swep.consumedGas = 0
    end

    if button == ply.preference.server_only_sc.use_gas and  swep:GetGas() > 0 and swep:CanUseGas() then
        swep:SetNWBool("use_gas", true)
    end
end)

function SWEP:GetNearestEnts(ply)
    local nearest = {}
    local currentEnt = {}
    local index = 1

    local nearEnts = ents.FindInBox(ply:LocalToWorld(self.DetectBox.mins), ply:LocalToWorld(self.DetectBox.maxs))
    for _, ent in pairs(nearEnts) do
        if ent:GetName() == "accroche" then
            local distance = ply:EyePos():Distance(ent:GetPos())
            currentEnt["distance"] = distance
            currentEnt["ent"] = ent
            nearest[index] = currentEnt
            currentEnt = {}
            index = index + 1
        end
    end

    table.sort(nearest, function(a, b) return a.distance < b.distance end)

    return nearest
end

function SWEP:ThrowGrappin(ent1, ent2)
    self:ThrowGrappinToPos(ent1 and ent1:WorldSpaceCenter() or nil, ent2 and ent2:WorldSpaceCenter() or nil)
end

function SWEP:ThrowGrappinToPos(loc1, loc2, shouldRefresh)
    local rightSheats = self:GetOwner():LocalToWorld(Vector(0,-10,20))
    local leftSheats = self:GetOwner():LocalToWorld(Vector(0,10,20))
    local tempLoc
    if (loc1 and rightSheats:Distance(loc1) > leftSheats:Distance(loc1)) then
        tempLoc = loc1
        loc1 = loc2
        loc2 = tempLoc
    end
    
    local canUseRope1
    if(loc1) then
        canUseRope1 = loc1:Distance(self:GetOwner():GetPos()) < self.MaxRopeRange
    end

    local canUseRope2
    if(loc2) then
        canUseRope2 = loc2:Distance(self:GetOwner():GetPos()) < self.MaxRopeRange
    end

    if loc1 and canUseRope1 then
        self.rope1 = ents.Create("rope")
        self.rope1:SetDestination(loc1)
        self.rope1:SetParent(self)
        self.rope1:SetOwner(self:GetOwner())
        self.rope1:SetPos(rightSheats)
        self.rope1:Spawn()
        self:SetNWEntity("rope1", self.rope1)
    end

    if loc2 and canUseRope2 then
        self.rope2 = ents.Create("rope")
        self.rope2:SetDestination(loc2)
        self.rope2:SetParent(self)
        self.rope2:SetOwner(self:GetOwner())
        self.rope2:SetPos(leftSheats)
        self.rope2:Spawn()
        self:SetNWEntity("rope2", self.rope2)
    end

    if (canUseRope1 or canUseRope2) then
        GST_SNK.Utils:PlaySound(GST_SNK.Sounds.TRI_DIM.Start, self:GetOwner())
    end
end

hook.Add("PlayerButtonUp", "3DMG:OnReleaseGrapping", function(ply, button)
    local swep = ply:GetActiveWeapon()
    if (not IsValid(swep)
        or (swep:GetClass() ~= "gst_3dmg"
        and baseclass.Get(swep:GetClass()).Base ~= "gst_3dmg" )) then
        return
    end

    if button == ply.preference.server_only_sc.use_3dmg then
        swep:RemoveRopes()
        swep:SetNWBool("use_grab", false)
        timer.Remove("autoGrab" .. ply:EntIndex())
        ply:AddPlayerStats(GST_SNK.AvailableStats.GasComsumed, swep.consumedGas)
    end

    if button == ply.preference.server_only_sc.use_gas then
        swep:SetNWBool("use_gas", false)
    end
end)

function SWEP:RemoveRopes()
    self:RemoveRope(self.rope1)
    self:RemoveRope(self.rope2)
end

function SWEP:RemoveRope(rope)
    if IsValid(rope) then
        rope:Remove()
    end
end

function SWEP:RegenGas()
    if (timer.Exists("regen_delay" ..   self:GetOwner():EntIndex()) or timer.Exists("regen_gas" .. self:GetOwner():EntIndex())) then
        return
    end

    local ply = self:GetOwner()
    timer.Create("regen_delay" .. self:GetOwner():EntIndex(), self.RegenDelay, 1, function()
        timer.Create("regen_gas" .. self:GetOwner():EntIndex(), self.RegenTickDelay, 0, function()
            if IsValid(self) and not self:GetNWBool("use_gas") and self:GetGas() < self.MaxGasRegen then
                self:ChangeGas(self:GetNWInt("MaxGas") * (self.RegenSpeedPerc / 100), 0, self.MaxGasRegen)
            else
                timer.Remove("regen_delay" .. ply:EntIndex())
            end
        end)
    end)
end

function SWEP:ChangeGas(amount, min, max)
    self:SetGas(math.Clamp(self:GetGas() + amount, min, max))
    self.consumedGas = self.consumedGas + amount * -1

    if (SERVER and self:CanUseGas() and self:GetGas() <= 0) then
        self:RemoveRopes()
    end

    net.Start("UpdatePlayerHudGas")
    net.Send(self:GetOwner())
end

function SWEP:SetGas(amount)
    self:SetNWFloat("Gas", amount)
end

function SWEP:Think()
    local ply = self:GetOwner()

    if IsValid(self.rope1) or IsValid(self.rope2) then
        if IsValid(self.rope1) and self.rope1:GetDestination():Distance(ply:GetPos()) > self.MaxRopeRange then
            self.rope1:Remove()
        end

        if IsValid(self.rope2) and self.rope2:GetDestination():Distance(ply:GetPos()) > self.MaxRopeRange then
            self.rope2:Remove()
        end

        if not self.hasGrabTitan then
            if ply:IsOnGround() then
                ply:SetVelocity(ply:EyeAngles():Forward() + Vector(0, 0, self:GetNWInt("AttractSpeed") * 10))
            else
                local direction = ply:GetForward()
                direction.z = 0

                if self:GetNWBool("use_gas") then
                    direction = ply:GetForward() * 4
                    direction.z = (direction.z * 1.4) + .2
                    ply:SetVelocity(direction * (self:GetNWInt("AttractSpeed") * 1.2))
                else
                    local higher = 0

                    if IsValid(self.rope1) and IsValid(self.rope2) then
                        higher = self.rope1:GetDestination().z > self.rope2:GetDestination().z and self.rope1:GetDestination().z or self.rope2:GetDestination().z
                    elseif IsValid(self.rope1) then
                        higher = self.rope1:GetDestination().z
                    elseif IsValid(self.rope2) then
                        higher = self.rope2:GetDestination().z
                    end

                    local addition = math.Clamp(higher / self:GetPos().z * 15, 0, 60)
                    ply:SetVelocity(direction * self:GetNWInt("AttractSpeed") + Vector(0, 0, addition))
                end
            end
        elseif (IsValid(self.rope2)) then
            local direction = (self.rope2:GetDestination() - ply:GetPos()):GetNormalized()
            if ply:IsOnGround() then
                self:ResetSequence("3dmg_start")
                ply:SetVelocity(direction + Vector(0,0,300)) --+ Vector(0, 0, (self.rope2:GetDestination() - ply:GetPos()).z * 2))
            else
                self:ResetSequence("3dmg_idle")
                if self:GetNWBool("use_gas") then
                    ply:SetVelocity(direction * 120)
                else
                    ply:SetVelocity(direction * 70)
                end
            end
        end
    end

    local velocity = ply:GetVelocity()
    ply:SetLocalVelocity(Vector(
                        math.Clamp(velocity.x, -self.MaxSpeed, self.MaxSpeed),
                        math.Clamp(velocity.y, -self.MaxSpeed, self.MaxSpeed),
                        math.Clamp(velocity.z, -self.MaxSpeed, self.MaxSpeed))
                        )
end

local function StopTrail(ply)
    if (IsValid(ply.trail)) then
        ply.trail:Remove()
        GST_SNK.Utils:StopLoopingSound(ply)
    end
end

function SWEP:InitGasHandler()
    local ply = self:GetOwner()
    timer.Create("reduce_gas_" .. self:GetOwner():EntIndex(), .3, 0, function()
        if (IsValid(self)) then
            if ((self:GetNWBool("use_gas") or self:GetNWBool("use_grab")) and self:CanUseGas()) then

                if (timer.Exists("regen_delay" .. self:GetOwner():EntIndex())) then
                    timer.Remove("regen_delay" .. self:GetOwner():EntIndex())
                end

                if (timer.Exists("regen_gas" .. self:GetOwner():EntIndex())) then
                    timer.Remove("regen_gas" .. self:GetOwner():EntIndex())
                end

                if (self:GetNWBool("use_gas")) then
                    if (not IsValid(ply.trail)) then
                        ply.trail = util.SpriteTrail(ply, 8,
                            ply.trailColor and ply.trailColor or Color(255,255,255),
                            true,
                            0,
                            200, .7, 1 / (0 + 200) * .5,
                            ply.trailTexture and ply.trailTexture or "trails/smoke")

                        GST_SNK.Utils:PlaySound(GST_SNK.Sounds.TRI_DIM.Smoke, ply, true)
                    end

                    self:ChangeGas(-self.GasComsuption, 0, self:GetNWInt("MaxGas"))
                else
                    StopTrail(ply)
                    self:ChangeGas(-self.GrabComsuption, 0, self:GetNWInt("MaxGas"))
                end
            elseif (self:GetGas() <= self.MaxGasRegen) then
                StopTrail(ply)
                self:RegenGas()
            else
                StopTrail(ply)
            end
        else
            timer.Remove("reduce_gas_" .. ply:EntIndex())
        end
    end)
end