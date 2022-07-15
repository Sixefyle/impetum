SWEP.PrintName = "Primordial Cuirassé"
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
SWEP.TitanModel = "models/gst/Cuirasse.mdl"

SWEP.BaseHeight = 7.5
SWEP.HumanBaseHeight = 1.8
SWEP.BaseCameraOffset = 128
SWEP.AttackSpeed = 1
SWEP.SpeedIncrease = 1.4

function SWEP:Initialize()
    self.Skills = {
        [1] = {
            ["Name"] = "test1",
            ["Cooldown"] = 5,
            ["Icon"] = GST_SNK.Images.SKILL_PRIMORDIAL_ARMORED_THIRD_SPELL,
            ["IconBack"] = GST_SNK.Images.SKILL_PRIMORDIAL_ARMORED_THIRD_SPELL_BACK,
        },
        [2] = {
            ["Name"] = "test2",
            ["Cooldown"] = 5,
            ["Icon"] = GST_SNK.Images.SKILL_PRIMORDIAL_ARMORED_SECOND_SPELL,
            ["IconBack"] = GST_SNK.Images.SKILL_PRIMORDIAL_ARMORED_SECOND_SPELL_BACK,
        },
        [3] = {
            ["Name"] = "test3",
            ["Cooldown"] = -1,
            ["Icon"] = GST_SNK.Images.SKILL_PRIMORDIAL_ARMORED_FIRST_SPELL,
            ["IconBack"] = GST_SNK.Images.SKILL_PRIMORDIAL_ARMORED_FIRST_SPELL_BACK,
        },
    }
end

function SWEP:AfterDeploy()
    --self:GetOwner():SetHull(Vector(-40,-40,0), Vector(40,40,150))
end

function SWEP:GetSpawnPos()
    return GST_SNK.Utils:GetWorldHeightPos(self:GetOwner():GetPos() + (Vector(math.random(-1, 1), math.random(-1, 1), 1) * 200))
end

function SWEP:GetNearEntsAmount(pos, range, exclude)
    local entTable = {}
    for _, ent in pairs(ents.FindInSphere(pos, range)) do
        if (not table.HasValue(exclude, ent:GetName())) then
            table.insert(entTable, ent)
        end
    end
    return #entTable
end

function SWEP:FirstSpell()
    GST_SNK.Utils:RunAnimation("garde", self:GetOwner(), false, 30)
    self:GetOwner():GodEnable()
    timer.Simple(30, function()
        self:GetOwner():GodDisable()
    end)
end

function SWEP:SecondSpell()
    GST_SNK.Utils:RunAnimation("charge", self:GetOwner(), true, 6)

    timer.Create("CheckNearPlayer", .1, 60, function()
        for _, ent in pairs(ents.FindInSphere(self:GetOwner():GetPos(), 30)) do
            if (IsValid(ent) and ent ~= self:GetOwner() and ent:IsPlayer() and ent:Alive()) then
               ent:TakeDamage(1000, self:GetOwner(), self)
            elseif (IsValid(ent)) then
                GST_SNK.Utils:BreakNextBuildState(ent:GetName())
            end
        end
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
                    ply:TakeDamage(1000, self:GetOwner(), self)
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
            local footPos = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("mixamorig:LeftFoot"))

            for _, ply in pairs(ents.FindInSphere(footPos, 60)) do
                if IsValid(ply) and not table.HasValue(damagedPlayers, ply) and ply ~= self:GetOwner() then
                    ply:TakeDamage(1000, self:GetOwner(), self)
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

function SWEP:Reload()
    local animName = "elbow"
    local _, animTime = self:GetOwner():LookupSequence(animName)
    if SERVER then
        GST_SNK.Utils:RunAnimation(animName, self:GetOwner(), true)
        damagedPlayers = {}
        buildDestroyed = false

        timer.Create("checkNearbyPlayer" .. self:EntIndex(), .1, animTime * 10, function()
            local handPos = self:GetOwner():GetBonePosition(self:GetOwner():LookupBone("mixamorig:RightHand"))

            for _, ply in pairs(ents.FindInSphere(handPos, 60)) do
                if IsValid(ply) and not table.HasValue(damagedPlayers, ply) and ply ~= self:GetOwner() then
                    ply:TakeDamage(1000, self:GetOwner(), self)
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

hook.Add("PlayerTick", "setupChargeMove", function(ply, moveData)
    if (ply:GetNWString("doAnimation") == "charge") then
        local aimvector = ply:GetAimVector() * 1200
        moveData:SetVelocity(Vector(aimvector.x, aimvector.y, moveData:GetVelocity().z - 200))
    end
end)

hook.Add("EntityTakeDamage", "OnArmoredTakeDamage", function(ent, damageInfo)
    if (IsValid(ent) and ent:IsPlayer() and ent:GetActiveWeapon():GetClass() == "primordial_armored") then
        damageInfo:ScaleDamage(.5)
    end
end)
