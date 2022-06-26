SWEP.PrintName = "Plan de construction"
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

SWEP.BaseCooldown = 1
SWEP.Icon = GST_SNK.Images.SKILL_HUMAN_ELDIEN_ARTILLERY
SWEP.IconBack = GST_SNK.Images.SKILL_HUMAN_ELDIEN_ARTILLERY_BACK

SWEP.AvailableBuild = {
    ["models/props_c17/fence01a.mdl"] = {
        ["Name"] = "Test 1",
        ["Description"] = "Une belle description pour décrire l'objet en question",
        ["Time"] = 30,
        ["EntityClass"] = "build_prop"
    },
    ["models/props_c17/concrete_barrier001a.mdl"] = {
        ["Name"] = "Test 2",
        ["Description"] = "Une belle description pour décrire l'objet en question",
        ["Time"] = 30,
        ["EntityClass"] = "build_prop"
    },
    ["models/props_vehicles/tire001c_car.mdl"] = {
        ["Name"] = "Test 2",
        ["Description"] = "Une belle description pour décrire l'objet en question",
        ["Time"] = 30,
        ["EntityClass"] = "build_prop"
    },
    ["models/props_c17/FurnitureWashingmachine001a.mdl"] = {
        ["Name"] = "Test 2",
        ["Description"] = "Une belle description pour décrire l'objet en question",
        ["Time"] = 30,
        ["EntityClass"] = "build_prop"
    },
    ["models/props_combine/weaponstripper.mdl"] = {
        ["Name"] = "Test 2",
        ["Description"] = "Une belle description pour décrire l'objet en question",
        ["Time"] = 30,
        ["EntityClass"] = "build_prop"
    },
    ["models/props_lab/blastdoor001a.mdl"] = {
        ["Name"] = "Porte",
        ["Description"] = "Une belle description pour décrire l'objet en question",
        ["Time"] = 10,
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
            GST_SNK.Utils:CreateGhost(self.lastSelection, self, 1500)
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
            build:Fire("kill", nil, buildInfo.Time)
        end
    end)

    function SWEP:UseSkill()
        self:GetOwner():SetHealth(self:GetOwner():GetMaxHealth())
    end
end