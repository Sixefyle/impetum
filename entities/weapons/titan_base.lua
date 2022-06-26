SWEP.PrintName = "Titan"
SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.Base = "weapon_base"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 75
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = true
SWEP.DrawAmmo = false
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.HoldType = "normal"
SWEP.DrawCrosshair = true
SWEP.Weight = 0
SWEP.Category = "GST"
SWEP.FiresUnderwater = false
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.TitanModel = "models/gst/titan1.mdl"
SWEP.BaseHeight = 7
SWEP.HumanBaseHeight = 1.8
SWEP.AttackSpeed = 1
SWEP.SpeedIncrease = 1.4

function SWEP:Initialize()

end

function SWEP:Deploy()
    local owner = self:GetOwner()

    local realSize = owner:GetCurrentClass().size and owner:GetCurrentClass().size or self.BaseHeight
    self:SetNWInt("Size", realSize / self.HumanBaseHeight)

    self:SetHoldType(self.HoldType)
    owner:SetModel(self.TitanModel)
    owner:SetModelScale(self:GetNWInt("Size"), 1)
    owner:SetViewOffset(Vector(0,0,64 * self:GetNWInt("Size")))
    owner:Activate()

    if CLIENT then
        LocalPlayer():ShowWeaponCooldownBar(true)
        self.PrintName = "Titan " .. self:GetOwner():GetCurrentClass().size and self:GetOwner():GetCurrentClass().size or self.BaseHeight .. " mètres"
    else
        owner:SetJumpPower(0)
    end
end

function SWEP:Holster()
    if CLIENT then
        LocalPlayer():ShowWeaponCooldownBar(false)
    end
end

function SWEP:SecondaryAttack()
    if(IsFirstTimePredicted() and self:CanSecondaryAttack()) then
        local _, animTime = self:GetOwner():LookupSequence("kick")
        if SERVER then
            --self:GetOwner():Freeze(true)
            -- net.Start("GST:Titan_Kick")
            --     net.WriteEntity(self:GetOwner())
            -- net.Broadcast()
            -- self:GetOwner():SetNWBool("testKick", true)
            -- self:GetOwner():AnimRestartMainSequence()

            local damagedPlayers = {}
            local buildDestroyed = false
            timer.Create("checkNearbyPlayer" .. self:EntIndex(), .1, animTime * 10, function()
                local footPos = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("mixamorig:RightFoot"))

                local merde = ents.Create("prop_physics")
                merde:SetModel("models/props_combine/breenglobe.mdl")
                merde:Spawn()
                merde:SetPos(footPos)
                merde:Fire("kill", nil, .1)
                
                if (timer.Exists("checkNearbyPlayer" .. self:EntIndex()) and timer.RepsLeft("checkNearbyPlayer" .. self:EntIndex()) <= animTime * 10 and
                timer.RepsLeft("checkNearbyPlayer" .. self:EntIndex()) >= animTime * 7) then
                    local nearEnts = ents.FindInSphere(footPos, 120)

                    for _, ply in pairs(nearEnts) do
                        if (IsValid(ply) and not table.HasValue(damagedPlayers, ply) and ply ~= self:GetOwner()) then
                            ply:TakeDamage(10000, self:GetOwner(), self)
                            table.insert(damagedPlayers, ply)
                        elseif (not buildDestroyed) then
                            local tr = util.TraceLine({
                                start = self:GetOwner():EyePos(),
                                endpos = self:GetOwner():GetPos() + self:GetOwner():GetAngles():Forward() * 280,
                                filter = function(ent) return ent ~= self:GetOwner()  end
                            })
                            if (IsValid(tr.Entity)) then
                                GST_SNK.Utils:BreakNextBuildState(tr.Entity:GetName())
                                buildDestroyed = true
                            end
                        end
                    end
                end

                if (timer.RepsLeft("checkNearbyPlayer" .. self:EntIndex()) == 1) then
                    self:GetOwner():Freeze(false)
                    self:GetOwner():SetNWBool("testKick", false)
                end
            end)
        else
            self:GetOwner():WeaponCooldownBar(CurTime() + animTime)
        end
        self:SetNextSecondaryFire(CurTime() + animTime)
    end
end

function SWEP:PrimaryAttack()
    if (IsFirstTimePredicted() and self:CanPrimaryAttack()) then
        local _, animTime = self:GetOwner():LookupSequence("balayage")
        local animationName = "GST:Titan_Balayage"
        if (self:GetOwner():EyeAngles()[1] >= 10) then
            animationName = "GST:Titan_Punch1"
            _, animTime = self:GetOwner():LookupSequence("punch1")
        end
        if SERVER then
            self:GetOwner():Freeze(true)
            net.Start(animationName)
                net.WriteEntity(self:GetOwner())
            net.Broadcast()

            local damagedPlayers = {}
            local buildDestroyed = false
            timer.Create("checkNearbyPlayer" .. self:EntIndex(), .1, animTime * 10, function()
                if (timer.Exists("checkNearbyPlayer" .. self:EntIndex()) and timer.RepsLeft("checkNearbyPlayer" .. self:EntIndex()) <= animTime * 5) then
                    local handPos = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("mixamorig:RightHandPinky1"))
                    local nearEnts = ents.FindInSphere(handPos, 80)
                    for _, ply in pairs(nearEnts) do
                        if (IsValid(ply) and ply:IsPlayer() and not table.HasValue(damagedPlayers, ply) and ply ~= self:GetOwner() and ply:Alive()) then
                            ply:TakeDamage(100, self:GetOwner(), self)
                            table.insert(damagedPlayers, ply)
                        elseif (not buildDestroyed) then
                            local tr = util.TraceLine({
                                start = self:GetOwner():EyePos(),
                                endpos = self:GetOwner():GetPos() + self:GetOwner():GetAngles():Forward() * 250,
                                filter = function(ent) return ent ~= self:GetOwner()  end
                            })
                            if (IsValid(tr.Entity)) then
                                GST_SNK.Utils:BreakNextBuildState(tr.Entity:GetName())
                                buildDestroyed = true
                            end
                        end
                    end
                end

                if (timer.RepsLeft("checkNearbyPlayer" .. self:EntIndex()) == 1) then
                    self:GetOwner():Freeze(false)
                end
            end)
        else
            self:GetOwner():WeaponCooldownBar(CurTime() + animTime)
        end
        self:SetNextPrimaryFire(CurTime() + animTime)
    end
end