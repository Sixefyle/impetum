if (SERVER) then
    util.AddNetworkString("GetClassInfo")
    util.AddNetworkString("GetUnlockedClass")
    util.AddNetworkString("ClassBuyRequest")
    util.AddNetworkString("GetNewLockedClass")
end

GST_SNK.Classes = {
    [GST_SNK.Teams.Eldien.name] = {
        ["Soldat"] = {
            ["id"] = 1,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_SOLDIER,
            ["description"] = "Je suis une description",
            ["display_name"] = "Soldat",
            ["health"] = 100,
            ["speed"] = 200,
            ["max_speed"] = 300,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Docteur"] = {
            ["id"] = 2,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_HEALER,
            ["description"] = "Je suis une belle plus grande description",
            ["display_name"] = "Docteur",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg", "skill_medikit"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Ravitalleur"] = {
            ["id"] = 3,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_SUPPLIER,
            ["display_name"] = "Ravitalleur",
            ["description"] = "Je suis une",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg", "skill_gas_supplier"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Fusillier"] = {
            ["id"] = 4,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_GUNNER,
            ["description"] = "Je suis une très très très trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèsdescription",
            ["display_name"] = "Fusillier",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg", "skill_musket"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Artilleur"] = {
            ["id"] = 5,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_ARTILLERY,
            ["description"] = "Munissez vous d'un canon afin de vous protéger des titans",
            ["display_name"] = "Artilleur",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg", "skill_cannon"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Veteran"] = {
            ["id"] = 6,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_VETERAN,
            ["description"] = "Je suis une très très très trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèsdescription",
            ["display_name"] = "Vétéran",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["attract_speed"] = 45,
            ["max_gas"] = 1500,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 120
        },
        ["Ingenieur"] = {
            ["id"] = 10,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_ENGINEER,
            ["description"] = "Je suis une description",
            ["display_name"] = "Ingénieur",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg", "skill_build"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Tank"] = {
            ["id"] = 13,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_TANK,
            ["description"] = "Je suis une description",
            ["display_name"] = "Tank",
            ["health"] = 400,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["attract_speed"] = 25,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Ackerman"] = {
            ["id"] = 14,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ELDIEN_ACKERMAN,
            ["description"] = "Je suis une description",
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
        ["Soldat"] = {
            ["id"] = 1,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_SOLDIER,
            ["description"] = "Je suis une description",
            ["display_name"] = "Soldat",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Docteur"] = {
            ["id"] = 2,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_HEALER,
            ["description"] = "Je suis une belle plus grande description",
            ["display_name"] = "Soldat",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Ravitalleur"] = {
            ["id"] = 3,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_SUPPLIER,
            ["display_name"] = "Soldat",
            ["description"] = "Je suis une",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Fusillier"] = {
            ["id"] = 4,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_GUNNER,
            ["description"] = "Je suis une très très très trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèsdescription",
            ["display_name"] = "Soldat",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Artilleur"] = {
            ["id"] = 5,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_ARTILLERY,
            ["description"] = "Je suis une description",
            ["display_name"] = "Soldat",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 120
        },
        ["Veteran"] = {
            ["id"] = 6,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_VETERAN,
            ["description"] = "Je suis une très très très trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèstrès trèsdescription",
            ["display_name"] = "Vétéran",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg_veteran"},
            ["price_std"] = 1000,
            ["price_gst"] = 120
        },
        ["Eclaireur"] = {
            ["id"] = 7,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_SCOUT,
            ["description"] = "c'est fous n'est-ce pas ?!",
            ["display_name"] = "Soldat",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 120
        },
        ["BAP"] = {
            ["id"] = 8,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_BAP,
            ["description"] = "BEEP BOOP BAP",
            ["display_name"] = "Soldat",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Demolisseur"] = {
            ["id"] = 9,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_DEMOLISHER,
            ["description"] = "Il démolie, c'est dans le nom trou duc",
            ["display_name"] = "Soldat",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Ingenieur"] = {
            ["id"] = 10,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_ENGINEER,
            ["description"] = "Je suis une description",
            ["display_name"] = "Ingénieur",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Trappeur"] = {
            ["id"] = 11,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_TRAPPER,
            ["description"] = "Je suis une description",
            ["display_name"] = "Soldat",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Medecin"] = {
            ["id"] = 12,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_MEDIC,
            ["description"] = "Je suis une description",
            ["display_name"] = "Soldat",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Tank"] = {
            ["id"] = 13,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_TANK,
            ["description"] = "Je suis une description",
            ["display_name"] = "Tank",
            ["health"] = 200,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["attract_speed"] = 10,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Magath"] = {
            ["id"] = 14,
            ["icon"] = GST_SNK.Images.CLASS_ICON_MAHR_MAGATH,
            ["description"] = "Je suis une description",
            ["display_name"] = "Soldat",
            ["health"] = 100,
            ["speed"] = 350,
            ["max_speed"] = 650,
            ["kit"] = {"gst_3dmg"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
    },
    [GST_SNK.Teams.Titan.name] = {
        ["Titan5"] = {
            ["id"] = 1,
            ["icon"] = GST_SNK.Images.CLASS_ICON_TITAN_5M,
            ["display_name"] = "Titan 5 mètres",
            ["health"] = 1000,
            ["speed"] = 350,
            ["max_speed"] = 350,
            ["size"] = 5,
            ["kit"] = {"titan_base"},
            ["price_std"] = 0,
            ["price_gst"] = 0
        },
        ["Titan7"] = {
            ["id"] = 2,
            ["icon"] = GST_SNK.Images.CLASS_ICON_TITAN_7M,
            ["display_name"] = "Titan 7 mètres",
            ["health"] = 1000,
            ["speed"] = 400,
            ["max_speed"] = 400,
            ["kit"] = {"titan_base"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Titan10"] = {
            ["id"] = 3,
            ["icon"] = GST_SNK.Images.CLASS_ICON_TITAN_10M,
            ["display_name"] = "Titan 10 mètres",
            ["health"] = 1000,
            ["speed"] = 500,
            ["max_speed"] = 500,
            ["size"] = 10,
            ["kit"] = {"titan_base"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Titan15"] = {
            ["id"] = 4,
            ["icon"] = GST_SNK.Images.CLASS_ICON_TITAN_15M,
            ["display_name"] = "Titan 15 mètres",
            ["health"] = 1000,
            ["speed"] = 750,
            ["max_speed"] = 750,
            ["size"] = 15,
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
            ["speed"] = 700,
            ["max_speed"] = 700,
            ["kit"] = {"primordial_beast"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Armored"] = {
            ["id"] = 2,
            ["icon"] = GST_SNK.Images.CLASS_ICON_ARMORED,
            ["display_name"] = "Cuirassé",
            ["health"] = 5000,
            ["speed"] = 350,
            ["max_speed"] = 350,
            ["kit"] = {"primordial_armored"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Feminin"] = {
            ["id"] = 6,
            ["icon"] = GST_SNK.Images.CLASS_ICON_FEMALE,
            ["display_name"] = "Féminin",
            ["health"] = 5000,
            ["speed"] = 350,
            ["max_speed"] = 350,
            ["kit"] = {"primordial_female"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
        ["Asaillant"] = {
            ["id"] = 7,
            ["icon"] = GST_SNK.Images.CLASS_ICON_WARHAMMER,
            ["display_name"] = "Assaillant",
            ["health"] = 5000,
            ["speed"] = 350,
            ["max_speed"] = 350,
            ["kit"] = {"primordial_asaillant"},
            ["price_std"] = 1000,
            ["price_gst"] = 0
        },
    },
}


local ply = FindMetaTable( "Player" )


function ply:SaveUnlockedClass()
    if (file.Exists("gst/unlocked_classes/" .. self:SteamID64() .. ".json", "DATA"	)) then
        file.Write("gst/unlocked_classes/" .. self:SteamID64() .. ".json", util.TableToJSON(self.unlocked_classes))
    end
end

function ply:GetUnlockedClass()
    if (not file.Exists("gst/unlocked_classes/" .. self:SteamID64() .. ".json", "DATA"	)) then
        file.CreateDir("gst/unlocked_classes/")

        local defaultClasses = {
            ["Eldien"] = {
                "Soldat",
                "Docteur",
                "Ravitalleur",
                "Fusillier"
            },
            ["Mahr"] = {
                "Soldat",
                "Docteur",
                "Ravitalleur",
                "Fusillier"
            },
            ["Titan"] = {
                "Titan5"
            },
            ["Primordial"] = {}
        }
        file.Write("gst/unlocked_classes/" .. self:SteamID64() .. ".json", util.TableToJSON(defaultClasses))

        return defaultClasses
    else
        return util.JSONToTable(file.Read("gst/unlocked_classes/" .. self:SteamID64() .. ".json"))
    end
end

function ply:SendUnlockedClasses()
    net.Start("GetUnlockedClass")
        net.WriteTable(self.unlocked_classes)
    net.Send(self)
end

function ply:UnlockClass(class_name, team_name)
    table.insert(self.unlocked_classes[team_name], class_name)
    self:SendUnlockedClasses()
    self:SaveUnlockedClass()
end

function ply:SetClass(class)
    net.Start("GetClassInfo")
        net.WriteTable(class)
    net.Send(self)
    self.class = class

    self:SetModel("models/Hydralis/kaouet/vip/soldat_feminin/bataillon/soldat_feminin_bataillon_3_vip.mdl")
    self:SetModelScale(1)
    self:SetViewOffset(Vector(0,0,64))
end

function ply:GetCurrentClass()
    return self.class
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

if (SERVER) then -- TODO mettre ca dans un fichier server
    net.Receive("ClassBuyRequest", function(len, ply)
        local payment_method = net.ReadBit()
        local class_name = net.ReadString()
        local team_name = net.ReadString()
 
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

        if (not table.HasValue(ply.unlocked_classes[team_name], class_name)) then
            ply:UnlockClass(class_name, team_name)
        end
    end)
end

if (CLIENT) then
    net.Receive("GetClassInfo", function()
        LocalPlayer().class = net.ReadTable()
    end)

    net.Receive("GetNewLockedClass", function()
        local teamName = net.ReadString()
        local className = net.ReadString()
        local isDisabled = net.ReadBool()

        GST_SNK.Classes[teamName][className].isDisabled = isDisabled
    end)

    net.Receive("GetUnlockedClass", function()
        LocalPlayer().unlocked_classes = net.ReadTable()
    end)
end