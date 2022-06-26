SWEP.PrintName = ""
SWEP.Author = "Sixefyle"
SWEP.Instructions = "Attack On Titan"
SWEP.AdminSpawnable = true
SWEP.Spawnable = false
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 75
SWEP.ViewModel = "models/titan/v_hand_v2.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = true
SWEP.DrawAmmo = false
SWEP.Base = "weapon_base"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.HoldType = "melee"
SWEP.DrawCrosshair = true
SWEP.Weight = 0
SWEP.SetWeaponHoldType = melee
SWEP.Category = "GST"
SWEP.FiresUnderwater = true
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.BaseCooldown = 1
SWEP.Icon = GST_SNK.Images.CLASS_ICON_ELDIEN_TRAPPER

function SWEP:Initialize()
    self:SetNWFloat("NextCooldown", CurTime())
end

function SWEP:GetTimeCooldown()
    return self:GetCooldown() - CurTime()
end

function SWEP:GetCooldown()
    return self:GetNWFloat("NextCooldown") or 0
end

function SWEP:SetCooldown(time)
    self:SetNWFloat("LastCooldown", time and time or self.BaseCooldown)
    self:SetNWFloat("NextCooldown", CurTime() + (time and time or self.BaseCooldown))
end

function SWEP:UseSkill() end

function SWEP:PrimaryAttack()
    if (self:CanPrimaryAttack()) then
        self:SetCooldown()
        self:UseSkill()
    end
end

function SWEP:CanPrimaryAttack()
    return CurTime() >= self:GetCooldown()
end