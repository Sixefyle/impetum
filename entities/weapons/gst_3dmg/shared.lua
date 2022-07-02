if SERVER then
    AddCSLuaFile("shared.lua")
    AddCSLuaFile("cl_init.lua")

    util.AddNetworkString("UpdatePlayerHudGas")
end

SWEP.PrintName = "Equipement Tridimentionnel"
SWEP.Author = "Sixefyle"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.Category = "GST"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModel = "models/weapons/v_fusion3dmg.mdl"
SWEP.WorldModel = "models/gst/3dmg/r_lame.mdl"
SWEP.ViewModelFOV = 60

SWEP.MaxSpeed = 2000
SWEP.BaseAttractSpeed = 30
SWEP.BaseMaxGas = 1000

-- Grab settings
SWEP.BaseRange = 1200
SWEP.Angle = 60

SWEP.GrabComsuption = 0 --10
SWEP.GasComsuption = 0 --20

SWEP.RegenMaxPerc = 20
SWEP.RegenSpeedPerc = 1
SWEP.RegenDelay = 4 -- time before start regen
SWEP.RegenTickDelay = 2
SWEP.HoldType 			= "gizer_idle"

if CLIENT then
    function SWEP:PrimaryAttack()
        --self:GetOwner():AddVCDSequenceToGestureSlot(0, self:GetOwner():LookupSequence("3dmg_idle"),0, true)
    end
end

if SERVER then
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
    end

    function SWEP:Holster()
        self:RemoveRopes()
        return true
    end

    function SWEP:PrimaryAttack()
        self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
		self:SetWeaponHoldType( "melee" )
        self.Weapon:EmitSound( "weapons/iceaxe/iceaxe_swing1.wav" )
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
        self.Weapon:PrimarySlash()
        timer.Simple(0.45, function() self:SetWeaponHoldType( "normal" ) end)
    end

    function SWEP:SecondaryAttack()
        self:SetNextSecondaryFire(CurTime() + 1)
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
        self:PrimarySlash()

        self:SendWeaponAnim(ACT_RELOAD)

        timer.Simple(0.45, function()
            self:SetHoldType( self.HoldType )
        end)
    end

    function SWEP:PrimarySlash()
        self:SendWeaponAnim(ACT_VM_HITCENTER)
        pos = self.Owner:GetShootPos()
        ang = self.Owner:GetAimVector()
        self.Owner:LagCompensation(true)

        if IsValid(self.Owner) and self.Owner:Alive() then
            --self:TraceTest()
            local slash = {}
            slash.start = pos
            slash.endpos = pos + (ang * 100)
            slash.filter = self.Owner
            slash.mins = Vector(-15, -15, 0)
            slash.maxs = Vector(15, 15, 5)
            local slashtrace = util.TraceHull(slash)

            if slashtrace.Hit then
                targ = slashtrace.Entity
  
                if targ:IsPlayer() or baseclass.Get(targ:GetClass()).Base == "base_titan" then
                    local bullet = {}
                    bullet.Attacker = self.Owner
                    bullet.Num = 1
                    bullet.Src = self.Owner:GetShootPos()
                    bullet.Dir = self.Owner:GetAimVector()
                    bullet.Spread = Vector(0, 0, 0)
                    bullet.Tracer = 0
                    bullet.Force = 35000
                    bullet.Damage = 0
                    self.Owner:FireBullets(bullet)
                    paininfo = DamageInfo()
                    paininfo:SetDamage(100)
                    paininfo:SetDamageType(DMG_SLASH)
                    paininfo:SetAttacker(self.Owner)
                    paininfo:SetInflictor(self.Weapon)
                    paininfo:SetDamageForce(slashtrace.Normal * 35000)
                    targ:TakeDamageInfo(paininfo)
                else
                    GST_SNK.Utils:BreakNextBuildState(targ:GetName())
                end
            end
            --self.Weapon:EmitSound(KnifeStab)
        end

        self.Owner:LagCompensation(false)
    end

    function SWEP:DoGrab(ply)
        local targetEntity = ply:GetEyeTraceNoCursor().Entity
        if (not IsValid(targetEntity)) then return end

        self.hasGrabTitan = string.match(targetEntity:GetModel(), "titan") and ply:GetPos():Distance(targetEntity:EyePos()) < 2000 -- faire ca mais avec une verification sur le début du nom du model (ex. titan_...)

        if IsValid(swep) and self.hasGrabTitan then
            self:RemoveRopes()
            self:ThrowGrappinToPos(targetEntity:GetPos(), targetEntity:GetPos() + Vector(0,0,450))
        else
            self:RemoveRopes()
            local nearestEnts = self:GetNearestEnts(ply)
            self:ThrowGrappin(nearestEnts[1] and nearestEnts[1].ent or nil, nearestEnts[2] and nearestEnts[2].ent or nil)
        end
    end

    function SWEP:GetRopesDistance()
        local ply = self:GetOwner()
        local firstRopeDistance = -1
        local secondRopeDistance = -1
        if IsValid(self.rope1) then
            firstRopeDistance = self.rope1:GetDestination():Distance(ply:GetPos()) 
        end

        if IsValid(self.rope1) then
            secondRopeDistance = self.rope1:GetDestination():Distance(ply:GetPos())
        end
        return firstRopeDistance, secondRopeDistance
    end

    hook.Add("PlayerButtonDown", "3DMG:OnButtonDown", function(ply, button)
        local swep = ply:GetActiveWeapon()

        if not IsValid(swep) or (IsValid(swep) and swep:GetClass() ~= "gst_3dmg") then return end

        if button == KEY_E and swep:GetGas() > 0 then
            swep:SetNWBool("use_grab", true)
            swep:DoGrab(ply)
            timer.Create("autoGrab" .. ply:EntIndex(), .1, 0, function()
                if (swep:GetGas() > 0 and swep:GetNWBool("use_grab")) then
                    local firstRopeDistance, secondRopeDistance = swep:GetRopesDistance()
                    local longest = firstRopeDistance > secondRopeDistance and firstRopeDistance or secondRopeDistance

                    if longest > 3500 or longest == -1 then
                        swep:DoGrab(ply)
                    end
                end
            end)
        end

        if button == KEY_SPACE and  swep:GetGas() > 0 and swep:CanUseGas() then
            swep:SetNWBool("use_gas", true)
        end
    end)

    function SWEP:GetNearestEnts(ply)
        local nearest = {}
        local currentEnt = {}
        local index = 1

        for _, ent in pairs(ents.FindInCone(ply:EyePos() + Vector(0,0,350), ply:GetAimVector(), self.BaseRange, math.cos(math.rad(self.Angle)))) do
            if ent:GetName() == "accroche" then
                local distance = ply:GetPos():Distance(ent:GetPos())
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

    local SHOOT_SOUND = Sound("zaref_sound/wire_shoot.wav")
    function SWEP:ThrowGrappin(ent1, ent2)
        self:ThrowGrappinToPos(ent1 and ent1:WorldSpaceCenter() or nil, ent2 and ent2:WorldSpaceCenter() or nil)
    end

    function SWEP:ThrowGrappinToPos(loc1, loc2)
        if loc1 then
            self:EmitSound(SHOOT_SOUND)
            self.rope1 = ents.Create("rope")
            self.rope1:SetDestination(loc1)
            self.rope1:SetParent(self)
            self.rope1:SetOwner(self:GetOwner())
            self.rope1:SetPos(self:GetOwner():LocalToWorld(Vector(0,-10,20)))
            self.rope1:Spawn()
            self:SetNWEntity("rope1", self.rope1)
        end

        if loc2 then
            self:EmitSound(SHOOT_SOUND)
            self.rope2 = ents.Create("rope")
            self.rope2:SetDestination(loc2)
            self.rope2:SetParent(self)
            self.rope2:SetOwner(self:GetOwner())
            self.rope2:SetPos(self:GetOwner():LocalToWorld(Vector(0,10,20)))
            self.rope2:Spawn()
            self:SetNWEntity("rope2", self.rope2)
        end
    end

    hook.Add("PlayerButtonUp", "3DMG:OnReleaseGrapping", function(ply, button)
        local swep = ply:GetActiveWeapon()
        if (not IsValid(swep) or swep:GetClass() ~= "gst_3dmg") then return end

        if button == KEY_E then
            swep:RemoveRopes()
            swep:SetNWBool("use_grab", false)
            timer.Remove("autoGrab" .. ply:EntIndex())
        end

        if button == KEY_SPACE then
            swep:SetNWBool("use_gas", false)
        end
    end)

    function SWEP:RemoveRopes()
        if IsValid(self.rope1) then
            self.rope1:Remove()
        end

        if IsValid(self.rope2) then
            self.rope2:Remove()
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
            if IsValid(self.rope1) and self.rope1:GetDestination():Distance(ply:GetPos()) > 4000 then
                self.rope1:Remove()
            end
    
            if IsValid(self.rope2) and self.rope2:GetDestination():Distance(ply:GetPos()) > 4000 then
                self.rope2:Remove()
            end
    
            if not self.hasGrabTitan then
                if ply:IsOnGround() then
                    ply:SetVelocity(ply:EyeAngles():Forward() + Vector(0, 0, self:GetNWInt("AttractSpeed") * 10))
                else
                    local direction = ply:GetForward()
                    direction.z = 0
    
                    if self:GetNWBool("use_gas") then
                        direction = ply:GetForward()
                        direction.z = direction.z * 5
                        direction.x = direction.x * 3
                        direction.y = direction.y * 3
                        ply:SetVelocity(direction * (self:GetNWInt("AttractSpeed") * 1.2) + Vector(0, 0, 20))
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
            else
                local direction = (self.rope2:GetDestination() - ply:GetPos()):GetNormalized()
                if ply:IsOnGround() then
                    self:ResetSequence("3dmg_start")
                    ply:SetVelocity(ply:EyeAngles():Forward() + Vector(0, 0, 450))
                else
                    self:ResetSequence("3dmg_idle")
                    if self:GetNWBool("use_gas") then
                        ply:SetVelocity(direction * 80)
                    else
                        ply:SetVelocity(direction * 50)
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
                        self:ChangeGas(-self.GasComsuption, 0, self:GetNWInt("MaxGas"))
                    else
                        self:ChangeGas(-self.GrabComsuption, 0, self:GetNWInt("MaxGas"))
                    end
                elseif (self:GetGas() <= self.MaxGasRegen) then
                    self:RegenGas()
                end
            else
                timer.Remove("reduce_gas_" .. ply:EntIndex())
            end
        end)
    end
end

function SWEP:CanUseGas()
    return IsValid(self:GetNWEntity("rope1")) or IsValid(self:GetNWEntity("rope2"))
end

function SWEP:GetGas()
    return self:GetNWFloat("Gas", 0)
end

-- local mat = Material( "models/shiny" )
-- mat:SetFloat( "$alpha", 0.5 )

-- hook.Add( "PostDrawOpaqueRenderables", "conetest", function()
-- 	local size = 600
-- 	local dir = LocalPlayer():GetAimVector()
-- 	local startPos = LocalPlayer():EyePos() + Vector(0,0,350)
--     local angle = 60

-- 	local entities = ents.FindInCone(LocalPlayer():EyePos() + Vector(0,0,350), LocalPlayer():GetAimVector(), size, math.cos(math.rad(angle)))

--     -- draw the outer box
-- 	local mins = Vector( -size, -size, -size )
-- 	local maxs = Vector( size, size, size )

-- 	render.SetMaterial( mat )
-- 	render.DrawWireframeBox( startPos, Angle( 0, 0, 0 ), mins, maxs, color_white, true )
-- 	--render.DrawBox( startPos, Angle( 0, 0, 0 ), -mins, -maxs, Color(44,44,44,100) )

-- 	-- draw the lines
-- 	for id, ent in ipairs( entities ) do
-- 		render.DrawLine( LocalPlayer():GetPos(), ent:WorldSpaceCenter(), Color( 255, 0, 0 ) )
-- 	end
-- end )