SWEP.PrintName = "Cannon"
SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_arms_dod.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
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

SWEP.BaseCooldown = 120
SWEP.IsPlaced = false
SWEP.Icon = GST_SNK.Images.SKILL_HUMAN_ELDIEN_ARTILLERY
SWEP.IconBack = GST_SNK.Images.SKILL_HUMAN_ELDIEN_ARTILLERY_BACK

function SWEP:Initialize()
end

function SWEP:CanSecondaryAttack()
    return false
end

if CLIENT then
    function SWEP:Deploy()
        GST_SNK.Utils:CreateGhost("models/models/gst/canon.mdl", self, 300)
    end

    function SWEP:PrimaryAttack()
        if (self:CanPrimaryAttack() and IsValid(self.ghost)) then
            timer.Remove("ShowGhostCannon")
            net.Start("PlaceCanon")
                net.WriteVector(self.ghost:GetPos())
                net.WriteAngle(self.ghost:GetAngles())
            net.SendToServer()
            self.ghost:Remove()
        end
    end
end


if SERVER then
    util.AddNetworkString("PlaceCanon")

    net.Receive("PlaceCanon", function(len, ply)
        if (not ply.canUseSkill) then return end

        local pos = net.ReadVector()
        local angle = net.ReadAngle()
        if (type(pos) == "Vector" and type(angle) == "Angle") then
            if (IsValid(ply.PlacedCanon)) then
                ply.PlacedCanon:Remove()
            end
            local canon = ents.Create("ent_canon")
            canon:SetCreator(ply)
            canon:SetAngles(angle)
            canon:Spawn()
            canon:SetPos(pos)
            canon:EmitSound("gst/build_place.wav")
            ply.PlacedCanon = canon
        end
    end)

    function SWEP:UseSkill()
    end
end

