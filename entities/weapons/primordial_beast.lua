SWEP.PrintName = "Primordial Bestial"
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
SWEP.TitanModel = "models/gst/Bestial.mdl"

SWEP.BaseHeight = 7
SWEP.HumanBaseHeight = 1.8
SWEP.BaseCameraOffset = 164
SWEP.AttackSpeed = 1
SWEP.SpeedIncrease = 1.4

SWEP.RockTypes = {
    "models/props/cs_militia/militiarock03.mdl",
    "models/props/cs_militia/militiarock02.mdl",
    "models/props/cs_militia/militiarock01.mdl",
}

function SWEP:Initialize()
    self.Skills = {
        [1] = {
            ["Name"] = "test1",
            ["Cooldown"] = 5,
            ["Icon"] = GST_SNK.Images.SKILL_PRIMORDIAL_BEAST_FIRST_SPELL,
            ["IconBack"] = GST_SNK.Images.SKILL_PRIMORDIAL_BEAST_FIRST_SPELL_BACK,
        },
        [2] = {
            ["Name"] = "test2",
            ["Cooldown"] = 10,
            ["Icon"] = GST_SNK.Images.SKILL_PRIMORDIAL_BEAST_SECOND_SPELL,
            ["IconBack"] = GST_SNK.Images.SKILL_PRIMORDIAL_BEAST_SECOND_SPELL_BACK,
        },
        [3] = {
            ["Name"] = "test3",
            ["Cooldown"] = -1,
            ["Icon"] = GST_SNK.Images.SKILL_PRIMORDIAL_BEAST_THIRD_SPELL,
            ["IconBack"] = GST_SNK.Images.SKILL_PRIMORDIAL_BEAST_THIRD_SPELL_BACK,
        },
    }

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
    GST_SNK.Utils:RunAnimation("throw", self:GetOwner(), true)

    timer.Simple(2, function()
        local random = math.random(10, 15)
        for i = 1, random do
            local projectile = ents.Create("beast_throw_projectil")
            projectile:SetOwner(self:GetOwner())
            projectile:SetModel(table.Random(self.RockTypes))

            local owner = self:GetOwner()

            local aimvec = owner:GetAimVector()
            local pos = aimvec * 150
            pos:Add(owner:EyePos())

            projectile:SetPos( pos )

            projectile:SetAngles(owner:EyeAngles() + Angle(AngleRand(-10, 10), AngleRand(-10, 10) , AngleRand(0, 20)))
            projectile:Spawn()

            local phys = projectile:GetPhysicsObject()
            if ( not phys:IsValid() ) then projectile:Remove() return end
            -- aimvec:Mul( 1000000 )
            -- aimvec:Add( VectorRand( -10, 10 ) )
            phys:SetMass(1000)
            phys:ApplyForceCenter( projectile:GetForward() * 5000000 )

            projectile:Fire("Kill", nil, math.random(4,6))
        end
    end)
end

function SWEP:SecondSpell()
    self:GetOwner():SetNoTarget(true)
    GST_SNK.Utils:RunAnimation("roar", self:GetOwner(), true)
    self:GetOwner():EmitSound("gst/titan/scream_beast.wav")


    timer.Simple(2, function()
        local amountToSpawn = math.random(2, 4)
        local posToSpawn = self:GetSpawnPos()

        local maxTry = 500
        local try = 0
        for index = 1, amountToSpawn do
            local titan = ents.Create("nextbot_titan")

            while (self:GetNearEntsAmount(posToSpawn, 150, {"accroche"}) > 0) do
                posToSpawn = self:GetSpawnPos()
                try = try + 1
                if (try >= maxTry) then
                    return
                end
            end

            titan:SetPos(posToSpawn)
            titan:SetOwner(self:GetOwner())
            titan:Spawn()
            titan:Fire("Kill", nil, math.random(55, 65))
        end
    end)
end

function SWEP:PrimaryAttack()
    local animName = "punch"
    local _, animTime = self:GetOwner():LookupSequence(animName)
    if SERVER then
        GST_SNK.Utils:RunAnimation(animName, self:GetOwner(), true)
        local damagedPlayers = {}
        local buildDestroyed = false

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

function SWEP:SecondaryAttack()
    local animName = "groundpunch"
    local _, animTime = self:GetOwner():LookupSequence(animName)
    if SERVER then
        GST_SNK.Utils:RunAnimation(animName, self:GetOwner(), true)
        local damagedPlayers = {}
        local buildDestroyed = false

        timer.Simple(animTime * .32, function()
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