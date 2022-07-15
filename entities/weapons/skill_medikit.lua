SWEP.PrintName = "Trousse de soin"
SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.ViewModel = "models/titan/v_hand_v2.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Base = "base_skill"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 75
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = true
SWEP.DrawAmmo = false
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.HoldType = "melee"
SWEP.DrawCrosshair = true
SWEP.Weight = 0
SWEP.Category = "GST"
SWEP.FiresUnderwater = false
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.BaseCooldown = 15
SWEP.Icon = GST_SNK.Images.SKILL_HUMAN_ELDIEN_HEALER
SWEP.IconBack = GST_SNK.Images.SKILL_HUMAN_ELDIEN_HEALER_BACK

function SWEP:Initialize()
end

function SWEP:CanSecondaryAttack()
    return false
end

if SERVER then
    function SWEP:SecondaryAttack()
        if (self:CanPrimaryAttack()) then
            local trace = self:GetOwner():GetEyeTrace()
            local ent = trace.Entity
            if (IsValid(ent) and ent:IsPlayer()) then
                ent:SetHealth(ent:GetMaxHealth())
                self:SetCooldown()
            else
                self:GetOwner():PrintMessage(3, "Il n'y a personne devant vous!")
                self:SetCooldown(1.5)
            end
        end
    end

    function SWEP:UseSkill()
        self:GetOwner():SetHealth(self:GetOwner():GetMaxHealth())
    end
end

