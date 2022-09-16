if (SERVER) then
    util.AddNetworkString("AOTA:TC:GetClassInfo")
    util.AddNetworkString("AOTA:TC:GetUnlockedClass")
    util.AddNetworkString("AOTA:TS:ClassBuyRequest")
    util.AddNetworkString("AOTA:TC:GetNewLockedClass")
    util.AddNetworkString("AOTA:TC:UpdateClassExperience")
    util.AddNetworkString("AOTA:TC:UpdateClassLevel")
end

GST_SNK = GST_SNK or {}
GST_SNK.Teams = GST_SNK.Teams or {}

GST_SNK.FreeClass = {
    ["Eldien"] = {
        "Soldier",
        "Doctor",
        "Ravitalleur",
        "Fusillier"
    },
    ["Mahr"] = {
        "Soldier",
        "Doctor",
        "Ravitalleur",
        "Fusillier"
    },
    ["Titan"] = {
        "Titan5"
    },
    ["Primordial"] = {}
}

GST_SNK.Classes = {
    [GST_SNK.Teams.Eldien.name] = {
        ["Soldier"] = {
            ["id"] = 1,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_SOLDIER,
            ["display_name"] = "Soldat",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Doctor"] = {
            ["id"] = 2,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_HEALER,
            ["display_name"] = "Docteur",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["kit"] = {"gst_3dmg", "skill_medikit"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Ravitalleur"] = {
            ["id"] = 3,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_SUPPLIER,
            ["display_name"] = "Ravitalleur",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["kit"] = {"gst_3dmg", "skill_gas_supplier"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Fusillier"] = {
            ["id"] = 4,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_GUNNER,
            ["display_name"] = "Fusillier",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["kit"] = {"gst_3dmg", "skill_musket"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Gunner"] = {
            ["id"] = 5,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_ARTILLERY,
            ["display_name"] = "Artilleur",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["kit"] = {"gst_3dmg", "skill_cannon"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Veteran"] = {
            ["id"] = 6,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_VETERAN,
            ["display_name"] = "Vétéran",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["attract_speed"] = 45,
            ["max_gas"] = 1500,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Engineer"] = {
            ["id"] = 7,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_ENGINEER,
            ["display_name"] = "Ingénieur",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["kit"] = {"gst_3dmg", "skill_build"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Tank"] = {
            ["id"] = 8,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_TANK,
            ["display_name"] = "Tank",
            ["health"] = 400,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["attract_speed"] = 25,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Ackerman"] = {
            ["id"] = 9,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_ACKERMAN,
            ["display_name"] = "Ackerman",
            ["damage"] = 20,
            ["health"] = 200,
            ["speed"] = 400,
            ["max_speed"] = 700,
            ["attract_speed"] = 60,
            ["max_gas"] = 2000,
            ["max_range"] = 900,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
    },

    [GST_SNK.Teams.Mahr.name] = {
        ["Soldier"] = {
            ["id"] = 1,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_SOLDIER,
            ["display_name"] = "Soldat",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Doctor"] = {
            ["id"] = 2,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_HEALER,
            ["display_name"] = "Docteur",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["kit"] = {"gst_3dmg", "skill_medikit"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Ravitalleur"] = {
            ["id"] = 3,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_SUPPLIER,
            ["display_name"] = "Ravitalleur",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["kit"] = {"gst_3dmg", "skil_gas_supplier"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Fusillier"] = {
            ["id"] = 4,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_GUNNER,
            ["display_name"] = "Fusiller",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["kit"] = {"gst_3dmg", "skill_musket"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Gunner"] = {
            ["id"] = 5,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_ARTILLERY,
            ["display_name"] = "Artilleur",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["kit"] = {"gst_3dmg", "skill_cannon"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Veteran"] = {
            ["id"] = 6,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_VETERAN,
            ["display_name"] = "Vétéran",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["attract_speed"] = 45,
            ["max_gas"] = 1500,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Engineer"] = {
            ["id"] = 7,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_ENGINEER,
            ["display_name"] = "Ingénieur",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["kit"] = {"gst_3dmg", "skill_build"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Tank"] = {
            ["id"] = 8,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_TANK,
            ["display_name"] = "Tank",
            ["health"] = 400,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["attract_speed"] = 25,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Magath"] = {
            ["id"] = 9,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_MAGATH,
            ["display_name"] = "Magath",
            ["damage"] = 20,
            ["health"] = 200,
            ["speed"] = 400,
            ["max_speed"] = 700,
            ["attract_speed"] = 60,
            ["max_gas"] = 2000,
            ["max_range"] = 900,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0,
            
        },
    },
    [GST_SNK.Teams.Titan.name] = {
        ["Titan5"] = {
            ["id"] = 1,
            ["icon"] = GST_SNK.Images.CLASS_ICON_TITAN_5M,
            ["display_name"] = "Titan 5 mètres",
            ["health"] = 1000,
            ["speed"] = 300,
            ["max_speed"] = 300,
            ["size"] = 10,
            ["kit"] = {"titan_base"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Titan7"] = {
            ["id"] = 2,
            ["icon"] = GST_SNK.Images.CLASS_ICON_TITAN_7M,
            ["display_name"] = "Titan 7 mètres",
            ["health"] = 1000,
            ["speed"] = 350,
            ["max_speed"] = 350,
            ["size"] = 12,
            ["kit"] = {"titan_base"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Titan10"] = {
            ["id"] = 3,
            ["icon"] = GST_SNK.Images.CLASS_ICON_TITAN_10M,
            ["display_name"] = "Titan 10 mètres",
            ["health"] = 1000,
            ["speed"] = 400,
            ["max_speed"] = 400,
            ["size"] = 15,
            ["kit"] = {"titan_base"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Titan15"] = {
            ["id"] = 4,
            ["icon"] = GST_SNK.Images.CLASS_ICON_TITAN_15M,
            ["display_name"] = "Titan 15 mètres",
            ["health"] = 1000,
            ["speed"] = 550,
            ["max_speed"] = 550,
            ["size"] = 20,
            ["kit"] = {"titan_base"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Crawler"] = {
            ["id"] = 5,
            ["icon"] = GST_SNK.Images.CLASS_ICON_TITAN_15M,
            ["display_name"] = "Titan Crawler",
            ["health"] = 1000,
            ["speed"] = 1400,
            ["max_speed"] = 1400,
            ["size"] = 20,
            ["kit"] = {"titan_crawler"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Sprinter"] = {
            ["id"] = 5,
            ["icon"] = GST_SNK.Images.CLASS_ICON_TITAN_15M,
            ["display_name"] = "Titan Sprinteur",
            ["health"] = 1000,
            ["speed"] = 550,
            ["max_speed"] = 1400,
            ["size"] = 20,
            ["kit"] = {"titan_base"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
    },
    [GST_SNK.Teams.Primordial.name] = {
        ["Beast"] = {
            ["id"] = 1,
            ["icon"] = GST_SNK.Images.CLASS_ICON_BEAST,
            ["display_name"] = "Bestial",
            ["health"] = 5000,
            ["speed"] = 550,
            ["max_speed"] = 1400,
            ["kit"] = {"primordial_beast"},
            ["price_std"] = 1000,
            ["price_gst"] = 0,
            
        },
        ["Armored"] = {
            ["id"] = 2,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ARMORED,
            ["display_name"] = "Cuirassé",
            ["health"] = 5000,
            ["speed"] = 550,
            ["max_speed"] = 1400,
            ["kit"] = {"primordial_armored"},
            ["price_std"] = 1000,
            ["price_gst"] = 0,
            
        },
        ["Female"] = {
            ["id"] = 6,
            ["icon"] = GST_SNK.Images.CLASS_ICON_FEMALE,
            ["display_name"] = "Féminin",
            ["health"] = 5000,
            ["speed"] = 550,
            ["max_speed"] = 1400,
            ["kit"] = {"primordial_female"},
            ["price_std"] = 1000,
            ["price_gst"] = 0,
            
        },
        ["Asaillant"] = {
            ["id"] = 7,
            ["icon"] = GST_SNK.Images.CLASS_ICON_WARHAMMER,
            ["display_name"] = "Assaillant",
            ["health"] = 5000,
            ["speed"] = 550,
            ["max_speed"] = 1400,
            ["kit"] = {"primordial_asaillant"},
            ["price_std"] = 1000,
            ["price_gst"] = 0,
            
        },
    },
}

local BaseRequiredExperience = 100
local PerLevelRequiredExperience = 150

local MaxLevel = 20
local TierToReward = 2

local ply = FindMetaTable( "Player" )

function ply:SendUnlockedClasses()
    net.Start("AOTA:TC:GetUnlockedClass")
        net.WriteTable(self.classes)
    net.Send(self)
end

function ply:UnlockClass(class_name, team_name)
    classExp = {
        Experience = 0,
        Level = 1
    }
    self.classes[team_name][class_name] = classExp
    self:SendUnlockedClasses()
    GST_DB:InsertUnlockedClass(self, team_name, class_name)
end

function ply:SetClass(class, className)
    net.Start("AOTA:TC:GetClassInfo")
        net.WriteTable(class)
        net.WriteString(className)
    net.Send(self)
    self.class = class
    self.className = className

    -- self:SetModel("models/Hydralis/kaouet/vip/soldat_feminin/bataillon/soldat_feminin_bataillon_3_vip.mdl")
    -- self:SetModelScale(1)
    -- self:SetViewOffset(Vector(0,0,64))
end

function ply:GetCurrentClass()
    return self.class
end

function ply:GetCurrentClassName()
    return self.className
end

function ply:GetSkills()
    local skills = {}
    for _, weapon in pairs(self:GetWeapons()) do
        if (weapon.Icon) then
            table.insert(skills, weapon)
        elseif (weapon.Skills) then
            for _, skill in pairs(weapon.Skills) do
                table.insert(skills, skill)
            end
        end
    end
    return skills
end

function ply:GetClassExperience(teamName, className)
    return self.classes[teamName][className].Experience
end

function ply:GetRequiredClassExperience(teamName, className)
    local classLevel = self:GetClassLevel(teamName, className)
    if classLevel >= MaxLevel then
        return 0
    end

    return BaseRequiredExperience + (classLevel - 1) * PerLevelRequiredExperience
end

function ply:GetClassLevel(teamName, className)
    return self.classes[teamName][className].Level
end

if (SERVER) then -- TODO mettre ca dans un fichier server

    function ply:SetClassExperience(teamName, className, experience)
        self.classes[teamName][className].Experience = experience

        net.Start("AOTA:TC:UpdateClassExperience")
            net.WriteString(teamName)
            net.WriteString(className)
            net.WriteUInt(experience, 32)
        net.Send(self)
    end

    function ply:SetClassLevel(teamName, className, level)
        self.classes[teamName][className].Level = level

        net.Start("AOTA:TC:UpdateClassLevel")
            net.WriteString(teamName)
            net.WriteString(className)
            net.WriteUInt(level, 8)
        net.Send(self)
    end

    function ply:AddClassExperience(teamName, className, amount)
        local newExperience = math.Clamp(self:GetClassExperience(teamName, className) + amount , 0, self:GetRequiredClassExperience(teamName, className))

        if newExperience < amount then
            self:AddClassLevel(teamName, className)
        end

        if newExperience > 0 then
            self:SetClassExperience(teamName, className, newExperience)
        end

        GST_DB:UpdatePlayerClassExp(self, teamName, className) -- See to maybe put this in a timer instead of update it every time player gain exp
    end

    function ply:AddClassLevel(teamName, className, amount)
        newLevel = math.Clamp(ply:GetClassLevel(teamName, className) + (amount or 1), 0, MaxLevel)

        if newLevel > 0 then
            local class = GST_SNK.Classes[teamName][className]
            self:SetClassLevel(teamName, className, newLevel)

            if newLevel % TierToReward == 0 and class.Rewards then
                ply:GiveClassLevelUpReward(teamName, className, newLevel)
            end

            return true
        end
        return false
    end

    function ply:GiveClassLevelUpReward(teamName, className, level)
        -- TODO
        --class.Rewards[newLevel / TierToReward]
    end

    net.Receive("AOTA:TS:ClassBuyRequest", function(len, ply)
        local payment_method = net.ReadBit()
        local class_name = net.ReadString()
        local team_name = net.ReadString()

        if not class_name == GST_SNK.Classes.Titan5 and
            (team_name == GST_SNK.Teams.Primordial or
            team_name == GST_SNK.Teams.Titan and
            not table.HasValue({"vip", "moderator", "admin", "superadmin"}, ply:GetUserGroup()))  then
            return
        end

        if (ply.classes and not table.HasValue(ply.classes[team_name], class_name)) then
            local price = (payment_method == 1 and GST_SNK.Classes[team_name][class_name].price_gst or GST_SNK.Classes[team_name][class_name].price_std)

            if (payment_method == 1 and ply:SH_GetPremiumPoints() >= price) then -- paiement en GST Coins
                ply:SH_AddPremiumPoints(-price, "[SNK] Achat de la classe " .. class_name .. " équipe " .. team_name, true, true)
            elseif (ply:SH_GetStandardPoints() >= price) then
                ply:SH_AddStandardPoints(-price, nil, true, true)
            else
                return false
            end

            ply:SH_TransmitPointshop()
            ply:SH_SavePointshop()

            ply:UnlockClass(class_name, team_name)
            GST_SNK.Utils:PlaySoundToPlayer("gst/buying.wav", ply)
        end
    end)
else
    net.Receive("AOTA:TC:GetClassInfo", function()
        LocalPlayer().class = net.ReadTable()
        LocalPlayer().className = net.ReadString()
    end)

    net.Receive("AOTA:TC:GetNewLockedClass", function()
        local teamName = net.ReadString()
        local className = net.ReadString()
        local isDisabled = net.ReadBool()

        GST_SNK.Classes[teamName][className].isDisabled = isDisabled
    end)

    net.Receive("AOTA:TC:GetUnlockedClass", function()
        LocalPlayer().classes = net.ReadTable()
    end)

    net.Receive("AOTA:TC:UpdateClassExperience", function()
        local teamName = net.ReadString()
        local className = net.ReadString()
        local experience = net.ReadUInt(32)

        LocalPlayer().classes[teamName][className].Experience = experience
    end)

    net.Receive("AOTA:TC:UpdateClassLevel", function()
        local teamName = net.ReadString()
        local className = net.ReadString()
        local level = net.ReadUInt(8)

        LocalPlayer().classes[teamName][className].Level = level
    end)
end