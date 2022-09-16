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

SWEP.ViewModel = "models/weapons/gst/v_lame_first.mdl"
SWEP.WorldModel = "models/gst/3dmg/w_lame_first.mdl"
SWEP.Skin = 0

SWEP.ViewModelFOV = 60

SWEP.MaxSpeed = 2000
SWEP.BaseAttractSpeed = 30
SWEP.BaseMaxGas = 1000

-- Grab settings
SWEP.MaxRopeRange = 6000
SWEP.BaseRange = 1200
SWEP.DetectBox = {
    mins = Vector(3400,-800,-900), --Vector(0,-1800,-400),
    maxs = Vector(600,800,900)   --Vector(2400,1800,400) -- Face Left Height
}

SWEP.GrabComsuption = 2--2
SWEP.GasComsuption = 4--4

SWEP.RegenMaxPerc = 20
SWEP.RegenSpeedPerc = 1
SWEP.RegenDelay = 4 -- time before start regen
SWEP.RegenTickDelay = 2
SWEP.HoldType 			= "gizer_idle"

function SWEP:CanUseGas()
    return IsValid(self:GetNWEntity("rope1")) or IsValid(self:GetNWEntity("rope2"))
end

function SWEP:GetGas()
    return self:GetNWFloat("Gas", 0)
end

function SWEP:CanSecondaryAttack()
    return
end