
hook.Add("InitPostEntity", "setupPlayerPref", function()
    GetPlayerPreference()
end)

function GetPlayerPreference()
    if (not file.Exists("gst/snk/player_config.json", "DATA")) then
        file.CreateDir("gst/snk")

        file.Write("gst/snk/player_config.json", "[]")
        LocalPlayer().preference = {}
        LocalPlayer().preference["server_only_sc"] = {
            ["use_3dmg"] = 15,
            ["use_gas"] = 65
        }
        LocalPlayer().preference["player_skill_hud_pos"] = { ["x"] = 0, ["y"] = 0 }
        LocalPlayer().preference["skill_key"] = {2, 3, 4}
        LocalPlayer().preference["health_bar_color"] = Color(9, 255, 70, 160)
        LocalPlayer().preference["armor_bar_color"] = Color(17, 104, 235)

        SavePlayerPreference()
    else
        LocalPlayer().preference = util.JSONToTable(file.Read("gst/snk/player_config.json"))
        --LocalPlayer().preference["skill_key"] = {2, 3, 4}
        net.Start("AOTA:TS:SendPlayerShortcut")
            net.WriteTable(LocalPlayer().preference["server_only_sc"])
        net.SendToServer()
    end
end

function SavePlayerPreference()
    if (file.Exists("gst/snk/player_config.json", "DATA")) then
       file.Write("gst/snk/player_config.json", util.TableToJSON(LocalPlayer().preference))
    end
    net.Start("AOTA:TS:SendPlayerShortcut")
        net.WriteTable(LocalPlayer().preference["server_only_sc"])
    net.SendToServer()
end

function SavePlayerHudPos(x, y)
    LocalPlayer().preference["player_hud_pos"] = { ["x"] = x, ["y"] = y }
    SavePlayerPreference()
end

function SavePlayerSkillHudPos(x, y)
    LocalPlayer().preference["player_skill_hud_pos"] = { ["x"] = x, ["y"] = y }
    SavePlayerPreference()
end