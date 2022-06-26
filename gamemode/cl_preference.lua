
hook.Add("InitPostEntity", "setupPlayerPref", function()
    GetPlayerPreference()
end)

function GetPlayerPreference()
    if (not file.Exists("gst/snk/hud_config.json", "DATA")) then
        file.CreateDir("gst/snk")

        file.Write("gst/snk/hud_config.json", "[]")
        LocalPlayer().preference = {}
    else
        LocalPlayer().preference = util.JSONToTable(file.Read("gst/snk/hud_config.json"))
        LocalPlayer().preference["skill_key"] = {2, 3, 4}
    end
end

function SavePlayerPreference()
    if (file.Exists("gst/snk/hud_config.json", "DATA")) then
       file.Write("gst/snk/hud_config.json", util.TableToJSON(LocalPlayer().preference))
    end
end

function SavePlayerHudPos(x, y)
    LocalPlayer().preference["player_hud_pos"] = { ["x"] = x, ["y"] = y }
    SavePlayerPreference()
end