SWEP.PrintName = "Primordial Aissaillant"
SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.Base = "primordial_base"
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
SWEP.NextReload = 0
SWEP.TitanModel = "models/gst/titan_assaillant.mdl"

SWEP.BaseHeight = 16
SWEP.HumanBaseHeight = 1.8
SWEP.BaseCameraOffset = 64
SWEP.AttackSpeed = 1
SWEP.SpeedIncrease = 1.4

function SWEP:Initialize()
    self.Skills = {
        [1] = {
            ["Name"] = "test1",
            ["Cooldown"] = 2,
            ["Icon"] = GST_SNK.Images.SKILL_PRIMORDIAL_ASAILLANT_FIRST_SPELL,
            ["IconBack"] = GST_SNK.Images.SKILL_PRIMORDIAL_ASAILLANT_FIRST_SPELL_BACK,
        },
        [2] = {
            ["Name"] = "test2",
            ["Cooldown"] = 2,
            ["Icon"] = GST_SNK.Images.SKILL_PRIMORDIAL_ASAILLANT_SECOND_SPELL,
            ["IconBack"] = GST_SNK.Images.SKILL_PRIMORDIAL_ASAILLANT_SECOND_SPELL_BACK,
        },
        [3] = {
            ["Name"] = "test3",
            ["Cooldown"] = 10,
            ["Icon"] = GST_SNK.Images.SKILL_PRIMORDIAL_ASAILLANT_THIRD_SPELL,
            ["IconBack"] = GST_SNK.Images.SKILL_PRIMORDIAL_ASAILLANT_THIRD_SPELL_BACK,
        },
    }

end

function SWEP:FirstSpell()
    GST_SNK.Utils:RunAnimation("roar", self:GetOwner(), true)
    GST_SNK.Utils:PlaySoundToAllPlayer("gst/titan/scream_asaillant.wav")

    timer.Simple(1, function()
        for _, ent in pairs(ents.FindInSphere(self:GetOwner():GetPos() + Vector(0,0,200), 700)) do
            if (IsValid(ent) and ent:IsPlayer() and ent:Alive() and self:GetOwner() ~= ent) then
                local physEnt = ent:GetPhysicsObject()
                if (IsValid(physEnt) or ent:IsPlayer()) then
                    local vec = ent:GetPos() - self:GetOwner():GetPos()
                    vec:Normalize()
                    vec = vec * 4000
                    vec[3] = 800
    
                    if not ent:IsPlayer() then
                        physEnt:SetVelocity(vec)
                    else
                        ent:SetVelocity(vec)
                    end
                end
            end
        end
    end)
end

function SWEP:SecondSpell()
    GST_SNK.Utils:RunAnimation("eat", self:GetOwner(), true)
    local owner = self:GetOwner()

    local tr = util.TraceLine({
        start = owner:EyePos(),
        endpos = owner:EyePos() + (owner:EyeAngles():Forward() * 1000),
        filter = function(ent) return ent ~= owner and string.match(ent:GetModel(), "titan") ~= nil end
    })

    local entToEat = tr.Entity
    if (IsValid(entToEat)) then
        entToEat:TakeDamage(99999, self:GetOwner(), self)
        owner:SetHealth(owner:GetMaxHealth())
    end
end

function SWEP:ThirdSpell()
    GST_SNK.Utils:RunAnimation("roar", self:GetOwner(), true)

    timer.Simple(1, function()
        local owner = self:GetOwner()
        local oldWalkSpeed = owner:GetWalkSpeed()
        local oldRunSpeed = owner:GetRunSpeed()

        owner:SetSkin(1)
        owner:SetWalkSpeed(oldWalkSpeed * 1.4)
        owner:SetRunSpeed(oldRunSpeed * 1.4)
        owner:SetNWInt("IsBerserk", 1)

        owner:SetHealth(owner:GetMaxHealth() * 1.3)

        timer.Simple(10, function() -- remtre a 5
            owner:SetColor(Color(0,255,234))
            owner:SetWalkSpeed(oldWalkSpeed * .7)
            owner:SetRunSpeed(oldRunSpeed * .7)
            owner:SetNWInt("IsBerserk", 2)
            owner:SetHealth(math.Clamp(owner:Health(), 0, owner:GetMaxHealth() * .7))

            timer.Simple(5, function()
                owner:SetSkin(0)
                owner:SetColor(Color(255,255,255))
                owner:SetWalkSpeed(oldWalkSpeed)
                owner:SetRunSpeed(oldRunSpeed)
                owner:SetNWInt("IsBerserk", 0)
                owner:SetHealth(math.Clamp(owner:Health(), 0, owner:GetMaxHealth()))
            end)
        end)
    end)
end


function SWEP:PrimaryAttack()
    local animName = table.Random({"punchl", "punchr"})
    local _, animTime = self:GetOwner():LookupSequence(animName)
    if SERVER then
        GST_SNK.Utils:RunAnimation(animName, self:GetOwner(), true)
        local damagedPlayers = {}
        local buildDestroyed = false

        timer.Create("checkNearbyPlayer" .. self:EntIndex(), .1, animTime * 10, function()
            local bonesName = {["punchl"] = "LeftHand", ["punchr"] = "RightHand"}
            local handPos = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("mixamorig:" .. bonesName[animName]))

            for _, ply in pairs(ents.FindInSphere(handPos, 60)) do
                if IsValid(ply) and not table.HasValue(damagedPlayers, ply) and ply ~= self:GetOwner() then
                    ply:TakeDamage(2000, self:GetOwner(), self)
                    table.insert(damagedPlayers, ply)
                elseif not buildDestroyed then
                    local tr = util.TraceLine({
                        start = self:GetOwner():EyePos(),
                        endpos = self:GetOwner():GetPos() + self:GetOwner():GetAngles():Forward() * 280,
                        filter = function(ent) return ent ~= self:GetOwner() end
                    })

                    if IsValid(tr.Entity) then
                        GST_SNK.Utils:BreakNextBuildState(tr.Entity:GetName())
                        buildDestroyed = true
                    end
                end
            end
        end)
    else
        self:GetOwner():WeaponCooldownBar(CurTime() + animTime)
    end
    return
end

function SWEP:SecondaryAttack()
    local animName = "kick"
    local _, animTime = self:GetOwner():LookupSequence(animName)
    if SERVER then
        GST_SNK.Utils:RunAnimation(animName, self:GetOwner(), true)
        local damagedPlayers = {}
        local buildDestroyed = false

        timer.Create("checkNearbyPlayer" .. self:EntIndex(), .1, animTime * 10, function()
            local handPos = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("mixamorig:RightFoot"))

            for _, ply in pairs(ents.FindInSphere(handPos, 60)) do
                if IsValid(ply) and not table.HasValue(damagedPlayers, ply) and ply ~= self:GetOwner() then
                    ply:TakeDamage(2000, self:GetOwner(), self)
                    table.insert(damagedPlayers, ply)
                elseif not buildDestroyed then
                    local tr = util.TraceLine({
                        start = self:GetOwner():EyePos(),
                        endpos = self:GetOwner():GetPos() + self:GetOwner():GetAngles():Forward() * 280,
                        filter = function(ent) return ent ~= self:GetOwner() end
                    })

                    if IsValid(tr.Entity) then
                        GST_SNK.Utils:BreakNextBuildState(tr.Entity:GetName())
                        buildDestroyed = true
                    end
                end
            end
        end)
    else
        self:GetOwner():WeaponCooldownBar(CurTime() + animTime)
    end
    return
end

hook.Add("EntityTakeDamage", "OnArmoredTakeDamage", function(ent, damageInfo)
    if (IsValid(ent) and ent:IsPlayer()) then
        if (ent:GetNWInt("IsBerserk") == 1) then
            damageInfo:ScaleDamage(.7)
        elseif (ent:GetNWInt("IsBerserk") == 2) then
            damageInfo:ScaleDamage(1.3)
        end
    end
end)