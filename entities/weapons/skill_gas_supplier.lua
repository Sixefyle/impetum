SWEP.PrintName = "Ravitaillement de Gaz"
SWEP.AdminSpawnable = true
SWEP.Spawnable = true
SWEP.ViewModel = "models/titan/v_hand_v2.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Base = "base_skill"

SWEP.BaseCooldown = 60
SWEP.Icon = GST_SNK.Images.SKILL_HUMAN_ELDIEN_SUPPLIER
SWEP.IconBack = GST_SNK.Images.SKILL_HUMAN_ELDIEN_SUPPLIER_BACK
SWEP.Duration = 5

function SWEP:CanSecondaryAttack()
    return false
end

if CLIENT then
    function SWEP:Deploy()
        if (IsValid(self.ghost)) then
            self.ghost:Remove()
        end

        GST_SNK.Utils:CreateGhost("models/gst/gaz2.mdl", self, 300, Vector(0,0,40))
    end

    function SWEP:PrimaryAttack()
        if (IsFirstTimePredicted() and self:CanPrimaryAttack() and IsValid(self.ghost)) then
            net.Start("PlaceGasSupplier")
                net.WriteVector(self.ghost:GetPos())
                net.WriteAngle(self.ghost:GetAngles())
                net.WriteString(self.ghost:GetModel())
            net.SendToServer()
            --self.ghost:Remove()
        end
    end

    hook.Add( "PostDrawTranslucentRenderables", "MySuper3DRenderingHook", function()
        -- local weap = LocalPlayer():GetActiveWeapon()
        -- local ent = weap.ghost
        -- render.DrawLine( ent:GetPos(), ent:GetPos() + Angle(-90,0,0):Forward() * 1000)
    end )

else
    util.AddNetworkString("PlaceGasSupplier")

    net.Receive("PlaceGasSupplier", function(len, ply)
        local pos = net.ReadVector()
        local angle = net.ReadAngle()
        local model = net.ReadString()

        local weap = ply:GetWeapon("skill_gas_supplier")

        if (type(pos) == "Vector" and type(angle) == "Angle") then
            local build = ents.Create("gas_supplier_ent")
            build:SetModel(model)
            build:SetCreator(ply)
            build:SetAngles(angle)
            build:Spawn()
            build:SetPos(pos)
            build:Fire("kill", nil, weap.Duration)
        end
    end)

    -- function SWEP:UseSkill()
    --     if SERVER then
    --         local ent = ents.Create( "gas_supplier_ent" )
    --         ent:SetPos(self:GetOwner():GetPos() + self:GetOwner():GetForward() * 40)
    --         ent:Spawn()
    --         ent:Fire("Kill", nil, self.Duration)
    --     end
    -- end
end