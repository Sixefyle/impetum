SWEP.PrintName = "Mousquet"
SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/v_aot_bs.mdl"
SWEP.WorldModel = "models/weapons/w_aot_bs.mdl"
SWEP.Base = "weapon_base"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 75
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = true
SWEP.DrawAmmo = false
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.HoldType = "smg"
SWEP.DrawCrosshair = true
SWEP.Weight = 0
SWEP.Category = "GST"
SWEP.FiresUnderwater = false
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.AttackSpeed = .14

function SWEP:Initialize()
end

function SWEP:Deploy()
    self:SetHoldType(self.HoldType)

    if CLIENT then
        LocalPlayer():ShowWeaponCooldownBar(true)
    end
end

function SWEP:CanSecondaryAttack()
    return
end

if CLIENT then
    function SWEP:Holster()
        LocalPlayer():ShowWeaponCooldownBar(false)
    end
end

function SWEP:PrimaryAttack()
    if (IsFirstTimePredicted() and self:CanPrimaryAttack()) then
        local nextAttack = CurTime() + (1 / self.AttackSpeed)

        self:SetNextPrimaryFire(nextAttack)
        self:ShootBullet(201, 1, 0, "self.Primary.Ammo", 1, 1)

        if CLIENT then
            self:GetOwner():WeaponCooldownBar(nextAttack)
        else
            GST_SNK.Utils:PlaySound(table.Random(GST_SNK.Sounds.MUSKET_SHOOT), self:GetOwner())
            self:GetOwner():AddPlayerStats(GST_SNK.AvailableStats.ShotFired)
        end

        timer.Simple(.01, function()
            local _, animTime = self:LookupSequence("reload")
             self:SendWeaponAnim(ACT_VM_RELOAD)
             self:GetOwner():GetViewModel():SetPlaybackRate(self.AttackSpeed * animTime)
        end)
    end
end