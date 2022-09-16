SWEP.PrintName = "Plan de construction"
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

SWEP.BaseCooldown = 30
SWEP.Icon = GST_SNK.Images.SKILL_HUMAN_ELDIEN_ENGINEER
SWEP.IconBack = GST_SNK.Images.SKILL_HUMAN_ELDIEN_ENGINEER_BACK

SWEP.BuildRange = 400

SWEP.AvailableBuild = {
    ["models/props_trenches/r_czech_hedgehog.mdl"] = {
        ["Name"] = "hérisson tchèque",
        ["Description"] = "Ça arrete les tanks, pourquoi pas les titans?",
        ["Time"] = 1200,
        ["Rotation"] = Angle(0,0,0),
        ["EntityClass"] = "build_prop"
    },
    ["models/props_trenches/lapland02_128.mdl"] = {
        ["Name"] = "Barbelé",
        ["Description"] = "Ralenti et blesse vos ennemis",
        ["Time"] = 1200,
        ["Rotation"] = Angle(0,0,0),
        ["EntityClass"] = "build_prop"
    },
    ["models/props_fortifications/sandbags_corner2_tall.mdl"] = {
        ["Name"] = "Mur de sac de sable",
        ["Description"] = "Protege des balles",
        ["Time"] = 1200,
        ["Rotation"] = Angle(0,0,0),
        ["EntityClass"] = "build_prop"
    }
}

function SWEP:Initialize()
end

function SWEP:CanSecondaryAttack()
    return false
end

if CLIENT then
    function SWEP:Deploy()
        if (IsValid(self.ghost)) then
            self.ghost:Remove()
        end

        if (self.lastSelection) then
            GST_SNK.Utils:CreateGhost(self.lastSelection, self, self.BuildRange)
        end
    end

    function SWEP:PrimaryAttack()
        if (IsFirstTimePredicted() and self:CanPrimaryAttack() and IsValid(self.ghost)) then
            timer.Remove("ShowGhostBuild")
            net.Start("PlaceBuild")
                net.WriteVector(self.ghost:GetPos())
                net.WriteAngle(self.ghost:GetAngles())
                net.WriteString(self.ghost:GetModel())
            net.SendToServer()
            --self.ghost:Remove()
        end
    end

    function SWEP:SecondaryAttack()
        if not IsFirstTimePredicted() then return end
        LocalPlayer():ShowBuildSelector()
    end
end


if SERVER then
    util.AddNetworkString("PlaceBuild")

    net.Receive("PlaceBuild", function(len, ply)
        if (not ply.canUseSkill) then return end

        local pos = net.ReadVector()
        local angle = net.ReadAngle()
        local model = net.ReadString()

        local weap = ply:GetActiveWeapon()
        local buildInfo
        if (weap:GetClass() == "skill_build") then
            buildInfo = weap.AvailableBuild[model]
            if (buildInfo == nil) then
                return
            end
        end

        if (type(pos) == "Vector" and type(angle) == "Angle") then
            local build = ents.Create(buildInfo.EntityClass)
            build:SetModel(model)
            build:SetCreator(ply)
            build:SetAngles(angle)
            build:Spawn()
            build:SetPos(pos)

            local phys = build:GetPhysicsObject()
            if IsValid(phys) then
                phys:EnableMotion(false)
            end

            build:Fire("kill", nil, buildInfo.Time)
        end
    end)

    function SWEP:UseSkill()
        --self:GetOwner():SetHealth(self:GetOwner():GetMaxHealth())
    end
end