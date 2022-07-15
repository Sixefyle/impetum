SWEP.PrintName = "Primordial Feminin"
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
SWEP.TitanModel = "models/gst/Feminin.mdl"

SWEP.BaseHeight = 8
SWEP.HumanBaseHeight = 1.8
SWEP.BaseCameraOffset = 128
SWEP.AttackSpeed = 1
SWEP.SpeedIncrease = 1.4

function SWEP:Initialize()
    self.Skills = {
        [1] = {
            ["Name"] = "test1",
            ["Cooldown"] = 5,
            ["Icon"] = GST_SNK.Images.SKILL_PRIMORDIAL_FEMALE_FIRST_SPELL,
            ["IconBack"] = GST_SNK.Images.SKILL_PRIMORDIAL_FEMALE_FIRST_SPELL_BACK,
        },
        [2] = {
            ["Name"] = "test2",
            ["Cooldown"] = 5,
            ["Icon"] = GST_SNK.Images.SKILL_PRIMORDIAL_FEMALE_SECOND_SPELL,
            ["IconBack"] = GST_SNK.Images.SKILL_PRIMORDIAL_FEMALE_SECOND_SPELL_BACK,
        },
        [3] = {
            ["Name"] = "test3",
            ["Cooldown"] = -1,
            ["Icon"] = GST_SNK.Images.SKILL_PRIMORDIAL_FEMALE_THIRD_SPELL,
            ["IconBack"] = GST_SNK.Images.SKILL_PRIMORDIAL_FEMALE_THIRD_SPELL,
        },
    }
end

function SWEP:FirstSpell()
    GST_SNK.Utils:RunAnimation("roar", self:GetOwner(), true)
    self:GetOwner():EmitSound("gst/titan/scream_female.wav")

    for _, ent in pairs(ents.FindInSphere(self:GetOwner():GetPos(), 5000)) do
        if (IsValid(ent) and ent:IsNextBot()) then
            ent.ForceGotoPos = self:GetOwner():GetPos()
        end
    end
end

function SWEP:SecondSpell()
    self:GetOwner():GodEnable()

    timer.Simple(1.6, function()
        self:GetOwner():SetSkin(1)
    end) 
    timer.Simple(GST_SNK.Utils:RunAnimation("crystalin", self:GetOwner(), true), function()
        GST_SNK.Utils:RunAnimation("crystalidle", self:GetOwner(), true, 10)
        timer.Create("Heal" .. self:GetOwner():EntIndex(), 1, 10, function()
            self:GetOwner():SetHealth(math.Clamp(self:GetOwner():Health() + (self:GetOwner():GetMaxHealth() * .165), 0, self:GetOwner():GetMaxHealth()))
            if (timer.RepsLeft("Heal" .. self:GetOwner():EntIndex()) == 1) then
                GST_SNK.Utils:RunAnimation("crystalout", self:GetOwner(), true)
                self:GetOwner():SetSkin(0)
                self:GetOwner():GodDisable()
            end
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
