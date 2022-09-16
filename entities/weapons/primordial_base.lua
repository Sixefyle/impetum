SWEP.PrintName = "Titan Primordial"
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
SWEP.NextReload = 0
SWEP.TitanModel = "models/gst/titan1.mdl"

SWEP.BaseHeight = 7
SWEP.HumanBaseHeight = 1.8
SWEP.BaseCameraOffset = 64
SWEP.AttackSpeed = 1
SWEP.SpeedIncrease = 1.4

SWEP.Skills = {
    [1] = {
        ["Name"] = "Skill 1",
        ["Cooldown"] = -1,
        ["Icon"] = GST_SNK.Images.CLASS_ICON_MAHR_MAGATH,
        ["IconBack"] = GST_SNK.Images.CLASS_ICON_MAHR_MAGATH,
    },
    [2] = {
        ["Name"] = "Skill 2",
        ["Cooldown"] = -1,
        ["Icon"] = GST_SNK.Images.CLASS_ICON_MAHR_ARTILLERY,
        ["IconBack"] = GST_SNK.Images.CLASS_ICON_MAHR_MAGATH,
    },
    [3] = {
        ["Name"] = "Skill 3",
        ["Cooldown"] = -1,
        ["Icon"] = GST_SNK.Images.CLASS_ICON_MAHR_BAP,
        ["IconBack"] = GST_SNK.Images.CLASS_ICON_MAHR_MAGATH,
    },
}

function SWEP:Initialize()

end

function SWEP:Deploy()
    local owner = self:GetOwner()
    local realSize = owner:GetCurrentClass().size and owner:GetCurrentClass().size or self.BaseHeight
    self:SetNWInt("Size", realSize / self.HumanBaseHeight)
    self:SetHoldType(self.HoldType)
    owner:SetModel(self.TitanModel)
    owner:SetModelScale(self:GetNWInt("Size"), 1)
    owner:SetViewOffset(Vector(0, 0, self.BaseCameraOffset * self:GetNWInt("Size")))
    owner:Activate()

    if CLIENT then
        LocalPlayer():ShowWeaponCooldownBar(true)
    else
        timer.Create("UpdateBonAngle" .. owner:EntIndex(), 0, .1, function()
            if IsValid(owner) then
                local angle = owner:EyeAngles()
                owner:ManipulateBoneAngles(owner:LookupBone("mixamorig:Spine"), Angle(0, 0, math.Clamp(angle[1], -80, 60)))
            end
        end)
    end

    self:AfterDeploy()
end

function SWEP:AfterDeploy() end

function SWEP:Holster()
    if CLIENT then
        LocalPlayer():ShowWeaponCooldownBar(false)
    end
end

function SWEP:GetTimeCooldown(skillId)
    return self:GetCooldown(skillId) - CurTime()
end

function SWEP:GetCooldown(skillId)
    return self:GetNWFloat(skillId .. "NextCooldown", 0)
end

function SWEP:SetCooldown(skillId, time)
    self:SetNWFloat(skillId .. "LastCooldown", time)
    self:SetNWFloat(skillId .. "NextCooldown", CurTime() + time)
end

function SWEP:DoSkill(skillId)
    local skillTable = self.Skills[skillId]
    if (CurTime() >= self:GetCooldown(skillId, 0)) then
        if (skillId == 1 and not skillTable.IsPassif) then
            self:FirstSpell()
        elseif (skillId == 2 and not skillTable.IsPassif) then
            self:SecondSpell()
        elseif (not skillTable.IsPassif) then
            self:ThirdSpell()
        end
        self:SetCooldown(skillId, skillTable.Cooldown)
    end
end

function SWEP:FirstSpell() end

function SWEP:SecondSpell() end

function SWEP:ThirdSpell() end

function SWEP:PrimaryAttack()
    return
end

function SWEP:SecondaryAttack()
    return
end