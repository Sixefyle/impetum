SWEP.PrintName = "Ravitaillement de Gaz"
SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.ViewModel = "models/titan/v_hand_v2.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Base = "base_skill"

SWEP.BaseCooldown = 5
SWEP.Icon = GST_SNK.Images.CLASS_ICON_ELDIEN_TANK
SWEP.Duration = 5

function SWEP:Initialize()
end

function SWEP:UseSkill()
    if SERVER then
        local ent = ents.Create( "gas_supplier_ent" )
        ent:SetPos(self:GetOwner():GetPos() + self:GetOwner():GetForward() * 40)
        ent:Spawn()
        ent:Fire("Kill", nil, self.Duration)
    end
end

